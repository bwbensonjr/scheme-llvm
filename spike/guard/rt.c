/* Spike: prove the guard/raise mechanism end-to-end (change: r7rs-exceptions-subset).
 *
 * Composes the three pieces the real change needs, in a throwaway:
 *   - a C-owned stack of setjmp escape frames + rt_run_guarded (owns the setjmp),
 *   - a ccc trampoline @__apply0 (hand-written IR, prog.ll) doing the fastcc
 *     thunk call the emitter would synthesize,
 *   - rt_raise longjmp'ing to the nearest frame across fastcc frames.
 *
 * Faithful to the real value rep (tagged words, closure = {code_ptr,...} tag 4)
 * and calling convention (fastcc uniform prototype, K=2 here).
 */
#include <stdint.h>
#include <setjmp.h>
#include <stdio.h>
#include <stdlib.h>

typedef intptr_t val;
#define FIX(n)      ((val)(((intptr_t)(n)) << 3))
#define UNFIX(v)    (((intptr_t)(v)) >> 3)
#define TAG_CLOSURE 4

typedef struct { jmp_buf env; val raised; } frame;
static frame frames[64];
static int nf = 0;

/* raise into the nearest enclosing guard frame; uncaught => abort (like rt_trap). */
val rt_raise(val obj) {
  if (nf > 0) { frames[nf - 1].raised = obj; longjmp(frames[nf - 1].env, 1); }
  fprintf(stderr, "UNCAUGHT raise %ld\n", (long)UNFIX(obj));
  exit(2);
}

/* ccc trampoline pointer type (matches @__apply0 in prog.ll). */
typedef val (*apply0_t)(val);

/* Owns the setjmp in a persistent C frame; calls the guarded thunk through the
 * emitter-synthesized ccc trampoline `fn`.  Returns the value on the normal
 * path; on a raise, sets *raisedp and returns the raised object. */
val rt_run_guarded(apply0_t fn, val thunk, int *raisedp) {
  frame *f = &frames[nf++];
  if (setjmp(f->env) == 0) {
    val v = fn(thunk);
    nf--; *raisedp = 0; return v;
  } else {
    val o = f->raised;
    nf--; *raisedp = 1; return o;
  }
}

val rt_mk_closure(void *code) {
  val *p = (val *)malloc(sizeof(val));
  p[0] = (val)code;
  return (val)((intptr_t)p | TAG_CLOSURE);
}

/* --- test thunks live in prog.ll (fastcc); we only take their addresses --- */
extern val __apply0(val);
extern void thunk_normal(void);
extern void thunk_raise(void);
extern void thunk_nested(void);

/* Called (ccc) by the fastcc thunk_nested: runs an INNER guard, then raises to
 * the OUTER frame -- proving nested frames and nearest-frame delivery. */
val rt_do_nested(void) {
  int r = 0;
  val got = rt_run_guarded(__apply0, rt_mk_closure((void *)thunk_raise), &r);
  printf("  inner guard: raised=%d obj=%ld  (want raised=1 obj=99)\n", r, (long)UNFIX(got));
  rt_raise(FIX(7));      /* must reach the OUTER frame, not the (popped) inner */
  return FIX(0);         /* unreachable */
}

int main(void) {
  int r, ok = 1;

  val v1 = rt_run_guarded(__apply0, rt_mk_closure((void *)thunk_normal), &r);
  printf("normal: raised=%d val=%ld  (want raised=0 val=42)\n", r, (long)UNFIX(v1));
  ok &= (r == 0 && UNFIX(v1) == 42);

  val v2 = rt_run_guarded(__apply0, rt_mk_closure((void *)thunk_raise), &r);
  printf("raise:  raised=%d obj=%ld  (want raised=1 obj=99)\n", r, (long)UNFIX(v2));
  ok &= (r == 1 && UNFIX(v2) == 99);

  val v3 = rt_run_guarded(__apply0, rt_mk_closure((void *)thunk_nested), &r);
  printf("nested: raised=%d obj=%ld  (want raised=1 obj=7)\n", r, (long)UNFIX(v3));
  ok &= (r == 1 && UNFIX(v3) == 7);

  printf(ok ? "SPIKE OK\n" : "SPIKE FAIL\n");
  return ok ? 0 : 1;
}
