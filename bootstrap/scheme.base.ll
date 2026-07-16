declare i64 @rt_alloc_words(i64)
declare i64 @rt_cons(i64, i64)
declare i64 @rt_car(i64)
declare i64 @rt_cdr(i64)
declare i64 @rt_box(i64)
declare i64 @rt_unbox(i64)
declare i64 @rt_set_box(i64, i64)
declare i64 @rt_add(i64, i64)
declare i64 @rt_sub(i64, i64)
declare i64 @rt_mul(i64, i64)
declare i64 @rt_quotient(i64, i64)
declare i64 @rt_remainder(i64, i64)
declare i64 @rt_num_eq(i64, i64)
declare i64 @rt_lt(i64, i64)
declare i64 @rt_null_p(i64)
declare i64 @rt_pair_p(i64)
declare i64 @rt_eq_p(i64, i64)
declare i64 @rt_eqv_p(i64, i64)
declare i64 @rt_equal(i64, i64)
declare i64 @rt_not(i64)
declare i64 @rt_intern(ptr)
declare i64 @rt_make_string(ptr, i64)
declare i64 @rt_char_to_integer(i64)
declare i64 @rt_integer_to_char(i64)
declare i64 @rt_string_length(i64)
declare i64 @rt_string_ref(i64, i64)
declare i64 @rt_substring(i64, i64, i64)
declare i64 @rt_string_to_symbol(i64)
declare i64 @rt_string_eq(i64, i64)
declare i64 @rt_string_append(i64, i64)
declare i64 @rt_symbol_to_string(i64)
declare i64 @rt_list_to_string(i64)
declare i64 @rt_make_string_fill(i64, i64)
declare i64 @rt_string_set(i64, i64, i64)
declare i64 @rt_string_copy(i64)
declare i64 @rt_make_vector(i64, i64)
declare i64 @rt_vector_ref(i64, i64)
declare i64 @rt_vector_set(i64, i64, i64)
declare i64 @rt_vector_length(i64)
declare i64 @rt_vector_p(i64)
declare i64 @rt_symbol_p(i64)
declare i64 @rt_string_p(i64)
declare i64 @rt_char_p(i64)
declare i64 @rt_boolean_p(i64)
declare i64 @rt_integer_p(i64)
declare i64 @rt_exact_p(i64)
declare i64 @rt_read_all_stdin()
declare i64 @rt_no_prelude_p()
declare i64 @rt_repl_mode()
declare i64 @rt_repl_input()
declare i64 @rt_repl_state_ref()
declare i64 @rt_repl_state_set(i64)
declare i64 @rt_root(i64)
declare i64 @rt_display(i64)
declare i64 @rt_list_length(i64)
declare i64 @rt_build_rest(i64, i64, i64, ptr, ptr)
declare ptr @rt_apply_argv(i64, ptr, i64, i64)
declare void @rt_arity_error(i64, i64)
declare i64 @rt_error(i64, i64)
declare i64 @rt_raise(i64)
declare i64 @rt_run_guarded(ptr, i64)
declare i64 @rt_error_object_p(i64)
declare i64 @rt_error_object_message(i64)
declare i64 @rt_error_object_irritants(i64)

@.str.lit.0 = private unnamed_addr constant [1 x i8] c"\00"
@.str.lit.1 = private unnamed_addr constant [2 x i8] c"0\00"
@.str.lit.2 = private unnamed_addr constant [3 x i8] c": \00"
@.str.lit.3 = private unnamed_addr constant [6 x i8] c"space\00"
@.str.lit.4 = private unnamed_addr constant [8 x i8] c"newline\00"
@.str.lit.5 = private unnamed_addr constant [4 x i8] c"tab\00"
@.str.lit.6 = private unnamed_addr constant [7 x i8] c"return\00"
@.str.lit.7 = private unnamed_addr constant [4 x i8] c"nul\00"
@.str.lit.8 = private unnamed_addr constant [5 x i8] c"null\00"
@.str.lit.9 = private unnamed_addr constant [7 x i8] c"delete\00"
@.str.lit.10 = private unnamed_addr constant [8 x i8] c"altmode\00"
@.str.lit.11 = private unnamed_addr constant [4 x i8] c"esc\00"
@.str.sym.12 = private unnamed_addr constant [6 x i8] c"quote\00"
@.str.sym.13 = private unnamed_addr constant [11 x i8] c"quasiquote\00"
@.str.sym.14 = private unnamed_addr constant [17 x i8] c"unquote-splicing\00"
@.str.sym.15 = private unnamed_addr constant [8 x i8] c"unquote\00"
@"scheme.base:__inited" = global i64 0
@"scheme.base:list" = global i64 0
@"scheme.base:caar" = global i64 0
@"scheme.base:cadr" = global i64 0
@"scheme.base:cdar" = global i64 0
@"scheme.base:cddr" = global i64 0
@"scheme.base:caaar" = global i64 0
@"scheme.base:caadr" = global i64 0
@"scheme.base:cadar" = global i64 0
@"scheme.base:caddr" = global i64 0
@"scheme.base:cdaar" = global i64 0
@"scheme.base:cdadr" = global i64 0
@"scheme.base:cddar" = global i64 0
@"scheme.base:cdddr" = global i64 0
@"scheme.base:length" = global i64 0
@"scheme.base:reverse" = global i64 0
@"scheme.base:%append2" = global i64 0
@"scheme.base:append" = global i64 0
@"scheme.base:%map1" = global i64 0
@"scheme.base:%any-null?" = global i64 0
@"scheme.base:%mapn" = global i64 0
@"scheme.base:map" = global i64 0
@"scheme.base:memq" = global i64 0
@"scheme.base:memv" = global i64 0
@"scheme.base:assq" = global i64 0
@"scheme.base:member" = global i64 0
@"scheme.base:assoc" = global i64 0
@"scheme.base:filter" = global i64 0
@"scheme.base:fold-left" = global i64 0
@"scheme.base:fold-right" = global i64 0
@"scheme.base:%for-each1" = global i64 0
@"scheme.base:%for-eachn" = global i64 0
@"scheme.base:for-each" = global i64 0
@"scheme.base:andmap" = global i64 0
@"scheme.base:memp" = global i64 0
@"scheme.base:cadddr" = global i64 0
@"scheme.base:list?" = global i64 0
@"scheme.base:zero?" = global i64 0
@"scheme.base:list-tail" = global i64 0
@"scheme.base:list-ref" = global i64 0
@"scheme.base:list-head" = global i64 0
@"scheme.base:make-list" = global i64 0
@"scheme.base:iota" = global i64 0
@"scheme.base:max" = global i64 0
@"scheme.base:void" = global i64 0
@"scheme.base:string" = global i64 0
@"scheme.base:%str-concat" = global i64 0
@"scheme.base:chr-cmp" = global i64 0
@"scheme.base:char=?" = global i64 0
@"scheme.base:char<?" = global i64 0
@"scheme.base:char>?" = global i64 0
@"scheme.base:char<=?" = global i64 0
@"scheme.base:char>=?" = global i64 0
@"scheme.base:string->list" = global i64 0
@"scheme.base:ns-digits" = global i64 0
@"scheme.base:number->string" = global i64 0
@"scheme.base:error" = global i64 0
@"scheme.base:raise" = global i64 0
@"scheme.base:error-object?" = global i64 0
@"scheme.base:error-object-message" = global i64 0
@"scheme.base:error-object-irritants" = global i64 0
@"scheme.base:list->vector" = global i64 0
@"scheme.base:vector" = global i64 0
@"scheme.base:rd-ws?" = global i64 0
@"scheme.base:rd-digit?" = global i64 0
@"scheme.base:rd-delim?" = global i64 0
@"scheme.base:rd-skip-line" = global i64 0
@"scheme.base:rd-skip-ws" = global i64 0
@"scheme.base:rd-token-end" = global i64 0
@"scheme.base:rd-all-digits?" = global i64 0
@"scheme.base:rd-numeric?" = global i64 0
@"scheme.base:rd-digits" = global i64 0
@"scheme.base:rd-parse-int" = global i64 0
@"scheme.base:rd-atom" = global i64 0
@"scheme.base:rd-hex-digit" = global i64 0
@"scheme.base:rd-hex" = global i64 0
@"scheme.base:rd-str-esc" = global i64 0
@"scheme.base:rd-string" = global i64 0
@"scheme.base:rd-hash" = global i64 0
@"scheme.base:rd-char-name" = global i64 0
@"scheme.base:rd-char" = global i64 0
@"scheme.base:rd-quote" = global i64 0
@"scheme.base:rd-quasi" = global i64 0
@"scheme.base:rd-unquote" = global i64 0
@"scheme.base:rd-dot?" = global i64 0
@"scheme.base:rd-append-reverse" = global i64 0
@"scheme.base:rd-list" = global i64 0
@"scheme.base:rd-datum" = global i64 0
@"scheme.base:read-from-string" = global i64 0
@"scheme.base:read-all-from-string" = global i64 0
define fastcc i64 @"scheme.base:code_1"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1 = icmp sge i64 %argc, 0
  br i1 %t1, label %argok2, label %arityerr1
arityerr1:
  call void @rt_arity_error(i64 0, i64 %argc)
  unreachable
argok2:
  %t2 = call i64 @rt_alloc_words(i64 8)
  %t3 = inttoptr i64 %t2 to ptr
  %t4 = getelementptr i64, ptr %t3, i64 0
  store i64 %a0, ptr %t4
  %t5 = getelementptr i64, ptr %t3, i64 1
  store i64 %a1, ptr %t5
  %t6 = getelementptr i64, ptr %t3, i64 2
  store i64 %a2, ptr %t6
  %t7 = getelementptr i64, ptr %t3, i64 3
  store i64 %a3, ptr %t7
  %t8 = getelementptr i64, ptr %t3, i64 4
  store i64 %a4, ptr %t8
  %t9 = getelementptr i64, ptr %t3, i64 5
  store i64 %a5, ptr %t9
  %t10 = getelementptr i64, ptr %t3, i64 6
  store i64 %a6, ptr %t10
  %t11 = getelementptr i64, ptr %t3, i64 7
  store i64 %a7, ptr %t11
  %t12 = call i64 @rt_build_rest(i64 %argc, i64 0, i64 8, ptr %t3, ptr %overflow)
  ret i64 %t12
}

define fastcc i64 @"scheme.base:code_4"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t17 = icmp eq i64 %argc, 1
  br i1 %t17, label %argok4, label %arityerr3
arityerr3:
  call void @rt_arity_error(i64 1, i64 %argc)
  unreachable
argok4:
  %t18 = call i64 @rt_car(i64 %a0)
  %t19 = call i64 @rt_car(i64 %t18)
  ret i64 %t19
}

define fastcc i64 @"scheme.base:code_7"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t24 = icmp eq i64 %argc, 1
  br i1 %t24, label %argok6, label %arityerr5
arityerr5:
  call void @rt_arity_error(i64 1, i64 %argc)
  unreachable
argok6:
  %t25 = call i64 @rt_cdr(i64 %a0)
  %t26 = call i64 @rt_car(i64 %t25)
  ret i64 %t26
}

define fastcc i64 @"scheme.base:code_10"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t31 = icmp eq i64 %argc, 1
  br i1 %t31, label %argok8, label %arityerr7
arityerr7:
  call void @rt_arity_error(i64 1, i64 %argc)
  unreachable
argok8:
  %t32 = call i64 @rt_car(i64 %a0)
  %t33 = call i64 @rt_cdr(i64 %t32)
  ret i64 %t33
}

define fastcc i64 @"scheme.base:code_13"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t38 = icmp eq i64 %argc, 1
  br i1 %t38, label %argok10, label %arityerr9
arityerr9:
  call void @rt_arity_error(i64 1, i64 %argc)
  unreachable
argok10:
  %t39 = call i64 @rt_cdr(i64 %a0)
  %t40 = call i64 @rt_cdr(i64 %t39)
  ret i64 %t40
}

define fastcc i64 @"scheme.base:code_16"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t45 = icmp eq i64 %argc, 1
  br i1 %t45, label %argok12, label %arityerr11
arityerr11:
  call void @rt_arity_error(i64 1, i64 %argc)
  unreachable
argok12:
  %t46 = load i64, ptr @"scheme.base:caar"
  %t47 = and i64 %t46, -8
  %t48 = inttoptr i64 %t47 to ptr
  %t49 = load i64, ptr %t48
  %t50 = inttoptr i64 %t49 to ptr
  %t51 = call fastcc i64%t50(i64 %t46, i64 1, i64 %a0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t52 = call i64 @rt_car(i64 %t51)
  ret i64 %t52
}

define fastcc i64 @"scheme.base:code_19"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t57 = icmp eq i64 %argc, 1
  br i1 %t57, label %argok14, label %arityerr13
arityerr13:
  call void @rt_arity_error(i64 1, i64 %argc)
  unreachable
argok14:
  %t58 = load i64, ptr @"scheme.base:cadr"
  %t59 = and i64 %t58, -8
  %t60 = inttoptr i64 %t59 to ptr
  %t61 = load i64, ptr %t60
  %t62 = inttoptr i64 %t61 to ptr
  %t63 = call fastcc i64%t62(i64 %t58, i64 1, i64 %a0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t64 = call i64 @rt_car(i64 %t63)
  ret i64 %t64
}

define fastcc i64 @"scheme.base:code_22"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t69 = icmp eq i64 %argc, 1
  br i1 %t69, label %argok16, label %arityerr15
arityerr15:
  call void @rt_arity_error(i64 1, i64 %argc)
  unreachable
argok16:
  %t70 = load i64, ptr @"scheme.base:cdar"
  %t71 = and i64 %t70, -8
  %t72 = inttoptr i64 %t71 to ptr
  %t73 = load i64, ptr %t72
  %t74 = inttoptr i64 %t73 to ptr
  %t75 = call fastcc i64%t74(i64 %t70, i64 1, i64 %a0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t76 = call i64 @rt_car(i64 %t75)
  ret i64 %t76
}

define fastcc i64 @"scheme.base:code_25"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t81 = icmp eq i64 %argc, 1
  br i1 %t81, label %argok18, label %arityerr17
arityerr17:
  call void @rt_arity_error(i64 1, i64 %argc)
  unreachable
argok18:
  %t82 = load i64, ptr @"scheme.base:cddr"
  %t83 = and i64 %t82, -8
  %t84 = inttoptr i64 %t83 to ptr
  %t85 = load i64, ptr %t84
  %t86 = inttoptr i64 %t85 to ptr
  %t87 = call fastcc i64%t86(i64 %t82, i64 1, i64 %a0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t88 = call i64 @rt_car(i64 %t87)
  ret i64 %t88
}

define fastcc i64 @"scheme.base:code_28"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t93 = icmp eq i64 %argc, 1
  br i1 %t93, label %argok20, label %arityerr19
arityerr19:
  call void @rt_arity_error(i64 1, i64 %argc)
  unreachable
argok20:
  %t94 = load i64, ptr @"scheme.base:caar"
  %t95 = and i64 %t94, -8
  %t96 = inttoptr i64 %t95 to ptr
  %t97 = load i64, ptr %t96
  %t98 = inttoptr i64 %t97 to ptr
  %t99 = call fastcc i64%t98(i64 %t94, i64 1, i64 %a0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t100 = call i64 @rt_cdr(i64 %t99)
  ret i64 %t100
}

define fastcc i64 @"scheme.base:code_31"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t105 = icmp eq i64 %argc, 1
  br i1 %t105, label %argok22, label %arityerr21
arityerr21:
  call void @rt_arity_error(i64 1, i64 %argc)
  unreachable
argok22:
  %t106 = load i64, ptr @"scheme.base:cadr"
  %t107 = and i64 %t106, -8
  %t108 = inttoptr i64 %t107 to ptr
  %t109 = load i64, ptr %t108
  %t110 = inttoptr i64 %t109 to ptr
  %t111 = call fastcc i64%t110(i64 %t106, i64 1, i64 %a0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t112 = call i64 @rt_cdr(i64 %t111)
  ret i64 %t112
}

define fastcc i64 @"scheme.base:code_34"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t117 = icmp eq i64 %argc, 1
  br i1 %t117, label %argok24, label %arityerr23
arityerr23:
  call void @rt_arity_error(i64 1, i64 %argc)
  unreachable
argok24:
  %t118 = load i64, ptr @"scheme.base:cdar"
  %t119 = and i64 %t118, -8
  %t120 = inttoptr i64 %t119 to ptr
  %t121 = load i64, ptr %t120
  %t122 = inttoptr i64 %t121 to ptr
  %t123 = call fastcc i64%t122(i64 %t118, i64 1, i64 %a0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t124 = call i64 @rt_cdr(i64 %t123)
  ret i64 %t124
}

define fastcc i64 @"scheme.base:code_37"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t129 = icmp eq i64 %argc, 1
  br i1 %t129, label %argok26, label %arityerr25
arityerr25:
  call void @rt_arity_error(i64 1, i64 %argc)
  unreachable
argok26:
  %t130 = load i64, ptr @"scheme.base:cddr"
  %t131 = and i64 %t130, -8
  %t132 = inttoptr i64 %t131 to ptr
  %t133 = load i64, ptr %t132
  %t134 = inttoptr i64 %t133 to ptr
  %t135 = call fastcc i64%t134(i64 %t130, i64 1, i64 %a0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t136 = call i64 @rt_cdr(i64 %t135)
  ret i64 %t136
}

define fastcc i64 @"scheme.base:code_45"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t141 = icmp eq i64 %argc, 2
  br i1 %t141, label %argok28, label %arityerr27
arityerr27:
  call void @rt_arity_error(i64 2, i64 %argc)
  unreachable
argok28:
  %t142 = call i64 @rt_null_p(i64 %a0)
  %t143 = icmp ne i64 %t142, 1
  br i1 %t143, label %then29, label %else30
then29:
  ret i64 %a1
else30:
  %t144 = call i64 @rt_cdr(i64 %a0)
  %t145 = call i64 @rt_add(i64 %a1, i64 8)
  %t146 = and i64 %self, -8
  %t147 = inttoptr i64 %t146 to ptr
  %t148 = getelementptr i64, ptr %t147, i64 1
  %t149 = load i64, ptr %t148
  %t150 = and i64 %t149, -8
  %t151 = inttoptr i64 %t150 to ptr
  %t152 = load i64, ptr %t151
  %t153 = inttoptr i64 %t152 to ptr
  %t154 = musttail call fastcc i64 %t153(i64 %t149, i64 2, i64 %t144, i64 %t145, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t154
}

define fastcc i64 @"scheme.base:code_43"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t155 = icmp eq i64 %argc, 1
  br i1 %t155, label %argok32, label %arityerr31
arityerr31:
  call void @rt_arity_error(i64 1, i64 %argc)
  unreachable
argok32:
  %t156 = call i64 @rt_alloc_words(i64 2)
  %t157 = inttoptr i64 %t156 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_45" to i64), ptr %t157
  %t158 = or i64 %t156, 4
  %t159 = getelementptr i64, ptr %t157, i64 1
  store i64 %t158, ptr %t159
  %t160 = and i64 %t158, -8
  %t161 = inttoptr i64 %t160 to ptr
  %t162 = load i64, ptr %t161
  %t163 = inttoptr i64 %t162 to ptr
  %t164 = musttail call fastcc i64 %t163(i64 %t158, i64 2, i64 %a0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t164
}

define fastcc i64 @"scheme.base:code_53"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t169 = icmp eq i64 %argc, 2
  br i1 %t169, label %argok34, label %arityerr33
arityerr33:
  call void @rt_arity_error(i64 2, i64 %argc)
  unreachable
argok34:
  %t170 = call i64 @rt_null_p(i64 %a0)
  %t171 = icmp ne i64 %t170, 1
  br i1 %t171, label %then35, label %else36
then35:
  ret i64 %a1
else36:
  %t172 = call i64 @rt_cdr(i64 %a0)
  %t173 = call i64 @rt_car(i64 %a0)
  %t174 = call i64 @rt_cons(i64 %t173, i64 %a1)
  %t175 = and i64 %self, -8
  %t176 = inttoptr i64 %t175 to ptr
  %t177 = getelementptr i64, ptr %t176, i64 1
  %t178 = load i64, ptr %t177
  %t179 = and i64 %t178, -8
  %t180 = inttoptr i64 %t179 to ptr
  %t181 = load i64, ptr %t180
  %t182 = inttoptr i64 %t181 to ptr
  %t183 = musttail call fastcc i64 %t182(i64 %t178, i64 2, i64 %t172, i64 %t174, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t183
}

define fastcc i64 @"scheme.base:code_51"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t184 = icmp eq i64 %argc, 1
  br i1 %t184, label %argok38, label %arityerr37
arityerr37:
  call void @rt_arity_error(i64 1, i64 %argc)
  unreachable
argok38:
  %t185 = call i64 @rt_alloc_words(i64 2)
  %t186 = inttoptr i64 %t185 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_53" to i64), ptr %t186
  %t187 = or i64 %t185, 4
  %t188 = getelementptr i64, ptr %t186, i64 1
  store i64 %t187, ptr %t188
  %t189 = and i64 %t187, -8
  %t190 = inttoptr i64 %t189 to ptr
  %t191 = load i64, ptr %t190
  %t192 = inttoptr i64 %t191 to ptr
  %t193 = musttail call fastcc i64 %t192(i64 %t187, i64 2, i64 %a0, i64 2, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t193
}

define fastcc i64 @"scheme.base:code_57"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t198 = icmp eq i64 %argc, 2
  br i1 %t198, label %argok40, label %arityerr39
arityerr39:
  call void @rt_arity_error(i64 2, i64 %argc)
  unreachable
argok40:
  %t199 = call i64 @rt_null_p(i64 %a0)
  %t200 = icmp ne i64 %t199, 1
  br i1 %t200, label %then41, label %else42
then41:
  ret i64 %a1
else42:
  %t201 = call i64 @rt_car(i64 %a0)
  %t202 = call i64 @rt_cdr(i64 %a0)
  %t203 = load i64, ptr @"scheme.base:%append2"
  %t204 = and i64 %t203, -8
  %t205 = inttoptr i64 %t204 to ptr
  %t206 = load i64, ptr %t205
  %t207 = inttoptr i64 %t206 to ptr
  %t208 = call fastcc i64%t207(i64 %t203, i64 2, i64 %t202, i64 %a1, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t209 = call i64 @rt_cons(i64 %t201, i64 %t208)
  ret i64 %t209
}

define fastcc i64 @"scheme.base:code_60"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t214 = icmp sge i64 %argc, 0
  br i1 %t214, label %argok44, label %arityerr43
arityerr43:
  call void @rt_arity_error(i64 0, i64 %argc)
  unreachable
argok44:
  %t215 = call i64 @rt_alloc_words(i64 8)
  %t216 = inttoptr i64 %t215 to ptr
  %t217 = getelementptr i64, ptr %t216, i64 0
  store i64 %a0, ptr %t217
  %t218 = getelementptr i64, ptr %t216, i64 1
  store i64 %a1, ptr %t218
  %t219 = getelementptr i64, ptr %t216, i64 2
  store i64 %a2, ptr %t219
  %t220 = getelementptr i64, ptr %t216, i64 3
  store i64 %a3, ptr %t220
  %t221 = getelementptr i64, ptr %t216, i64 4
  store i64 %a4, ptr %t221
  %t222 = getelementptr i64, ptr %t216, i64 5
  store i64 %a5, ptr %t222
  %t223 = getelementptr i64, ptr %t216, i64 6
  store i64 %a6, ptr %t223
  %t224 = getelementptr i64, ptr %t216, i64 7
  store i64 %a7, ptr %t224
  %t225 = call i64 @rt_build_rest(i64 %argc, i64 0, i64 8, ptr %t216, ptr %overflow)
  %t226 = call i64 @rt_null_p(i64 %t225)
  %t227 = icmp ne i64 %t226, 1
  br i1 %t227, label %then45, label %else46
then45:
  ret i64 2
else46:
  %t228 = call i64 @rt_cdr(i64 %t225)
  %t229 = call i64 @rt_null_p(i64 %t228)
  %t230 = icmp ne i64 %t229, 1
  br i1 %t230, label %then47, label %else48
then47:
  %t231 = call i64 @rt_car(i64 %t225)
  ret i64 %t231
else48:
  %t232 = call i64 @rt_car(i64 %t225)
  %t233 = call i64 @rt_cdr(i64 %t225)
  %t234 = load i64, ptr @"scheme.base:append"
  %t235 = and i64 %t234, -8
  %t236 = inttoptr i64 %t235 to ptr
  %t237 = load i64, ptr %t236
  %t238 = inttoptr i64 %t237 to ptr
  %t239 = call i64 @rt_list_length(i64 %t233)
  %t240 = add i64 0, %t239
  %t241 = call ptr @rt_apply_argv(i64 0, ptr null, i64 %t233, i64 8)
  %t253 = getelementptr i64, ptr %t241, i64 0
  %t245 = load i64, ptr %t253
  %t254 = getelementptr i64, ptr %t241, i64 1
  %t246 = load i64, ptr %t254
  %t255 = getelementptr i64, ptr %t241, i64 2
  %t247 = load i64, ptr %t255
  %t256 = getelementptr i64, ptr %t241, i64 3
  %t248 = load i64, ptr %t256
  %t257 = getelementptr i64, ptr %t241, i64 4
  %t249 = load i64, ptr %t257
  %t258 = getelementptr i64, ptr %t241, i64 5
  %t250 = load i64, ptr %t258
  %t259 = getelementptr i64, ptr %t241, i64 6
  %t251 = load i64, ptr %t259
  %t260 = getelementptr i64, ptr %t241, i64 7
  %t252 = load i64, ptr %t260
  %t242 = icmp sgt i64 %t240, 8
  %t243 = getelementptr i64, ptr %t241, i64 8
  %t244 = select i1 %t242, ptr %t243, ptr null
  %t261 = call fastcc i64%t238(i64 %t234, i64 %t240, i64 %t245, i64 %t246, i64 %t247, i64 %t248, i64 %t249, i64 %t250, i64 %t251, i64 %t252, ptr %t244)
  %t262 = load i64, ptr @"scheme.base:%append2"
  %t263 = and i64 %t262, -8
  %t264 = inttoptr i64 %t263 to ptr
  %t265 = load i64, ptr %t264
  %t266 = inttoptr i64 %t265 to ptr
  %t267 = musttail call fastcc i64 %t266(i64 %t262, i64 2, i64 %t232, i64 %t261, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t267
}

define fastcc i64 @"scheme.base:code_64"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t272 = icmp eq i64 %argc, 2
  br i1 %t272, label %argok50, label %arityerr49
arityerr49:
  call void @rt_arity_error(i64 2, i64 %argc)
  unreachable
argok50:
  %t273 = call i64 @rt_null_p(i64 %a1)
  %t274 = icmp ne i64 %t273, 1
  br i1 %t274, label %then51, label %else52
then51:
  ret i64 2
else52:
  %t275 = call i64 @rt_car(i64 %a1)
  %t276 = and i64 %a0, -8
  %t277 = inttoptr i64 %t276 to ptr
  %t278 = load i64, ptr %t277
  %t279 = inttoptr i64 %t278 to ptr
  %t280 = call fastcc i64%t279(i64 %a0, i64 1, i64 %t275, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t281 = call i64 @rt_cdr(i64 %a1)
  %t282 = load i64, ptr @"scheme.base:%map1"
  %t283 = and i64 %t282, -8
  %t284 = inttoptr i64 %t283 to ptr
  %t285 = load i64, ptr %t284
  %t286 = inttoptr i64 %t285 to ptr
  %t287 = call fastcc i64%t286(i64 %t282, i64 2, i64 %a0, i64 %t281, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t288 = call i64 @rt_cons(i64 %t280, i64 %t287)
  ret i64 %t288
}

define fastcc i64 @"scheme.base:code_67"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t293 = icmp eq i64 %argc, 1
  br i1 %t293, label %argok54, label %arityerr53
arityerr53:
  call void @rt_arity_error(i64 1, i64 %argc)
  unreachable
argok54:
  %t294 = call i64 @rt_null_p(i64 %a0)
  %t295 = icmp ne i64 %t294, 1
  br i1 %t295, label %then55, label %else56
then55:
  ret i64 1
else56:
  %t296 = call i64 @rt_car(i64 %a0)
  %t297 = call i64 @rt_null_p(i64 %t296)
  %t298 = icmp ne i64 %t297, 1
  br i1 %t298, label %then57, label %else58
then57:
  ret i64 257
else58:
  %t299 = call i64 @rt_cdr(i64 %a0)
  %t300 = load i64, ptr @"scheme.base:%any-null?"
  %t301 = and i64 %t300, -8
  %t302 = inttoptr i64 %t301 to ptr
  %t303 = load i64, ptr %t302
  %t304 = inttoptr i64 %t303 to ptr
  %t305 = musttail call fastcc i64 %t304(i64 %t300, i64 1, i64 %t299, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t305
}

define fastcc i64 @"scheme.base:code_75"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t310 = icmp eq i64 %argc, 1
  br i1 %t310, label %argok60, label %arityerr59
arityerr59:
  call void @rt_arity_error(i64 1, i64 %argc)
  unreachable
argok60:
  %t311 = call i64 @rt_car(i64 %a0)
  ret i64 %t311
}

define fastcc i64 @"scheme.base:code_77"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t312 = icmp eq i64 %argc, 1
  br i1 %t312, label %argok62, label %arityerr61
arityerr61:
  call void @rt_arity_error(i64 1, i64 %argc)
  unreachable
argok62:
  %t313 = call i64 @rt_cdr(i64 %a0)
  ret i64 %t313
}

define fastcc i64 @"scheme.base:code_73"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t314 = icmp eq i64 %argc, 2
  br i1 %t314, label %argok64, label %arityerr63
arityerr63:
  call void @rt_arity_error(i64 2, i64 %argc)
  unreachable
argok64:
  %t315 = load i64, ptr @"scheme.base:%any-null?"
  %t316 = and i64 %t315, -8
  %t317 = inttoptr i64 %t316 to ptr
  %t318 = load i64, ptr %t317
  %t319 = inttoptr i64 %t318 to ptr
  %t320 = call fastcc i64%t319(i64 %t315, i64 1, i64 %a1, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t321 = icmp ne i64 %t320, 1
  br i1 %t321, label %then65, label %else66
then65:
  ret i64 2
else66:
  %t322 = call i64 @rt_alloc_words(i64 1)
  %t323 = inttoptr i64 %t322 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_75" to i64), ptr %t323
  %t324 = or i64 %t322, 4
  %t325 = load i64, ptr @"scheme.base:%map1"
  %t326 = and i64 %t325, -8
  %t327 = inttoptr i64 %t326 to ptr
  %t328 = load i64, ptr %t327
  %t329 = inttoptr i64 %t328 to ptr
  %t330 = call fastcc i64%t329(i64 %t325, i64 2, i64 %t324, i64 %a1, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t331 = and i64 %a0, -8
  %t332 = inttoptr i64 %t331 to ptr
  %t333 = load i64, ptr %t332
  %t334 = inttoptr i64 %t333 to ptr
  %t335 = call i64 @rt_list_length(i64 %t330)
  %t336 = add i64 0, %t335
  %t337 = call ptr @rt_apply_argv(i64 0, ptr null, i64 %t330, i64 8)
  %t349 = getelementptr i64, ptr %t337, i64 0
  %t341 = load i64, ptr %t349
  %t350 = getelementptr i64, ptr %t337, i64 1
  %t342 = load i64, ptr %t350
  %t351 = getelementptr i64, ptr %t337, i64 2
  %t343 = load i64, ptr %t351
  %t352 = getelementptr i64, ptr %t337, i64 3
  %t344 = load i64, ptr %t352
  %t353 = getelementptr i64, ptr %t337, i64 4
  %t345 = load i64, ptr %t353
  %t354 = getelementptr i64, ptr %t337, i64 5
  %t346 = load i64, ptr %t354
  %t355 = getelementptr i64, ptr %t337, i64 6
  %t347 = load i64, ptr %t355
  %t356 = getelementptr i64, ptr %t337, i64 7
  %t348 = load i64, ptr %t356
  %t338 = icmp sgt i64 %t336, 8
  %t339 = getelementptr i64, ptr %t337, i64 8
  %t340 = select i1 %t338, ptr %t339, ptr null
  %t357 = call fastcc i64%t334(i64 %a0, i64 %t336, i64 %t341, i64 %t342, i64 %t343, i64 %t344, i64 %t345, i64 %t346, i64 %t347, i64 %t348, ptr %t340)
  %t358 = call i64 @rt_alloc_words(i64 1)
  %t359 = inttoptr i64 %t358 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_77" to i64), ptr %t359
  %t360 = or i64 %t358, 4
  %t361 = load i64, ptr @"scheme.base:%map1"
  %t362 = and i64 %t361, -8
  %t363 = inttoptr i64 %t362 to ptr
  %t364 = load i64, ptr %t363
  %t365 = inttoptr i64 %t364 to ptr
  %t366 = call fastcc i64%t365(i64 %t361, i64 2, i64 %t360, i64 %a1, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t367 = load i64, ptr @"scheme.base:%mapn"
  %t368 = and i64 %t367, -8
  %t369 = inttoptr i64 %t368 to ptr
  %t370 = load i64, ptr %t369
  %t371 = inttoptr i64 %t370 to ptr
  %t372 = call fastcc i64%t371(i64 %t367, i64 2, i64 %a0, i64 %t366, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t373 = call i64 @rt_cons(i64 %t357, i64 %t372)
  ret i64 %t373
}

define fastcc i64 @"scheme.base:code_82"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t378 = icmp sge i64 %argc, 2
  br i1 %t378, label %argok68, label %arityerr67
arityerr67:
  call void @rt_arity_error(i64 2, i64 %argc)
  unreachable
argok68:
  %t379 = call i64 @rt_alloc_words(i64 8)
  %t380 = inttoptr i64 %t379 to ptr
  %t381 = getelementptr i64, ptr %t380, i64 0
  store i64 %a0, ptr %t381
  %t382 = getelementptr i64, ptr %t380, i64 1
  store i64 %a1, ptr %t382
  %t383 = getelementptr i64, ptr %t380, i64 2
  store i64 %a2, ptr %t383
  %t384 = getelementptr i64, ptr %t380, i64 3
  store i64 %a3, ptr %t384
  %t385 = getelementptr i64, ptr %t380, i64 4
  store i64 %a4, ptr %t385
  %t386 = getelementptr i64, ptr %t380, i64 5
  store i64 %a5, ptr %t386
  %t387 = getelementptr i64, ptr %t380, i64 6
  store i64 %a6, ptr %t387
  %t388 = getelementptr i64, ptr %t380, i64 7
  store i64 %a7, ptr %t388
  %t389 = call i64 @rt_build_rest(i64 %argc, i64 2, i64 8, ptr %t380, ptr %overflow)
  %t390 = call i64 @rt_null_p(i64 %t389)
  %t391 = icmp ne i64 %t390, 1
  br i1 %t391, label %then69, label %else70
then69:
  %t392 = load i64, ptr @"scheme.base:%map1"
  %t393 = and i64 %t392, -8
  %t394 = inttoptr i64 %t393 to ptr
  %t395 = load i64, ptr %t394
  %t396 = inttoptr i64 %t395 to ptr
  %t397 = musttail call fastcc i64 %t396(i64 %t392, i64 2, i64 %a0, i64 %a1, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t397
else70:
  %t398 = call i64 @rt_cons(i64 %a1, i64 %t389)
  %t399 = load i64, ptr @"scheme.base:%mapn"
  %t400 = and i64 %t399, -8
  %t401 = inttoptr i64 %t400 to ptr
  %t402 = load i64, ptr %t401
  %t403 = inttoptr i64 %t402 to ptr
  %t404 = musttail call fastcc i64 %t403(i64 %t399, i64 2, i64 %a0, i64 %t398, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t404
}

define fastcc i64 @"scheme.base:code_90"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t409 = icmp eq i64 %argc, 2
  br i1 %t409, label %argok72, label %arityerr71
arityerr71:
  call void @rt_arity_error(i64 2, i64 %argc)
  unreachable
argok72:
  %t410 = call i64 @rt_null_p(i64 %a1)
  %t411 = icmp ne i64 %t410, 1
  br i1 %t411, label %then73, label %else74
then73:
  ret i64 1
else74:
  %t412 = call i64 @rt_car(i64 %a1)
  %t413 = call i64 @rt_eq_p(i64 %a0, i64 %t412)
  %t414 = icmp ne i64 %t413, 1
  br i1 %t414, label %then75, label %else76
then75:
  ret i64 %a1
else76:
  %t415 = call i64 @rt_cdr(i64 %a1)
  %t416 = load i64, ptr @"scheme.base:memq"
  %t417 = and i64 %t416, -8
  %t418 = inttoptr i64 %t417 to ptr
  %t419 = load i64, ptr %t418
  %t420 = inttoptr i64 %t419 to ptr
  %t421 = musttail call fastcc i64 %t420(i64 %t416, i64 2, i64 %a0, i64 %t415, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t421
}

define fastcc i64 @"scheme.base:code_98"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t426 = icmp eq i64 %argc, 2
  br i1 %t426, label %argok78, label %arityerr77
arityerr77:
  call void @rt_arity_error(i64 2, i64 %argc)
  unreachable
argok78:
  %t427 = call i64 @rt_null_p(i64 %a1)
  %t428 = icmp ne i64 %t427, 1
  br i1 %t428, label %then79, label %else80
then79:
  ret i64 1
else80:
  %t429 = call i64 @rt_car(i64 %a1)
  %t430 = call i64 @rt_eqv_p(i64 %a0, i64 %t429)
  %t431 = icmp ne i64 %t430, 1
  br i1 %t431, label %then81, label %else82
then81:
  ret i64 %a1
else82:
  %t432 = call i64 @rt_cdr(i64 %a1)
  %t433 = load i64, ptr @"scheme.base:memv"
  %t434 = and i64 %t433, -8
  %t435 = inttoptr i64 %t434 to ptr
  %t436 = load i64, ptr %t435
  %t437 = inttoptr i64 %t436 to ptr
  %t438 = musttail call fastcc i64 %t437(i64 %t433, i64 2, i64 %a0, i64 %t432, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t438
}

define fastcc i64 @"scheme.base:code_106"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t443 = icmp eq i64 %argc, 2
  br i1 %t443, label %argok84, label %arityerr83
arityerr83:
  call void @rt_arity_error(i64 2, i64 %argc)
  unreachable
argok84:
  %t444 = call i64 @rt_null_p(i64 %a1)
  %t445 = icmp ne i64 %t444, 1
  br i1 %t445, label %then85, label %else86
then85:
  ret i64 1
else86:
  %t446 = call i64 @rt_car(i64 %a1)
  %t447 = call i64 @rt_car(i64 %t446)
  %t448 = call i64 @rt_eq_p(i64 %a0, i64 %t447)
  %t449 = icmp ne i64 %t448, 1
  br i1 %t449, label %then87, label %else88
then87:
  %t450 = call i64 @rt_car(i64 %a1)
  ret i64 %t450
else88:
  %t451 = call i64 @rt_cdr(i64 %a1)
  %t452 = load i64, ptr @"scheme.base:assq"
  %t453 = and i64 %t452, -8
  %t454 = inttoptr i64 %t453 to ptr
  %t455 = load i64, ptr %t454
  %t456 = inttoptr i64 %t455 to ptr
  %t457 = musttail call fastcc i64 %t456(i64 %t452, i64 2, i64 %a0, i64 %t451, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t457
}

define fastcc i64 @"scheme.base:code_110"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t462 = icmp eq i64 %argc, 2
  br i1 %t462, label %argok90, label %arityerr89
arityerr89:
  call void @rt_arity_error(i64 2, i64 %argc)
  unreachable
argok90:
  %t463 = call i64 @rt_null_p(i64 %a1)
  %t464 = icmp ne i64 %t463, 1
  br i1 %t464, label %then91, label %else92
then91:
  ret i64 1
else92:
  %t465 = call i64 @rt_car(i64 %a1)
  %t466 = call i64 @rt_equal(i64 %a0, i64 %t465)
  %t467 = icmp ne i64 %t466, 1
  br i1 %t467, label %then93, label %else94
then93:
  ret i64 %a1
else94:
  %t468 = call i64 @rt_cdr(i64 %a1)
  %t469 = load i64, ptr @"scheme.base:member"
  %t470 = and i64 %t469, -8
  %t471 = inttoptr i64 %t470 to ptr
  %t472 = load i64, ptr %t471
  %t473 = inttoptr i64 %t472 to ptr
  %t474 = musttail call fastcc i64 %t473(i64 %t469, i64 2, i64 %a0, i64 %t468, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t474
}

define fastcc i64 @"scheme.base:code_114"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t479 = icmp eq i64 %argc, 2
  br i1 %t479, label %argok96, label %arityerr95
arityerr95:
  call void @rt_arity_error(i64 2, i64 %argc)
  unreachable
argok96:
  %t480 = call i64 @rt_null_p(i64 %a1)
  %t481 = icmp ne i64 %t480, 1
  br i1 %t481, label %then97, label %else98
then97:
  ret i64 1
else98:
  %t482 = call i64 @rt_car(i64 %a1)
  %t483 = call i64 @rt_car(i64 %t482)
  %t484 = call i64 @rt_equal(i64 %a0, i64 %t483)
  %t485 = icmp ne i64 %t484, 1
  br i1 %t485, label %then99, label %else100
then99:
  %t486 = call i64 @rt_car(i64 %a1)
  ret i64 %t486
else100:
  %t487 = call i64 @rt_cdr(i64 %a1)
  %t488 = load i64, ptr @"scheme.base:assoc"
  %t489 = and i64 %t488, -8
  %t490 = inttoptr i64 %t489 to ptr
  %t491 = load i64, ptr %t490
  %t492 = inttoptr i64 %t491 to ptr
  %t493 = musttail call fastcc i64 %t492(i64 %t488, i64 2, i64 %a0, i64 %t487, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t493
}

define fastcc i64 @"scheme.base:code_118"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t498 = icmp eq i64 %argc, 2
  br i1 %t498, label %argok102, label %arityerr101
arityerr101:
  call void @rt_arity_error(i64 2, i64 %argc)
  unreachable
argok102:
  %t499 = call i64 @rt_null_p(i64 %a1)
  %t500 = icmp ne i64 %t499, 1
  br i1 %t500, label %then103, label %else104
then103:
  ret i64 2
else104:
  %t501 = call i64 @rt_car(i64 %a1)
  %t502 = and i64 %a0, -8
  %t503 = inttoptr i64 %t502 to ptr
  %t504 = load i64, ptr %t503
  %t505 = inttoptr i64 %t504 to ptr
  %t506 = call fastcc i64%t505(i64 %a0, i64 1, i64 %t501, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t507 = icmp ne i64 %t506, 1
  br i1 %t507, label %then105, label %else106
then105:
  %t508 = call i64 @rt_car(i64 %a1)
  %t509 = call i64 @rt_cdr(i64 %a1)
  %t510 = load i64, ptr @"scheme.base:filter"
  %t511 = and i64 %t510, -8
  %t512 = inttoptr i64 %t511 to ptr
  %t513 = load i64, ptr %t512
  %t514 = inttoptr i64 %t513 to ptr
  %t515 = call fastcc i64%t514(i64 %t510, i64 2, i64 %a0, i64 %t509, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t516 = call i64 @rt_cons(i64 %t508, i64 %t515)
  ret i64 %t516
else106:
  %t517 = call i64 @rt_cdr(i64 %a1)
  %t518 = load i64, ptr @"scheme.base:filter"
  %t519 = and i64 %t518, -8
  %t520 = inttoptr i64 %t519 to ptr
  %t521 = load i64, ptr %t520
  %t522 = inttoptr i64 %t521 to ptr
  %t523 = musttail call fastcc i64 %t522(i64 %t518, i64 2, i64 %a0, i64 %t517, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t523
}

define fastcc i64 @"scheme.base:code_123"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t528 = icmp eq i64 %argc, 3
  br i1 %t528, label %argok108, label %arityerr107
arityerr107:
  call void @rt_arity_error(i64 3, i64 %argc)
  unreachable
argok108:
  %t529 = call i64 @rt_null_p(i64 %a2)
  %t530 = icmp ne i64 %t529, 1
  br i1 %t530, label %then109, label %else110
then109:
  ret i64 %a1
else110:
  %t531 = call i64 @rt_car(i64 %a2)
  %t532 = and i64 %a0, -8
  %t533 = inttoptr i64 %t532 to ptr
  %t534 = load i64, ptr %t533
  %t535 = inttoptr i64 %t534 to ptr
  %t536 = call fastcc i64%t535(i64 %a0, i64 2, i64 %a1, i64 %t531, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t537 = call i64 @rt_cdr(i64 %a2)
  %t538 = load i64, ptr @"scheme.base:fold-left"
  %t539 = and i64 %t538, -8
  %t540 = inttoptr i64 %t539 to ptr
  %t541 = load i64, ptr %t540
  %t542 = inttoptr i64 %t541 to ptr
  %t543 = musttail call fastcc i64 %t542(i64 %t538, i64 3, i64 %a0, i64 %t536, i64 %t537, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t543
}

define fastcc i64 @"scheme.base:code_128"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t548 = icmp eq i64 %argc, 3
  br i1 %t548, label %argok112, label %arityerr111
arityerr111:
  call void @rt_arity_error(i64 3, i64 %argc)
  unreachable
argok112:
  %t549 = call i64 @rt_null_p(i64 %a2)
  %t550 = icmp ne i64 %t549, 1
  br i1 %t550, label %then113, label %else114
then113:
  ret i64 %a1
else114:
  %t551 = call i64 @rt_car(i64 %a2)
  %t552 = call i64 @rt_cdr(i64 %a2)
  %t553 = load i64, ptr @"scheme.base:fold-right"
  %t554 = and i64 %t553, -8
  %t555 = inttoptr i64 %t554 to ptr
  %t556 = load i64, ptr %t555
  %t557 = inttoptr i64 %t556 to ptr
  %t558 = call fastcc i64%t557(i64 %t553, i64 3, i64 %a0, i64 %a1, i64 %t552, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t559 = and i64 %a0, -8
  %t560 = inttoptr i64 %t559 to ptr
  %t561 = load i64, ptr %t560
  %t562 = inttoptr i64 %t561 to ptr
  %t563 = musttail call fastcc i64 %t562(i64 %a0, i64 2, i64 %t551, i64 %t558, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t563
}

define fastcc i64 @"scheme.base:code_132"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t568 = icmp eq i64 %argc, 2
  br i1 %t568, label %argok116, label %arityerr115
arityerr115:
  call void @rt_arity_error(i64 2, i64 %argc)
  unreachable
argok116:
  %t569 = call i64 @rt_null_p(i64 %a1)
  %t570 = icmp ne i64 %t569, 1
  br i1 %t570, label %then117, label %else118
then117:
  %t571 = icmp ne i64 1, 1
  br i1 %t571, label %then119, label %else120
then119:
  ret i64 1
else120:
  ret i64 1
else118:
  %t572 = call i64 @rt_car(i64 %a1)
  %t573 = and i64 %a0, -8
  %t574 = inttoptr i64 %t573 to ptr
  %t575 = load i64, ptr %t574
  %t576 = inttoptr i64 %t575 to ptr
  %t577 = call fastcc i64%t576(i64 %a0, i64 1, i64 %t572, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t578 = call i64 @rt_cdr(i64 %a1)
  %t579 = load i64, ptr @"scheme.base:%for-each1"
  %t580 = and i64 %t579, -8
  %t581 = inttoptr i64 %t580 to ptr
  %t582 = load i64, ptr %t581
  %t583 = inttoptr i64 %t582 to ptr
  %t584 = musttail call fastcc i64 %t583(i64 %t579, i64 2, i64 %a0, i64 %t578, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t584
}

define fastcc i64 @"scheme.base:code_140"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t589 = icmp eq i64 %argc, 1
  br i1 %t589, label %argok122, label %arityerr121
arityerr121:
  call void @rt_arity_error(i64 1, i64 %argc)
  unreachable
argok122:
  %t590 = call i64 @rt_car(i64 %a0)
  ret i64 %t590
}

define fastcc i64 @"scheme.base:code_142"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t591 = icmp eq i64 %argc, 1
  br i1 %t591, label %argok124, label %arityerr123
arityerr123:
  call void @rt_arity_error(i64 1, i64 %argc)
  unreachable
argok124:
  %t592 = call i64 @rt_cdr(i64 %a0)
  ret i64 %t592
}

define fastcc i64 @"scheme.base:code_138"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t593 = icmp eq i64 %argc, 2
  br i1 %t593, label %argok126, label %arityerr125
arityerr125:
  call void @rt_arity_error(i64 2, i64 %argc)
  unreachable
argok126:
  %t594 = load i64, ptr @"scheme.base:%any-null?"
  %t595 = and i64 %t594, -8
  %t596 = inttoptr i64 %t595 to ptr
  %t597 = load i64, ptr %t596
  %t598 = inttoptr i64 %t597 to ptr
  %t599 = call fastcc i64%t598(i64 %t594, i64 1, i64 %a1, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t600 = icmp ne i64 %t599, 1
  br i1 %t600, label %then127, label %else128
then127:
  %t601 = icmp ne i64 1, 1
  br i1 %t601, label %then129, label %else130
then129:
  ret i64 1
else130:
  ret i64 1
else128:
  %t602 = call i64 @rt_alloc_words(i64 1)
  %t603 = inttoptr i64 %t602 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_140" to i64), ptr %t603
  %t604 = or i64 %t602, 4
  %t605 = load i64, ptr @"scheme.base:%map1"
  %t606 = and i64 %t605, -8
  %t607 = inttoptr i64 %t606 to ptr
  %t608 = load i64, ptr %t607
  %t609 = inttoptr i64 %t608 to ptr
  %t610 = call fastcc i64%t609(i64 %t605, i64 2, i64 %t604, i64 %a1, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t611 = and i64 %a0, -8
  %t612 = inttoptr i64 %t611 to ptr
  %t613 = load i64, ptr %t612
  %t614 = inttoptr i64 %t613 to ptr
  %t615 = call i64 @rt_list_length(i64 %t610)
  %t616 = add i64 0, %t615
  %t617 = call ptr @rt_apply_argv(i64 0, ptr null, i64 %t610, i64 8)
  %t629 = getelementptr i64, ptr %t617, i64 0
  %t621 = load i64, ptr %t629
  %t630 = getelementptr i64, ptr %t617, i64 1
  %t622 = load i64, ptr %t630
  %t631 = getelementptr i64, ptr %t617, i64 2
  %t623 = load i64, ptr %t631
  %t632 = getelementptr i64, ptr %t617, i64 3
  %t624 = load i64, ptr %t632
  %t633 = getelementptr i64, ptr %t617, i64 4
  %t625 = load i64, ptr %t633
  %t634 = getelementptr i64, ptr %t617, i64 5
  %t626 = load i64, ptr %t634
  %t635 = getelementptr i64, ptr %t617, i64 6
  %t627 = load i64, ptr %t635
  %t636 = getelementptr i64, ptr %t617, i64 7
  %t628 = load i64, ptr %t636
  %t618 = icmp sgt i64 %t616, 8
  %t619 = getelementptr i64, ptr %t617, i64 8
  %t620 = select i1 %t618, ptr %t619, ptr null
  %t637 = call fastcc i64%t614(i64 %a0, i64 %t616, i64 %t621, i64 %t622, i64 %t623, i64 %t624, i64 %t625, i64 %t626, i64 %t627, i64 %t628, ptr %t620)
  %t638 = call i64 @rt_alloc_words(i64 1)
  %t639 = inttoptr i64 %t638 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_142" to i64), ptr %t639
  %t640 = or i64 %t638, 4
  %t641 = load i64, ptr @"scheme.base:%map1"
  %t642 = and i64 %t641, -8
  %t643 = inttoptr i64 %t642 to ptr
  %t644 = load i64, ptr %t643
  %t645 = inttoptr i64 %t644 to ptr
  %t646 = call fastcc i64%t645(i64 %t641, i64 2, i64 %t640, i64 %a1, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t647 = load i64, ptr @"scheme.base:%for-eachn"
  %t648 = and i64 %t647, -8
  %t649 = inttoptr i64 %t648 to ptr
  %t650 = load i64, ptr %t649
  %t651 = inttoptr i64 %t650 to ptr
  %t652 = musttail call fastcc i64 %t651(i64 %t647, i64 2, i64 %a0, i64 %t646, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t652
}

define fastcc i64 @"scheme.base:code_147"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t657 = icmp sge i64 %argc, 2
  br i1 %t657, label %argok132, label %arityerr131
arityerr131:
  call void @rt_arity_error(i64 2, i64 %argc)
  unreachable
argok132:
  %t658 = call i64 @rt_alloc_words(i64 8)
  %t659 = inttoptr i64 %t658 to ptr
  %t660 = getelementptr i64, ptr %t659, i64 0
  store i64 %a0, ptr %t660
  %t661 = getelementptr i64, ptr %t659, i64 1
  store i64 %a1, ptr %t661
  %t662 = getelementptr i64, ptr %t659, i64 2
  store i64 %a2, ptr %t662
  %t663 = getelementptr i64, ptr %t659, i64 3
  store i64 %a3, ptr %t663
  %t664 = getelementptr i64, ptr %t659, i64 4
  store i64 %a4, ptr %t664
  %t665 = getelementptr i64, ptr %t659, i64 5
  store i64 %a5, ptr %t665
  %t666 = getelementptr i64, ptr %t659, i64 6
  store i64 %a6, ptr %t666
  %t667 = getelementptr i64, ptr %t659, i64 7
  store i64 %a7, ptr %t667
  %t668 = call i64 @rt_build_rest(i64 %argc, i64 2, i64 8, ptr %t659, ptr %overflow)
  %t669 = call i64 @rt_null_p(i64 %t668)
  %t670 = icmp ne i64 %t669, 1
  br i1 %t670, label %then133, label %else134
then133:
  %t671 = load i64, ptr @"scheme.base:%for-each1"
  %t672 = and i64 %t671, -8
  %t673 = inttoptr i64 %t672 to ptr
  %t674 = load i64, ptr %t673
  %t675 = inttoptr i64 %t674 to ptr
  %t676 = musttail call fastcc i64 %t675(i64 %t671, i64 2, i64 %a0, i64 %a1, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t676
else134:
  %t677 = call i64 @rt_cons(i64 %a1, i64 %t668)
  %t678 = load i64, ptr @"scheme.base:%for-eachn"
  %t679 = and i64 %t678, -8
  %t680 = inttoptr i64 %t679 to ptr
  %t681 = load i64, ptr %t680
  %t682 = inttoptr i64 %t681 to ptr
  %t683 = musttail call fastcc i64 %t682(i64 %t678, i64 2, i64 %a0, i64 %t677, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t683
}

define fastcc i64 @"scheme.base:code_151"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t688 = icmp eq i64 %argc, 2
  br i1 %t688, label %argok136, label %arityerr135
arityerr135:
  call void @rt_arity_error(i64 2, i64 %argc)
  unreachable
argok136:
  %t689 = call i64 @rt_null_p(i64 %a1)
  %t690 = icmp ne i64 %t689, 1
  br i1 %t690, label %then137, label %else138
then137:
  ret i64 257
else138:
  %t691 = call i64 @rt_car(i64 %a1)
  %t692 = and i64 %a0, -8
  %t693 = inttoptr i64 %t692 to ptr
  %t694 = load i64, ptr %t693
  %t695 = inttoptr i64 %t694 to ptr
  %t696 = call fastcc i64%t695(i64 %a0, i64 1, i64 %t691, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t697 = icmp ne i64 %t696, 1
  br i1 %t697, label %then139, label %else140
then139:
  %t698 = call i64 @rt_cdr(i64 %a1)
  %t699 = load i64, ptr @"scheme.base:andmap"
  %t700 = and i64 %t699, -8
  %t701 = inttoptr i64 %t700 to ptr
  %t702 = load i64, ptr %t701
  %t703 = inttoptr i64 %t702 to ptr
  %t704 = musttail call fastcc i64 %t703(i64 %t699, i64 2, i64 %a0, i64 %t698, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t704
else140:
  ret i64 1
}

define fastcc i64 @"scheme.base:code_155"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t709 = icmp eq i64 %argc, 2
  br i1 %t709, label %argok142, label %arityerr141
arityerr141:
  call void @rt_arity_error(i64 2, i64 %argc)
  unreachable
argok142:
  %t710 = call i64 @rt_null_p(i64 %a1)
  %t711 = icmp ne i64 %t710, 1
  br i1 %t711, label %then143, label %else144
then143:
  ret i64 1
else144:
  %t712 = call i64 @rt_car(i64 %a1)
  %t713 = and i64 %a0, -8
  %t714 = inttoptr i64 %t713 to ptr
  %t715 = load i64, ptr %t714
  %t716 = inttoptr i64 %t715 to ptr
  %t717 = call fastcc i64%t716(i64 %a0, i64 1, i64 %t712, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t718 = icmp ne i64 %t717, 1
  br i1 %t718, label %then145, label %else146
then145:
  ret i64 %a1
else146:
  %t719 = call i64 @rt_cdr(i64 %a1)
  %t720 = load i64, ptr @"scheme.base:memp"
  %t721 = and i64 %t720, -8
  %t722 = inttoptr i64 %t721 to ptr
  %t723 = load i64, ptr %t722
  %t724 = inttoptr i64 %t723 to ptr
  %t725 = musttail call fastcc i64 %t724(i64 %t720, i64 2, i64 %a0, i64 %t719, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t725
}

define fastcc i64 @"scheme.base:code_158"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t730 = icmp eq i64 %argc, 1
  br i1 %t730, label %argok148, label %arityerr147
arityerr147:
  call void @rt_arity_error(i64 1, i64 %argc)
  unreachable
argok148:
  %t731 = load i64, ptr @"scheme.base:cdddr"
  %t732 = and i64 %t731, -8
  %t733 = inttoptr i64 %t732 to ptr
  %t734 = load i64, ptr %t733
  %t735 = inttoptr i64 %t734 to ptr
  %t736 = call fastcc i64%t735(i64 %t731, i64 1, i64 %a0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t737 = call i64 @rt_car(i64 %t736)
  ret i64 %t737
}

define fastcc i64 @"scheme.base:code_161"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t742 = icmp eq i64 %argc, 1
  br i1 %t742, label %argok150, label %arityerr149
arityerr149:
  call void @rt_arity_error(i64 1, i64 %argc)
  unreachable
argok150:
  %t743 = call i64 @rt_null_p(i64 %a0)
  %t744 = icmp ne i64 %t743, 1
  br i1 %t744, label %then151, label %else152
then151:
  ret i64 257
else152:
  %t745 = call i64 @rt_pair_p(i64 %a0)
  %t746 = icmp ne i64 %t745, 1
  br i1 %t746, label %then153, label %else154
then153:
  %t747 = call i64 @rt_cdr(i64 %a0)
  %t748 = load i64, ptr @"scheme.base:list?"
  %t749 = and i64 %t748, -8
  %t750 = inttoptr i64 %t749 to ptr
  %t751 = load i64, ptr %t750
  %t752 = inttoptr i64 %t751 to ptr
  %t753 = musttail call fastcc i64 %t752(i64 %t748, i64 1, i64 %t747, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t753
else154:
  ret i64 1
}

define fastcc i64 @"scheme.base:code_168"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t758 = icmp eq i64 %argc, 1
  br i1 %t758, label %argok156, label %arityerr155
arityerr155:
  call void @rt_arity_error(i64 1, i64 %argc)
  unreachable
argok156:
  %t759 = call i64 @rt_num_eq(i64 %a0, i64 0)
  ret i64 %t759
}

define fastcc i64 @"scheme.base:code_172"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t764 = icmp eq i64 %argc, 2
  br i1 %t764, label %argok158, label %arityerr157
arityerr157:
  call void @rt_arity_error(i64 2, i64 %argc)
  unreachable
argok158:
  %t765 = load i64, ptr @"scheme.base:zero?"
  %t766 = and i64 %t765, -8
  %t767 = inttoptr i64 %t766 to ptr
  %t768 = load i64, ptr %t767
  %t769 = inttoptr i64 %t768 to ptr
  %t770 = call fastcc i64%t769(i64 %t765, i64 1, i64 %a1, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t771 = icmp ne i64 %t770, 1
  br i1 %t771, label %then159, label %else160
then159:
  ret i64 %a0
else160:
  %t772 = call i64 @rt_cdr(i64 %a0)
  %t773 = call i64 @rt_sub(i64 %a1, i64 8)
  %t774 = load i64, ptr @"scheme.base:list-tail"
  %t775 = and i64 %t774, -8
  %t776 = inttoptr i64 %t775 to ptr
  %t777 = load i64, ptr %t776
  %t778 = inttoptr i64 %t777 to ptr
  %t779 = musttail call fastcc i64 %t778(i64 %t774, i64 2, i64 %t772, i64 %t773, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t779
}

define fastcc i64 @"scheme.base:code_176"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t784 = icmp eq i64 %argc, 2
  br i1 %t784, label %argok162, label %arityerr161
arityerr161:
  call void @rt_arity_error(i64 2, i64 %argc)
  unreachable
argok162:
  %t785 = load i64, ptr @"scheme.base:list-tail"
  %t786 = and i64 %t785, -8
  %t787 = inttoptr i64 %t786 to ptr
  %t788 = load i64, ptr %t787
  %t789 = inttoptr i64 %t788 to ptr
  %t790 = call fastcc i64%t789(i64 %t785, i64 2, i64 %a0, i64 %a1, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t791 = call i64 @rt_car(i64 %t790)
  ret i64 %t791
}

define fastcc i64 @"scheme.base:code_180"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t796 = icmp eq i64 %argc, 2
  br i1 %t796, label %argok164, label %arityerr163
arityerr163:
  call void @rt_arity_error(i64 2, i64 %argc)
  unreachable
argok164:
  %t797 = load i64, ptr @"scheme.base:zero?"
  %t798 = and i64 %t797, -8
  %t799 = inttoptr i64 %t798 to ptr
  %t800 = load i64, ptr %t799
  %t801 = inttoptr i64 %t800 to ptr
  %t802 = call fastcc i64%t801(i64 %t797, i64 1, i64 %a1, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t803 = icmp ne i64 %t802, 1
  br i1 %t803, label %then165, label %else166
then165:
  ret i64 2
else166:
  %t804 = call i64 @rt_car(i64 %a0)
  %t805 = call i64 @rt_cdr(i64 %a0)
  %t806 = call i64 @rt_sub(i64 %a1, i64 8)
  %t807 = load i64, ptr @"scheme.base:list-head"
  %t808 = and i64 %t807, -8
  %t809 = inttoptr i64 %t808 to ptr
  %t810 = load i64, ptr %t809
  %t811 = inttoptr i64 %t810 to ptr
  %t812 = call fastcc i64%t811(i64 %t807, i64 2, i64 %t805, i64 %t806, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t813 = call i64 @rt_cons(i64 %t804, i64 %t812)
  ret i64 %t813
}

define fastcc i64 @"scheme.base:code_184"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t818 = icmp eq i64 %argc, 2
  br i1 %t818, label %argok168, label %arityerr167
arityerr167:
  call void @rt_arity_error(i64 2, i64 %argc)
  unreachable
argok168:
  %t819 = load i64, ptr @"scheme.base:zero?"
  %t820 = and i64 %t819, -8
  %t821 = inttoptr i64 %t820 to ptr
  %t822 = load i64, ptr %t821
  %t823 = inttoptr i64 %t822 to ptr
  %t824 = call fastcc i64%t823(i64 %t819, i64 1, i64 %a0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t825 = icmp ne i64 %t824, 1
  br i1 %t825, label %then169, label %else170
then169:
  ret i64 2
else170:
  %t826 = call i64 @rt_sub(i64 %a0, i64 8)
  %t827 = load i64, ptr @"scheme.base:make-list"
  %t828 = and i64 %t827, -8
  %t829 = inttoptr i64 %t828 to ptr
  %t830 = load i64, ptr %t829
  %t831 = inttoptr i64 %t830 to ptr
  %t832 = call fastcc i64%t831(i64 %t827, i64 2, i64 %t826, i64 %a1, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t833 = call i64 @rt_cons(i64 %a1, i64 %t832)
  ret i64 %t833
}

define fastcc i64 @"scheme.base:code_196"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t838 = icmp eq i64 %argc, 2
  br i1 %t838, label %argok172, label %arityerr171
arityerr171:
  call void @rt_arity_error(i64 2, i64 %argc)
  unreachable
argok172:
  %t839 = and i64 %self, -8
  %t840 = inttoptr i64 %t839 to ptr
  %t841 = getelementptr i64, ptr %t840, i64 1
  %t842 = load i64, ptr %t841
  %t843 = call i64 @rt_num_eq(i64 %a0, i64 %t842)
  %t844 = icmp ne i64 %t843, 1
  br i1 %t844, label %then173, label %else174
then173:
  %t845 = load i64, ptr @"scheme.base:reverse"
  %t846 = and i64 %t845, -8
  %t847 = inttoptr i64 %t846 to ptr
  %t848 = load i64, ptr %t847
  %t849 = inttoptr i64 %t848 to ptr
  %t850 = musttail call fastcc i64 %t849(i64 %t845, i64 1, i64 %a1, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t850
else174:
  %t851 = call i64 @rt_add(i64 %a0, i64 8)
  %t852 = call i64 @rt_cons(i64 %a0, i64 %a1)
  %t853 = and i64 %self, -8
  %t854 = inttoptr i64 %t853 to ptr
  %t855 = getelementptr i64, ptr %t854, i64 2
  %t856 = load i64, ptr %t855
  %t857 = and i64 %t856, -8
  %t858 = inttoptr i64 %t857 to ptr
  %t859 = load i64, ptr %t858
  %t860 = inttoptr i64 %t859 to ptr
  %t861 = musttail call fastcc i64 %t860(i64 %t856, i64 2, i64 %t851, i64 %t852, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t861
}

define fastcc i64 @"scheme.base:code_194"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t862 = icmp eq i64 %argc, 1
  br i1 %t862, label %argok176, label %arityerr175
arityerr175:
  call void @rt_arity_error(i64 1, i64 %argc)
  unreachable
argok176:
  %t863 = call i64 @rt_alloc_words(i64 3)
  %t864 = inttoptr i64 %t863 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_196" to i64), ptr %t864
  %t865 = or i64 %t863, 4
  %t866 = getelementptr i64, ptr %t864, i64 1
  store i64 %a0, ptr %t866
  %t867 = getelementptr i64, ptr %t864, i64 2
  store i64 %t865, ptr %t867
  %t868 = and i64 %t865, -8
  %t869 = inttoptr i64 %t868 to ptr
  %t870 = load i64, ptr %t869
  %t871 = inttoptr i64 %t870 to ptr
  %t872 = musttail call fastcc i64 %t871(i64 %t865, i64 2, i64 0, i64 2, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t872
}

define fastcc i64 @"scheme.base:code_204"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t877 = icmp eq i64 %argc, 2
  br i1 %t877, label %argok178, label %arityerr177
arityerr177:
  call void @rt_arity_error(i64 2, i64 %argc)
  unreachable
argok178:
  %t878 = call i64 @rt_lt(i64 %a0, i64 %a1)
  %t879 = icmp ne i64 %t878, 1
  br i1 %t879, label %then179, label %else180
then179:
  ret i64 %a1
else180:
  ret i64 %a0
}

define fastcc i64 @"scheme.base:code_206"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t884 = icmp eq i64 %argc, 0
  br i1 %t884, label %argok182, label %arityerr181
arityerr181:
  call void @rt_arity_error(i64 0, i64 %argc)
  unreachable
argok182:
  %t885 = icmp ne i64 1, 1
  br i1 %t885, label %then183, label %else184
then183:
  ret i64 1
else184:
  ret i64 1
}

define fastcc i64 @"scheme.base:code_209"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t890 = icmp sge i64 %argc, 0
  br i1 %t890, label %argok186, label %arityerr185
arityerr185:
  call void @rt_arity_error(i64 0, i64 %argc)
  unreachable
argok186:
  %t891 = call i64 @rt_alloc_words(i64 8)
  %t892 = inttoptr i64 %t891 to ptr
  %t893 = getelementptr i64, ptr %t892, i64 0
  store i64 %a0, ptr %t893
  %t894 = getelementptr i64, ptr %t892, i64 1
  store i64 %a1, ptr %t894
  %t895 = getelementptr i64, ptr %t892, i64 2
  store i64 %a2, ptr %t895
  %t896 = getelementptr i64, ptr %t892, i64 3
  store i64 %a3, ptr %t896
  %t897 = getelementptr i64, ptr %t892, i64 4
  store i64 %a4, ptr %t897
  %t898 = getelementptr i64, ptr %t892, i64 5
  store i64 %a5, ptr %t898
  %t899 = getelementptr i64, ptr %t892, i64 6
  store i64 %a6, ptr %t899
  %t900 = getelementptr i64, ptr %t892, i64 7
  store i64 %a7, ptr %t900
  %t901 = call i64 @rt_build_rest(i64 %argc, i64 0, i64 8, ptr %t892, ptr %overflow)
  %t902 = call i64 @rt_list_to_string(i64 %t901)
  ret i64 %t902
}

define fastcc i64 @"scheme.base:code_212"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t907 = icmp eq i64 %argc, 1
  br i1 %t907, label %argok188, label %arityerr187
arityerr187:
  call void @rt_arity_error(i64 1, i64 %argc)
  unreachable
argok188:
  %t908 = call i64 @rt_null_p(i64 %a0)
  %t909 = icmp ne i64 %t908, 1
  br i1 %t909, label %then189, label %else190
then189:
  %t910 = call i64 @rt_make_string(ptr @.str.lit.0, i64 0)
  ret i64 %t910
else190:
  %t911 = call i64 @rt_car(i64 %a0)
  %t912 = call i64 @rt_cdr(i64 %a0)
  %t913 = load i64, ptr @"scheme.base:%str-concat"
  %t914 = and i64 %t913, -8
  %t915 = inttoptr i64 %t914 to ptr
  %t916 = load i64, ptr %t915
  %t917 = inttoptr i64 %t916 to ptr
  %t918 = call fastcc i64%t917(i64 %t913, i64 1, i64 %t912, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t919 = call i64 @rt_string_append(i64 %t911, i64 %t918)
  ret i64 %t919
}

define fastcc i64 @"scheme.base:code_218"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t924 = icmp eq i64 %argc, 4
  br i1 %t924, label %argok192, label %arityerr191
arityerr191:
  call void @rt_arity_error(i64 4, i64 %argc)
  unreachable
argok192:
  %t925 = call i64 @rt_char_to_integer(i64 %a1)
  %t926 = call i64 @rt_char_to_integer(i64 %a2)
  %t927 = and i64 %a0, -8
  %t928 = inttoptr i64 %t927 to ptr
  %t929 = load i64, ptr %t928
  %t930 = inttoptr i64 %t929 to ptr
  %t931 = call fastcc i64%t930(i64 %a0, i64 2, i64 %t925, i64 %t926, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t932 = icmp ne i64 %t931, 1
  br i1 %t932, label %then193, label %else194
then193:
  %t933 = call i64 @rt_null_p(i64 %a3)
  %t934 = icmp ne i64 %t933, 1
  br i1 %t934, label %then195, label %else196
then195:
  ret i64 257
else196:
  %t935 = call i64 @rt_car(i64 %a3)
  %t936 = call i64 @rt_cdr(i64 %a3)
  %t937 = load i64, ptr @"scheme.base:chr-cmp"
  %t938 = and i64 %t937, -8
  %t939 = inttoptr i64 %t938 to ptr
  %t940 = load i64, ptr %t939
  %t941 = inttoptr i64 %t940 to ptr
  %t942 = musttail call fastcc i64 %t941(i64 %t937, i64 4, i64 %a0, i64 %a2, i64 %t935, i64 %t936, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t942
else194:
  ret i64 1
}

define fastcc i64 @"scheme.base:code_231"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t947 = icmp eq i64 %argc, 2
  br i1 %t947, label %argok198, label %arityerr197
arityerr197:
  call void @rt_arity_error(i64 2, i64 %argc)
  unreachable
argok198:
  %t948 = call i64 @rt_num_eq(i64 %a0, i64 %a1)
  ret i64 %t948
}

define fastcc i64 @"scheme.base:code_229"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t949 = icmp sge i64 %argc, 2
  br i1 %t949, label %argok200, label %arityerr199
arityerr199:
  call void @rt_arity_error(i64 2, i64 %argc)
  unreachable
argok200:
  %t950 = call i64 @rt_alloc_words(i64 8)
  %t951 = inttoptr i64 %t950 to ptr
  %t952 = getelementptr i64, ptr %t951, i64 0
  store i64 %a0, ptr %t952
  %t953 = getelementptr i64, ptr %t951, i64 1
  store i64 %a1, ptr %t953
  %t954 = getelementptr i64, ptr %t951, i64 2
  store i64 %a2, ptr %t954
  %t955 = getelementptr i64, ptr %t951, i64 3
  store i64 %a3, ptr %t955
  %t956 = getelementptr i64, ptr %t951, i64 4
  store i64 %a4, ptr %t956
  %t957 = getelementptr i64, ptr %t951, i64 5
  store i64 %a5, ptr %t957
  %t958 = getelementptr i64, ptr %t951, i64 6
  store i64 %a6, ptr %t958
  %t959 = getelementptr i64, ptr %t951, i64 7
  store i64 %a7, ptr %t959
  %t960 = call i64 @rt_build_rest(i64 %argc, i64 2, i64 8, ptr %t951, ptr %overflow)
  %t961 = call i64 @rt_alloc_words(i64 1)
  %t962 = inttoptr i64 %t961 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_231" to i64), ptr %t962
  %t963 = or i64 %t961, 4
  %t964 = load i64, ptr @"scheme.base:chr-cmp"
  %t965 = and i64 %t964, -8
  %t966 = inttoptr i64 %t965 to ptr
  %t967 = load i64, ptr %t966
  %t968 = inttoptr i64 %t967 to ptr
  %t969 = musttail call fastcc i64 %t968(i64 %t964, i64 4, i64 %t963, i64 %a0, i64 %a1, i64 %t960, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t969
}

define fastcc i64 @"scheme.base:code_244"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t974 = icmp eq i64 %argc, 2
  br i1 %t974, label %argok202, label %arityerr201
arityerr201:
  call void @rt_arity_error(i64 2, i64 %argc)
  unreachable
argok202:
  %t975 = call i64 @rt_lt(i64 %a0, i64 %a1)
  ret i64 %t975
}

define fastcc i64 @"scheme.base:code_242"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t976 = icmp sge i64 %argc, 2
  br i1 %t976, label %argok204, label %arityerr203
arityerr203:
  call void @rt_arity_error(i64 2, i64 %argc)
  unreachable
argok204:
  %t977 = call i64 @rt_alloc_words(i64 8)
  %t978 = inttoptr i64 %t977 to ptr
  %t979 = getelementptr i64, ptr %t978, i64 0
  store i64 %a0, ptr %t979
  %t980 = getelementptr i64, ptr %t978, i64 1
  store i64 %a1, ptr %t980
  %t981 = getelementptr i64, ptr %t978, i64 2
  store i64 %a2, ptr %t981
  %t982 = getelementptr i64, ptr %t978, i64 3
  store i64 %a3, ptr %t982
  %t983 = getelementptr i64, ptr %t978, i64 4
  store i64 %a4, ptr %t983
  %t984 = getelementptr i64, ptr %t978, i64 5
  store i64 %a5, ptr %t984
  %t985 = getelementptr i64, ptr %t978, i64 6
  store i64 %a6, ptr %t985
  %t986 = getelementptr i64, ptr %t978, i64 7
  store i64 %a7, ptr %t986
  %t987 = call i64 @rt_build_rest(i64 %argc, i64 2, i64 8, ptr %t978, ptr %overflow)
  %t988 = call i64 @rt_alloc_words(i64 1)
  %t989 = inttoptr i64 %t988 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_244" to i64), ptr %t989
  %t990 = or i64 %t988, 4
  %t991 = load i64, ptr @"scheme.base:chr-cmp"
  %t992 = and i64 %t991, -8
  %t993 = inttoptr i64 %t992 to ptr
  %t994 = load i64, ptr %t993
  %t995 = inttoptr i64 %t994 to ptr
  %t996 = musttail call fastcc i64 %t995(i64 %t991, i64 4, i64 %t990, i64 %a0, i64 %a1, i64 %t987, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t996
}

define fastcc i64 @"scheme.base:code_257"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1001 = icmp eq i64 %argc, 2
  br i1 %t1001, label %argok206, label %arityerr205
arityerr205:
  call void @rt_arity_error(i64 2, i64 %argc)
  unreachable
argok206:
  %t1002 = call i64 @rt_lt(i64 %a1, i64 %a0)
  ret i64 %t1002
}

define fastcc i64 @"scheme.base:code_255"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1003 = icmp sge i64 %argc, 2
  br i1 %t1003, label %argok208, label %arityerr207
arityerr207:
  call void @rt_arity_error(i64 2, i64 %argc)
  unreachable
argok208:
  %t1004 = call i64 @rt_alloc_words(i64 8)
  %t1005 = inttoptr i64 %t1004 to ptr
  %t1006 = getelementptr i64, ptr %t1005, i64 0
  store i64 %a0, ptr %t1006
  %t1007 = getelementptr i64, ptr %t1005, i64 1
  store i64 %a1, ptr %t1007
  %t1008 = getelementptr i64, ptr %t1005, i64 2
  store i64 %a2, ptr %t1008
  %t1009 = getelementptr i64, ptr %t1005, i64 3
  store i64 %a3, ptr %t1009
  %t1010 = getelementptr i64, ptr %t1005, i64 4
  store i64 %a4, ptr %t1010
  %t1011 = getelementptr i64, ptr %t1005, i64 5
  store i64 %a5, ptr %t1011
  %t1012 = getelementptr i64, ptr %t1005, i64 6
  store i64 %a6, ptr %t1012
  %t1013 = getelementptr i64, ptr %t1005, i64 7
  store i64 %a7, ptr %t1013
  %t1014 = call i64 @rt_build_rest(i64 %argc, i64 2, i64 8, ptr %t1005, ptr %overflow)
  %t1015 = call i64 @rt_alloc_words(i64 1)
  %t1016 = inttoptr i64 %t1015 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_257" to i64), ptr %t1016
  %t1017 = or i64 %t1015, 4
  %t1018 = load i64, ptr @"scheme.base:chr-cmp"
  %t1019 = and i64 %t1018, -8
  %t1020 = inttoptr i64 %t1019 to ptr
  %t1021 = load i64, ptr %t1020
  %t1022 = inttoptr i64 %t1021 to ptr
  %t1023 = musttail call fastcc i64 %t1022(i64 %t1018, i64 4, i64 %t1017, i64 %a0, i64 %a1, i64 %t1014, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t1023
}

define fastcc i64 @"scheme.base:code_270"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1028 = icmp eq i64 %argc, 2
  br i1 %t1028, label %argok210, label %arityerr209
arityerr209:
  call void @rt_arity_error(i64 2, i64 %argc)
  unreachable
argok210:
  %t1029 = call i64 @rt_lt(i64 %a0, i64 %a1)
  %t1030 = icmp ne i64 %t1029, 1
  br i1 %t1030, label %then211, label %else212
then211:
  ret i64 257
else212:
  %t1031 = call i64 @rt_num_eq(i64 %a0, i64 %a1)
  ret i64 %t1031
}

define fastcc i64 @"scheme.base:code_268"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1032 = icmp sge i64 %argc, 2
  br i1 %t1032, label %argok214, label %arityerr213
arityerr213:
  call void @rt_arity_error(i64 2, i64 %argc)
  unreachable
argok214:
  %t1033 = call i64 @rt_alloc_words(i64 8)
  %t1034 = inttoptr i64 %t1033 to ptr
  %t1035 = getelementptr i64, ptr %t1034, i64 0
  store i64 %a0, ptr %t1035
  %t1036 = getelementptr i64, ptr %t1034, i64 1
  store i64 %a1, ptr %t1036
  %t1037 = getelementptr i64, ptr %t1034, i64 2
  store i64 %a2, ptr %t1037
  %t1038 = getelementptr i64, ptr %t1034, i64 3
  store i64 %a3, ptr %t1038
  %t1039 = getelementptr i64, ptr %t1034, i64 4
  store i64 %a4, ptr %t1039
  %t1040 = getelementptr i64, ptr %t1034, i64 5
  store i64 %a5, ptr %t1040
  %t1041 = getelementptr i64, ptr %t1034, i64 6
  store i64 %a6, ptr %t1041
  %t1042 = getelementptr i64, ptr %t1034, i64 7
  store i64 %a7, ptr %t1042
  %t1043 = call i64 @rt_build_rest(i64 %argc, i64 2, i64 8, ptr %t1034, ptr %overflow)
  %t1044 = call i64 @rt_alloc_words(i64 1)
  %t1045 = inttoptr i64 %t1044 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_270" to i64), ptr %t1045
  %t1046 = or i64 %t1044, 4
  %t1047 = load i64, ptr @"scheme.base:chr-cmp"
  %t1048 = and i64 %t1047, -8
  %t1049 = inttoptr i64 %t1048 to ptr
  %t1050 = load i64, ptr %t1049
  %t1051 = inttoptr i64 %t1050 to ptr
  %t1052 = musttail call fastcc i64 %t1051(i64 %t1047, i64 4, i64 %t1046, i64 %a0, i64 %a1, i64 %t1043, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t1052
}

define fastcc i64 @"scheme.base:code_283"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1057 = icmp eq i64 %argc, 2
  br i1 %t1057, label %argok216, label %arityerr215
arityerr215:
  call void @rt_arity_error(i64 2, i64 %argc)
  unreachable
argok216:
  %t1058 = call i64 @rt_lt(i64 %a1, i64 %a0)
  %t1059 = icmp ne i64 %t1058, 1
  br i1 %t1059, label %then217, label %else218
then217:
  ret i64 257
else218:
  %t1060 = call i64 @rt_num_eq(i64 %a0, i64 %a1)
  ret i64 %t1060
}

define fastcc i64 @"scheme.base:code_281"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1061 = icmp sge i64 %argc, 2
  br i1 %t1061, label %argok220, label %arityerr219
arityerr219:
  call void @rt_arity_error(i64 2, i64 %argc)
  unreachable
argok220:
  %t1062 = call i64 @rt_alloc_words(i64 8)
  %t1063 = inttoptr i64 %t1062 to ptr
  %t1064 = getelementptr i64, ptr %t1063, i64 0
  store i64 %a0, ptr %t1064
  %t1065 = getelementptr i64, ptr %t1063, i64 1
  store i64 %a1, ptr %t1065
  %t1066 = getelementptr i64, ptr %t1063, i64 2
  store i64 %a2, ptr %t1066
  %t1067 = getelementptr i64, ptr %t1063, i64 3
  store i64 %a3, ptr %t1067
  %t1068 = getelementptr i64, ptr %t1063, i64 4
  store i64 %a4, ptr %t1068
  %t1069 = getelementptr i64, ptr %t1063, i64 5
  store i64 %a5, ptr %t1069
  %t1070 = getelementptr i64, ptr %t1063, i64 6
  store i64 %a6, ptr %t1070
  %t1071 = getelementptr i64, ptr %t1063, i64 7
  store i64 %a7, ptr %t1071
  %t1072 = call i64 @rt_build_rest(i64 %argc, i64 2, i64 8, ptr %t1063, ptr %overflow)
  %t1073 = call i64 @rt_alloc_words(i64 1)
  %t1074 = inttoptr i64 %t1073 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_283" to i64), ptr %t1074
  %t1075 = or i64 %t1073, 4
  %t1076 = load i64, ptr @"scheme.base:chr-cmp"
  %t1077 = and i64 %t1076, -8
  %t1078 = inttoptr i64 %t1077 to ptr
  %t1079 = load i64, ptr %t1078
  %t1080 = inttoptr i64 %t1079 to ptr
  %t1081 = musttail call fastcc i64 %t1080(i64 %t1076, i64 4, i64 %t1075, i64 %a0, i64 %a1, i64 %t1072, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t1081
}

define fastcc i64 @"scheme.base:code_295"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1086 = icmp eq i64 %argc, 2
  br i1 %t1086, label %argok222, label %arityerr221
arityerr221:
  call void @rt_arity_error(i64 2, i64 %argc)
  unreachable
argok222:
  %t1087 = call i64 @rt_lt(i64 %a0, i64 0)
  %t1088 = icmp ne i64 %t1087, 1
  br i1 %t1088, label %then223, label %else224
then223:
  ret i64 %a1
else224:
  %t1089 = call i64 @rt_sub(i64 %a0, i64 8)
  %t1090 = and i64 %self, -8
  %t1091 = inttoptr i64 %t1090 to ptr
  %t1092 = getelementptr i64, ptr %t1091, i64 2
  %t1093 = load i64, ptr %t1092
  %t1094 = call i64 @rt_string_ref(i64 %t1093, i64 %a0)
  %t1095 = call i64 @rt_cons(i64 %t1094, i64 %a1)
  %t1096 = and i64 %self, -8
  %t1097 = inttoptr i64 %t1096 to ptr
  %t1098 = getelementptr i64, ptr %t1097, i64 1
  %t1099 = load i64, ptr %t1098
  %t1100 = and i64 %t1099, -8
  %t1101 = inttoptr i64 %t1100 to ptr
  %t1102 = load i64, ptr %t1101
  %t1103 = inttoptr i64 %t1102 to ptr
  %t1104 = musttail call fastcc i64 %t1103(i64 %t1099, i64 2, i64 %t1089, i64 %t1095, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t1104
}

define fastcc i64 @"scheme.base:code_293"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1105 = icmp eq i64 %argc, 1
  br i1 %t1105, label %argok226, label %arityerr225
arityerr225:
  call void @rt_arity_error(i64 1, i64 %argc)
  unreachable
argok226:
  %t1106 = call i64 @rt_alloc_words(i64 3)
  %t1107 = inttoptr i64 %t1106 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_295" to i64), ptr %t1107
  %t1108 = or i64 %t1106, 4
  %t1109 = getelementptr i64, ptr %t1107, i64 1
  store i64 %t1108, ptr %t1109
  %t1110 = getelementptr i64, ptr %t1107, i64 2
  store i64 %a0, ptr %t1110
  %t1111 = call i64 @rt_string_length(i64 %a0)
  %t1112 = call i64 @rt_sub(i64 %t1111, i64 8)
  %t1113 = and i64 %t1108, -8
  %t1114 = inttoptr i64 %t1113 to ptr
  %t1115 = load i64, ptr %t1114
  %t1116 = inttoptr i64 %t1115 to ptr
  %t1117 = musttail call fastcc i64 %t1116(i64 %t1108, i64 2, i64 %t1112, i64 2, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t1117
}

define fastcc i64 @"scheme.base:code_305"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1122 = icmp eq i64 %argc, 2
  br i1 %t1122, label %argok228, label %arityerr227
arityerr227:
  call void @rt_arity_error(i64 2, i64 %argc)
  unreachable
argok228:
  %t1123 = call i64 @rt_remainder(i64 %a0, i64 80)
  %t1124 = call i64 @rt_sub(i64 0, i64 %t1123)
  %t1125 = call i64 @rt_add(i64 384, i64 %t1124)
  %t1126 = call i64 @rt_integer_to_char(i64 %t1125)
  %t1127 = call i64 @rt_quotient(i64 %a0, i64 80)
  %t1128 = call i64 @rt_num_eq(i64 %t1127, i64 0)
  %t1129 = icmp ne i64 %t1128, 1
  br i1 %t1129, label %then229, label %else230
then229:
  %t1130 = call i64 @rt_cons(i64 %t1126, i64 %a1)
  ret i64 %t1130
else230:
  %t1131 = call i64 @rt_cons(i64 %t1126, i64 %a1)
  %t1132 = load i64, ptr @"scheme.base:ns-digits"
  %t1133 = and i64 %t1132, -8
  %t1134 = inttoptr i64 %t1133 to ptr
  %t1135 = load i64, ptr %t1134
  %t1136 = inttoptr i64 %t1135 to ptr
  %t1137 = musttail call fastcc i64 %t1136(i64 %t1132, i64 2, i64 %t1127, i64 %t1131, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t1137
}

define fastcc i64 @"scheme.base:code_316"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1142 = icmp eq i64 %argc, 1
  br i1 %t1142, label %argok232, label %arityerr231
arityerr231:
  call void @rt_arity_error(i64 1, i64 %argc)
  unreachable
argok232:
  %t1143 = call i64 @rt_num_eq(i64 %a0, i64 0)
  %t1144 = icmp ne i64 %t1143, 1
  br i1 %t1144, label %then233, label %else234
then233:
  %t1145 = call i64 @rt_make_string(ptr @.str.lit.1, i64 1)
  ret i64 %t1145
else234:
  %t1146 = call i64 @rt_lt(i64 %a0, i64 0)
  %t1147 = icmp ne i64 %t1146, 1
  br i1 %t1147, label %then235, label %else236
then235:
  %t1148 = load i64, ptr @"scheme.base:ns-digits"
  %t1149 = and i64 %t1148, -8
  %t1150 = inttoptr i64 %t1149 to ptr
  %t1151 = load i64, ptr %t1150
  %t1152 = inttoptr i64 %t1151 to ptr
  %t1153 = call fastcc i64%t1152(i64 %t1148, i64 2, i64 %a0, i64 2, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t1154 = call i64 @rt_cons(i64 11529, i64 %t1153)
  %t1155 = call i64 @rt_list_to_string(i64 %t1154)
  ret i64 %t1155
else236:
  %t1156 = call i64 @rt_sub(i64 0, i64 %a0)
  %t1157 = load i64, ptr @"scheme.base:ns-digits"
  %t1158 = and i64 %t1157, -8
  %t1159 = inttoptr i64 %t1158 to ptr
  %t1160 = load i64, ptr %t1159
  %t1161 = inttoptr i64 %t1160 to ptr
  %t1162 = call fastcc i64%t1161(i64 %t1157, i64 2, i64 %t1156, i64 2, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t1163 = call i64 @rt_list_to_string(i64 %t1162)
  ret i64 %t1163
}

define fastcc i64 @"scheme.base:code_320"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1168 = icmp sge i64 %argc, 1
  br i1 %t1168, label %argok238, label %arityerr237
arityerr237:
  call void @rt_arity_error(i64 1, i64 %argc)
  unreachable
argok238:
  %t1169 = call i64 @rt_alloc_words(i64 8)
  %t1170 = inttoptr i64 %t1169 to ptr
  %t1171 = getelementptr i64, ptr %t1170, i64 0
  store i64 %a0, ptr %t1171
  %t1172 = getelementptr i64, ptr %t1170, i64 1
  store i64 %a1, ptr %t1172
  %t1173 = getelementptr i64, ptr %t1170, i64 2
  store i64 %a2, ptr %t1173
  %t1174 = getelementptr i64, ptr %t1170, i64 3
  store i64 %a3, ptr %t1174
  %t1175 = getelementptr i64, ptr %t1170, i64 4
  store i64 %a4, ptr %t1175
  %t1176 = getelementptr i64, ptr %t1170, i64 5
  store i64 %a5, ptr %t1176
  %t1177 = getelementptr i64, ptr %t1170, i64 6
  store i64 %a6, ptr %t1177
  %t1178 = getelementptr i64, ptr %t1170, i64 7
  store i64 %a7, ptr %t1178
  %t1179 = call i64 @rt_build_rest(i64 %argc, i64 1, i64 8, ptr %t1170, ptr %overflow)
  %t1180 = call i64 @rt_string_p(i64 %a0)
  %t1181 = icmp ne i64 %t1180, 1
  br i1 %t1181, label %then239, label %else240
then239:
  %t1182 = call i64 @rt_error(i64 %a0, i64 %t1179)
  ret i64 %t1182
else240:
  %t1183 = call i64 @rt_symbol_to_string(i64 %a0)
  %t1184 = call i64 @rt_make_string(ptr @.str.lit.2, i64 2)
  %t1185 = call i64 @rt_car(i64 %t1179)
  %t1186 = call i64 @rt_string_append(i64 %t1184, i64 %t1185)
  %t1187 = call i64 @rt_string_append(i64 %t1183, i64 %t1186)
  %t1188 = call i64 @rt_cdr(i64 %t1179)
  %t1189 = call i64 @rt_error(i64 %t1187, i64 %t1188)
  ret i64 %t1189
}

define fastcc i64 @"scheme.base:code_323"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1194 = icmp eq i64 %argc, 1
  br i1 %t1194, label %argok242, label %arityerr241
arityerr241:
  call void @rt_arity_error(i64 1, i64 %argc)
  unreachable
argok242:
  %t1195 = call i64 @rt_raise(i64 %a0)
  ret i64 %t1195
}

define fastcc i64 @"scheme.base:code_326"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1200 = icmp eq i64 %argc, 1
  br i1 %t1200, label %argok244, label %arityerr243
arityerr243:
  call void @rt_arity_error(i64 1, i64 %argc)
  unreachable
argok244:
  %t1201 = call i64 @rt_error_object_p(i64 %a0)
  ret i64 %t1201
}

define fastcc i64 @"scheme.base:code_329"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1206 = icmp eq i64 %argc, 1
  br i1 %t1206, label %argok246, label %arityerr245
arityerr245:
  call void @rt_arity_error(i64 1, i64 %argc)
  unreachable
argok246:
  %t1207 = call i64 @rt_error_object_message(i64 %a0)
  ret i64 %t1207
}

define fastcc i64 @"scheme.base:code_332"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1212 = icmp eq i64 %argc, 1
  br i1 %t1212, label %argok248, label %arityerr247
arityerr247:
  call void @rt_arity_error(i64 1, i64 %argc)
  unreachable
argok248:
  %t1213 = call i64 @rt_error_object_irritants(i64 %a0)
  ret i64 %t1213
}

define fastcc i64 @"scheme.base:code_341"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1218 = icmp eq i64 %argc, 2
  br i1 %t1218, label %argok250, label %arityerr249
arityerr249:
  call void @rt_arity_error(i64 2, i64 %argc)
  unreachable
argok250:
  %t1219 = call i64 @rt_null_p(i64 %a0)
  %t1220 = icmp ne i64 %t1219, 1
  br i1 %t1220, label %then251, label %else252
then251:
  %t1221 = and i64 %self, -8
  %t1222 = inttoptr i64 %t1221 to ptr
  %t1223 = getelementptr i64, ptr %t1222, i64 1
  %t1224 = load i64, ptr %t1223
  ret i64 %t1224
else252:
  %t1225 = and i64 %self, -8
  %t1226 = inttoptr i64 %t1225 to ptr
  %t1227 = getelementptr i64, ptr %t1226, i64 1
  %t1228 = load i64, ptr %t1227
  %t1229 = call i64 @rt_car(i64 %a0)
  %t1230 = call i64 @rt_vector_set(i64 %t1228, i64 %a1, i64 %t1229)
  %t1231 = call i64 @rt_cdr(i64 %a0)
  %t1232 = call i64 @rt_add(i64 %a1, i64 8)
  %t1233 = and i64 %self, -8
  %t1234 = inttoptr i64 %t1233 to ptr
  %t1235 = getelementptr i64, ptr %t1234, i64 2
  %t1236 = load i64, ptr %t1235
  %t1237 = and i64 %t1236, -8
  %t1238 = inttoptr i64 %t1237 to ptr
  %t1239 = load i64, ptr %t1238
  %t1240 = inttoptr i64 %t1239 to ptr
  %t1241 = musttail call fastcc i64 %t1240(i64 %t1236, i64 2, i64 %t1231, i64 %t1232, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t1241
}

define fastcc i64 @"scheme.base:code_339"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1242 = icmp eq i64 %argc, 1
  br i1 %t1242, label %argok254, label %arityerr253
arityerr253:
  call void @rt_arity_error(i64 1, i64 %argc)
  unreachable
argok254:
  %t1243 = load i64, ptr @"scheme.base:length"
  %t1244 = and i64 %t1243, -8
  %t1245 = inttoptr i64 %t1244 to ptr
  %t1246 = load i64, ptr %t1245
  %t1247 = inttoptr i64 %t1246 to ptr
  %t1248 = call fastcc i64%t1247(i64 %t1243, i64 1, i64 %a0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t1249 = call i64 @rt_make_vector(i64 %t1248, i64 0)
  %t1250 = call i64 @rt_alloc_words(i64 3)
  %t1251 = inttoptr i64 %t1250 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_341" to i64), ptr %t1251
  %t1252 = or i64 %t1250, 4
  %t1253 = getelementptr i64, ptr %t1251, i64 1
  store i64 %t1249, ptr %t1253
  %t1254 = getelementptr i64, ptr %t1251, i64 2
  store i64 %t1252, ptr %t1254
  %t1255 = and i64 %t1252, -8
  %t1256 = inttoptr i64 %t1255 to ptr
  %t1257 = load i64, ptr %t1256
  %t1258 = inttoptr i64 %t1257 to ptr
  %t1259 = musttail call fastcc i64 %t1258(i64 %t1252, i64 2, i64 %a0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t1259
}

define fastcc i64 @"scheme.base:code_344"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1264 = icmp sge i64 %argc, 0
  br i1 %t1264, label %argok256, label %arityerr255
arityerr255:
  call void @rt_arity_error(i64 0, i64 %argc)
  unreachable
argok256:
  %t1265 = call i64 @rt_alloc_words(i64 8)
  %t1266 = inttoptr i64 %t1265 to ptr
  %t1267 = getelementptr i64, ptr %t1266, i64 0
  store i64 %a0, ptr %t1267
  %t1268 = getelementptr i64, ptr %t1266, i64 1
  store i64 %a1, ptr %t1268
  %t1269 = getelementptr i64, ptr %t1266, i64 2
  store i64 %a2, ptr %t1269
  %t1270 = getelementptr i64, ptr %t1266, i64 3
  store i64 %a3, ptr %t1270
  %t1271 = getelementptr i64, ptr %t1266, i64 4
  store i64 %a4, ptr %t1271
  %t1272 = getelementptr i64, ptr %t1266, i64 5
  store i64 %a5, ptr %t1272
  %t1273 = getelementptr i64, ptr %t1266, i64 6
  store i64 %a6, ptr %t1273
  %t1274 = getelementptr i64, ptr %t1266, i64 7
  store i64 %a7, ptr %t1274
  %t1275 = call i64 @rt_build_rest(i64 %argc, i64 0, i64 8, ptr %t1266, ptr %overflow)
  %t1276 = load i64, ptr @"scheme.base:list->vector"
  %t1277 = and i64 %t1276, -8
  %t1278 = inttoptr i64 %t1277 to ptr
  %t1279 = load i64, ptr %t1278
  %t1280 = inttoptr i64 %t1279 to ptr
  %t1281 = musttail call fastcc i64 %t1280(i64 %t1276, i64 1, i64 %t1275, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t1281
}

define fastcc i64 @"scheme.base:code_370"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1286 = icmp eq i64 %argc, 1
  br i1 %t1286, label %argok258, label %arityerr257
arityerr257:
  call void @rt_arity_error(i64 1, i64 %argc)
  unreachable
argok258:
  %t1287 = call i64 @rt_char_to_integer(i64 %a0)
  %t1288 = call i64 @rt_num_eq(i64 %t1287, i64 256)
  %t1289 = icmp ne i64 %t1288, 1
  br i1 %t1289, label %then259, label %else260
then259:
  ret i64 %t1288
else260:
  %t1290 = call i64 @rt_num_eq(i64 %t1287, i64 72)
  %t1291 = icmp ne i64 %t1290, 1
  br i1 %t1291, label %then261, label %else262
then261:
  ret i64 %t1290
else262:
  %t1292 = call i64 @rt_num_eq(i64 %t1287, i64 80)
  %t1293 = icmp ne i64 %t1292, 1
  br i1 %t1293, label %then263, label %else264
then263:
  ret i64 %t1292
else264:
  %t1294 = call i64 @rt_num_eq(i64 %t1287, i64 104)
  ret i64 %t1294
}

define fastcc i64 @"scheme.base:code_382"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1299 = icmp eq i64 %argc, 1
  br i1 %t1299, label %argok266, label %arityerr265
arityerr265:
  call void @rt_arity_error(i64 1, i64 %argc)
  unreachable
argok266:
  %t1300 = call i64 @rt_char_to_integer(i64 %a0)
  %t1301 = call i64 @rt_lt(i64 376, i64 %t1300)
  %t1302 = icmp ne i64 %t1301, 1
  br i1 %t1302, label %then267, label %else268
then267:
  %t1303 = call i64 @rt_lt(i64 %t1300, i64 464)
  ret i64 %t1303
else268:
  ret i64 1
}

define fastcc i64 @"scheme.base:code_422"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1308 = icmp eq i64 %argc, 1
  br i1 %t1308, label %argok270, label %arityerr269
arityerr269:
  call void @rt_arity_error(i64 1, i64 %argc)
  unreachable
argok270:
  %t1309 = call i64 @rt_char_to_integer(i64 %a0)
  %t1310 = load i64, ptr @"scheme.base:rd-ws?"
  %t1311 = and i64 %t1310, -8
  %t1312 = inttoptr i64 %t1311 to ptr
  %t1313 = load i64, ptr %t1312
  %t1314 = inttoptr i64 %t1313 to ptr
  %t1315 = call fastcc i64%t1314(i64 %t1310, i64 1, i64 %a0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t1316 = icmp ne i64 %t1315, 1
  br i1 %t1316, label %then271, label %else272
then271:
  ret i64 %t1315
else272:
  %t1317 = call i64 @rt_num_eq(i64 %t1309, i64 320)
  %t1318 = icmp ne i64 %t1317, 1
  br i1 %t1318, label %then273, label %else274
then273:
  ret i64 %t1317
else274:
  %t1319 = call i64 @rt_num_eq(i64 %t1309, i64 328)
  %t1320 = icmp ne i64 %t1319, 1
  br i1 %t1320, label %then275, label %else276
then275:
  ret i64 %t1319
else276:
  %t1321 = call i64 @rt_num_eq(i64 %t1309, i64 728)
  %t1322 = icmp ne i64 %t1321, 1
  br i1 %t1322, label %then277, label %else278
then277:
  ret i64 %t1321
else278:
  %t1323 = call i64 @rt_num_eq(i64 %t1309, i64 744)
  %t1324 = icmp ne i64 %t1323, 1
  br i1 %t1324, label %then279, label %else280
then279:
  ret i64 %t1323
else280:
  %t1325 = call i64 @rt_num_eq(i64 %t1309, i64 272)
  %t1326 = icmp ne i64 %t1325, 1
  br i1 %t1326, label %then281, label %else282
then281:
  ret i64 %t1325
else282:
  %t1327 = call i64 @rt_num_eq(i64 %t1309, i64 472)
  ret i64 %t1327
}

define fastcc i64 @"scheme.base:code_435"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1332 = icmp eq i64 %argc, 3
  br i1 %t1332, label %argok284, label %arityerr283
arityerr283:
  call void @rt_arity_error(i64 3, i64 %argc)
  unreachable
argok284:
  %t1333 = call i64 @rt_lt(i64 %a2, i64 %a1)
  %t1334 = icmp ne i64 %t1333, 1
  br i1 %t1334, label %then285, label %else286
then285:
  %t1335 = call i64 @rt_string_ref(i64 %a0, i64 %a2)
  %t1336 = call i64 @rt_char_to_integer(i64 %t1335)
  %t1337 = call i64 @rt_num_eq(i64 %t1336, i64 80)
  %t1338 = icmp ne i64 %t1337, 1
  br i1 %t1338, label %then287, label %else288
then287:
  %t1339 = call i64 @rt_add(i64 %a2, i64 8)
  ret i64 %t1339
else288:
  %t1340 = call i64 @rt_add(i64 %a2, i64 8)
  %t1341 = load i64, ptr @"scheme.base:rd-skip-line"
  %t1342 = and i64 %t1341, -8
  %t1343 = inttoptr i64 %t1342 to ptr
  %t1344 = load i64, ptr %t1343
  %t1345 = inttoptr i64 %t1344 to ptr
  %t1346 = musttail call fastcc i64 %t1345(i64 %t1341, i64 3, i64 %a0, i64 %a1, i64 %t1340, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t1346
else286:
  ret i64 %a2
}

define fastcc i64 @"scheme.base:code_449"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1351 = icmp eq i64 %argc, 3
  br i1 %t1351, label %argok290, label %arityerr289
arityerr289:
  call void @rt_arity_error(i64 3, i64 %argc)
  unreachable
argok290:
  %t1352 = call i64 @rt_lt(i64 %a2, i64 %a1)
  %t1353 = icmp ne i64 %t1352, 1
  br i1 %t1353, label %then291, label %else292
then291:
  %t1354 = call i64 @rt_string_ref(i64 %a0, i64 %a2)
  %t1355 = load i64, ptr @"scheme.base:rd-ws?"
  %t1356 = and i64 %t1355, -8
  %t1357 = inttoptr i64 %t1356 to ptr
  %t1358 = load i64, ptr %t1357
  %t1359 = inttoptr i64 %t1358 to ptr
  %t1360 = call fastcc i64%t1359(i64 %t1355, i64 1, i64 %t1354, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t1361 = icmp ne i64 %t1360, 1
  br i1 %t1361, label %then293, label %else294
then293:
  %t1362 = call i64 @rt_add(i64 %a2, i64 8)
  %t1363 = load i64, ptr @"scheme.base:rd-skip-ws"
  %t1364 = and i64 %t1363, -8
  %t1365 = inttoptr i64 %t1364 to ptr
  %t1366 = load i64, ptr %t1365
  %t1367 = inttoptr i64 %t1366 to ptr
  %t1368 = musttail call fastcc i64 %t1367(i64 %t1363, i64 3, i64 %a0, i64 %a1, i64 %t1362, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t1368
else294:
  %t1369 = call i64 @rt_char_to_integer(i64 %t1354)
  %t1370 = call i64 @rt_num_eq(i64 %t1369, i64 472)
  %t1371 = icmp ne i64 %t1370, 1
  br i1 %t1371, label %then295, label %else296
then295:
  %t1372 = call i64 @rt_add(i64 %a2, i64 8)
  %t1373 = load i64, ptr @"scheme.base:rd-skip-line"
  %t1374 = and i64 %t1373, -8
  %t1375 = inttoptr i64 %t1374 to ptr
  %t1376 = load i64, ptr %t1375
  %t1377 = inttoptr i64 %t1376 to ptr
  %t1378 = call fastcc i64%t1377(i64 %t1373, i64 3, i64 %a0, i64 %a1, i64 %t1372, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t1379 = load i64, ptr @"scheme.base:rd-skip-ws"
  %t1380 = and i64 %t1379, -8
  %t1381 = inttoptr i64 %t1380 to ptr
  %t1382 = load i64, ptr %t1381
  %t1383 = inttoptr i64 %t1382 to ptr
  %t1384 = musttail call fastcc i64 %t1383(i64 %t1379, i64 3, i64 %a0, i64 %a1, i64 %t1378, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t1384
else296:
  ret i64 %a2
else292:
  ret i64 %a2
}

define fastcc i64 @"scheme.base:code_458"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1389 = icmp eq i64 %argc, 3
  br i1 %t1389, label %argok298, label %arityerr297
arityerr297:
  call void @rt_arity_error(i64 3, i64 %argc)
  unreachable
argok298:
  %t1390 = call i64 @rt_lt(i64 %a2, i64 %a1)
  %t1391 = icmp ne i64 %t1390, 1
  br i1 %t1391, label %then299, label %else300
then299:
  %t1392 = call i64 @rt_string_ref(i64 %a0, i64 %a2)
  %t1393 = load i64, ptr @"scheme.base:rd-delim?"
  %t1394 = and i64 %t1393, -8
  %t1395 = inttoptr i64 %t1394 to ptr
  %t1396 = load i64, ptr %t1395
  %t1397 = inttoptr i64 %t1396 to ptr
  %t1398 = call fastcc i64%t1397(i64 %t1393, i64 1, i64 %t1392, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t1399 = icmp ne i64 %t1398, 1
  br i1 %t1399, label %then301, label %else302
then301:
  ret i64 %a2
else302:
  %t1400 = call i64 @rt_add(i64 %a2, i64 8)
  %t1401 = load i64, ptr @"scheme.base:rd-token-end"
  %t1402 = and i64 %t1401, -8
  %t1403 = inttoptr i64 %t1402 to ptr
  %t1404 = load i64, ptr %t1403
  %t1405 = inttoptr i64 %t1404 to ptr
  %t1406 = musttail call fastcc i64 %t1405(i64 %t1401, i64 3, i64 %a0, i64 %a1, i64 %t1400, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t1406
else300:
  ret i64 %a2
}

define fastcc i64 @"scheme.base:code_467"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1411 = icmp eq i64 %argc, 3
  br i1 %t1411, label %argok304, label %arityerr303
arityerr303:
  call void @rt_arity_error(i64 3, i64 %argc)
  unreachable
argok304:
  %t1412 = call i64 @rt_lt(i64 %a1, i64 %a2)
  %t1413 = icmp ne i64 %t1412, 1
  br i1 %t1413, label %then305, label %else306
then305:
  %t1414 = call i64 @rt_string_ref(i64 %a0, i64 %a1)
  %t1415 = load i64, ptr @"scheme.base:rd-digit?"
  %t1416 = and i64 %t1415, -8
  %t1417 = inttoptr i64 %t1416 to ptr
  %t1418 = load i64, ptr %t1417
  %t1419 = inttoptr i64 %t1418 to ptr
  %t1420 = call fastcc i64%t1419(i64 %t1415, i64 1, i64 %t1414, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t1421 = icmp ne i64 %t1420, 1
  br i1 %t1421, label %then307, label %else308
then307:
  %t1422 = call i64 @rt_add(i64 %a1, i64 8)
  %t1423 = load i64, ptr @"scheme.base:rd-all-digits?"
  %t1424 = and i64 %t1423, -8
  %t1425 = inttoptr i64 %t1424 to ptr
  %t1426 = load i64, ptr %t1425
  %t1427 = inttoptr i64 %t1426 to ptr
  %t1428 = musttail call fastcc i64 %t1427(i64 %t1423, i64 3, i64 %a0, i64 %t1422, i64 %a2, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t1428
else308:
  ret i64 1
else306:
  ret i64 257
}

define fastcc i64 @"scheme.base:code_490"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1433 = icmp eq i64 %argc, 1
  br i1 %t1433, label %argok310, label %arityerr309
arityerr309:
  call void @rt_arity_error(i64 1, i64 %argc)
  unreachable
argok310:
  %t1434 = call i64 @rt_string_length(i64 %a0)
  %t1435 = call i64 @rt_lt(i64 0, i64 %t1434)
  %t1436 = icmp ne i64 %t1435, 1
  br i1 %t1436, label %then311, label %else312
then311:
  %t1437 = call i64 @rt_string_ref(i64 %a0, i64 0)
  %t1438 = call i64 @rt_char_to_integer(i64 %t1437)
  %t1439 = call i64 @rt_string_ref(i64 %a0, i64 0)
  %t1440 = load i64, ptr @"scheme.base:rd-digit?"
  %t1441 = and i64 %t1440, -8
  %t1442 = inttoptr i64 %t1441 to ptr
  %t1443 = load i64, ptr %t1442
  %t1444 = inttoptr i64 %t1443 to ptr
  %t1445 = call fastcc i64%t1444(i64 %t1440, i64 1, i64 %t1439, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t1446 = icmp ne i64 %t1445, 1
  br i1 %t1446, label %then313, label %else314
then313:
  %t1447 = load i64, ptr @"scheme.base:rd-all-digits?"
  %t1448 = and i64 %t1447, -8
  %t1449 = inttoptr i64 %t1448 to ptr
  %t1450 = load i64, ptr %t1449
  %t1451 = inttoptr i64 %t1450 to ptr
  %t1452 = musttail call fastcc i64 %t1451(i64 %t1447, i64 3, i64 %a0, i64 0, i64 %t1434, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t1452
else314:
  %t1453 = call i64 @rt_num_eq(i64 %t1438, i64 360)
  %t1454 = icmp ne i64 %t1453, 1
  br i1 %t1454, label %then315, label %else316
then315:
  br label %merge317
else316:
  %t1455 = call i64 @rt_num_eq(i64 %t1438, i64 344)
  br label %merge317
merge317:
  %t1456 = phi i64 [ %t1453, %then315 ], [ %t1455, %else316 ]
  %t1457 = icmp ne i64 %t1456, 1
  br i1 %t1457, label %then318, label %else319
then318:
  %t1458 = call i64 @rt_lt(i64 8, i64 %t1434)
  %t1459 = icmp ne i64 %t1458, 1
  br i1 %t1459, label %then320, label %else321
then320:
  %t1460 = load i64, ptr @"scheme.base:rd-all-digits?"
  %t1461 = and i64 %t1460, -8
  %t1462 = inttoptr i64 %t1461 to ptr
  %t1463 = load i64, ptr %t1462
  %t1464 = inttoptr i64 %t1463 to ptr
  %t1465 = musttail call fastcc i64 %t1464(i64 %t1460, i64 3, i64 %a0, i64 8, i64 %t1434, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t1465
else321:
  ret i64 1
else319:
  ret i64 1
else312:
  ret i64 1
}

define fastcc i64 @"scheme.base:code_500"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1470 = icmp eq i64 %argc, 4
  br i1 %t1470, label %argok323, label %arityerr322
arityerr322:
  call void @rt_arity_error(i64 4, i64 %argc)
  unreachable
argok323:
  %t1471 = call i64 @rt_lt(i64 %a1, i64 %a2)
  %t1472 = icmp ne i64 %t1471, 1
  br i1 %t1472, label %then324, label %else325
then324:
  %t1473 = call i64 @rt_add(i64 %a1, i64 8)
  %t1474 = call i64 @rt_mul(i64 %a3, i64 80)
  %t1475 = call i64 @rt_string_ref(i64 %a0, i64 %a1)
  %t1476 = call i64 @rt_char_to_integer(i64 %t1475)
  %t1477 = call i64 @rt_sub(i64 %t1476, i64 384)
  %t1478 = call i64 @rt_add(i64 %t1474, i64 %t1477)
  %t1479 = load i64, ptr @"scheme.base:rd-digits"
  %t1480 = and i64 %t1479, -8
  %t1481 = inttoptr i64 %t1480 to ptr
  %t1482 = load i64, ptr %t1481
  %t1483 = inttoptr i64 %t1482 to ptr
  %t1484 = musttail call fastcc i64 %t1483(i64 %t1479, i64 4, i64 %a0, i64 %t1473, i64 %a2, i64 %t1478, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t1484
else325:
  ret i64 %a3
}

define fastcc i64 @"scheme.base:code_513"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1489 = icmp eq i64 %argc, 1
  br i1 %t1489, label %argok327, label %arityerr326
arityerr326:
  call void @rt_arity_error(i64 1, i64 %argc)
  unreachable
argok327:
  %t1490 = call i64 @rt_string_length(i64 %a0)
  %t1491 = call i64 @rt_string_ref(i64 %a0, i64 0)
  %t1492 = call i64 @rt_char_to_integer(i64 %t1491)
  %t1493 = call i64 @rt_num_eq(i64 %t1492, i64 360)
  %t1494 = icmp ne i64 %t1493, 1
  br i1 %t1494, label %then328, label %else329
then328:
  %t1495 = load i64, ptr @"scheme.base:rd-digits"
  %t1496 = and i64 %t1495, -8
  %t1497 = inttoptr i64 %t1496 to ptr
  %t1498 = load i64, ptr %t1497
  %t1499 = inttoptr i64 %t1498 to ptr
  %t1500 = call fastcc i64%t1499(i64 %t1495, i64 4, i64 %a0, i64 8, i64 %t1490, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t1501 = call i64 @rt_sub(i64 0, i64 %t1500)
  ret i64 %t1501
else329:
  %t1502 = call i64 @rt_num_eq(i64 %t1492, i64 344)
  %t1503 = icmp ne i64 %t1502, 1
  br i1 %t1503, label %then330, label %else331
then330:
  %t1504 = load i64, ptr @"scheme.base:rd-digits"
  %t1505 = and i64 %t1504, -8
  %t1506 = inttoptr i64 %t1505 to ptr
  %t1507 = load i64, ptr %t1506
  %t1508 = inttoptr i64 %t1507 to ptr
  %t1509 = musttail call fastcc i64 %t1508(i64 %t1504, i64 4, i64 %a0, i64 8, i64 %t1490, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t1509
else331:
  %t1510 = load i64, ptr @"scheme.base:rd-digits"
  %t1511 = and i64 %t1510, -8
  %t1512 = inttoptr i64 %t1511 to ptr
  %t1513 = load i64, ptr %t1512
  %t1514 = inttoptr i64 %t1513 to ptr
  %t1515 = musttail call fastcc i64 %t1514(i64 %t1510, i64 4, i64 %a0, i64 0, i64 %t1490, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t1515
}

define fastcc i64 @"scheme.base:code_520"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1520 = icmp eq i64 %argc, 3
  br i1 %t1520, label %argok333, label %arityerr332
arityerr332:
  call void @rt_arity_error(i64 3, i64 %argc)
  unreachable
argok333:
  %t1521 = load i64, ptr @"scheme.base:rd-token-end"
  %t1522 = and i64 %t1521, -8
  %t1523 = inttoptr i64 %t1522 to ptr
  %t1524 = load i64, ptr %t1523
  %t1525 = inttoptr i64 %t1524 to ptr
  %t1526 = call fastcc i64%t1525(i64 %t1521, i64 3, i64 %a0, i64 %a1, i64 %a2, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t1527 = call i64 @rt_substring(i64 %a0, i64 %a2, i64 %t1526)
  %t1528 = load i64, ptr @"scheme.base:rd-numeric?"
  %t1529 = and i64 %t1528, -8
  %t1530 = inttoptr i64 %t1529 to ptr
  %t1531 = load i64, ptr %t1530
  %t1532 = inttoptr i64 %t1531 to ptr
  %t1533 = call fastcc i64%t1532(i64 %t1528, i64 1, i64 %t1527, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t1534 = icmp ne i64 %t1533, 1
  br i1 %t1534, label %then334, label %else335
then334:
  %t1535 = load i64, ptr @"scheme.base:rd-parse-int"
  %t1536 = and i64 %t1535, -8
  %t1537 = inttoptr i64 %t1536 to ptr
  %t1538 = load i64, ptr %t1537
  %t1539 = inttoptr i64 %t1538 to ptr
  %t1540 = call fastcc i64%t1539(i64 %t1535, i64 1, i64 %t1527, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  br label %merge336
else335:
  %t1541 = call i64 @rt_string_to_symbol(i64 %t1527)
  br label %merge336
merge336:
  %t1542 = phi i64 [ %t1540, %then334 ], [ %t1541, %else335 ]
  %t1543 = call i64 @rt_cons(i64 %t1542, i64 %t1526)
  ret i64 %t1543
}

define fastcc i64 @"scheme.base:code_548"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1548 = icmp eq i64 %argc, 1
  br i1 %t1548, label %argok338, label %arityerr337
arityerr337:
  call void @rt_arity_error(i64 1, i64 %argc)
  unreachable
argok338:
  %t1549 = call i64 @rt_char_to_integer(i64 %a0)
  %t1550 = call i64 @rt_lt(i64 376, i64 %t1549)
  %t1551 = icmp ne i64 %t1550, 1
  br i1 %t1551, label %then339, label %else340
then339:
  %t1552 = call i64 @rt_lt(i64 %t1549, i64 464)
  br label %merge341
else340:
  br label %merge341
merge341:
  %t1553 = phi i64 [ %t1552, %then339 ], [ 1, %else340 ]
  %t1554 = icmp ne i64 %t1553, 1
  br i1 %t1554, label %then342, label %else343
then342:
  %t1555 = call i64 @rt_sub(i64 %t1549, i64 384)
  ret i64 %t1555
else343:
  %t1556 = call i64 @rt_lt(i64 768, i64 %t1549)
  %t1557 = icmp ne i64 %t1556, 1
  br i1 %t1557, label %then344, label %else345
then344:
  %t1558 = call i64 @rt_lt(i64 %t1549, i64 824)
  br label %merge346
else345:
  br label %merge346
merge346:
  %t1559 = phi i64 [ %t1558, %then344 ], [ 1, %else345 ]
  %t1560 = icmp ne i64 %t1559, 1
  br i1 %t1560, label %then347, label %else348
then347:
  %t1561 = call i64 @rt_sub(i64 %t1549, i64 696)
  ret i64 %t1561
else348:
  %t1562 = call i64 @rt_lt(i64 512, i64 %t1549)
  %t1563 = icmp ne i64 %t1562, 1
  br i1 %t1563, label %then349, label %else350
then349:
  %t1564 = call i64 @rt_lt(i64 %t1549, i64 568)
  br label %merge351
else350:
  br label %merge351
merge351:
  %t1565 = phi i64 [ %t1564, %then349 ], [ 1, %else350 ]
  %t1566 = icmp ne i64 %t1565, 1
  br i1 %t1566, label %then352, label %else353
then352:
  %t1567 = call i64 @rt_sub(i64 %t1549, i64 440)
  ret i64 %t1567
else353:
  ret i64 0
}

define fastcc i64 @"scheme.base:code_562"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1572 = icmp eq i64 %argc, 4
  br i1 %t1572, label %argok355, label %arityerr354
arityerr354:
  call void @rt_arity_error(i64 4, i64 %argc)
  unreachable
argok355:
  %t1573 = call i64 @rt_lt(i64 %a2, i64 %a1)
  %t1574 = icmp ne i64 %t1573, 1
  br i1 %t1574, label %then356, label %else357
then356:
  %t1575 = call i64 @rt_string_ref(i64 %a0, i64 %a2)
  %t1576 = call i64 @rt_char_to_integer(i64 %t1575)
  %t1577 = call i64 @rt_num_eq(i64 %t1576, i64 472)
  %t1578 = icmp ne i64 %t1577, 1
  br i1 %t1578, label %then358, label %else359
then358:
  %t1579 = call i64 @rt_add(i64 %a2, i64 8)
  %t1580 = call i64 @rt_cons(i64 %a3, i64 %t1579)
  ret i64 %t1580
else359:
  %t1581 = call i64 @rt_add(i64 %a2, i64 8)
  %t1582 = call i64 @rt_mul(i64 %a3, i64 128)
  %t1583 = call i64 @rt_string_ref(i64 %a0, i64 %a2)
  %t1584 = load i64, ptr @"scheme.base:rd-hex-digit"
  %t1585 = and i64 %t1584, -8
  %t1586 = inttoptr i64 %t1585 to ptr
  %t1587 = load i64, ptr %t1586
  %t1588 = inttoptr i64 %t1587 to ptr
  %t1589 = call fastcc i64%t1588(i64 %t1584, i64 1, i64 %t1583, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t1590 = call i64 @rt_add(i64 %t1582, i64 %t1589)
  %t1591 = load i64, ptr @"scheme.base:rd-hex"
  %t1592 = and i64 %t1591, -8
  %t1593 = inttoptr i64 %t1592 to ptr
  %t1594 = load i64, ptr %t1593
  %t1595 = inttoptr i64 %t1594 to ptr
  %t1596 = musttail call fastcc i64 %t1595(i64 %t1591, i64 4, i64 %a0, i64 %a1, i64 %t1581, i64 %t1590, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t1596
else357:
  %t1597 = call i64 @rt_cons(i64 %a3, i64 %a2)
  ret i64 %t1597
}

define fastcc i64 @"scheme.base:code_578"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1602 = icmp eq i64 %argc, 1
  br i1 %t1602, label %argok361, label %arityerr360
arityerr360:
  call void @rt_arity_error(i64 1, i64 %argc)
  unreachable
argok361:
  %t1603 = call i64 @rt_char_to_integer(i64 %a0)
  %t1604 = call i64 @rt_num_eq(i64 %t1603, i64 880)
  %t1605 = icmp ne i64 %t1604, 1
  br i1 %t1605, label %then362, label %else363
then362:
  %t1606 = call i64 @rt_integer_to_char(i64 80)
  ret i64 %t1606
else363:
  %t1607 = call i64 @rt_num_eq(i64 %t1603, i64 928)
  %t1608 = icmp ne i64 %t1607, 1
  br i1 %t1608, label %then364, label %else365
then364:
  %t1609 = call i64 @rt_integer_to_char(i64 72)
  ret i64 %t1609
else365:
  %t1610 = call i64 @rt_num_eq(i64 %t1603, i64 912)
  %t1611 = icmp ne i64 %t1610, 1
  br i1 %t1611, label %then366, label %else367
then366:
  %t1612 = call i64 @rt_integer_to_char(i64 104)
  ret i64 %t1612
else367:
  ret i64 %a0
}

define fastcc i64 @"scheme.base:code_608"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1617 = icmp eq i64 %argc, 2
  br i1 %t1617, label %argok369, label %arityerr368
arityerr368:
  call void @rt_arity_error(i64 2, i64 %argc)
  unreachable
argok369:
  %t1618 = and i64 %self, -8
  %t1619 = inttoptr i64 %t1618 to ptr
  %t1620 = getelementptr i64, ptr %t1619, i64 1
  %t1621 = load i64, ptr %t1620
  %t1622 = call i64 @rt_lt(i64 %a0, i64 %t1621)
  %t1623 = icmp ne i64 %t1622, 1
  br i1 %t1623, label %then370, label %else371
then370:
  %t1624 = and i64 %self, -8
  %t1625 = inttoptr i64 %t1624 to ptr
  %t1626 = getelementptr i64, ptr %t1625, i64 2
  %t1627 = load i64, ptr %t1626
  %t1628 = call i64 @rt_string_ref(i64 %t1627, i64 %a0)
  %t1629 = call i64 @rt_char_to_integer(i64 %t1628)
  %t1630 = call i64 @rt_num_eq(i64 %t1629, i64 272)
  %t1631 = icmp ne i64 %t1630, 1
  br i1 %t1631, label %then372, label %else373
then372:
  %t1632 = load i64, ptr @"scheme.base:reverse"
  %t1633 = and i64 %t1632, -8
  %t1634 = inttoptr i64 %t1633 to ptr
  %t1635 = load i64, ptr %t1634
  %t1636 = inttoptr i64 %t1635 to ptr
  %t1637 = call fastcc i64%t1636(i64 %t1632, i64 1, i64 %a1, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t1638 = call i64 @rt_list_to_string(i64 %t1637)
  %t1639 = call i64 @rt_add(i64 %a0, i64 8)
  %t1640 = call i64 @rt_cons(i64 %t1638, i64 %t1639)
  ret i64 %t1640
else373:
  %t1641 = call i64 @rt_num_eq(i64 %t1629, i64 736)
  %t1642 = icmp ne i64 %t1641, 1
  br i1 %t1642, label %then374, label %else375
then374:
  %t1643 = and i64 %self, -8
  %t1644 = inttoptr i64 %t1643 to ptr
  %t1645 = getelementptr i64, ptr %t1644, i64 2
  %t1646 = load i64, ptr %t1645
  %t1647 = call i64 @rt_add(i64 %a0, i64 8)
  %t1648 = call i64 @rt_string_ref(i64 %t1646, i64 %t1647)
  %t1649 = call i64 @rt_char_to_integer(i64 %t1648)
  %t1650 = call i64 @rt_num_eq(i64 %t1649, i64 960)
  %t1651 = icmp ne i64 %t1650, 1
  br i1 %t1651, label %then376, label %else377
then376:
  %t1652 = and i64 %self, -8
  %t1653 = inttoptr i64 %t1652 to ptr
  %t1654 = getelementptr i64, ptr %t1653, i64 2
  %t1655 = load i64, ptr %t1654
  %t1656 = and i64 %self, -8
  %t1657 = inttoptr i64 %t1656 to ptr
  %t1658 = getelementptr i64, ptr %t1657, i64 1
  %t1659 = load i64, ptr %t1658
  %t1660 = call i64 @rt_add(i64 %a0, i64 16)
  %t1661 = load i64, ptr @"scheme.base:rd-hex"
  %t1662 = and i64 %t1661, -8
  %t1663 = inttoptr i64 %t1662 to ptr
  %t1664 = load i64, ptr %t1663
  %t1665 = inttoptr i64 %t1664 to ptr
  %t1666 = call fastcc i64%t1665(i64 %t1661, i64 4, i64 %t1655, i64 %t1659, i64 %t1660, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t1667 = call i64 @rt_cdr(i64 %t1666)
  %t1668 = call i64 @rt_car(i64 %t1666)
  %t1669 = call i64 @rt_integer_to_char(i64 %t1668)
  %t1670 = call i64 @rt_cons(i64 %t1669, i64 %a1)
  %t1671 = and i64 %self, -8
  %t1672 = inttoptr i64 %t1671 to ptr
  %t1673 = getelementptr i64, ptr %t1672, i64 3
  %t1674 = load i64, ptr %t1673
  %t1675 = and i64 %t1674, -8
  %t1676 = inttoptr i64 %t1675 to ptr
  %t1677 = load i64, ptr %t1676
  %t1678 = inttoptr i64 %t1677 to ptr
  %t1679 = musttail call fastcc i64 %t1678(i64 %t1674, i64 2, i64 %t1667, i64 %t1670, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t1679
else377:
  %t1680 = call i64 @rt_add(i64 %a0, i64 16)
  %t1681 = load i64, ptr @"scheme.base:rd-str-esc"
  %t1682 = and i64 %t1681, -8
  %t1683 = inttoptr i64 %t1682 to ptr
  %t1684 = load i64, ptr %t1683
  %t1685 = inttoptr i64 %t1684 to ptr
  %t1686 = call fastcc i64%t1685(i64 %t1681, i64 1, i64 %t1648, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t1687 = call i64 @rt_cons(i64 %t1686, i64 %a1)
  %t1688 = and i64 %self, -8
  %t1689 = inttoptr i64 %t1688 to ptr
  %t1690 = getelementptr i64, ptr %t1689, i64 3
  %t1691 = load i64, ptr %t1690
  %t1692 = and i64 %t1691, -8
  %t1693 = inttoptr i64 %t1692 to ptr
  %t1694 = load i64, ptr %t1693
  %t1695 = inttoptr i64 %t1694 to ptr
  %t1696 = musttail call fastcc i64 %t1695(i64 %t1691, i64 2, i64 %t1680, i64 %t1687, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t1696
else375:
  %t1697 = call i64 @rt_add(i64 %a0, i64 8)
  %t1698 = call i64 @rt_cons(i64 %t1628, i64 %a1)
  %t1699 = and i64 %self, -8
  %t1700 = inttoptr i64 %t1699 to ptr
  %t1701 = getelementptr i64, ptr %t1700, i64 3
  %t1702 = load i64, ptr %t1701
  %t1703 = and i64 %t1702, -8
  %t1704 = inttoptr i64 %t1703 to ptr
  %t1705 = load i64, ptr %t1704
  %t1706 = inttoptr i64 %t1705 to ptr
  %t1707 = musttail call fastcc i64 %t1706(i64 %t1702, i64 2, i64 %t1697, i64 %t1698, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t1707
else371:
  %t1708 = load i64, ptr @"scheme.base:reverse"
  %t1709 = and i64 %t1708, -8
  %t1710 = inttoptr i64 %t1709 to ptr
  %t1711 = load i64, ptr %t1710
  %t1712 = inttoptr i64 %t1711 to ptr
  %t1713 = call fastcc i64%t1712(i64 %t1708, i64 1, i64 %a1, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t1714 = call i64 @rt_list_to_string(i64 %t1713)
  %t1715 = call i64 @rt_cons(i64 %t1714, i64 %a0)
  ret i64 %t1715
}

define fastcc i64 @"scheme.base:code_606"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1716 = icmp eq i64 %argc, 3
  br i1 %t1716, label %argok379, label %arityerr378
arityerr378:
  call void @rt_arity_error(i64 3, i64 %argc)
  unreachable
argok379:
  %t1717 = call i64 @rt_alloc_words(i64 4)
  %t1718 = inttoptr i64 %t1717 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_608" to i64), ptr %t1718
  %t1719 = or i64 %t1717, 4
  %t1720 = getelementptr i64, ptr %t1718, i64 1
  store i64 %a1, ptr %t1720
  %t1721 = getelementptr i64, ptr %t1718, i64 2
  store i64 %a0, ptr %t1721
  %t1722 = getelementptr i64, ptr %t1718, i64 3
  store i64 %t1719, ptr %t1722
  %t1723 = and i64 %t1719, -8
  %t1724 = inttoptr i64 %t1723 to ptr
  %t1725 = load i64, ptr %t1724
  %t1726 = inttoptr i64 %t1725 to ptr
  %t1727 = musttail call fastcc i64 %t1726(i64 %t1719, i64 2, i64 %a2, i64 2, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t1727
}

define fastcc i64 @"scheme.base:code_632"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1732 = icmp eq i64 %argc, 3
  br i1 %t1732, label %argok381, label %arityerr380
arityerr380:
  call void @rt_arity_error(i64 3, i64 %argc)
  unreachable
argok381:
  %t1733 = call i64 @rt_string_ref(i64 %a0, i64 %a2)
  %t1734 = call i64 @rt_char_to_integer(i64 %t1733)
  %t1735 = call i64 @rt_num_eq(i64 %t1734, i64 928)
  %t1736 = icmp ne i64 %t1735, 1
  br i1 %t1736, label %then382, label %else383
then382:
  %t1737 = call i64 @rt_add(i64 %a2, i64 8)
  %t1738 = call i64 @rt_cons(i64 257, i64 %t1737)
  ret i64 %t1738
else383:
  %t1739 = call i64 @rt_num_eq(i64 %t1734, i64 816)
  %t1740 = icmp ne i64 %t1739, 1
  br i1 %t1740, label %then384, label %else385
then384:
  %t1741 = call i64 @rt_add(i64 %a2, i64 8)
  %t1742 = call i64 @rt_cons(i64 1, i64 %t1741)
  ret i64 %t1742
else385:
  %t1743 = call i64 @rt_num_eq(i64 %t1734, i64 736)
  %t1744 = icmp ne i64 %t1743, 1
  br i1 %t1744, label %then386, label %else387
then386:
  %t1745 = load i64, ptr @"scheme.base:rd-char"
  %t1746 = and i64 %t1745, -8
  %t1747 = inttoptr i64 %t1746 to ptr
  %t1748 = load i64, ptr %t1747
  %t1749 = inttoptr i64 %t1748 to ptr
  %t1750 = musttail call fastcc i64 %t1749(i64 %t1745, i64 3, i64 %a0, i64 %a1, i64 %a2, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t1750
else387:
  %t1751 = call i64 @rt_num_eq(i64 %t1734, i64 320)
  %t1752 = icmp ne i64 %t1751, 1
  br i1 %t1752, label %then388, label %else389
then388:
  %t1753 = call i64 @rt_add(i64 %a2, i64 8)
  %t1754 = load i64, ptr @"scheme.base:rd-list"
  %t1755 = and i64 %t1754, -8
  %t1756 = inttoptr i64 %t1755 to ptr
  %t1757 = load i64, ptr %t1756
  %t1758 = inttoptr i64 %t1757 to ptr
  %t1759 = call fastcc i64%t1758(i64 %t1754, i64 4, i64 %a0, i64 %a1, i64 %t1753, i64 2, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t1760 = call i64 @rt_car(i64 %t1759)
  %t1761 = load i64, ptr @"scheme.base:list->vector"
  %t1762 = and i64 %t1761, -8
  %t1763 = inttoptr i64 %t1762 to ptr
  %t1764 = load i64, ptr %t1763
  %t1765 = inttoptr i64 %t1764 to ptr
  %t1766 = call fastcc i64%t1765(i64 %t1761, i64 1, i64 %t1760, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t1767 = call i64 @rt_cdr(i64 %t1759)
  %t1768 = call i64 @rt_cons(i64 %t1766, i64 %t1767)
  ret i64 %t1768
else389:
  %t1769 = load i64, ptr @"scheme.base:rd-token-end"
  %t1770 = and i64 %t1769, -8
  %t1771 = inttoptr i64 %t1770 to ptr
  %t1772 = load i64, ptr %t1771
  %t1773 = inttoptr i64 %t1772 to ptr
  %t1774 = call fastcc i64%t1773(i64 %t1769, i64 3, i64 %a0, i64 %a1, i64 %a2, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t1775 = call i64 @rt_substring(i64 %a0, i64 %a2, i64 %t1774)
  %t1776 = call i64 @rt_string_to_symbol(i64 %t1775)
  %t1777 = call i64 @rt_cons(i64 %t1776, i64 %t1774)
  ret i64 %t1777
}

define fastcc i64 @"scheme.base:code_635"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1782 = icmp eq i64 %argc, 1
  br i1 %t1782, label %argok391, label %arityerr390
arityerr390:
  call void @rt_arity_error(i64 1, i64 %argc)
  unreachable
argok391:
  %t1783 = call i64 @rt_make_string(ptr @.str.lit.3, i64 5)
  %t1784 = call i64 @rt_string_eq(i64 %a0, i64 %t1783)
  %t1785 = icmp ne i64 %t1784, 1
  br i1 %t1785, label %then392, label %else393
then392:
  %t1786 = call i64 @rt_integer_to_char(i64 256)
  ret i64 %t1786
else393:
  %t1787 = call i64 @rt_make_string(ptr @.str.lit.4, i64 7)
  %t1788 = call i64 @rt_string_eq(i64 %a0, i64 %t1787)
  %t1789 = icmp ne i64 %t1788, 1
  br i1 %t1789, label %then394, label %else395
then394:
  %t1790 = call i64 @rt_integer_to_char(i64 80)
  ret i64 %t1790
else395:
  %t1791 = call i64 @rt_make_string(ptr @.str.lit.5, i64 3)
  %t1792 = call i64 @rt_string_eq(i64 %a0, i64 %t1791)
  %t1793 = icmp ne i64 %t1792, 1
  br i1 %t1793, label %then396, label %else397
then396:
  %t1794 = call i64 @rt_integer_to_char(i64 72)
  ret i64 %t1794
else397:
  %t1795 = call i64 @rt_make_string(ptr @.str.lit.6, i64 6)
  %t1796 = call i64 @rt_string_eq(i64 %a0, i64 %t1795)
  %t1797 = icmp ne i64 %t1796, 1
  br i1 %t1797, label %then398, label %else399
then398:
  %t1798 = call i64 @rt_integer_to_char(i64 104)
  ret i64 %t1798
else399:
  %t1799 = call i64 @rt_make_string(ptr @.str.lit.7, i64 3)
  %t1800 = call i64 @rt_string_eq(i64 %a0, i64 %t1799)
  %t1801 = icmp ne i64 %t1800, 1
  br i1 %t1801, label %then400, label %else401
then400:
  %t1802 = call i64 @rt_integer_to_char(i64 0)
  ret i64 %t1802
else401:
  %t1803 = call i64 @rt_make_string(ptr @.str.lit.8, i64 4)
  %t1804 = call i64 @rt_string_eq(i64 %a0, i64 %t1803)
  %t1805 = icmp ne i64 %t1804, 1
  br i1 %t1805, label %then402, label %else403
then402:
  %t1806 = call i64 @rt_integer_to_char(i64 0)
  ret i64 %t1806
else403:
  %t1807 = call i64 @rt_make_string(ptr @.str.lit.9, i64 6)
  %t1808 = call i64 @rt_string_eq(i64 %a0, i64 %t1807)
  %t1809 = icmp ne i64 %t1808, 1
  br i1 %t1809, label %then404, label %else405
then404:
  %t1810 = call i64 @rt_integer_to_char(i64 1016)
  ret i64 %t1810
else405:
  %t1811 = call i64 @rt_make_string(ptr @.str.lit.10, i64 7)
  %t1812 = call i64 @rt_string_eq(i64 %a0, i64 %t1811)
  %t1813 = icmp ne i64 %t1812, 1
  br i1 %t1813, label %then406, label %else407
then406:
  %t1814 = call i64 @rt_integer_to_char(i64 216)
  ret i64 %t1814
else407:
  %t1815 = call i64 @rt_make_string(ptr @.str.lit.11, i64 3)
  %t1816 = call i64 @rt_string_eq(i64 %a0, i64 %t1815)
  %t1817 = icmp ne i64 %t1816, 1
  br i1 %t1817, label %then408, label %else409
then408:
  %t1818 = call i64 @rt_integer_to_char(i64 216)
  ret i64 %t1818
else409:
  %t1819 = call i64 @rt_string_ref(i64 %a0, i64 0)
  ret i64 %t1819
}

define fastcc i64 @"scheme.base:code_647"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1824 = icmp eq i64 %argc, 3
  br i1 %t1824, label %argok411, label %arityerr410
arityerr410:
  call void @rt_arity_error(i64 3, i64 %argc)
  unreachable
argok411:
  %t1825 = call i64 @rt_add(i64 %a2, i64 8)
  %t1826 = call i64 @rt_add(i64 %t1825, i64 8)
  %t1827 = load i64, ptr @"scheme.base:rd-token-end"
  %t1828 = and i64 %t1827, -8
  %t1829 = inttoptr i64 %t1828 to ptr
  %t1830 = load i64, ptr %t1829
  %t1831 = inttoptr i64 %t1830 to ptr
  %t1832 = call fastcc i64%t1831(i64 %t1827, i64 3, i64 %a0, i64 %a1, i64 %t1826, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t1833 = call i64 @rt_substring(i64 %a0, i64 %t1825, i64 %t1832)
  %t1834 = call i64 @rt_string_length(i64 %t1833)
  %t1835 = call i64 @rt_num_eq(i64 %t1834, i64 8)
  %t1836 = icmp ne i64 %t1835, 1
  br i1 %t1836, label %then412, label %else413
then412:
  %t1837 = call i64 @rt_string_ref(i64 %a0, i64 %t1825)
  %t1838 = call i64 @rt_cons(i64 %t1837, i64 %t1832)
  ret i64 %t1838
else413:
  %t1839 = load i64, ptr @"scheme.base:rd-char-name"
  %t1840 = and i64 %t1839, -8
  %t1841 = inttoptr i64 %t1840 to ptr
  %t1842 = load i64, ptr %t1841
  %t1843 = inttoptr i64 %t1842 to ptr
  %t1844 = call fastcc i64%t1843(i64 %t1839, i64 1, i64 %t1833, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t1845 = call i64 @rt_cons(i64 %t1844, i64 %t1832)
  ret i64 %t1845
}

define fastcc i64 @"scheme.base:code_654"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1850 = icmp eq i64 %argc, 3
  br i1 %t1850, label %argok415, label %arityerr414
arityerr414:
  call void @rt_arity_error(i64 3, i64 %argc)
  unreachable
argok415:
  %t1851 = load i64, ptr @"scheme.base:rd-skip-ws"
  %t1852 = and i64 %t1851, -8
  %t1853 = inttoptr i64 %t1852 to ptr
  %t1854 = load i64, ptr %t1853
  %t1855 = inttoptr i64 %t1854 to ptr
  %t1856 = call fastcc i64%t1855(i64 %t1851, i64 3, i64 %a0, i64 %a1, i64 %a2, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t1857 = load i64, ptr @"scheme.base:rd-datum"
  %t1858 = and i64 %t1857, -8
  %t1859 = inttoptr i64 %t1858 to ptr
  %t1860 = load i64, ptr %t1859
  %t1861 = inttoptr i64 %t1860 to ptr
  %t1862 = call fastcc i64%t1861(i64 %t1857, i64 3, i64 %a0, i64 %a1, i64 %t1856, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t1863 = call i64 @rt_intern(ptr @.str.sym.12)
  %t1864 = call i64 @rt_car(i64 %t1862)
  %t1865 = load i64, ptr @"scheme.base:list"
  %t1866 = and i64 %t1865, -8
  %t1867 = inttoptr i64 %t1866 to ptr
  %t1868 = load i64, ptr %t1867
  %t1869 = inttoptr i64 %t1868 to ptr
  %t1870 = call fastcc i64%t1869(i64 %t1865, i64 2, i64 %t1863, i64 %t1864, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t1871 = call i64 @rt_cdr(i64 %t1862)
  %t1872 = call i64 @rt_cons(i64 %t1870, i64 %t1871)
  ret i64 %t1872
}

define fastcc i64 @"scheme.base:code_661"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1877 = icmp eq i64 %argc, 3
  br i1 %t1877, label %argok417, label %arityerr416
arityerr416:
  call void @rt_arity_error(i64 3, i64 %argc)
  unreachable
argok417:
  %t1878 = load i64, ptr @"scheme.base:rd-skip-ws"
  %t1879 = and i64 %t1878, -8
  %t1880 = inttoptr i64 %t1879 to ptr
  %t1881 = load i64, ptr %t1880
  %t1882 = inttoptr i64 %t1881 to ptr
  %t1883 = call fastcc i64%t1882(i64 %t1878, i64 3, i64 %a0, i64 %a1, i64 %a2, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t1884 = load i64, ptr @"scheme.base:rd-datum"
  %t1885 = and i64 %t1884, -8
  %t1886 = inttoptr i64 %t1885 to ptr
  %t1887 = load i64, ptr %t1886
  %t1888 = inttoptr i64 %t1887 to ptr
  %t1889 = call fastcc i64%t1888(i64 %t1884, i64 3, i64 %a0, i64 %a1, i64 %t1883, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t1890 = call i64 @rt_intern(ptr @.str.sym.13)
  %t1891 = call i64 @rt_car(i64 %t1889)
  %t1892 = load i64, ptr @"scheme.base:list"
  %t1893 = and i64 %t1892, -8
  %t1894 = inttoptr i64 %t1893 to ptr
  %t1895 = load i64, ptr %t1894
  %t1896 = inttoptr i64 %t1895 to ptr
  %t1897 = call fastcc i64%t1896(i64 %t1892, i64 2, i64 %t1890, i64 %t1891, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t1898 = call i64 @rt_cdr(i64 %t1889)
  %t1899 = call i64 @rt_cons(i64 %t1897, i64 %t1898)
  ret i64 %t1899
}

define fastcc i64 @"scheme.base:code_678"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1904 = icmp eq i64 %argc, 3
  br i1 %t1904, label %argok419, label %arityerr418
arityerr418:
  call void @rt_arity_error(i64 3, i64 %argc)
  unreachable
argok419:
  %t1905 = call i64 @rt_lt(i64 %a2, i64 %a1)
  %t1906 = icmp ne i64 %t1905, 1
  br i1 %t1906, label %then420, label %else421
then420:
  %t1907 = call i64 @rt_string_ref(i64 %a0, i64 %a2)
  %t1908 = call i64 @rt_char_to_integer(i64 %t1907)
  %t1909 = call i64 @rt_num_eq(i64 %t1908, i64 512)
  br label %merge422
else421:
  br label %merge422
merge422:
  %t1910 = phi i64 [ %t1909, %then420 ], [ 1, %else421 ]
  %t1911 = icmp ne i64 %t1910, 1
  br i1 %t1911, label %then423, label %else424
then423:
  %t1912 = call i64 @rt_add(i64 %a2, i64 8)
  %t1913 = load i64, ptr @"scheme.base:rd-skip-ws"
  %t1914 = and i64 %t1913, -8
  %t1915 = inttoptr i64 %t1914 to ptr
  %t1916 = load i64, ptr %t1915
  %t1917 = inttoptr i64 %t1916 to ptr
  %t1918 = call fastcc i64%t1917(i64 %t1913, i64 3, i64 %a0, i64 %a1, i64 %t1912, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t1919 = load i64, ptr @"scheme.base:rd-datum"
  %t1920 = and i64 %t1919, -8
  %t1921 = inttoptr i64 %t1920 to ptr
  %t1922 = load i64, ptr %t1921
  %t1923 = inttoptr i64 %t1922 to ptr
  %t1924 = call fastcc i64%t1923(i64 %t1919, i64 3, i64 %a0, i64 %a1, i64 %t1918, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t1925 = call i64 @rt_intern(ptr @.str.sym.14)
  %t1926 = call i64 @rt_car(i64 %t1924)
  %t1927 = load i64, ptr @"scheme.base:list"
  %t1928 = and i64 %t1927, -8
  %t1929 = inttoptr i64 %t1928 to ptr
  %t1930 = load i64, ptr %t1929
  %t1931 = inttoptr i64 %t1930 to ptr
  %t1932 = call fastcc i64%t1931(i64 %t1927, i64 2, i64 %t1925, i64 %t1926, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t1933 = call i64 @rt_cdr(i64 %t1924)
  %t1934 = call i64 @rt_cons(i64 %t1932, i64 %t1933)
  ret i64 %t1934
else424:
  %t1935 = load i64, ptr @"scheme.base:rd-skip-ws"
  %t1936 = and i64 %t1935, -8
  %t1937 = inttoptr i64 %t1936 to ptr
  %t1938 = load i64, ptr %t1937
  %t1939 = inttoptr i64 %t1938 to ptr
  %t1940 = call fastcc i64%t1939(i64 %t1935, i64 3, i64 %a0, i64 %a1, i64 %a2, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t1941 = load i64, ptr @"scheme.base:rd-datum"
  %t1942 = and i64 %t1941, -8
  %t1943 = inttoptr i64 %t1942 to ptr
  %t1944 = load i64, ptr %t1943
  %t1945 = inttoptr i64 %t1944 to ptr
  %t1946 = call fastcc i64%t1945(i64 %t1941, i64 3, i64 %a0, i64 %a1, i64 %t1940, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t1947 = call i64 @rt_intern(ptr @.str.sym.15)
  %t1948 = call i64 @rt_car(i64 %t1946)
  %t1949 = load i64, ptr @"scheme.base:list"
  %t1950 = and i64 %t1949, -8
  %t1951 = inttoptr i64 %t1950 to ptr
  %t1952 = load i64, ptr %t1951
  %t1953 = inttoptr i64 %t1952 to ptr
  %t1954 = call fastcc i64%t1953(i64 %t1949, i64 2, i64 %t1947, i64 %t1948, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t1955 = call i64 @rt_cdr(i64 %t1946)
  %t1956 = call i64 @rt_cons(i64 %t1954, i64 %t1955)
  ret i64 %t1956
}

define fastcc i64 @"scheme.base:code_691"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1961 = icmp eq i64 %argc, 3
  br i1 %t1961, label %argok426, label %arityerr425
arityerr425:
  call void @rt_arity_error(i64 3, i64 %argc)
  unreachable
argok426:
  %t1962 = call i64 @rt_string_ref(i64 %a0, i64 %a2)
  %t1963 = call i64 @rt_char_to_integer(i64 %t1962)
  %t1964 = call i64 @rt_num_eq(i64 %t1963, i64 368)
  %t1965 = icmp ne i64 %t1964, 1
  br i1 %t1965, label %then427, label %else428
then427:
  %t1966 = call i64 @rt_add(i64 %a2, i64 8)
  %t1967 = load i64, ptr @"scheme.base:rd-token-end"
  %t1968 = and i64 %t1967, -8
  %t1969 = inttoptr i64 %t1968 to ptr
  %t1970 = load i64, ptr %t1969
  %t1971 = inttoptr i64 %t1970 to ptr
  %t1972 = call fastcc i64%t1971(i64 %t1967, i64 3, i64 %a0, i64 %a1, i64 %t1966, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t1973 = call i64 @rt_add(i64 %a2, i64 8)
  %t1974 = call i64 @rt_num_eq(i64 %t1972, i64 %t1973)
  ret i64 %t1974
else428:
  ret i64 1
}

define fastcc i64 @"scheme.base:code_695"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1979 = icmp eq i64 %argc, 2
  br i1 %t1979, label %argok430, label %arityerr429
arityerr429:
  call void @rt_arity_error(i64 2, i64 %argc)
  unreachable
argok430:
  %t1980 = call i64 @rt_null_p(i64 %a0)
  %t1981 = icmp ne i64 %t1980, 1
  br i1 %t1981, label %then431, label %else432
then431:
  ret i64 %a1
else432:
  %t1982 = call i64 @rt_cdr(i64 %a0)
  %t1983 = call i64 @rt_car(i64 %a0)
  %t1984 = call i64 @rt_cons(i64 %t1983, i64 %a1)
  %t1985 = load i64, ptr @"scheme.base:rd-append-reverse"
  %t1986 = and i64 %t1985, -8
  %t1987 = inttoptr i64 %t1986 to ptr
  %t1988 = load i64, ptr %t1987
  %t1989 = inttoptr i64 %t1988 to ptr
  %t1990 = musttail call fastcc i64 %t1989(i64 %t1985, i64 2, i64 %t1982, i64 %t1984, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t1990
}

define fastcc i64 @"scheme.base:code_720"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1995 = icmp eq i64 %argc, 4
  br i1 %t1995, label %argok434, label %arityerr433
arityerr433:
  call void @rt_arity_error(i64 4, i64 %argc)
  unreachable
argok434:
  %t1996 = load i64, ptr @"scheme.base:rd-skip-ws"
  %t1997 = and i64 %t1996, -8
  %t1998 = inttoptr i64 %t1997 to ptr
  %t1999 = load i64, ptr %t1998
  %t2000 = inttoptr i64 %t1999 to ptr
  %t2001 = call fastcc i64%t2000(i64 %t1996, i64 3, i64 %a0, i64 %a1, i64 %a2, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t2002 = call i64 @rt_lt(i64 %t2001, i64 %a1)
  %t2003 = icmp ne i64 %t2002, 1
  br i1 %t2003, label %then435, label %else436
then435:
  %t2004 = call i64 @rt_string_ref(i64 %a0, i64 %t2001)
  %t2005 = call i64 @rt_char_to_integer(i64 %t2004)
  %t2006 = call i64 @rt_num_eq(i64 %t2005, i64 328)
  %t2007 = icmp ne i64 %t2006, 1
  br i1 %t2007, label %then437, label %else438
then437:
  br label %merge439
else438:
  %t2008 = call i64 @rt_num_eq(i64 %t2005, i64 744)
  br label %merge439
merge439:
  %t2009 = phi i64 [ %t2006, %then437 ], [ %t2008, %else438 ]
  %t2010 = icmp ne i64 %t2009, 1
  br i1 %t2010, label %then440, label %else441
then440:
  %t2011 = load i64, ptr @"scheme.base:reverse"
  %t2012 = and i64 %t2011, -8
  %t2013 = inttoptr i64 %t2012 to ptr
  %t2014 = load i64, ptr %t2013
  %t2015 = inttoptr i64 %t2014 to ptr
  %t2016 = call fastcc i64%t2015(i64 %t2011, i64 1, i64 %a3, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t2017 = call i64 @rt_add(i64 %t2001, i64 8)
  %t2018 = call i64 @rt_cons(i64 %t2016, i64 %t2017)
  ret i64 %t2018
else441:
  %t2019 = load i64, ptr @"scheme.base:rd-dot?"
  %t2020 = and i64 %t2019, -8
  %t2021 = inttoptr i64 %t2020 to ptr
  %t2022 = load i64, ptr %t2021
  %t2023 = inttoptr i64 %t2022 to ptr
  %t2024 = call fastcc i64%t2023(i64 %t2019, i64 3, i64 %a0, i64 %a1, i64 %t2001, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t2025 = icmp ne i64 %t2024, 1
  br i1 %t2025, label %then442, label %else443
then442:
  %t2026 = call i64 @rt_add(i64 %t2001, i64 8)
  %t2027 = load i64, ptr @"scheme.base:rd-skip-ws"
  %t2028 = and i64 %t2027, -8
  %t2029 = inttoptr i64 %t2028 to ptr
  %t2030 = load i64, ptr %t2029
  %t2031 = inttoptr i64 %t2030 to ptr
  %t2032 = call fastcc i64%t2031(i64 %t2027, i64 3, i64 %a0, i64 %a1, i64 %t2026, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t2033 = load i64, ptr @"scheme.base:rd-datum"
  %t2034 = and i64 %t2033, -8
  %t2035 = inttoptr i64 %t2034 to ptr
  %t2036 = load i64, ptr %t2035
  %t2037 = inttoptr i64 %t2036 to ptr
  %t2038 = call fastcc i64%t2037(i64 %t2033, i64 3, i64 %a0, i64 %a1, i64 %t2032, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t2039 = call i64 @rt_cdr(i64 %t2038)
  %t2040 = load i64, ptr @"scheme.base:rd-skip-ws"
  %t2041 = and i64 %t2040, -8
  %t2042 = inttoptr i64 %t2041 to ptr
  %t2043 = load i64, ptr %t2042
  %t2044 = inttoptr i64 %t2043 to ptr
  %t2045 = call fastcc i64%t2044(i64 %t2040, i64 3, i64 %a0, i64 %a1, i64 %t2039, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t2046 = call i64 @rt_car(i64 %t2038)
  %t2047 = load i64, ptr @"scheme.base:rd-append-reverse"
  %t2048 = and i64 %t2047, -8
  %t2049 = inttoptr i64 %t2048 to ptr
  %t2050 = load i64, ptr %t2049
  %t2051 = inttoptr i64 %t2050 to ptr
  %t2052 = call fastcc i64%t2051(i64 %t2047, i64 2, i64 %a3, i64 %t2046, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t2053 = call i64 @rt_add(i64 %t2045, i64 8)
  %t2054 = call i64 @rt_cons(i64 %t2052, i64 %t2053)
  ret i64 %t2054
else443:
  %t2055 = load i64, ptr @"scheme.base:rd-datum"
  %t2056 = and i64 %t2055, -8
  %t2057 = inttoptr i64 %t2056 to ptr
  %t2058 = load i64, ptr %t2057
  %t2059 = inttoptr i64 %t2058 to ptr
  %t2060 = call fastcc i64%t2059(i64 %t2055, i64 3, i64 %a0, i64 %a1, i64 %t2001, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t2061 = call i64 @rt_cdr(i64 %t2060)
  %t2062 = call i64 @rt_car(i64 %t2060)
  %t2063 = call i64 @rt_cons(i64 %t2062, i64 %a3)
  %t2064 = load i64, ptr @"scheme.base:rd-list"
  %t2065 = and i64 %t2064, -8
  %t2066 = inttoptr i64 %t2065 to ptr
  %t2067 = load i64, ptr %t2066
  %t2068 = inttoptr i64 %t2067 to ptr
  %t2069 = musttail call fastcc i64 %t2068(i64 %t2064, i64 4, i64 %a0, i64 %a1, i64 %t2061, i64 %t2063, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t2069
else436:
  %t2070 = load i64, ptr @"scheme.base:reverse"
  %t2071 = and i64 %t2070, -8
  %t2072 = inttoptr i64 %t2071 to ptr
  %t2073 = load i64, ptr %t2072
  %t2074 = inttoptr i64 %t2073 to ptr
  %t2075 = call fastcc i64%t2074(i64 %t2070, i64 1, i64 %a3, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t2076 = call i64 @rt_cons(i64 %t2075, i64 %t2001)
  ret i64 %t2076
}

define fastcc i64 @"scheme.base:code_754"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t2081 = icmp eq i64 %argc, 3
  br i1 %t2081, label %argok445, label %arityerr444
arityerr444:
  call void @rt_arity_error(i64 3, i64 %argc)
  unreachable
argok445:
  %t2082 = call i64 @rt_string_ref(i64 %a0, i64 %a2)
  %t2083 = call i64 @rt_char_to_integer(i64 %t2082)
  %t2084 = call i64 @rt_num_eq(i64 %t2083, i64 320)
  %t2085 = icmp ne i64 %t2084, 1
  br i1 %t2085, label %then446, label %else447
then446:
  %t2086 = call i64 @rt_add(i64 %a2, i64 8)
  %t2087 = load i64, ptr @"scheme.base:rd-list"
  %t2088 = and i64 %t2087, -8
  %t2089 = inttoptr i64 %t2088 to ptr
  %t2090 = load i64, ptr %t2089
  %t2091 = inttoptr i64 %t2090 to ptr
  %t2092 = musttail call fastcc i64 %t2091(i64 %t2087, i64 4, i64 %a0, i64 %a1, i64 %t2086, i64 2, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t2092
else447:
  %t2093 = call i64 @rt_num_eq(i64 %t2083, i64 728)
  %t2094 = icmp ne i64 %t2093, 1
  br i1 %t2094, label %then448, label %else449
then448:
  %t2095 = call i64 @rt_add(i64 %a2, i64 8)
  %t2096 = load i64, ptr @"scheme.base:rd-list"
  %t2097 = and i64 %t2096, -8
  %t2098 = inttoptr i64 %t2097 to ptr
  %t2099 = load i64, ptr %t2098
  %t2100 = inttoptr i64 %t2099 to ptr
  %t2101 = musttail call fastcc i64 %t2100(i64 %t2096, i64 4, i64 %a0, i64 %a1, i64 %t2095, i64 2, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t2101
else449:
  %t2102 = call i64 @rt_num_eq(i64 %t2083, i64 312)
  %t2103 = icmp ne i64 %t2102, 1
  br i1 %t2103, label %then450, label %else451
then450:
  %t2104 = call i64 @rt_add(i64 %a2, i64 8)
  %t2105 = load i64, ptr @"scheme.base:rd-quote"
  %t2106 = and i64 %t2105, -8
  %t2107 = inttoptr i64 %t2106 to ptr
  %t2108 = load i64, ptr %t2107
  %t2109 = inttoptr i64 %t2108 to ptr
  %t2110 = musttail call fastcc i64 %t2109(i64 %t2105, i64 3, i64 %a0, i64 %a1, i64 %t2104, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t2110
else451:
  %t2111 = call i64 @rt_num_eq(i64 %t2083, i64 768)
  %t2112 = icmp ne i64 %t2111, 1
  br i1 %t2112, label %then452, label %else453
then452:
  %t2113 = call i64 @rt_add(i64 %a2, i64 8)
  %t2114 = load i64, ptr @"scheme.base:rd-quasi"
  %t2115 = and i64 %t2114, -8
  %t2116 = inttoptr i64 %t2115 to ptr
  %t2117 = load i64, ptr %t2116
  %t2118 = inttoptr i64 %t2117 to ptr
  %t2119 = musttail call fastcc i64 %t2118(i64 %t2114, i64 3, i64 %a0, i64 %a1, i64 %t2113, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t2119
else453:
  %t2120 = call i64 @rt_num_eq(i64 %t2083, i64 352)
  %t2121 = icmp ne i64 %t2120, 1
  br i1 %t2121, label %then454, label %else455
then454:
  %t2122 = call i64 @rt_add(i64 %a2, i64 8)
  %t2123 = load i64, ptr @"scheme.base:rd-unquote"
  %t2124 = and i64 %t2123, -8
  %t2125 = inttoptr i64 %t2124 to ptr
  %t2126 = load i64, ptr %t2125
  %t2127 = inttoptr i64 %t2126 to ptr
  %t2128 = musttail call fastcc i64 %t2127(i64 %t2123, i64 3, i64 %a0, i64 %a1, i64 %t2122, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t2128
else455:
  %t2129 = call i64 @rt_num_eq(i64 %t2083, i64 272)
  %t2130 = icmp ne i64 %t2129, 1
  br i1 %t2130, label %then456, label %else457
then456:
  %t2131 = call i64 @rt_add(i64 %a2, i64 8)
  %t2132 = load i64, ptr @"scheme.base:rd-string"
  %t2133 = and i64 %t2132, -8
  %t2134 = inttoptr i64 %t2133 to ptr
  %t2135 = load i64, ptr %t2134
  %t2136 = inttoptr i64 %t2135 to ptr
  %t2137 = musttail call fastcc i64 %t2136(i64 %t2132, i64 3, i64 %a0, i64 %a1, i64 %t2131, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t2137
else457:
  %t2138 = call i64 @rt_num_eq(i64 %t2083, i64 280)
  %t2139 = icmp ne i64 %t2138, 1
  br i1 %t2139, label %then458, label %else459
then458:
  %t2140 = call i64 @rt_add(i64 %a2, i64 8)
  %t2141 = load i64, ptr @"scheme.base:rd-hash"
  %t2142 = and i64 %t2141, -8
  %t2143 = inttoptr i64 %t2142 to ptr
  %t2144 = load i64, ptr %t2143
  %t2145 = inttoptr i64 %t2144 to ptr
  %t2146 = musttail call fastcc i64 %t2145(i64 %t2141, i64 3, i64 %a0, i64 %a1, i64 %t2140, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t2146
else459:
  %t2147 = load i64, ptr @"scheme.base:rd-atom"
  %t2148 = and i64 %t2147, -8
  %t2149 = inttoptr i64 %t2148 to ptr
  %t2150 = load i64, ptr %t2149
  %t2151 = inttoptr i64 %t2150 to ptr
  %t2152 = musttail call fastcc i64 %t2151(i64 %t2147, i64 3, i64 %a0, i64 %a1, i64 %a2, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t2152
}

define fastcc i64 @"scheme.base:code_758"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t2157 = icmp eq i64 %argc, 1
  br i1 %t2157, label %argok461, label %arityerr460
arityerr460:
  call void @rt_arity_error(i64 1, i64 %argc)
  unreachable
argok461:
  %t2158 = call i64 @rt_string_length(i64 %a0)
  %t2159 = load i64, ptr @"scheme.base:rd-skip-ws"
  %t2160 = and i64 %t2159, -8
  %t2161 = inttoptr i64 %t2160 to ptr
  %t2162 = load i64, ptr %t2161
  %t2163 = inttoptr i64 %t2162 to ptr
  %t2164 = call fastcc i64%t2163(i64 %t2159, i64 3, i64 %a0, i64 %t2158, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t2165 = load i64, ptr @"scheme.base:rd-datum"
  %t2166 = and i64 %t2165, -8
  %t2167 = inttoptr i64 %t2166 to ptr
  %t2168 = load i64, ptr %t2167
  %t2169 = inttoptr i64 %t2168 to ptr
  %t2170 = call fastcc i64%t2169(i64 %t2165, i64 3, i64 %a0, i64 %t2158, i64 %t2164, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t2171 = call i64 @rt_car(i64 %t2170)
  ret i64 %t2171
}

define fastcc i64 @"scheme.base:code_772"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t2176 = icmp eq i64 %argc, 2
  br i1 %t2176, label %argok463, label %arityerr462
arityerr462:
  call void @rt_arity_error(i64 2, i64 %argc)
  unreachable
argok463:
  %t2177 = and i64 %self, -8
  %t2178 = inttoptr i64 %t2177 to ptr
  %t2179 = getelementptr i64, ptr %t2178, i64 1
  %t2180 = load i64, ptr %t2179
  %t2181 = call i64 @rt_lt(i64 %a0, i64 %t2180)
  %t2182 = icmp ne i64 %t2181, 1
  br i1 %t2182, label %then464, label %else465
then464:
  %t2183 = and i64 %self, -8
  %t2184 = inttoptr i64 %t2183 to ptr
  %t2185 = getelementptr i64, ptr %t2184, i64 2
  %t2186 = load i64, ptr %t2185
  %t2187 = and i64 %self, -8
  %t2188 = inttoptr i64 %t2187 to ptr
  %t2189 = getelementptr i64, ptr %t2188, i64 1
  %t2190 = load i64, ptr %t2189
  %t2191 = load i64, ptr @"scheme.base:rd-datum"
  %t2192 = and i64 %t2191, -8
  %t2193 = inttoptr i64 %t2192 to ptr
  %t2194 = load i64, ptr %t2193
  %t2195 = inttoptr i64 %t2194 to ptr
  %t2196 = call fastcc i64%t2195(i64 %t2191, i64 3, i64 %t2186, i64 %t2190, i64 %a0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t2197 = and i64 %self, -8
  %t2198 = inttoptr i64 %t2197 to ptr
  %t2199 = getelementptr i64, ptr %t2198, i64 2
  %t2200 = load i64, ptr %t2199
  %t2201 = and i64 %self, -8
  %t2202 = inttoptr i64 %t2201 to ptr
  %t2203 = getelementptr i64, ptr %t2202, i64 1
  %t2204 = load i64, ptr %t2203
  %t2205 = call i64 @rt_cdr(i64 %t2196)
  %t2206 = load i64, ptr @"scheme.base:rd-skip-ws"
  %t2207 = and i64 %t2206, -8
  %t2208 = inttoptr i64 %t2207 to ptr
  %t2209 = load i64, ptr %t2208
  %t2210 = inttoptr i64 %t2209 to ptr
  %t2211 = call fastcc i64%t2210(i64 %t2206, i64 3, i64 %t2200, i64 %t2204, i64 %t2205, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t2212 = call i64 @rt_car(i64 %t2196)
  %t2213 = call i64 @rt_cons(i64 %t2212, i64 %a1)
  %t2214 = and i64 %self, -8
  %t2215 = inttoptr i64 %t2214 to ptr
  %t2216 = getelementptr i64, ptr %t2215, i64 3
  %t2217 = load i64, ptr %t2216
  %t2218 = and i64 %t2217, -8
  %t2219 = inttoptr i64 %t2218 to ptr
  %t2220 = load i64, ptr %t2219
  %t2221 = inttoptr i64 %t2220 to ptr
  %t2222 = musttail call fastcc i64 %t2221(i64 %t2217, i64 2, i64 %t2211, i64 %t2213, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t2222
else465:
  %t2223 = load i64, ptr @"scheme.base:reverse"
  %t2224 = and i64 %t2223, -8
  %t2225 = inttoptr i64 %t2224 to ptr
  %t2226 = load i64, ptr %t2225
  %t2227 = inttoptr i64 %t2226 to ptr
  %t2228 = musttail call fastcc i64 %t2227(i64 %t2223, i64 1, i64 %a1, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t2228
}

define fastcc i64 @"scheme.base:code_770"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t2229 = icmp eq i64 %argc, 1
  br i1 %t2229, label %argok467, label %arityerr466
arityerr466:
  call void @rt_arity_error(i64 1, i64 %argc)
  unreachable
argok467:
  %t2230 = call i64 @rt_string_length(i64 %a0)
  %t2231 = call i64 @rt_alloc_words(i64 4)
  %t2232 = inttoptr i64 %t2231 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_772" to i64), ptr %t2232
  %t2233 = or i64 %t2231, 4
  %t2234 = getelementptr i64, ptr %t2232, i64 1
  store i64 %t2230, ptr %t2234
  %t2235 = getelementptr i64, ptr %t2232, i64 2
  store i64 %a0, ptr %t2235
  %t2236 = getelementptr i64, ptr %t2232, i64 3
  store i64 %t2233, ptr %t2236
  %t2237 = load i64, ptr @"scheme.base:rd-skip-ws"
  %t2238 = and i64 %t2237, -8
  %t2239 = inttoptr i64 %t2238 to ptr
  %t2240 = load i64, ptr %t2239
  %t2241 = inttoptr i64 %t2240 to ptr
  %t2242 = call fastcc i64%t2241(i64 %t2237, i64 3, i64 %a0, i64 %t2230, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t2243 = and i64 %t2233, -8
  %t2244 = inttoptr i64 %t2243 to ptr
  %t2245 = load i64, ptr %t2244
  %t2246 = inttoptr i64 %t2245 to ptr
  %t2247 = musttail call fastcc i64 %t2246(i64 %t2233, i64 2, i64 %t2242, i64 2, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t2247
}

define i64 @"scheme.base:__init_1"() {
entry:
  %t13 = call i64 @rt_alloc_words(i64 1)
  %t14 = inttoptr i64 %t13 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_1" to i64), ptr %t14
  %t15 = or i64 %t13, 4
  %t16 = call i64 @rt_root(i64 %t15)
  store i64 %t16, ptr @"scheme.base:list"
  ret i64 %t16
}

define i64 @"scheme.base:__init_2"() {
entry:
  %t20 = call i64 @rt_alloc_words(i64 1)
  %t21 = inttoptr i64 %t20 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_4" to i64), ptr %t21
  %t22 = or i64 %t20, 4
  %t23 = call i64 @rt_root(i64 %t22)
  store i64 %t23, ptr @"scheme.base:caar"
  ret i64 %t23
}

define i64 @"scheme.base:__init_3"() {
entry:
  %t27 = call i64 @rt_alloc_words(i64 1)
  %t28 = inttoptr i64 %t27 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_7" to i64), ptr %t28
  %t29 = or i64 %t27, 4
  %t30 = call i64 @rt_root(i64 %t29)
  store i64 %t30, ptr @"scheme.base:cadr"
  ret i64 %t30
}

define i64 @"scheme.base:__init_4"() {
entry:
  %t34 = call i64 @rt_alloc_words(i64 1)
  %t35 = inttoptr i64 %t34 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_10" to i64), ptr %t35
  %t36 = or i64 %t34, 4
  %t37 = call i64 @rt_root(i64 %t36)
  store i64 %t37, ptr @"scheme.base:cdar"
  ret i64 %t37
}

define i64 @"scheme.base:__init_5"() {
entry:
  %t41 = call i64 @rt_alloc_words(i64 1)
  %t42 = inttoptr i64 %t41 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_13" to i64), ptr %t42
  %t43 = or i64 %t41, 4
  %t44 = call i64 @rt_root(i64 %t43)
  store i64 %t44, ptr @"scheme.base:cddr"
  ret i64 %t44
}

define i64 @"scheme.base:__init_6"() {
entry:
  %t53 = call i64 @rt_alloc_words(i64 1)
  %t54 = inttoptr i64 %t53 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_16" to i64), ptr %t54
  %t55 = or i64 %t53, 4
  %t56 = call i64 @rt_root(i64 %t55)
  store i64 %t56, ptr @"scheme.base:caaar"
  ret i64 %t56
}

define i64 @"scheme.base:__init_7"() {
entry:
  %t65 = call i64 @rt_alloc_words(i64 1)
  %t66 = inttoptr i64 %t65 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_19" to i64), ptr %t66
  %t67 = or i64 %t65, 4
  %t68 = call i64 @rt_root(i64 %t67)
  store i64 %t68, ptr @"scheme.base:caadr"
  ret i64 %t68
}

define i64 @"scheme.base:__init_8"() {
entry:
  %t77 = call i64 @rt_alloc_words(i64 1)
  %t78 = inttoptr i64 %t77 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_22" to i64), ptr %t78
  %t79 = or i64 %t77, 4
  %t80 = call i64 @rt_root(i64 %t79)
  store i64 %t80, ptr @"scheme.base:cadar"
  ret i64 %t80
}

define i64 @"scheme.base:__init_9"() {
entry:
  %t89 = call i64 @rt_alloc_words(i64 1)
  %t90 = inttoptr i64 %t89 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_25" to i64), ptr %t90
  %t91 = or i64 %t89, 4
  %t92 = call i64 @rt_root(i64 %t91)
  store i64 %t92, ptr @"scheme.base:caddr"
  ret i64 %t92
}

define i64 @"scheme.base:__init_10"() {
entry:
  %t101 = call i64 @rt_alloc_words(i64 1)
  %t102 = inttoptr i64 %t101 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_28" to i64), ptr %t102
  %t103 = or i64 %t101, 4
  %t104 = call i64 @rt_root(i64 %t103)
  store i64 %t104, ptr @"scheme.base:cdaar"
  ret i64 %t104
}

define i64 @"scheme.base:__init_11"() {
entry:
  %t113 = call i64 @rt_alloc_words(i64 1)
  %t114 = inttoptr i64 %t113 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_31" to i64), ptr %t114
  %t115 = or i64 %t113, 4
  %t116 = call i64 @rt_root(i64 %t115)
  store i64 %t116, ptr @"scheme.base:cdadr"
  ret i64 %t116
}

define i64 @"scheme.base:__init_12"() {
entry:
  %t125 = call i64 @rt_alloc_words(i64 1)
  %t126 = inttoptr i64 %t125 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_34" to i64), ptr %t126
  %t127 = or i64 %t125, 4
  %t128 = call i64 @rt_root(i64 %t127)
  store i64 %t128, ptr @"scheme.base:cddar"
  ret i64 %t128
}

define i64 @"scheme.base:__init_13"() {
entry:
  %t137 = call i64 @rt_alloc_words(i64 1)
  %t138 = inttoptr i64 %t137 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_37" to i64), ptr %t138
  %t139 = or i64 %t137, 4
  %t140 = call i64 @rt_root(i64 %t139)
  store i64 %t140, ptr @"scheme.base:cdddr"
  ret i64 %t140
}

define i64 @"scheme.base:__init_14"() {
entry:
  %t165 = call i64 @rt_alloc_words(i64 1)
  %t166 = inttoptr i64 %t165 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_43" to i64), ptr %t166
  %t167 = or i64 %t165, 4
  %t168 = call i64 @rt_root(i64 %t167)
  store i64 %t168, ptr @"scheme.base:length"
  ret i64 %t168
}

define i64 @"scheme.base:__init_15"() {
entry:
  %t194 = call i64 @rt_alloc_words(i64 1)
  %t195 = inttoptr i64 %t194 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_51" to i64), ptr %t195
  %t196 = or i64 %t194, 4
  %t197 = call i64 @rt_root(i64 %t196)
  store i64 %t197, ptr @"scheme.base:reverse"
  ret i64 %t197
}

define i64 @"scheme.base:__init_16"() {
entry:
  %t210 = call i64 @rt_alloc_words(i64 1)
  %t211 = inttoptr i64 %t210 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_57" to i64), ptr %t211
  %t212 = or i64 %t210, 4
  %t213 = call i64 @rt_root(i64 %t212)
  store i64 %t213, ptr @"scheme.base:%append2"
  ret i64 %t213
}

define i64 @"scheme.base:__init_17"() {
entry:
  %t268 = call i64 @rt_alloc_words(i64 1)
  %t269 = inttoptr i64 %t268 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_60" to i64), ptr %t269
  %t270 = or i64 %t268, 4
  %t271 = call i64 @rt_root(i64 %t270)
  store i64 %t271, ptr @"scheme.base:append"
  ret i64 %t271
}

define i64 @"scheme.base:__init_18"() {
entry:
  %t289 = call i64 @rt_alloc_words(i64 1)
  %t290 = inttoptr i64 %t289 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_64" to i64), ptr %t290
  %t291 = or i64 %t289, 4
  %t292 = call i64 @rt_root(i64 %t291)
  store i64 %t292, ptr @"scheme.base:%map1"
  ret i64 %t292
}

define i64 @"scheme.base:__init_19"() {
entry:
  %t306 = call i64 @rt_alloc_words(i64 1)
  %t307 = inttoptr i64 %t306 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_67" to i64), ptr %t307
  %t308 = or i64 %t306, 4
  %t309 = call i64 @rt_root(i64 %t308)
  store i64 %t309, ptr @"scheme.base:%any-null?"
  ret i64 %t309
}

define i64 @"scheme.base:__init_20"() {
entry:
  %t374 = call i64 @rt_alloc_words(i64 1)
  %t375 = inttoptr i64 %t374 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_73" to i64), ptr %t375
  %t376 = or i64 %t374, 4
  %t377 = call i64 @rt_root(i64 %t376)
  store i64 %t377, ptr @"scheme.base:%mapn"
  ret i64 %t377
}

define i64 @"scheme.base:__init_21"() {
entry:
  %t405 = call i64 @rt_alloc_words(i64 1)
  %t406 = inttoptr i64 %t405 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_82" to i64), ptr %t406
  %t407 = or i64 %t405, 4
  %t408 = call i64 @rt_root(i64 %t407)
  store i64 %t408, ptr @"scheme.base:map"
  ret i64 %t408
}

define i64 @"scheme.base:__init_22"() {
entry:
  %t422 = call i64 @rt_alloc_words(i64 1)
  %t423 = inttoptr i64 %t422 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_90" to i64), ptr %t423
  %t424 = or i64 %t422, 4
  %t425 = call i64 @rt_root(i64 %t424)
  store i64 %t425, ptr @"scheme.base:memq"
  ret i64 %t425
}

define i64 @"scheme.base:__init_23"() {
entry:
  %t439 = call i64 @rt_alloc_words(i64 1)
  %t440 = inttoptr i64 %t439 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_98" to i64), ptr %t440
  %t441 = or i64 %t439, 4
  %t442 = call i64 @rt_root(i64 %t441)
  store i64 %t442, ptr @"scheme.base:memv"
  ret i64 %t442
}

define i64 @"scheme.base:__init_24"() {
entry:
  %t458 = call i64 @rt_alloc_words(i64 1)
  %t459 = inttoptr i64 %t458 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_106" to i64), ptr %t459
  %t460 = or i64 %t458, 4
  %t461 = call i64 @rt_root(i64 %t460)
  store i64 %t461, ptr @"scheme.base:assq"
  ret i64 %t461
}

define i64 @"scheme.base:__init_25"() {
entry:
  %t475 = call i64 @rt_alloc_words(i64 1)
  %t476 = inttoptr i64 %t475 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_110" to i64), ptr %t476
  %t477 = or i64 %t475, 4
  %t478 = call i64 @rt_root(i64 %t477)
  store i64 %t478, ptr @"scheme.base:member"
  ret i64 %t478
}

define i64 @"scheme.base:__init_26"() {
entry:
  %t494 = call i64 @rt_alloc_words(i64 1)
  %t495 = inttoptr i64 %t494 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_114" to i64), ptr %t495
  %t496 = or i64 %t494, 4
  %t497 = call i64 @rt_root(i64 %t496)
  store i64 %t497, ptr @"scheme.base:assoc"
  ret i64 %t497
}

define i64 @"scheme.base:__init_27"() {
entry:
  %t524 = call i64 @rt_alloc_words(i64 1)
  %t525 = inttoptr i64 %t524 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_118" to i64), ptr %t525
  %t526 = or i64 %t524, 4
  %t527 = call i64 @rt_root(i64 %t526)
  store i64 %t527, ptr @"scheme.base:filter"
  ret i64 %t527
}

define i64 @"scheme.base:__init_28"() {
entry:
  %t544 = call i64 @rt_alloc_words(i64 1)
  %t545 = inttoptr i64 %t544 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_123" to i64), ptr %t545
  %t546 = or i64 %t544, 4
  %t547 = call i64 @rt_root(i64 %t546)
  store i64 %t547, ptr @"scheme.base:fold-left"
  ret i64 %t547
}

define i64 @"scheme.base:__init_29"() {
entry:
  %t564 = call i64 @rt_alloc_words(i64 1)
  %t565 = inttoptr i64 %t564 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_128" to i64), ptr %t565
  %t566 = or i64 %t564, 4
  %t567 = call i64 @rt_root(i64 %t566)
  store i64 %t567, ptr @"scheme.base:fold-right"
  ret i64 %t567
}

define i64 @"scheme.base:__init_30"() {
entry:
  %t585 = call i64 @rt_alloc_words(i64 1)
  %t586 = inttoptr i64 %t585 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_132" to i64), ptr %t586
  %t587 = or i64 %t585, 4
  %t588 = call i64 @rt_root(i64 %t587)
  store i64 %t588, ptr @"scheme.base:%for-each1"
  ret i64 %t588
}

define i64 @"scheme.base:__init_31"() {
entry:
  %t653 = call i64 @rt_alloc_words(i64 1)
  %t654 = inttoptr i64 %t653 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_138" to i64), ptr %t654
  %t655 = or i64 %t653, 4
  %t656 = call i64 @rt_root(i64 %t655)
  store i64 %t656, ptr @"scheme.base:%for-eachn"
  ret i64 %t656
}

define i64 @"scheme.base:__init_32"() {
entry:
  %t684 = call i64 @rt_alloc_words(i64 1)
  %t685 = inttoptr i64 %t684 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_147" to i64), ptr %t685
  %t686 = or i64 %t684, 4
  %t687 = call i64 @rt_root(i64 %t686)
  store i64 %t687, ptr @"scheme.base:for-each"
  ret i64 %t687
}

define i64 @"scheme.base:__init_33"() {
entry:
  %t705 = call i64 @rt_alloc_words(i64 1)
  %t706 = inttoptr i64 %t705 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_151" to i64), ptr %t706
  %t707 = or i64 %t705, 4
  %t708 = call i64 @rt_root(i64 %t707)
  store i64 %t708, ptr @"scheme.base:andmap"
  ret i64 %t708
}

define i64 @"scheme.base:__init_34"() {
entry:
  %t726 = call i64 @rt_alloc_words(i64 1)
  %t727 = inttoptr i64 %t726 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_155" to i64), ptr %t727
  %t728 = or i64 %t726, 4
  %t729 = call i64 @rt_root(i64 %t728)
  store i64 %t729, ptr @"scheme.base:memp"
  ret i64 %t729
}

define i64 @"scheme.base:__init_35"() {
entry:
  %t738 = call i64 @rt_alloc_words(i64 1)
  %t739 = inttoptr i64 %t738 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_158" to i64), ptr %t739
  %t740 = or i64 %t738, 4
  %t741 = call i64 @rt_root(i64 %t740)
  store i64 %t741, ptr @"scheme.base:cadddr"
  ret i64 %t741
}

define i64 @"scheme.base:__init_36"() {
entry:
  %t754 = call i64 @rt_alloc_words(i64 1)
  %t755 = inttoptr i64 %t754 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_161" to i64), ptr %t755
  %t756 = or i64 %t754, 4
  %t757 = call i64 @rt_root(i64 %t756)
  store i64 %t757, ptr @"scheme.base:list?"
  ret i64 %t757
}

define i64 @"scheme.base:__init_37"() {
entry:
  %t760 = call i64 @rt_alloc_words(i64 1)
  %t761 = inttoptr i64 %t760 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_168" to i64), ptr %t761
  %t762 = or i64 %t760, 4
  %t763 = call i64 @rt_root(i64 %t762)
  store i64 %t763, ptr @"scheme.base:zero?"
  ret i64 %t763
}

define i64 @"scheme.base:__init_38"() {
entry:
  %t780 = call i64 @rt_alloc_words(i64 1)
  %t781 = inttoptr i64 %t780 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_172" to i64), ptr %t781
  %t782 = or i64 %t780, 4
  %t783 = call i64 @rt_root(i64 %t782)
  store i64 %t783, ptr @"scheme.base:list-tail"
  ret i64 %t783
}

define i64 @"scheme.base:__init_39"() {
entry:
  %t792 = call i64 @rt_alloc_words(i64 1)
  %t793 = inttoptr i64 %t792 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_176" to i64), ptr %t793
  %t794 = or i64 %t792, 4
  %t795 = call i64 @rt_root(i64 %t794)
  store i64 %t795, ptr @"scheme.base:list-ref"
  ret i64 %t795
}

define i64 @"scheme.base:__init_40"() {
entry:
  %t814 = call i64 @rt_alloc_words(i64 1)
  %t815 = inttoptr i64 %t814 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_180" to i64), ptr %t815
  %t816 = or i64 %t814, 4
  %t817 = call i64 @rt_root(i64 %t816)
  store i64 %t817, ptr @"scheme.base:list-head"
  ret i64 %t817
}

define i64 @"scheme.base:__init_41"() {
entry:
  %t834 = call i64 @rt_alloc_words(i64 1)
  %t835 = inttoptr i64 %t834 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_184" to i64), ptr %t835
  %t836 = or i64 %t834, 4
  %t837 = call i64 @rt_root(i64 %t836)
  store i64 %t837, ptr @"scheme.base:make-list"
  ret i64 %t837
}

define i64 @"scheme.base:__init_42"() {
entry:
  %t873 = call i64 @rt_alloc_words(i64 1)
  %t874 = inttoptr i64 %t873 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_194" to i64), ptr %t874
  %t875 = or i64 %t873, 4
  %t876 = call i64 @rt_root(i64 %t875)
  store i64 %t876, ptr @"scheme.base:iota"
  ret i64 %t876
}

define i64 @"scheme.base:__init_43"() {
entry:
  %t880 = call i64 @rt_alloc_words(i64 1)
  %t881 = inttoptr i64 %t880 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_204" to i64), ptr %t881
  %t882 = or i64 %t880, 4
  %t883 = call i64 @rt_root(i64 %t882)
  store i64 %t883, ptr @"scheme.base:max"
  ret i64 %t883
}

define i64 @"scheme.base:__init_44"() {
entry:
  %t886 = call i64 @rt_alloc_words(i64 1)
  %t887 = inttoptr i64 %t886 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_206" to i64), ptr %t887
  %t888 = or i64 %t886, 4
  %t889 = call i64 @rt_root(i64 %t888)
  store i64 %t889, ptr @"scheme.base:void"
  ret i64 %t889
}

define i64 @"scheme.base:__init_45"() {
entry:
  %t903 = call i64 @rt_alloc_words(i64 1)
  %t904 = inttoptr i64 %t903 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_209" to i64), ptr %t904
  %t905 = or i64 %t903, 4
  %t906 = call i64 @rt_root(i64 %t905)
  store i64 %t906, ptr @"scheme.base:string"
  ret i64 %t906
}

define i64 @"scheme.base:__init_46"() {
entry:
  %t920 = call i64 @rt_alloc_words(i64 1)
  %t921 = inttoptr i64 %t920 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_212" to i64), ptr %t921
  %t922 = or i64 %t920, 4
  %t923 = call i64 @rt_root(i64 %t922)
  store i64 %t923, ptr @"scheme.base:%str-concat"
  ret i64 %t923
}

define i64 @"scheme.base:__init_47"() {
entry:
  %t943 = call i64 @rt_alloc_words(i64 1)
  %t944 = inttoptr i64 %t943 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_218" to i64), ptr %t944
  %t945 = or i64 %t943, 4
  %t946 = call i64 @rt_root(i64 %t945)
  store i64 %t946, ptr @"scheme.base:chr-cmp"
  ret i64 %t946
}

define i64 @"scheme.base:__init_48"() {
entry:
  %t970 = call i64 @rt_alloc_words(i64 1)
  %t971 = inttoptr i64 %t970 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_229" to i64), ptr %t971
  %t972 = or i64 %t970, 4
  %t973 = call i64 @rt_root(i64 %t972)
  store i64 %t973, ptr @"scheme.base:char=?"
  ret i64 %t973
}

define i64 @"scheme.base:__init_49"() {
entry:
  %t997 = call i64 @rt_alloc_words(i64 1)
  %t998 = inttoptr i64 %t997 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_242" to i64), ptr %t998
  %t999 = or i64 %t997, 4
  %t1000 = call i64 @rt_root(i64 %t999)
  store i64 %t1000, ptr @"scheme.base:char<?"
  ret i64 %t1000
}

define i64 @"scheme.base:__init_50"() {
entry:
  %t1024 = call i64 @rt_alloc_words(i64 1)
  %t1025 = inttoptr i64 %t1024 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_255" to i64), ptr %t1025
  %t1026 = or i64 %t1024, 4
  %t1027 = call i64 @rt_root(i64 %t1026)
  store i64 %t1027, ptr @"scheme.base:char>?"
  ret i64 %t1027
}

define i64 @"scheme.base:__init_51"() {
entry:
  %t1053 = call i64 @rt_alloc_words(i64 1)
  %t1054 = inttoptr i64 %t1053 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_268" to i64), ptr %t1054
  %t1055 = or i64 %t1053, 4
  %t1056 = call i64 @rt_root(i64 %t1055)
  store i64 %t1056, ptr @"scheme.base:char<=?"
  ret i64 %t1056
}

define i64 @"scheme.base:__init_52"() {
entry:
  %t1082 = call i64 @rt_alloc_words(i64 1)
  %t1083 = inttoptr i64 %t1082 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_281" to i64), ptr %t1083
  %t1084 = or i64 %t1082, 4
  %t1085 = call i64 @rt_root(i64 %t1084)
  store i64 %t1085, ptr @"scheme.base:char>=?"
  ret i64 %t1085
}

define i64 @"scheme.base:__init_53"() {
entry:
  %t1118 = call i64 @rt_alloc_words(i64 1)
  %t1119 = inttoptr i64 %t1118 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_293" to i64), ptr %t1119
  %t1120 = or i64 %t1118, 4
  %t1121 = call i64 @rt_root(i64 %t1120)
  store i64 %t1121, ptr @"scheme.base:string->list"
  ret i64 %t1121
}

define i64 @"scheme.base:__init_54"() {
entry:
  %t1138 = call i64 @rt_alloc_words(i64 1)
  %t1139 = inttoptr i64 %t1138 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_305" to i64), ptr %t1139
  %t1140 = or i64 %t1138, 4
  %t1141 = call i64 @rt_root(i64 %t1140)
  store i64 %t1141, ptr @"scheme.base:ns-digits"
  ret i64 %t1141
}

define i64 @"scheme.base:__init_55"() {
entry:
  %t1164 = call i64 @rt_alloc_words(i64 1)
  %t1165 = inttoptr i64 %t1164 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_316" to i64), ptr %t1165
  %t1166 = or i64 %t1164, 4
  %t1167 = call i64 @rt_root(i64 %t1166)
  store i64 %t1167, ptr @"scheme.base:number->string"
  ret i64 %t1167
}

define i64 @"scheme.base:__init_56"() {
entry:
  %t1190 = call i64 @rt_alloc_words(i64 1)
  %t1191 = inttoptr i64 %t1190 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_320" to i64), ptr %t1191
  %t1192 = or i64 %t1190, 4
  %t1193 = call i64 @rt_root(i64 %t1192)
  store i64 %t1193, ptr @"scheme.base:error"
  ret i64 %t1193
}

define i64 @"scheme.base:__init_57"() {
entry:
  %t1196 = call i64 @rt_alloc_words(i64 1)
  %t1197 = inttoptr i64 %t1196 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_323" to i64), ptr %t1197
  %t1198 = or i64 %t1196, 4
  %t1199 = call i64 @rt_root(i64 %t1198)
  store i64 %t1199, ptr @"scheme.base:raise"
  ret i64 %t1199
}

define i64 @"scheme.base:__init_58"() {
entry:
  %t1202 = call i64 @rt_alloc_words(i64 1)
  %t1203 = inttoptr i64 %t1202 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_326" to i64), ptr %t1203
  %t1204 = or i64 %t1202, 4
  %t1205 = call i64 @rt_root(i64 %t1204)
  store i64 %t1205, ptr @"scheme.base:error-object?"
  ret i64 %t1205
}

define i64 @"scheme.base:__init_59"() {
entry:
  %t1208 = call i64 @rt_alloc_words(i64 1)
  %t1209 = inttoptr i64 %t1208 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_329" to i64), ptr %t1209
  %t1210 = or i64 %t1208, 4
  %t1211 = call i64 @rt_root(i64 %t1210)
  store i64 %t1211, ptr @"scheme.base:error-object-message"
  ret i64 %t1211
}

define i64 @"scheme.base:__init_60"() {
entry:
  %t1214 = call i64 @rt_alloc_words(i64 1)
  %t1215 = inttoptr i64 %t1214 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_332" to i64), ptr %t1215
  %t1216 = or i64 %t1214, 4
  %t1217 = call i64 @rt_root(i64 %t1216)
  store i64 %t1217, ptr @"scheme.base:error-object-irritants"
  ret i64 %t1217
}

define i64 @"scheme.base:__init_61"() {
entry:
  %t1260 = call i64 @rt_alloc_words(i64 1)
  %t1261 = inttoptr i64 %t1260 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_339" to i64), ptr %t1261
  %t1262 = or i64 %t1260, 4
  %t1263 = call i64 @rt_root(i64 %t1262)
  store i64 %t1263, ptr @"scheme.base:list->vector"
  ret i64 %t1263
}

define i64 @"scheme.base:__init_62"() {
entry:
  %t1282 = call i64 @rt_alloc_words(i64 1)
  %t1283 = inttoptr i64 %t1282 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_344" to i64), ptr %t1283
  %t1284 = or i64 %t1282, 4
  %t1285 = call i64 @rt_root(i64 %t1284)
  store i64 %t1285, ptr @"scheme.base:vector"
  ret i64 %t1285
}

define i64 @"scheme.base:__init_63"() {
entry:
  %t1295 = call i64 @rt_alloc_words(i64 1)
  %t1296 = inttoptr i64 %t1295 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_370" to i64), ptr %t1296
  %t1297 = or i64 %t1295, 4
  %t1298 = call i64 @rt_root(i64 %t1297)
  store i64 %t1298, ptr @"scheme.base:rd-ws?"
  ret i64 %t1298
}

define i64 @"scheme.base:__init_64"() {
entry:
  %t1304 = call i64 @rt_alloc_words(i64 1)
  %t1305 = inttoptr i64 %t1304 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_382" to i64), ptr %t1305
  %t1306 = or i64 %t1304, 4
  %t1307 = call i64 @rt_root(i64 %t1306)
  store i64 %t1307, ptr @"scheme.base:rd-digit?"
  ret i64 %t1307
}

define i64 @"scheme.base:__init_65"() {
entry:
  %t1328 = call i64 @rt_alloc_words(i64 1)
  %t1329 = inttoptr i64 %t1328 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_422" to i64), ptr %t1329
  %t1330 = or i64 %t1328, 4
  %t1331 = call i64 @rt_root(i64 %t1330)
  store i64 %t1331, ptr @"scheme.base:rd-delim?"
  ret i64 %t1331
}

define i64 @"scheme.base:__init_66"() {
entry:
  %t1347 = call i64 @rt_alloc_words(i64 1)
  %t1348 = inttoptr i64 %t1347 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_435" to i64), ptr %t1348
  %t1349 = or i64 %t1347, 4
  %t1350 = call i64 @rt_root(i64 %t1349)
  store i64 %t1350, ptr @"scheme.base:rd-skip-line"
  ret i64 %t1350
}

define i64 @"scheme.base:__init_67"() {
entry:
  %t1385 = call i64 @rt_alloc_words(i64 1)
  %t1386 = inttoptr i64 %t1385 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_449" to i64), ptr %t1386
  %t1387 = or i64 %t1385, 4
  %t1388 = call i64 @rt_root(i64 %t1387)
  store i64 %t1388, ptr @"scheme.base:rd-skip-ws"
  ret i64 %t1388
}

define i64 @"scheme.base:__init_68"() {
entry:
  %t1407 = call i64 @rt_alloc_words(i64 1)
  %t1408 = inttoptr i64 %t1407 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_458" to i64), ptr %t1408
  %t1409 = or i64 %t1407, 4
  %t1410 = call i64 @rt_root(i64 %t1409)
  store i64 %t1410, ptr @"scheme.base:rd-token-end"
  ret i64 %t1410
}

define i64 @"scheme.base:__init_69"() {
entry:
  %t1429 = call i64 @rt_alloc_words(i64 1)
  %t1430 = inttoptr i64 %t1429 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_467" to i64), ptr %t1430
  %t1431 = or i64 %t1429, 4
  %t1432 = call i64 @rt_root(i64 %t1431)
  store i64 %t1432, ptr @"scheme.base:rd-all-digits?"
  ret i64 %t1432
}

define i64 @"scheme.base:__init_70"() {
entry:
  %t1466 = call i64 @rt_alloc_words(i64 1)
  %t1467 = inttoptr i64 %t1466 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_490" to i64), ptr %t1467
  %t1468 = or i64 %t1466, 4
  %t1469 = call i64 @rt_root(i64 %t1468)
  store i64 %t1469, ptr @"scheme.base:rd-numeric?"
  ret i64 %t1469
}

define i64 @"scheme.base:__init_71"() {
entry:
  %t1485 = call i64 @rt_alloc_words(i64 1)
  %t1486 = inttoptr i64 %t1485 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_500" to i64), ptr %t1486
  %t1487 = or i64 %t1485, 4
  %t1488 = call i64 @rt_root(i64 %t1487)
  store i64 %t1488, ptr @"scheme.base:rd-digits"
  ret i64 %t1488
}

define i64 @"scheme.base:__init_72"() {
entry:
  %t1516 = call i64 @rt_alloc_words(i64 1)
  %t1517 = inttoptr i64 %t1516 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_513" to i64), ptr %t1517
  %t1518 = or i64 %t1516, 4
  %t1519 = call i64 @rt_root(i64 %t1518)
  store i64 %t1519, ptr @"scheme.base:rd-parse-int"
  ret i64 %t1519
}

define i64 @"scheme.base:__init_73"() {
entry:
  %t1544 = call i64 @rt_alloc_words(i64 1)
  %t1545 = inttoptr i64 %t1544 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_520" to i64), ptr %t1545
  %t1546 = or i64 %t1544, 4
  %t1547 = call i64 @rt_root(i64 %t1546)
  store i64 %t1547, ptr @"scheme.base:rd-atom"
  ret i64 %t1547
}

define i64 @"scheme.base:__init_74"() {
entry:
  %t1568 = call i64 @rt_alloc_words(i64 1)
  %t1569 = inttoptr i64 %t1568 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_548" to i64), ptr %t1569
  %t1570 = or i64 %t1568, 4
  %t1571 = call i64 @rt_root(i64 %t1570)
  store i64 %t1571, ptr @"scheme.base:rd-hex-digit"
  ret i64 %t1571
}

define i64 @"scheme.base:__init_75"() {
entry:
  %t1598 = call i64 @rt_alloc_words(i64 1)
  %t1599 = inttoptr i64 %t1598 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_562" to i64), ptr %t1599
  %t1600 = or i64 %t1598, 4
  %t1601 = call i64 @rt_root(i64 %t1600)
  store i64 %t1601, ptr @"scheme.base:rd-hex"
  ret i64 %t1601
}

define i64 @"scheme.base:__init_76"() {
entry:
  %t1613 = call i64 @rt_alloc_words(i64 1)
  %t1614 = inttoptr i64 %t1613 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_578" to i64), ptr %t1614
  %t1615 = or i64 %t1613, 4
  %t1616 = call i64 @rt_root(i64 %t1615)
  store i64 %t1616, ptr @"scheme.base:rd-str-esc"
  ret i64 %t1616
}

define i64 @"scheme.base:__init_77"() {
entry:
  %t1728 = call i64 @rt_alloc_words(i64 1)
  %t1729 = inttoptr i64 %t1728 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_606" to i64), ptr %t1729
  %t1730 = or i64 %t1728, 4
  %t1731 = call i64 @rt_root(i64 %t1730)
  store i64 %t1731, ptr @"scheme.base:rd-string"
  ret i64 %t1731
}

define i64 @"scheme.base:__init_78"() {
entry:
  %t1778 = call i64 @rt_alloc_words(i64 1)
  %t1779 = inttoptr i64 %t1778 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_632" to i64), ptr %t1779
  %t1780 = or i64 %t1778, 4
  %t1781 = call i64 @rt_root(i64 %t1780)
  store i64 %t1781, ptr @"scheme.base:rd-hash"
  ret i64 %t1781
}

define i64 @"scheme.base:__init_79"() {
entry:
  %t1820 = call i64 @rt_alloc_words(i64 1)
  %t1821 = inttoptr i64 %t1820 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_635" to i64), ptr %t1821
  %t1822 = or i64 %t1820, 4
  %t1823 = call i64 @rt_root(i64 %t1822)
  store i64 %t1823, ptr @"scheme.base:rd-char-name"
  ret i64 %t1823
}

define i64 @"scheme.base:__init_80"() {
entry:
  %t1846 = call i64 @rt_alloc_words(i64 1)
  %t1847 = inttoptr i64 %t1846 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_647" to i64), ptr %t1847
  %t1848 = or i64 %t1846, 4
  %t1849 = call i64 @rt_root(i64 %t1848)
  store i64 %t1849, ptr @"scheme.base:rd-char"
  ret i64 %t1849
}

define i64 @"scheme.base:__init_81"() {
entry:
  %t1873 = call i64 @rt_alloc_words(i64 1)
  %t1874 = inttoptr i64 %t1873 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_654" to i64), ptr %t1874
  %t1875 = or i64 %t1873, 4
  %t1876 = call i64 @rt_root(i64 %t1875)
  store i64 %t1876, ptr @"scheme.base:rd-quote"
  ret i64 %t1876
}

define i64 @"scheme.base:__init_82"() {
entry:
  %t1900 = call i64 @rt_alloc_words(i64 1)
  %t1901 = inttoptr i64 %t1900 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_661" to i64), ptr %t1901
  %t1902 = or i64 %t1900, 4
  %t1903 = call i64 @rt_root(i64 %t1902)
  store i64 %t1903, ptr @"scheme.base:rd-quasi"
  ret i64 %t1903
}

define i64 @"scheme.base:__init_83"() {
entry:
  %t1957 = call i64 @rt_alloc_words(i64 1)
  %t1958 = inttoptr i64 %t1957 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_678" to i64), ptr %t1958
  %t1959 = or i64 %t1957, 4
  %t1960 = call i64 @rt_root(i64 %t1959)
  store i64 %t1960, ptr @"scheme.base:rd-unquote"
  ret i64 %t1960
}

define i64 @"scheme.base:__init_84"() {
entry:
  %t1975 = call i64 @rt_alloc_words(i64 1)
  %t1976 = inttoptr i64 %t1975 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_691" to i64), ptr %t1976
  %t1977 = or i64 %t1975, 4
  %t1978 = call i64 @rt_root(i64 %t1977)
  store i64 %t1978, ptr @"scheme.base:rd-dot?"
  ret i64 %t1978
}

define i64 @"scheme.base:__init_85"() {
entry:
  %t1991 = call i64 @rt_alloc_words(i64 1)
  %t1992 = inttoptr i64 %t1991 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_695" to i64), ptr %t1992
  %t1993 = or i64 %t1991, 4
  %t1994 = call i64 @rt_root(i64 %t1993)
  store i64 %t1994, ptr @"scheme.base:rd-append-reverse"
  ret i64 %t1994
}

define i64 @"scheme.base:__init_86"() {
entry:
  %t2077 = call i64 @rt_alloc_words(i64 1)
  %t2078 = inttoptr i64 %t2077 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_720" to i64), ptr %t2078
  %t2079 = or i64 %t2077, 4
  %t2080 = call i64 @rt_root(i64 %t2079)
  store i64 %t2080, ptr @"scheme.base:rd-list"
  ret i64 %t2080
}

define i64 @"scheme.base:__init_87"() {
entry:
  %t2153 = call i64 @rt_alloc_words(i64 1)
  %t2154 = inttoptr i64 %t2153 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_754" to i64), ptr %t2154
  %t2155 = or i64 %t2153, 4
  %t2156 = call i64 @rt_root(i64 %t2155)
  store i64 %t2156, ptr @"scheme.base:rd-datum"
  ret i64 %t2156
}

define i64 @"scheme.base:__init_88"() {
entry:
  %t2172 = call i64 @rt_alloc_words(i64 1)
  %t2173 = inttoptr i64 %t2172 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_758" to i64), ptr %t2173
  %t2174 = or i64 %t2172, 4
  %t2175 = call i64 @rt_root(i64 %t2174)
  store i64 %t2175, ptr @"scheme.base:read-from-string"
  ret i64 %t2175
}

define i64 @"scheme.base:__init_89"() {
entry:
  %t2248 = call i64 @rt_alloc_words(i64 1)
  %t2249 = inttoptr i64 %t2248 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_770" to i64), ptr %t2249
  %t2250 = or i64 %t2248, 4
  %t2251 = call i64 @rt_root(i64 %t2250)
  store i64 %t2251, ptr @"scheme.base:read-all-from-string"
  ret i64 %t2251
}

define i64 @"scheme.base:__init"() {
entry:
  %f = load i64, ptr @"scheme.base:__inited"
  %c = icmp ne i64 %f, 0
  br i1 %c, label %already, label %run
already:
  ret i64 2
run:
  store i64 8, ptr @"scheme.base:__inited"
  call i64 @"scheme.base:__init_1"()
  call i64 @"scheme.base:__init_2"()
  call i64 @"scheme.base:__init_3"()
  call i64 @"scheme.base:__init_4"()
  call i64 @"scheme.base:__init_5"()
  call i64 @"scheme.base:__init_6"()
  call i64 @"scheme.base:__init_7"()
  call i64 @"scheme.base:__init_8"()
  call i64 @"scheme.base:__init_9"()
  call i64 @"scheme.base:__init_10"()
  call i64 @"scheme.base:__init_11"()
  call i64 @"scheme.base:__init_12"()
  call i64 @"scheme.base:__init_13"()
  call i64 @"scheme.base:__init_14"()
  call i64 @"scheme.base:__init_15"()
  call i64 @"scheme.base:__init_16"()
  call i64 @"scheme.base:__init_17"()
  call i64 @"scheme.base:__init_18"()
  call i64 @"scheme.base:__init_19"()
  call i64 @"scheme.base:__init_20"()
  call i64 @"scheme.base:__init_21"()
  call i64 @"scheme.base:__init_22"()
  call i64 @"scheme.base:__init_23"()
  call i64 @"scheme.base:__init_24"()
  call i64 @"scheme.base:__init_25"()
  call i64 @"scheme.base:__init_26"()
  call i64 @"scheme.base:__init_27"()
  call i64 @"scheme.base:__init_28"()
  call i64 @"scheme.base:__init_29"()
  call i64 @"scheme.base:__init_30"()
  call i64 @"scheme.base:__init_31"()
  call i64 @"scheme.base:__init_32"()
  call i64 @"scheme.base:__init_33"()
  call i64 @"scheme.base:__init_34"()
  call i64 @"scheme.base:__init_35"()
  call i64 @"scheme.base:__init_36"()
  call i64 @"scheme.base:__init_37"()
  call i64 @"scheme.base:__init_38"()
  call i64 @"scheme.base:__init_39"()
  call i64 @"scheme.base:__init_40"()
  call i64 @"scheme.base:__init_41"()
  call i64 @"scheme.base:__init_42"()
  call i64 @"scheme.base:__init_43"()
  call i64 @"scheme.base:__init_44"()
  call i64 @"scheme.base:__init_45"()
  call i64 @"scheme.base:__init_46"()
  call i64 @"scheme.base:__init_47"()
  call i64 @"scheme.base:__init_48"()
  call i64 @"scheme.base:__init_49"()
  call i64 @"scheme.base:__init_50"()
  call i64 @"scheme.base:__init_51"()
  call i64 @"scheme.base:__init_52"()
  call i64 @"scheme.base:__init_53"()
  call i64 @"scheme.base:__init_54"()
  call i64 @"scheme.base:__init_55"()
  call i64 @"scheme.base:__init_56"()
  call i64 @"scheme.base:__init_57"()
  call i64 @"scheme.base:__init_58"()
  call i64 @"scheme.base:__init_59"()
  call i64 @"scheme.base:__init_60"()
  call i64 @"scheme.base:__init_61"()
  call i64 @"scheme.base:__init_62"()
  call i64 @"scheme.base:__init_63"()
  call i64 @"scheme.base:__init_64"()
  call i64 @"scheme.base:__init_65"()
  call i64 @"scheme.base:__init_66"()
  call i64 @"scheme.base:__init_67"()
  call i64 @"scheme.base:__init_68"()
  call i64 @"scheme.base:__init_69"()
  call i64 @"scheme.base:__init_70"()
  call i64 @"scheme.base:__init_71"()
  call i64 @"scheme.base:__init_72"()
  call i64 @"scheme.base:__init_73"()
  call i64 @"scheme.base:__init_74"()
  call i64 @"scheme.base:__init_75"()
  call i64 @"scheme.base:__init_76"()
  call i64 @"scheme.base:__init_77"()
  call i64 @"scheme.base:__init_78"()
  call i64 @"scheme.base:__init_79"()
  call i64 @"scheme.base:__init_80"()
  call i64 @"scheme.base:__init_81"()
  call i64 @"scheme.base:__init_82"()
  call i64 @"scheme.base:__init_83"()
  call i64 @"scheme.base:__init_84"()
  call i64 @"scheme.base:__init_85"()
  call i64 @"scheme.base:__init_86"()
  call i64 @"scheme.base:__init_87"()
  call i64 @"scheme.base:__init_88"()
  call i64 @"scheme.base:__init_89"()
  ret i64 2
}
define internal i64 @__apply0(i64 %clos) {
entry:
  %b = and i64 %clos, -8
  %bp = inttoptr i64 %b to ptr
  %code = load i64, ptr %bp
  %fp = inttoptr i64 %code to ptr
  %r = call fastcc i64 %fp(i64 %clos, i64 0, i64 undef, i64 undef, i64 undef, i64 undef, i64 undef, i64 undef, i64 undef, i64 undef, ptr null)
  ret i64 %r
}

