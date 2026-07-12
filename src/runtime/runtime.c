/* runtime.c -- C runtime for the core-lambda-slice compiler.
 *
 * Value representation (tagged pointers, one 64-bit word), shared verbatim with
 * the LLVM IR emitter. Low 3 bits are the tag; the type of a heap object is
 * encoded in its pointer tag, so heap objects carry no header word.
 *
 *   tag 000  fixnum    immediate, payload = word >> 3 (signed)
 *   tag 001  boolean   immediate, #f = 0b001 (1), #t = 0b1001 (9)
 *   tag 010  nil       immediate, the empty list (only value 0b010 = 2)
 *   tag 011  pair      pointer, heap {car, cdr}
 *   tag 100  closure   pointer, heap {code_ptr, free0, ...}
 *   tag 101  box       pointer, heap {value}   (assignment-converted vars)
 *   tag 110  symbol    pointer, heap {name}    (interned; eq? by identity)
 *
 * Scheme truthiness: only #f is false; everything else (incl. 0 and ()) is true.
 */

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <gc/gc.h>

typedef intptr_t val;

#define TAG_MASK    7
#define TAG_FIXNUM  0
#define TAG_BOOL    1
#define TAG_NIL     2
#define TAG_PAIR    3
#define TAG_CLOSURE 4
#define TAG_BOX     5
#define TAG_SYMBOL  6

#define FIX(n)     ((val)(((intptr_t)(n)) << 3))
#define UNFIX(v)   (((intptr_t)(v)) >> 3)
#define FALSE_V    ((val)TAG_BOOL)             /* 1 */
#define TRUE_V     ((val)((1 << 3) | TAG_BOOL))/* 9 */
#define NIL_V      ((val)TAG_NIL)              /* 2 */
#define tag_of(v)  (((intptr_t)(v)) & TAG_MASK)
#define as_ptr(v)  ((val *)(((intptr_t)(v)) & ~(intptr_t)TAG_MASK))
#define tag_ptr(p, t) ((val)(((intptr_t)(p)) | (t)))

static inline val truthy(int b) { return b ? TRUE_V : FALSE_V; }

/* --- allocation -------------------------------------------------------- */
/* raw n-word allocation; the emitter tags the result and fills the slots
 * (used for closures, whose size/content is per-lambda). */
val rt_alloc_words(intptr_t n) { return (val)GC_MALLOC((size_t)n * sizeof(val)); }

/* --- pairs ------------------------------------------------------------- */
val rt_cons(val a, val b) {
  val *p = (val *)GC_MALLOC(2 * sizeof(val));
  p[0] = a; p[1] = b;
  return tag_ptr(p, TAG_PAIR);
}
val rt_car(val v) { return as_ptr(v)[0]; }
val rt_cdr(val v) { return as_ptr(v)[1]; }

/* --- boxes (assignment-converted variables) ---------------------------- */
val rt_box(val v)          { val *p = (val *)GC_MALLOC(sizeof(val)); p[0] = v; return tag_ptr(p, TAG_BOX); }
val rt_unbox(val b)        { return as_ptr(b)[0]; }
val rt_set_box(val b, val v) { as_ptr(b)[0] = v; return NIL_V; }

/* --- arithmetic and predicates ----------------------------------------- */
val rt_add(val a, val b) { return FIX(UNFIX(a) + UNFIX(b)); }
val rt_sub(val a, val b) { return FIX(UNFIX(a) - UNFIX(b)); }
val rt_mul(val a, val b) { return FIX(UNFIX(a) * UNFIX(b)); }
val rt_num_eq(val a, val b) { return truthy(UNFIX(a) == UNFIX(b)); }
val rt_lt(val a, val b)     { return truthy(UNFIX(a) <  UNFIX(b)); }
val rt_null_p(val v)       { return truthy(v == NIL_V); }
val rt_pair_p(val v)       { return truthy(tag_of(v) == TAG_PAIR); }
val rt_eq_p(val a, val b)  { return truthy(a == b); }

/* --- variadic / apply support ------------------------------------------ */
intptr_t rt_list_length(val lst) {
  intptr_t n = 0;
  while (tag_of(lst) == TAG_PAIR) { n++; lst = as_ptr(lst)[1]; }
  return n;
}

/* Build a variadic callee's rest list: the arguments at indices [fixed, argc)
 * in order.  Argument i lives in slots[i] when i < K, else in overflow[i-K].
 * `slots` points at the callee's K positional args spilled to a small array;
 * `overflow` is the calling-convention overflow vector (only read when
 * argc > K, so it may be NULL for calls with no excess). */
val rt_build_rest(intptr_t argc, intptr_t fixed, intptr_t K, val *slots, val *overflow) {
  val result = NIL_V;
  for (intptr_t i = argc - 1; i >= fixed; i--) {
    val a = (i < K) ? slots[i] : overflow[i - K];
    result = rt_cons(a, result);
  }
  return result;
}

/* apply: flatten n leading args (in `pre`) followed by the elements of `lst`
 * into a freshly allocated argument vector of length max(n+len(lst), K).  The
 * block is zero-initialized (GC_MALLOC) so the callee's K positional slots are
 * always readable even when the call supplies fewer than K arguments. */
val *rt_apply_argv(intptr_t n, val *pre, val lst, intptr_t K) {
  intptr_t m = rt_list_length(lst);
  intptr_t argc = n + m;
  intptr_t cap = argc > K ? argc : K;
  val *v = (val *)GC_MALLOC((size_t)(cap ? cap : 1) * sizeof(val));
  for (intptr_t i = 0; i < n; i++) v[i] = pre[i];
  for (intptr_t i = 0; i < m; i++) { v[n + i] = as_ptr(lst)[0]; lst = as_ptr(lst)[1]; }
  return v;
}

/* arity error: report to stderr and abort with a non-zero exit code. */
void rt_arity_error(intptr_t expected, intptr_t got) {
  fprintf(stderr, "arity error: expected %ld argument(s), got %ld\n",
          (long)expected, (long)got);
  exit(1);
}

/* --- symbols (interned) ------------------------------------------------ */
/* A symbol is a heap object { char *name }.  rt_intern canonicalizes by name so
 * two symbols with the same name are the same word, making eq? correct for
 * symbols with no special case.  The intern table array is allocated
 * GC_MALLOC_UNCOLLECTABLE: it is never collected and IS scanned for pointers, so
 * the symbols it holds are kept alive as roots.  (A plain static pointer into
 * the GC heap is not enough — under lli's JIT the module's data segment is not a
 * registered Boehm root, so the array would be collected mid-run.) */
static val *intern_table = NULL;   /* uncollectable, scanned array of symbols */
static intptr_t intern_count = 0;
static intptr_t intern_cap = 0;

static const char *sym_name(val s) { return (const char *)as_ptr(s)[0]; }

val rt_intern(const char *name) {
  for (intptr_t i = 0; i < intern_count; i++)
    if (strcmp(sym_name(intern_table[i]), name) == 0) return intern_table[i];

  size_t len = strlen(name);
  char *copy = (char *)GC_MALLOC_ATOMIC(len + 1);   /* name has no pointers */
  memcpy(copy, name, len + 1);
  val *p = (val *)GC_MALLOC(sizeof(val));
  p[0] = (val)copy;
  val s = tag_ptr(p, TAG_SYMBOL);

  if (intern_count == intern_cap) {
    intptr_t ncap = intern_cap ? intern_cap * 2 : 16;
    val *nt = (val *)GC_MALLOC_UNCOLLECTABLE((size_t)ncap * sizeof(val));
    for (intptr_t i = 0; i < intern_count; i++) nt[i] = intern_table[i];
    if (intern_table) GC_free(intern_table);
    intern_table = nt;
    intern_cap = ncap;
  }
  intern_table[intern_count++] = s;
  return s;
}

/* --- value printer (tag-walking, design R1) ---------------------------- */
void rt_write(val v) {
  switch (tag_of(v)) {
    case TAG_FIXNUM: printf("%ld", (long)UNFIX(v)); break;
    case TAG_BOOL:   printf(v == FALSE_V ? "#f" : "#t"); break;
    case TAG_NIL:    printf("()"); break;
    case TAG_PAIR: {
      printf("(");
      val cur = v; int first = 1;
      while (tag_of(cur) == TAG_PAIR) {
        if (!first) printf(" ");
        first = 0;
        rt_write(as_ptr(cur)[0]);
        cur = as_ptr(cur)[1];
      }
      if (cur != NIL_V) { printf(" . "); rt_write(cur); }
      printf(")");
      break;
    }
    case TAG_CLOSURE: printf("#<procedure>"); break;
    case TAG_BOX:     printf("#<box>"); break;
    case TAG_SYMBOL:  printf("%s", sym_name(v)); break;
    default:          printf("#<unknown:%ld>", (long)v);
  }
}

/* --- entry: exit code = ran/failed, stdout = value (design R1) ---------- */
extern val scheme_entry(void);

int main(void) {
  GC_INIT();
  val result = scheme_entry();
  rt_write(result);
  printf("\n");
  return 0;
}
