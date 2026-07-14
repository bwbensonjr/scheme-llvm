; Spike IR (change: r7rs-exceptions-subset): the fastcc thunks and the ccc
; trampoline @__apply0 the emitter would synthesize.  K=2 uniform prototype:
;   fastcc i64 (i64 self, i64 argc, i64 a0, i64 a1, ptr overflow)

declare i64 @rt_raise(i64)
declare i64 @rt_do_nested()

; a plain thunk: returns FIX(42) = 336
define fastcc i64 @thunk_normal(i64 %self, i64 %argc, i64 %a0, i64 %a1, ptr %ov) {
entry:
  ret i64 336
}

; raises FIX(99) = 792 (rt_raise longjmps; the ret is unreachable)
define fastcc i64 @thunk_raise(i64 %self, i64 %argc, i64 %a0, i64 %a1, ptr %ov) {
entry:
  %r = call i64 @rt_raise(i64 792)
  ret i64 %r
}

; fastcc -> ccc call into rt_do_nested, which runs an inner guard then re-raises
define fastcc i64 @thunk_nested(i64 %self, i64 %argc, i64 %a0, i64 %a1, ptr %ov) {
entry:
  %r = call i64 @rt_do_nested()
  ret i64 %r
}

; the emitter-synthesized ccc trampoline: extract code_ptr from the closure and
; do the fastcc 0-arg call (argc=0, K padding = undef, overflow = null).
define i64 @__apply0(i64 %clos) {
entry:
  %m  = and i64 %clos, -8
  %p  = inttoptr i64 %m to ptr
  %cp = load i64, ptr %p
  %fp = inttoptr i64 %cp to ptr
  %r  = call fastcc i64 %fp(i64 %clos, i64 0, i64 undef, i64 undef, ptr null)
  ret i64 %r
}
