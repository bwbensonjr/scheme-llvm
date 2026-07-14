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
#define HDR_VECTOR  2   /* { HDR_VECTOR, length, elem0, ... } */
#define HDR_ERROR   3   /* { HDR_ERROR, message-string, irritants-list } (R7RS error obj) */

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
/* Report a fatal runtime error the same way rt_arity_error does: record the
 * message, print it, and longjmp back to the REPL host if one is installed
 * (else exit non-zero for the standalone executable). */
static void rt_fatal(const char *msg) {
  snprintf(rt_trap_msg, sizeof rt_trap_msg, "%s", msg);
  fprintf(stderr, "%s\n", rt_trap_msg);
  if (rt_trap) longjmp(*rt_trap, 1);
  exit(1);
}

val rt_add(val a, val b) { return FIX(UNFIX(a) + UNFIX(b)); }
val rt_sub(val a, val b) { return FIX(UNFIX(a) - UNFIX(b)); }
val rt_mul(val a, val b) { return FIX(UNFIX(a) * UNFIX(b)); }
/* quotient/remainder: C integer division truncates toward zero, which is
 * exactly R7RS quotient/remainder.  Division by zero traps. */
val rt_quotient(val a, val b) {
  intptr_t d = UNFIX(b);
  if (d == 0) rt_fatal("division by zero: quotient");
  return FIX(UNFIX(a) / d);
}
val rt_remainder(val a, val b) {
  intptr_t d = UNFIX(b);
  if (d == 0) rt_fatal("division by zero: remainder");
  return FIX(UNFIX(a) % d);
}
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

/* Exported string accessors so an embedding C/C++ host can read the bytes of a
 * scheme string value returned across the FFI boundary (e.g. the IR text the
 * embedded compiler's scheme_entry returns).  Thin non-static wrappers over the
 * internal helpers above (change: path-a-embedding). */
intptr_t    rt_string_len(val v)   { return str_len(v); }
const char *rt_string_bytes(val v) { return str_bytes(v); }

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

/* --- string construction/comparison (string-char-library) --------------- */
/* content equality: equal byte length + equal bytes (UTF-8 => byte equality
 * is codepoint equality). */
val rt_string_eq(val a, val b) {
  intptr_t la = str_len(a);
  if (la != str_len(b)) return FALSE_V;
  return truthy(memcmp(str_bytes(a), str_bytes(b), (size_t)la) == 0);
}
/* new string = a's bytes followed by b's bytes. */
val rt_string_append(val a, val b) {
  intptr_t la = str_len(a), lb = str_len(b);
  char *buf = (char *)GC_MALLOC_ATOMIC((size_t)(la + lb + 1));
  memcpy(buf, str_bytes(a), (size_t)la);
  memcpy(buf + la, str_bytes(b), (size_t)lb);
  return rt_make_string(buf, la + lb);
}
/* a symbol's name as a fresh string. */
val rt_symbol_to_string(val s) {
  const char *name = sym_name(s);
  return rt_make_string(name, (intptr_t)strlen(name));
}
/* build a string from a list of characters, UTF-8-encoding each codepoint. */
val rt_list_to_string(val lst) {
  intptr_t n = rt_list_length(lst);
  char *buf = (char *)GC_MALLOC_ATOMIC((size_t)(4 * n + 1));  /* <=4 bytes/codepoint */
  intptr_t off = 0;
  for (val cur = lst; tag_of(cur) == TAG_PAIR; cur = as_ptr(cur)[1])
    off += utf8_encode(char_cp(as_ptr(cur)[0]), (unsigned char *)(buf + off));
  return rt_make_string(buf, off);
}
/* a string of k copies of character ch. */
val rt_make_string_fill(val k, val ch) {
  intptr_t n = UNFIX(k);
  unsigned char one[4];
  int len1 = utf8_encode(char_cp(ch), one);
  char *buf = (char *)GC_MALLOC_ATOMIC((size_t)(len1 * n + 1));
  for (intptr_t i = 0; i < n; i++) memcpy(buf + i * len1, one, (size_t)len1);
  return rt_make_string(buf, len1 * n);
}

/* --- string mutation (string-mutation change) --------------------------- */
/* string-set!: replace codepoint `idx` with `ch` in place.  UTF-8 is variable
 * width, so splice: rebuild the byte buffer with ch's bytes in place of the old
 * codepoint's, then overwrite the object's byte-length (word 1) and bytes
 * pointer (word 2) so the identity (and every alias) sees the update.  O(n).
 * The old buffer and `s` stay reachable across the allocation (s is live and
 * word 2 still points at the old bytes until the final store). */
val rt_string_set(val s, val idx, val ch) {
  const unsigned char *b = (const unsigned char *)str_bytes(s);
  intptr_t blen = str_len(s);
  intptr_t so = utf8_offset(b, blen, UNFIX(idx));
  intptr_t eo = so + utf8_seq_len(b[so]);          /* byte range of the old codepoint */
  unsigned char enc[4];
  int le = utf8_encode(char_cp(ch), enc);
  intptr_t newlen = blen - (eo - so) + le;
  char *buf = (char *)GC_MALLOC_ATOMIC((size_t)newlen + 1);
  memcpy(buf, b, (size_t)so);                       /* prefix */
  memcpy(buf + so, enc, (size_t)le);                /* replacement */
  memcpy(buf + so + le, b + eo, (size_t)(blen - eo)); /* suffix */
  buf[newlen] = '\0';
  as_ptr(s)[1] = (val)newlen;
  as_ptr(s)[2] = (val)buf;
  return NIL_V;
}
/* string-copy: a fresh string object over a fresh copy of the bytes. */
val rt_string_copy(val s) { return rt_make_string(str_bytes(s), str_len(s)); }

/* --- process I/O for a standalone text filter (self-host-io-strategy G3) ---
 * The two edge primitives a native `schemec` needs: pull all of stdin into a
 * string, and write a string's bytes to stdout raw.  Distinct from rt_write
 * (the final-value printer, which quotes strings and adds a newline). */

/* read all of stdin to EOF into a growable buffer; return a fresh scheme string. */
val rt_read_all_stdin(void) {
  size_t cap = 4096, len = 0;
  char *buf = (char *)GC_MALLOC_ATOMIC(cap);
  size_t n;
  while ((n = fread(buf + len, 1, cap - len, stdin)) > 0) {
    len += n;
    if (len == cap) {
      cap *= 2;
      char *nb = (char *)GC_MALLOC_ATOMIC(cap);
      memcpy(nb, buf, len);
      buf = nb;
    }
  }
  return rt_make_string(buf, (intptr_t)len);
}

/* --- REPL request channel (change: repl-embedded-incremental) -------------
 * The interactive host drives the embedded compiler by calling its single ccc
 * `scheme_entry` repeatedly, one call per operation.  Because a ccc entry takes
 * no scheme arguments, the host hands the operation selector and the per-form
 * source text in through this C-side channel (mirroring how rt_read_all_stdin
 * feeds the batch embed): the host calls rt_repl_set(mode, bytes, len) and then
 * scheme_entry, whose dispatcher reads them back via the (repl-mode)/(repl-input)
 * primitives.  Modes: 0 init-no-prelude, 1 init-with-prelude, 2 form-complete?,
 * 3 compile-one-form.
 *
 * The embedded compiler's whole program is folded into one @scheme_entry, so its
 * top-level bindings are LOCALS re-created on every call -- they cannot hold
 * state across the host's per-form calls.  The dispatcher therefore keeps the
 * session state (env/macro-env/known/n, bundled in a scheme vector) HERE, loading
 * it into working globals at entry and saving it back before returning, via
 * (repl-state-ref)/(repl-state-set!).
 *
 * Both the per-call input string and the cross-call state are held in single-slot
 * GC_MALLOC_UNCOLLECTABLE cells so they are scanned roots: scheme_entry's prologue
 * allocates (rt_box ...) before the dispatcher reads the input, and forms allocate
 * freely between calls, so a plain static `val` could be collected (same reasoning
 * as rt_intern's table).  #f (rt_repl_state_ref before any set) means "no state
 * yet". */
static intptr_t rt_repl_mode_v = 0;
static val *rt_repl_input_cell = NULL;     /* [1]: current form/prelude source */
static val *rt_repl_state_cell = NULL;     /* [1]: session-state vector, or FALSE_V */
static val *rt_repl_cell(val **slot, val init) {
  if (!*slot) { *slot = (val *)GC_MALLOC_UNCOLLECTABLE(sizeof(val)); (*slot)[0] = init; }
  return *slot;
}
void rt_repl_set(intptr_t mode, const char *bytes, intptr_t len) {
  rt_repl_mode_v = mode;
  rt_repl_cell(&rt_repl_input_cell, NIL_V)[0] = rt_make_string(bytes, len);
}
val rt_repl_mode(void)  { return FIX(rt_repl_mode_v); }
val rt_repl_input(void) { return rt_repl_cell(&rt_repl_input_cell, NIL_V)[0]; }
/* decode a scheme fixnum to a C integer, so the host can read form-complete?'s
 * consumed-count / incomplete(-1) / malformed(-2) result without knowing the tag. */
intptr_t rt_fixnum_value(val v) { return UNFIX(v); }

/* Persistent-global root set (change: repl-embedded-incremental).  In the REPL a
 * top-level define stores its value into a JIT'd module's global slot, and those
 * slots live in JIT-managed memory that libgc does NOT scan.  A value reachable
 * only through a global slot would therefore be collected once the in-process
 * embedded compiler's allocations trigger a GC (which they readily do -- the
 * compiler shares this heap, unlike the old JIT-only host).  Every global-set!
 * routes its value through rt_root, which keeps it in a scanned, uncollectable
 * table so it survives.  Only the persistent-globals model emits global-set!;
 * batch AOT uses letrec locals and never calls this.  Superseded values (a
 * redefinition's old binding) stay rooted -- bounded by the number of top-level
 * assignments in a session, which is negligible. */
static val *root_table = NULL;
static intptr_t root_count = 0, root_cap = 0;
val rt_root(val v) {
  if (root_count == root_cap) {
    intptr_t ncap = root_cap ? root_cap * 2 : 256;
    val *nt = (val *)GC_MALLOC_UNCOLLECTABLE((size_t)ncap * sizeof(val));
    for (intptr_t i = 0; i < root_count; i++) nt[i] = root_table[i];
    if (root_table) GC_free(root_table);
    root_table = nt;
    root_cap = ncap;
  }
  root_table[root_count++] = v;
  return v;
}
val rt_repl_state_ref(void)  { return rt_repl_cell(&rt_repl_state_cell, FALSE_V)[0]; }
val rt_repl_state_set(val v) { rt_repl_cell(&rt_repl_state_cell, FALSE_V)[0] = v; return NIL_V; }

/* write a string's bytes to stdout verbatim -- no quotes, no trailing newline.
 * Returns an unspecified value (NIL) so it composes inside a `begin`. */
val rt_display(val s) {
  fwrite(str_bytes(s), 1, (size_t)str_len(s), stdout);
  return NIL_V;
}

/* --- vectors (tag-7 HDR_VECTOR: { HDR_VECTOR, length, elem... }) --------- */
static intptr_t vec_len(val v) { return (intptr_t)as_ptr(v)[1]; }
val rt_make_vector(val k, val fill) {
  intptr_t n = UNFIX(k);
  val *p = (val *)GC_MALLOC((size_t)(n + 2) * sizeof(val));
  p[0] = (val)HDR_VECTOR; p[1] = (val)n;
  for (intptr_t i = 0; i < n; i++) p[i + 2] = fill;
  return tag_ptr(p, TAG_EXT);
}
val rt_vector_ref(val v, val i)        { return as_ptr(v)[2 + UNFIX(i)]; }
val rt_vector_set(val v, val i, val x) { as_ptr(v)[2 + UNFIX(i)] = x; return NIL_V; }
val rt_vector_length(val v)            { return FIX(vec_len(v)); }
val rt_vector_p(val v) {
  return truthy(tag_of(v) == TAG_EXT && ext_hdr(v) == HDR_VECTOR);
}

/* --- type predicates (self-hosting gap G9) -------------------------------- */
/* Each returns #t/#f by inspecting the tag (and, for tag-7 heap objects, the
 * header code -- guard the ext_hdr deref behind the TAG_EXT check, as vector? does).
 * The subset has a single number type (fixnums), so integer? and exact? coincide;
 * they are kept as distinct names for forward compatibility. */
val rt_symbol_p(val v)  { return truthy(tag_of(v) == TAG_SYMBOL); }
val rt_boolean_p(val v) { return truthy(tag_of(v) == TAG_BOOL); }
val rt_integer_p(val v) { return truthy(tag_of(v) == TAG_FIXNUM); }
val rt_exact_p(val v)   { return truthy(tag_of(v) == TAG_FIXNUM); }
val rt_string_p(val v)  { return truthy(tag_of(v) == TAG_EXT && ext_hdr(v) == HDR_STRING); }
val rt_char_p(val v)    { return truthy(tag_of(v) == TAG_EXT && ext_hdr(v) == HDR_CHAR); }

/* structural equality: eqv? fast path (immediates, interned symbols/chars, same
 * object), then recurse into pairs, compare string content by bytes (UTF-8, so
 * byte equality == codepoint equality), and recurse element-wise into vectors.
 * Everything else is #f. */
val rt_equal(val a, val b) {
  if (a == b) return TRUE_V;
  if (tag_of(a) == TAG_PAIR && tag_of(b) == TAG_PAIR) {
    if (rt_equal(as_ptr(a)[0], as_ptr(b)[0]) != TRUE_V) return FALSE_V;
    return rt_equal(as_ptr(a)[1], as_ptr(b)[1]);
  }
  if (tag_of(a) == TAG_EXT && tag_of(b) == TAG_EXT) {
    if (ext_hdr(a) == HDR_STRING && ext_hdr(b) == HDR_STRING) {
      intptr_t la = str_len(a);
      if (la != str_len(b)) return FALSE_V;
      return truthy(memcmp(str_bytes(a), str_bytes(b), (size_t)la) == 0);
    }
    if (ext_hdr(a) == HDR_VECTOR && ext_hdr(b) == HDR_VECTOR) {
      intptr_t la = vec_len(a);
      if (la != vec_len(b)) return FALSE_V;
      for (intptr_t i = 0; i < la; i++)
        if (rt_equal(as_ptr(a)[i + 2], as_ptr(b)[i + 2]) != TRUE_V) return FALSE_V;
      return TRUE_V;
    }
  }
  return FALSE_V;
}

/* --- error: report who/message/irritants and abort (error-and-guard-conditions)
 * The prelude formats "who: message" in-language and passes it as `prefix`; the
 * irritants (arbitrary values) are rendered here into rt_trap_msg with the same
 * tag-walking as rt_write, then we trap exactly like rt_arity_error -- under the
 * REPL host the longjmp unwinds and the session survives; standalone we exit(1).
 * Rendering is bounded by rt_trap_msg's capacity (a compact, possibly truncated
 * diagnostic; design: "compact form" over a full writer). */
static void err_put(char *buf, size_t cap, size_t *off, const char *s, size_t n) {
  for (size_t i = 0; i < n && *off + 1 < cap; i++) buf[(*off)++] = s[i];
  buf[*off] = '\0';
}
static void err_write(char *buf, size_t cap, size_t *off, val v) {
  char tmp[32];
  switch (tag_of(v)) {
    case TAG_FIXNUM:
      err_put(buf, cap, off, tmp, (size_t)snprintf(tmp, sizeof tmp, "%ld", (long)UNFIX(v)));
      break;
    case TAG_BOOL: err_put(buf, cap, off, v == FALSE_V ? "#f" : "#t", 2); break;
    case TAG_NIL:  err_put(buf, cap, off, "()", 2); break;
    case TAG_PAIR: {
      err_put(buf, cap, off, "(", 1);
      val cur = v; int first = 1;
      while (tag_of(cur) == TAG_PAIR) {
        if (!first) err_put(buf, cap, off, " ", 1);
        first = 0;
        err_write(buf, cap, off, as_ptr(cur)[0]);
        cur = as_ptr(cur)[1];
      }
      if (cur != NIL_V) { err_put(buf, cap, off, " . ", 3); err_write(buf, cap, off, cur); }
      err_put(buf, cap, off, ")", 1);
      break;
    }
    case TAG_SYMBOL: err_put(buf, cap, off, sym_name(v), strlen(sym_name(v))); break;
    case TAG_EXT:
      if (ext_hdr(v) == HDR_STRING) { err_put(buf, cap, off, str_bytes(v), (size_t)str_len(v)); break; }
      if (ext_hdr(v) == HDR_ERROR) {                       /* message, then irritants */
        val msg = as_ptr(v)[1], irritants = as_ptr(v)[2];
        err_put(buf, cap, off, str_bytes(msg), (size_t)str_len(msg));
        for (val cur = irritants; tag_of(cur) == TAG_PAIR; cur = as_ptr(cur)[1]) {
          err_put(buf, cap, off, " ", 1);
          err_write(buf, cap, off, as_ptr(cur)[0]);
        }
        break;
      }
      err_put(buf, cap, off, "#<obj>", 6);
      break;
    default: err_put(buf, cap, off, "#<obj>", 6); break;
  }
}

/* --- R7RS exceptions subset: error objects, raise, guard (r7rs-exceptions-subset)
 * A `guard` pushes an escape frame (a setjmp) via rt_run_guarded; `raise` (and
 * `error`, which raises an error object) longjmps to the nearest frame, else
 * falls back to the outermost trap (rt_trap) exactly as before -- so uncaught
 * behavior (REPL host survives; standalone exits non-zero) is unchanged.  guard
 * is only an upward, one-shot escape, so setjmp/longjmp suffices (no call/cc).
 * Validated by spike/guard/. */
#define RT_GUARD_MAX 256
static jmp_buf rt_guard_env[RT_GUARD_MAX];
static val     rt_guard_raised[RT_GUARD_MAX];   /* held only across an immediate longjmp */
static int     rt_guard_depth = 0;

/* Reset the guard stack; a host calls this after catching an outermost trap so a
 * longjmp that bypassed rt_run_guarded's pop does not leave stale frames. */
void rt_guard_reset(void) { rt_guard_depth = 0; }

val rt_make_error_object(val message, val irritants) {
  val *p = (val *)GC_MALLOC(3 * sizeof(val));
  p[0] = HDR_ERROR; p[1] = message; p[2] = irritants;
  return tag_ptr(p, TAG_EXT);
}
val rt_error_object_p(val v) { return truthy(tag_of(v) == TAG_EXT && ext_hdr(v) == HDR_ERROR); }
val rt_error_object_message(val v)   { return as_ptr(v)[1]; }
val rt_error_object_irritants(val v) { return as_ptr(v)[2]; }

/* raise OBJ to the nearest enclosing guard; if none, render and trap as before. */
val rt_raise(val obj) {
  if (rt_guard_depth > 0) {
    rt_guard_raised[rt_guard_depth - 1] = obj;
    longjmp(rt_guard_env[rt_guard_depth - 1], 1);
  }
  size_t off = 0;
  err_write(rt_trap_msg, sizeof rt_trap_msg, &off, obj);
  fprintf(stderr, "%s\n", rt_trap_msg);
  if (rt_trap) longjmp(*rt_trap, 1);
  exit(1);
  return NIL_V;   /* unreachable; keeps the i64-returning call site well-typed */
}

/* The emitter-synthesized ccc trampoline @__apply0 (per module) has this type;
 * it does the fastcc 0-arg call into the guarded thunk closure. */
typedef val (*rt_apply0_t)(val);

/* Run THUNK guarded: push a frame, setjmp, call it through the module's ccc
 * trampoline FN.  Returns (#f . value) on normal completion, (#t . object) if a
 * raise landed here.  Frame is popped on both paths (and any deeper abandoned
 * frames are discarded on the caught path). */
val rt_run_guarded(rt_apply0_t fn, val thunk) {
  if (rt_guard_depth >= RT_GUARD_MAX) rt_fatal("guard nesting too deep");
  int i = rt_guard_depth++;
  if (setjmp(rt_guard_env[i]) == 0) {
    val v = fn(thunk);
    rt_guard_depth = i;
    return rt_cons(FALSE_V, v);
  } else {
    val o = rt_guard_raised[i];
    rt_guard_depth = i;
    return rt_cons(TRUE_V, o);
  }
}

/* error: (error message obj ...) -- raise a fresh error object (R7RS signature).
 * The prelude passes the message string and the irritant list. */
val rt_error(val message, val irritants) {
  return rt_raise(rt_make_error_object(message, irritants));
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
        case HDR_VECTOR: {
          intptr_t len = (intptr_t)as_ptr(v)[1];
          printf("#(");
          for (intptr_t i = 0; i < len; i++) {
            if (i) putchar(' ');
            rt_write(as_ptr(v)[i + 2]);
          }
          putchar(')');
          break;
        }
        case HDR_ERROR: {
          val msg = as_ptr(v)[1];
          printf("#<error ");
          fwrite(str_bytes(msg), 1, (size_t)str_len(msg), stdout);
          putchar('>');
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
 * runtime with -DRT_NO_MAIN to omit this (and the scheme_entry it expects).
 *
 * -DRT_FILTER_MAIN builds a *filter* main that runs the program purely for its
 * effects and suppresses the final-value print.  A text filter (e.g. the
 * self-hosted `schemec`, whose entry is `(display (compile-source-string
 * (read-all-stdin)))`) does its own output via `display`; printing the entry's
 * value afterward would append `()\n` and corrupt the output stream. */
#ifndef RT_NO_MAIN
extern val scheme_entry(void);

int main(void) {
  GC_INIT();
#ifdef RT_FILTER_MAIN
  scheme_entry();          /* run for effect; the program handles its own I/O */
#else
  val result = scheme_entry();
  rt_write(result);
  printf("\n");
#endif
  return 0;
}
#endif
