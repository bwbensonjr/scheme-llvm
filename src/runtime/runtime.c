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
#include <setjmp.h>
#include <gc/gc.h>

typedef intptr_t val;

/* Trap escape hook.  A runtime trap (e.g. an arity error) aborts the process
 * in the AOT/batch model.  A persistent host (the ORC/LLJIT REPL) instead sets
 * rt_trap to a jmp_buf and setjmp()s before calling into JIT'd code, so a trap
 * longjmps back to the host loop and the session survives.  NULL => exit(1),
 * preserving the standalone-executable behavior.  rt_trap_msg holds the last
 * trap's message so a host can report it on its result channel (the host
 * silences the runtime's stderr to keep it out of the framed pipe). */
jmp_buf *rt_trap = NULL;
char rt_trap_msg[128] = "";

#define TAG_MASK    7
#define TAG_FIXNUM  0
#define TAG_BOOL    1
#define TAG_NIL     2
#define TAG_PAIR    3
#define TAG_CLOSURE 4
#define TAG_BOX     5
#define TAG_SYMBOL  6
#define TAG_EXT     7   /* extended heap object; first word = a header code */

/* header codes for TAG_EXT objects (tags 0-6 are exhausted, so new heap types
 * live under tag 7 and are discriminated by this header word) */
#define HDR_STRING  0
#define HDR_CHAR    1

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
/* eqv?: same-object identity.  == suffices because every value eqv? can
 * distinguish is immediate (fixnums), interned (symbols), or interned by
 * codepoint (characters, see rt_make_char); this diverges from rt_eq_p only
 * once non-immediate numbers (flonums/bignums) need value comparison. */
val rt_eqv_p(val a, val b) { return truthy(a == b); }
val rt_not(val x)          { return truthy(x == FALSE_V); }  /* only #f is false */

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
  snprintf(rt_trap_msg, sizeof rt_trap_msg,
           "arity error: expected %ld argument(s), got %ld",
           (long)expected, (long)got);
  fprintf(stderr, "%s\n", rt_trap_msg);
  if (rt_trap) longjmp(*rt_trap, 1);
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

/* --- extended heap objects: strings and characters (tag 7) ------------- */
/* An extended object is a heap block whose first word is a small header code
 * discriminating its type.  Further heap types (vectors, ...) add header codes
 * without needing a new primary tag. */
static intptr_t ext_hdr(val v) { return as_ptr(v)[0]; }

/* string: { HDR_STRING, byte-length, char *bytes } -- UTF-8, explicit length so
 * embedded NULs are fine (the trailing NUL is for C-side convenience only). */
val rt_make_string(const char *bytes, intptr_t len) {
  char *copy = (char *)GC_MALLOC_ATOMIC((size_t)len + 1);
  memcpy(copy, bytes, (size_t)len);
  copy[len] = '\0';
  val *p = (val *)GC_MALLOC(3 * sizeof(val));
  p[0] = HDR_STRING; p[1] = len; p[2] = (val)copy;
  return tag_ptr(p, TAG_EXT);
}
static intptr_t    str_len(val v)   { return as_ptr(v)[1]; }
static const char *str_bytes(val v) { return (const char *)as_ptr(v)[2]; }

/* char: { HDR_CHAR, codepoint } -- the full Unicode scalar value */
static intptr_t char_cp(val v) { return as_ptr(v)[1]; }

/* Characters are interned by codepoint so equal chars are the same object
 * (eq?/eqv? hold), mirroring symbol interning.  Two tiers: a direct Latin-1
 * array for 0..255 (the common case, O(1)) and a growable linear-scan table for
 * codepoints >= 256.  Both are GC_MALLOC_UNCOLLECTABLE and scanned, so interned
 * chars are roots that survive collection under the lli JIT (see rt_intern for
 * why a plain static pointer is not enough). */
static val *char_latin1 = NULL;          /* [256], lazily allocated, zero = absent */
static val *char_astral = NULL;          /* codepoints >= 256 */
static intptr_t char_astral_count = 0;
static intptr_t char_astral_cap = 0;

static val char_lookup(intptr_t cp) {
  if (cp < 256) return char_latin1 ? char_latin1[cp] : 0;
  for (intptr_t i = 0; i < char_astral_count; i++)
    if (char_cp(char_astral[i]) == cp) return char_astral[i];
  return 0;
}

static void char_intern_add(val ch, intptr_t cp) {
  if (cp < 256) {
    if (!char_latin1)
      char_latin1 = (val *)GC_MALLOC_UNCOLLECTABLE(256 * sizeof(val));
    char_latin1[cp] = ch;
    return;
  }
  if (char_astral_count == char_astral_cap) {
    intptr_t ncap = char_astral_cap ? char_astral_cap * 2 : 16;
    val *nt = (val *)GC_MALLOC_UNCOLLECTABLE((size_t)ncap * sizeof(val));
    for (intptr_t i = 0; i < char_astral_count; i++) nt[i] = char_astral[i];
    if (char_astral) GC_free(char_astral);
    char_astral = nt;
    char_astral_cap = ncap;
  }
  char_astral[char_astral_count++] = ch;
}

val rt_make_char(intptr_t codepoint) {
  val c = char_lookup(codepoint);
  if (c) return c;                          /* canonical char already interned */
  val *p = (val *)GC_MALLOC(2 * sizeof(val));
  p[0] = HDR_CHAR; p[1] = codepoint;
  val ch = tag_ptr(p, TAG_EXT);
  char_intern_add(ch, codepoint);
  return ch;
}

/* encode a Unicode codepoint as UTF-8 into buf (>= 4 bytes); return byte count */
static int utf8_encode(intptr_t cp, unsigned char *buf) {
  if (cp < 0x80) { buf[0] = (unsigned char)cp; return 1; }
  if (cp < 0x800) {
    buf[0] = (unsigned char)(0xC0 | (cp >> 6));
    buf[1] = (unsigned char)(0x80 | (cp & 0x3F));
    return 2;
  }
  if (cp < 0x10000) {
    buf[0] = (unsigned char)(0xE0 | (cp >> 12));
    buf[1] = (unsigned char)(0x80 | ((cp >> 6) & 0x3F));
    buf[2] = (unsigned char)(0x80 | (cp & 0x3F));
    return 3;
  }
  buf[0] = (unsigned char)(0xF0 | (cp >> 18));
  buf[1] = (unsigned char)(0x80 | ((cp >> 12) & 0x3F));
  buf[2] = (unsigned char)(0x80 | ((cp >> 6) & 0x3F));
  buf[3] = (unsigned char)(0x80 | (cp & 0x3F));
  return 4;
}

/* number of bytes in the UTF-8 sequence with lead byte b (assumes well-formed) */
static int utf8_seq_len(unsigned char b) {
  if (b < 0x80) return 1;
  if ((b >> 5) == 0x6) return 2;   /* 110xxxxx */
  if ((b >> 4) == 0xE) return 3;   /* 1110xxxx */
  return 4;                        /* 11110xxx */
}

/* decode the codepoint at byte offset i of s */
static intptr_t utf8_decode_at(const unsigned char *s, intptr_t i) {
  unsigned char b = s[i];
  switch (utf8_seq_len(b)) {
    case 1:  return b;
    case 2:  return ((b & 0x1F) << 6) | (s[i+1] & 0x3F);
    case 3:  return ((b & 0x0F) << 12) | ((s[i+1] & 0x3F) << 6) | (s[i+2] & 0x3F);
    default: return ((b & 0x07) << 18) | ((s[i+1] & 0x3F) << 12)
                    | ((s[i+2] & 0x3F) << 6) | (s[i+3] & 0x3F);
  }
}

/* byte offset of the cp-th codepoint of s (byte length blen); clamps at blen */
static intptr_t utf8_offset(const unsigned char *s, intptr_t blen, intptr_t cp) {
  intptr_t i = 0, k = 0;
  while (i < blen && k < cp) { i += utf8_seq_len(s[i]); k++; }
  return i;
}

/* --- character operations ---------------------------------------------- */
val rt_char_to_integer(val c) { return FIX(char_cp(c)); }
val rt_integer_to_char(val n) { return rt_make_char(UNFIX(n)); }

/* --- string operations (codepoint-indexed over UTF-8 storage, design D1) --- */
val rt_string_length(val s) {
  const unsigned char *b = (const unsigned char *)str_bytes(s);
  intptr_t blen = str_len(s), i = 0, k = 0;
  while (i < blen) { i += utf8_seq_len(b[i]); k++; }
  return FIX(k);
}
val rt_string_ref(val s, val idx) {
  const unsigned char *b = (const unsigned char *)str_bytes(s);
  intptr_t off = utf8_offset(b, str_len(s), UNFIX(idx));
  return rt_make_char(utf8_decode_at(b, off));
}
val rt_substring(val s, val start, val end) {
  const unsigned char *b = (const unsigned char *)str_bytes(s);
  intptr_t blen = str_len(s);
  intptr_t so = utf8_offset(b, blen, UNFIX(start));
  intptr_t eo = utf8_offset(b, blen, UNFIX(end));
  return rt_make_string((const char *)(b + so), eo - so);
}
/* intern the string's bytes (NUL-terminated; safe for source identifiers) */
val rt_string_to_symbol(val s) { return rt_intern(str_bytes(s)); }

/* structural equality: eqv? fast path (immediates, interned symbols/chars, same
 * object), then recurse into pairs and compare string content by bytes (UTF-8,
 * so byte equality == codepoint equality).  Everything else is #f.  A vector arm
 * is added when vectors land (see the vectors change). */
val rt_equal(val a, val b) {
  if (a == b) return TRUE_V;
  if (tag_of(a) == TAG_PAIR && tag_of(b) == TAG_PAIR) {
    if (rt_equal(as_ptr(a)[0], as_ptr(b)[0]) != TRUE_V) return FALSE_V;
    return rt_equal(as_ptr(a)[1], as_ptr(b)[1]);
  }
  if (tag_of(a) == TAG_EXT && tag_of(b) == TAG_EXT &&
      ext_hdr(a) == HDR_STRING && ext_hdr(b) == HDR_STRING) {
    intptr_t la = str_len(a);
    if (la != str_len(b)) return FALSE_V;
    return truthy(memcmp(str_bytes(a), str_bytes(b), (size_t)la) == 0);
  }
  return FALSE_V;
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
    case TAG_EXT:
      switch (ext_hdr(v)) {
        case HDR_STRING:
          putchar('"');
          fwrite(str_bytes(v), 1, (size_t)str_len(v), stdout);
          putchar('"');
          break;
        case HDR_CHAR: {
          intptr_t cp = char_cp(v);
          if (cp == ' ')       printf("#\\space");
          else if (cp == '\n') printf("#\\newline");
          else {
            unsigned char buf[4];
            int n = utf8_encode(cp, buf);
            printf("#\\");
            fwrite(buf, 1, (size_t)n, stdout);
          }
          break;
        }
        default: printf("#<ext:%ld>", (long)ext_hdr(v));
      }
      break;
    default:          printf("#<unknown:%ld>", (long)v);
  }
}

/* --- entry: exit code = ran/failed, stdout = value (design R1) ----------
 * The standalone AOT/JIT executables use this main.  The persistent REPL host
 * provides its own main and drives scheme code itself, so it compiles the
 * runtime with -DRT_NO_MAIN to omit this (and the scheme_entry it expects). */
#ifndef RT_NO_MAIN
extern val scheme_entry(void);

int main(void) {
  GC_INIT();
  val result = scheme_entry();
  rt_write(result);
  printf("\n");
  return 0;
}
#endif
