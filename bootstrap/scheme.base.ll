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
declare i64 @rt_div(i64, i64)
declare i64 @rt_quotient(i64, i64)
declare i64 @rt_remainder(i64, i64)
declare i64 @rt_modulo(i64, i64)
declare i64 @rt_num_eq(i64, i64)
declare i64 @rt_lt(i64, i64)
declare i64 @rt_flonum_lit(ptr)
declare i64 @rt_make_flonum(double)
declare i64 @rt_string_to_flonum(i64)
declare i64 @rt_flonum_to_string(i64)
declare i64 @rt_flonum_p(i64)
declare i64 @rt_number_p(i64)
declare i64 @rt_real_p(i64)
declare i64 @rt_inexact_p(i64)
declare i64 @rt_exact_to_inexact(i64)
declare i64 @rt_inexact_to_exact(i64)
declare i64 @rt_write_char(i64)
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
declare i64 @rt_make_bytevector(i64, i64)
declare i64 @rt_bytevector_u8_ref(i64, i64)
declare i64 @rt_bytevector_u8_set(i64, i64, i64)
declare i64 @rt_bytevector_length(i64)
declare i64 @rt_bytevector_p(i64)
declare i64 @rt_hash(i64)
declare i64 @rt_make_hash_table(i64)
declare i64 @rt_hash_table_p(i64)
declare i64 @rt_hash_table_spine(i64)
declare i64 @rt_make_record_type(i64)
declare i64 @rt_make_record(i64, i64)
declare i64 @rt_record_ref(i64, i64)
declare i64 @rt_record_set(i64, i64, i64)
declare i64 @rt_record_of_type_p(i64, i64)
declare i64 @rt_record_p(i64)
declare i64 @rt_list_to_mv(i64)
declare i64 @rt_mv_p(i64)
declare i64 @rt_mv_to_list(i64)
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
declare i64 @rt_write_val(i64)
declare i64 @rt_newline()
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
@.str.lit.3 = private unnamed_addr constant [30 x i8] c"hash-table-ref: key not found\00"
@.str.lit.4 = private unnamed_addr constant [6 x i8] c"space\00"
@.str.lit.5 = private unnamed_addr constant [8 x i8] c"newline\00"
@.str.lit.6 = private unnamed_addr constant [4 x i8] c"tab\00"
@.str.lit.7 = private unnamed_addr constant [7 x i8] c"return\00"
@.str.lit.8 = private unnamed_addr constant [4 x i8] c"nul\00"
@.str.lit.9 = private unnamed_addr constant [5 x i8] c"null\00"
@.str.lit.10 = private unnamed_addr constant [7 x i8] c"delete\00"
@.str.lit.11 = private unnamed_addr constant [8 x i8] c"altmode\00"
@.str.lit.12 = private unnamed_addr constant [4 x i8] c"esc\00"
@.str.sym.13 = private unnamed_addr constant [6 x i8] c"quote\00"
@.str.sym.14 = private unnamed_addr constant [11 x i8] c"quasiquote\00"
@.str.sym.15 = private unnamed_addr constant [17 x i8] c"unquote-splicing\00"
@.str.sym.16 = private unnamed_addr constant [8 x i8] c"unquote\00"
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
@"scheme.base:list->bytevector" = global i64 0
@"scheme.base:bytevector" = global i64 0
@"scheme.base:values" = global i64 0
@"scheme.base:call-with-values" = global i64 0
@"scheme.base:%ht-initial-buckets" = global i64 0
@"scheme.base:%ht-load-factor" = global i64 0
@"scheme.base:make-hash-table" = global i64 0
@"scheme.base:hash-table?" = global i64 0
@"scheme.base:%ht-count" = global i64 0
@"scheme.base:%ht-buckets" = global i64 0
@"scheme.base:%ht-set-count!" = global i64 0
@"scheme.base:%ht-set-buckets!" = global i64 0
@"scheme.base:%ht-index" = global i64 0
@"scheme.base:%ht-assoc" = global i64 0
@"scheme.base:%ht-remove" = global i64 0
@"scheme.base:hash-table-ref/default" = global i64 0
@"scheme.base:hash-table-contains?" = global i64 0
@"scheme.base:hash-table-ref" = global i64 0
@"scheme.base:hash-table-set!" = global i64 0
@"scheme.base:hash-table-delete!" = global i64 0
@"scheme.base:%ht-grow!" = global i64 0
@"scheme.base:hash-table-size" = global i64 0
@"scheme.base:%ht-fold-buckets" = global i64 0
@"scheme.base:hash-table->alist" = global i64 0
@"scheme.base:hash-table-keys" = global i64 0
@"scheme.base:hash-table-values" = global i64 0
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
@"scheme.base:rd-dotchar?" = global i64 0
@"scheme.base:rd-exp-char?" = global i64 0
@"scheme.base:rd-sign-char?" = global i64 0
@"scheme.base:rd-scan-digits" = global i64 0
@"scheme.base:rd-flonum?" = global i64 0
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
  %t145 = or i64 %a1, 8
  %t146 = and i64 %t145, 7
  %t147 = icmp eq i64 %t146, 0
  br i1 %t147, label %fixfast31, label %fixslow32
fixfast31:
  %t148 = add i64 %a1, 8
  br label %fixmerge33
fixslow32:
  %t149 = call i64 @rt_add(i64 %a1, i64 8)
  br label %fixmerge33
fixmerge33:
  %t150 = phi i64 [ %t148, %fixfast31 ], [ %t149, %fixslow32 ]
  %t151 = musttail call fastcc i64 @"scheme.base:code_45"(i64 %self, i64 2, i64 %t144, i64 %t150, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t151
}

define fastcc i64 @"scheme.base:code_43"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t152 = icmp eq i64 %argc, 1
  br i1 %t152, label %argok35, label %arityerr34
arityerr34:
  call void @rt_arity_error(i64 1, i64 %argc)
  unreachable
argok35:
  %t153 = call i64 @rt_alloc_words(i64 2)
  %t154 = inttoptr i64 %t153 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_45" to i64), ptr %t154
  %t155 = or i64 %t153, 4
  %t156 = getelementptr i64, ptr %t154, i64 1
  store i64 %t155, ptr %t156
  %t157 = and i64 %t155, -8
  %t158 = inttoptr i64 %t157 to ptr
  %t159 = load i64, ptr %t158
  %t160 = inttoptr i64 %t159 to ptr
  %t161 = musttail call fastcc i64 %t160(i64 %t155, i64 2, i64 %a0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t161
}

define fastcc i64 @"scheme.base:code_53"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t166 = icmp eq i64 %argc, 2
  br i1 %t166, label %argok37, label %arityerr36
arityerr36:
  call void @rt_arity_error(i64 2, i64 %argc)
  unreachable
argok37:
  %t167 = call i64 @rt_null_p(i64 %a0)
  %t168 = icmp ne i64 %t167, 1
  br i1 %t168, label %then38, label %else39
then38:
  ret i64 %a1
else39:
  %t169 = call i64 @rt_cdr(i64 %a0)
  %t170 = call i64 @rt_car(i64 %a0)
  %t171 = call i64 @rt_cons(i64 %t170, i64 %a1)
  %t172 = musttail call fastcc i64 @"scheme.base:code_53"(i64 %self, i64 2, i64 %t169, i64 %t171, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t172
}

define fastcc i64 @"scheme.base:code_51"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t173 = icmp eq i64 %argc, 1
  br i1 %t173, label %argok41, label %arityerr40
arityerr40:
  call void @rt_arity_error(i64 1, i64 %argc)
  unreachable
argok41:
  %t174 = call i64 @rt_alloc_words(i64 2)
  %t175 = inttoptr i64 %t174 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_53" to i64), ptr %t175
  %t176 = or i64 %t174, 4
  %t177 = getelementptr i64, ptr %t175, i64 1
  store i64 %t176, ptr %t177
  %t178 = and i64 %t176, -8
  %t179 = inttoptr i64 %t178 to ptr
  %t180 = load i64, ptr %t179
  %t181 = inttoptr i64 %t180 to ptr
  %t182 = musttail call fastcc i64 %t181(i64 %t176, i64 2, i64 %a0, i64 2, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t182
}

define fastcc i64 @"scheme.base:code_57"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t187 = icmp eq i64 %argc, 2
  br i1 %t187, label %argok43, label %arityerr42
arityerr42:
  call void @rt_arity_error(i64 2, i64 %argc)
  unreachable
argok43:
  %t188 = call i64 @rt_null_p(i64 %a0)
  %t189 = icmp ne i64 %t188, 1
  br i1 %t189, label %then44, label %else45
then44:
  ret i64 %a1
else45:
  %t190 = call i64 @rt_car(i64 %a0)
  %t191 = call i64 @rt_cdr(i64 %a0)
  %t192 = load i64, ptr @"scheme.base:%append2"
  %t193 = and i64 %t192, -8
  %t194 = inttoptr i64 %t193 to ptr
  %t195 = load i64, ptr %t194
  %t196 = inttoptr i64 %t195 to ptr
  %t197 = call fastcc i64%t196(i64 %t192, i64 2, i64 %t191, i64 %a1, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t198 = call i64 @rt_cons(i64 %t190, i64 %t197)
  ret i64 %t198
}

define fastcc i64 @"scheme.base:code_60"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t203 = icmp sge i64 %argc, 0
  br i1 %t203, label %argok47, label %arityerr46
arityerr46:
  call void @rt_arity_error(i64 0, i64 %argc)
  unreachable
argok47:
  %t204 = call i64 @rt_alloc_words(i64 8)
  %t205 = inttoptr i64 %t204 to ptr
  %t206 = getelementptr i64, ptr %t205, i64 0
  store i64 %a0, ptr %t206
  %t207 = getelementptr i64, ptr %t205, i64 1
  store i64 %a1, ptr %t207
  %t208 = getelementptr i64, ptr %t205, i64 2
  store i64 %a2, ptr %t208
  %t209 = getelementptr i64, ptr %t205, i64 3
  store i64 %a3, ptr %t209
  %t210 = getelementptr i64, ptr %t205, i64 4
  store i64 %a4, ptr %t210
  %t211 = getelementptr i64, ptr %t205, i64 5
  store i64 %a5, ptr %t211
  %t212 = getelementptr i64, ptr %t205, i64 6
  store i64 %a6, ptr %t212
  %t213 = getelementptr i64, ptr %t205, i64 7
  store i64 %a7, ptr %t213
  %t214 = call i64 @rt_build_rest(i64 %argc, i64 0, i64 8, ptr %t205, ptr %overflow)
  %t215 = call i64 @rt_null_p(i64 %t214)
  %t216 = icmp ne i64 %t215, 1
  br i1 %t216, label %then48, label %else49
then48:
  ret i64 2
else49:
  %t217 = call i64 @rt_cdr(i64 %t214)
  %t218 = call i64 @rt_null_p(i64 %t217)
  %t219 = icmp ne i64 %t218, 1
  br i1 %t219, label %then50, label %else51
then50:
  %t220 = call i64 @rt_car(i64 %t214)
  ret i64 %t220
else51:
  %t221 = call i64 @rt_car(i64 %t214)
  %t222 = call i64 @rt_cdr(i64 %t214)
  %t223 = load i64, ptr @"scheme.base:append"
  %t224 = and i64 %t223, -8
  %t225 = inttoptr i64 %t224 to ptr
  %t226 = load i64, ptr %t225
  %t227 = inttoptr i64 %t226 to ptr
  %t228 = call i64 @rt_list_length(i64 %t222)
  %t229 = add i64 0, %t228
  %t230 = call ptr @rt_apply_argv(i64 0, ptr null, i64 %t222, i64 8)
  %t242 = getelementptr i64, ptr %t230, i64 0
  %t234 = load i64, ptr %t242
  %t243 = getelementptr i64, ptr %t230, i64 1
  %t235 = load i64, ptr %t243
  %t244 = getelementptr i64, ptr %t230, i64 2
  %t236 = load i64, ptr %t244
  %t245 = getelementptr i64, ptr %t230, i64 3
  %t237 = load i64, ptr %t245
  %t246 = getelementptr i64, ptr %t230, i64 4
  %t238 = load i64, ptr %t246
  %t247 = getelementptr i64, ptr %t230, i64 5
  %t239 = load i64, ptr %t247
  %t248 = getelementptr i64, ptr %t230, i64 6
  %t240 = load i64, ptr %t248
  %t249 = getelementptr i64, ptr %t230, i64 7
  %t241 = load i64, ptr %t249
  %t231 = icmp sgt i64 %t229, 8
  %t232 = getelementptr i64, ptr %t230, i64 8
  %t233 = select i1 %t231, ptr %t232, ptr null
  %t250 = call fastcc i64%t227(i64 %t223, i64 %t229, i64 %t234, i64 %t235, i64 %t236, i64 %t237, i64 %t238, i64 %t239, i64 %t240, i64 %t241, ptr %t233)
  %t251 = load i64, ptr @"scheme.base:%append2"
  %t252 = and i64 %t251, -8
  %t253 = inttoptr i64 %t252 to ptr
  %t254 = load i64, ptr %t253
  %t255 = inttoptr i64 %t254 to ptr
  %t256 = musttail call fastcc i64 %t255(i64 %t251, i64 2, i64 %t221, i64 %t250, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t256
}

define fastcc i64 @"scheme.base:code_64"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t261 = icmp eq i64 %argc, 2
  br i1 %t261, label %argok53, label %arityerr52
arityerr52:
  call void @rt_arity_error(i64 2, i64 %argc)
  unreachable
argok53:
  %t262 = call i64 @rt_null_p(i64 %a1)
  %t263 = icmp ne i64 %t262, 1
  br i1 %t263, label %then54, label %else55
then54:
  ret i64 2
else55:
  %t264 = call i64 @rt_car(i64 %a1)
  %t265 = and i64 %a0, -8
  %t266 = inttoptr i64 %t265 to ptr
  %t267 = load i64, ptr %t266
  %t268 = inttoptr i64 %t267 to ptr
  %t269 = call fastcc i64%t268(i64 %a0, i64 1, i64 %t264, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t270 = call i64 @rt_cdr(i64 %a1)
  %t271 = load i64, ptr @"scheme.base:%map1"
  %t272 = and i64 %t271, -8
  %t273 = inttoptr i64 %t272 to ptr
  %t274 = load i64, ptr %t273
  %t275 = inttoptr i64 %t274 to ptr
  %t276 = call fastcc i64%t275(i64 %t271, i64 2, i64 %a0, i64 %t270, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t277 = call i64 @rt_cons(i64 %t269, i64 %t276)
  ret i64 %t277
}

define fastcc i64 @"scheme.base:code_67"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t282 = icmp eq i64 %argc, 1
  br i1 %t282, label %argok57, label %arityerr56
arityerr56:
  call void @rt_arity_error(i64 1, i64 %argc)
  unreachable
argok57:
  %t283 = call i64 @rt_null_p(i64 %a0)
  %t284 = icmp ne i64 %t283, 1
  br i1 %t284, label %then58, label %else59
then58:
  ret i64 1
else59:
  %t285 = call i64 @rt_car(i64 %a0)
  %t286 = call i64 @rt_null_p(i64 %t285)
  %t287 = icmp ne i64 %t286, 1
  br i1 %t287, label %then60, label %else61
then60:
  ret i64 257
else61:
  %t288 = call i64 @rt_cdr(i64 %a0)
  %t289 = load i64, ptr @"scheme.base:%any-null?"
  %t290 = and i64 %t289, -8
  %t291 = inttoptr i64 %t290 to ptr
  %t292 = load i64, ptr %t291
  %t293 = inttoptr i64 %t292 to ptr
  %t294 = musttail call fastcc i64 %t293(i64 %t289, i64 1, i64 %t288, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t294
}

define fastcc i64 @"scheme.base:code_75"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t299 = icmp eq i64 %argc, 1
  br i1 %t299, label %argok63, label %arityerr62
arityerr62:
  call void @rt_arity_error(i64 1, i64 %argc)
  unreachable
argok63:
  %t300 = call i64 @rt_car(i64 %a0)
  ret i64 %t300
}

define fastcc i64 @"scheme.base:code_77"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t301 = icmp eq i64 %argc, 1
  br i1 %t301, label %argok65, label %arityerr64
arityerr64:
  call void @rt_arity_error(i64 1, i64 %argc)
  unreachable
argok65:
  %t302 = call i64 @rt_cdr(i64 %a0)
  ret i64 %t302
}

define fastcc i64 @"scheme.base:code_73"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t303 = icmp eq i64 %argc, 2
  br i1 %t303, label %argok67, label %arityerr66
arityerr66:
  call void @rt_arity_error(i64 2, i64 %argc)
  unreachable
argok67:
  %t304 = load i64, ptr @"scheme.base:%any-null?"
  %t305 = and i64 %t304, -8
  %t306 = inttoptr i64 %t305 to ptr
  %t307 = load i64, ptr %t306
  %t308 = inttoptr i64 %t307 to ptr
  %t309 = call fastcc i64%t308(i64 %t304, i64 1, i64 %a1, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t310 = icmp ne i64 %t309, 1
  br i1 %t310, label %then68, label %else69
then68:
  ret i64 2
else69:
  %t311 = call i64 @rt_alloc_words(i64 1)
  %t312 = inttoptr i64 %t311 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_75" to i64), ptr %t312
  %t313 = or i64 %t311, 4
  %t314 = load i64, ptr @"scheme.base:%map1"
  %t315 = and i64 %t314, -8
  %t316 = inttoptr i64 %t315 to ptr
  %t317 = load i64, ptr %t316
  %t318 = inttoptr i64 %t317 to ptr
  %t319 = call fastcc i64%t318(i64 %t314, i64 2, i64 %t313, i64 %a1, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t320 = and i64 %a0, -8
  %t321 = inttoptr i64 %t320 to ptr
  %t322 = load i64, ptr %t321
  %t323 = inttoptr i64 %t322 to ptr
  %t324 = call i64 @rt_list_length(i64 %t319)
  %t325 = add i64 0, %t324
  %t326 = call ptr @rt_apply_argv(i64 0, ptr null, i64 %t319, i64 8)
  %t338 = getelementptr i64, ptr %t326, i64 0
  %t330 = load i64, ptr %t338
  %t339 = getelementptr i64, ptr %t326, i64 1
  %t331 = load i64, ptr %t339
  %t340 = getelementptr i64, ptr %t326, i64 2
  %t332 = load i64, ptr %t340
  %t341 = getelementptr i64, ptr %t326, i64 3
  %t333 = load i64, ptr %t341
  %t342 = getelementptr i64, ptr %t326, i64 4
  %t334 = load i64, ptr %t342
  %t343 = getelementptr i64, ptr %t326, i64 5
  %t335 = load i64, ptr %t343
  %t344 = getelementptr i64, ptr %t326, i64 6
  %t336 = load i64, ptr %t344
  %t345 = getelementptr i64, ptr %t326, i64 7
  %t337 = load i64, ptr %t345
  %t327 = icmp sgt i64 %t325, 8
  %t328 = getelementptr i64, ptr %t326, i64 8
  %t329 = select i1 %t327, ptr %t328, ptr null
  %t346 = call fastcc i64%t323(i64 %a0, i64 %t325, i64 %t330, i64 %t331, i64 %t332, i64 %t333, i64 %t334, i64 %t335, i64 %t336, i64 %t337, ptr %t329)
  %t347 = call i64 @rt_alloc_words(i64 1)
  %t348 = inttoptr i64 %t347 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_77" to i64), ptr %t348
  %t349 = or i64 %t347, 4
  %t350 = load i64, ptr @"scheme.base:%map1"
  %t351 = and i64 %t350, -8
  %t352 = inttoptr i64 %t351 to ptr
  %t353 = load i64, ptr %t352
  %t354 = inttoptr i64 %t353 to ptr
  %t355 = call fastcc i64%t354(i64 %t350, i64 2, i64 %t349, i64 %a1, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t356 = load i64, ptr @"scheme.base:%mapn"
  %t357 = and i64 %t356, -8
  %t358 = inttoptr i64 %t357 to ptr
  %t359 = load i64, ptr %t358
  %t360 = inttoptr i64 %t359 to ptr
  %t361 = call fastcc i64%t360(i64 %t356, i64 2, i64 %a0, i64 %t355, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t362 = call i64 @rt_cons(i64 %t346, i64 %t361)
  ret i64 %t362
}

define fastcc i64 @"scheme.base:code_82"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t367 = icmp sge i64 %argc, 2
  br i1 %t367, label %argok71, label %arityerr70
arityerr70:
  call void @rt_arity_error(i64 2, i64 %argc)
  unreachable
argok71:
  %t368 = call i64 @rt_alloc_words(i64 8)
  %t369 = inttoptr i64 %t368 to ptr
  %t370 = getelementptr i64, ptr %t369, i64 0
  store i64 %a0, ptr %t370
  %t371 = getelementptr i64, ptr %t369, i64 1
  store i64 %a1, ptr %t371
  %t372 = getelementptr i64, ptr %t369, i64 2
  store i64 %a2, ptr %t372
  %t373 = getelementptr i64, ptr %t369, i64 3
  store i64 %a3, ptr %t373
  %t374 = getelementptr i64, ptr %t369, i64 4
  store i64 %a4, ptr %t374
  %t375 = getelementptr i64, ptr %t369, i64 5
  store i64 %a5, ptr %t375
  %t376 = getelementptr i64, ptr %t369, i64 6
  store i64 %a6, ptr %t376
  %t377 = getelementptr i64, ptr %t369, i64 7
  store i64 %a7, ptr %t377
  %t378 = call i64 @rt_build_rest(i64 %argc, i64 2, i64 8, ptr %t369, ptr %overflow)
  %t379 = call i64 @rt_null_p(i64 %t378)
  %t380 = icmp ne i64 %t379, 1
  br i1 %t380, label %then72, label %else73
then72:
  %t381 = load i64, ptr @"scheme.base:%map1"
  %t382 = and i64 %t381, -8
  %t383 = inttoptr i64 %t382 to ptr
  %t384 = load i64, ptr %t383
  %t385 = inttoptr i64 %t384 to ptr
  %t386 = musttail call fastcc i64 %t385(i64 %t381, i64 2, i64 %a0, i64 %a1, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t386
else73:
  %t387 = call i64 @rt_cons(i64 %a1, i64 %t378)
  %t388 = load i64, ptr @"scheme.base:%mapn"
  %t389 = and i64 %t388, -8
  %t390 = inttoptr i64 %t389 to ptr
  %t391 = load i64, ptr %t390
  %t392 = inttoptr i64 %t391 to ptr
  %t393 = musttail call fastcc i64 %t392(i64 %t388, i64 2, i64 %a0, i64 %t387, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t393
}

define fastcc i64 @"scheme.base:code_90"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t398 = icmp eq i64 %argc, 2
  br i1 %t398, label %argok75, label %arityerr74
arityerr74:
  call void @rt_arity_error(i64 2, i64 %argc)
  unreachable
argok75:
  %t399 = call i64 @rt_null_p(i64 %a1)
  %t400 = icmp ne i64 %t399, 1
  br i1 %t400, label %then76, label %else77
then76:
  ret i64 1
else77:
  %t401 = call i64 @rt_car(i64 %a1)
  %t402 = call i64 @rt_eq_p(i64 %a0, i64 %t401)
  %t403 = icmp ne i64 %t402, 1
  br i1 %t403, label %then78, label %else79
then78:
  ret i64 %a1
else79:
  %t404 = call i64 @rt_cdr(i64 %a1)
  %t405 = load i64, ptr @"scheme.base:memq"
  %t406 = and i64 %t405, -8
  %t407 = inttoptr i64 %t406 to ptr
  %t408 = load i64, ptr %t407
  %t409 = inttoptr i64 %t408 to ptr
  %t410 = musttail call fastcc i64 %t409(i64 %t405, i64 2, i64 %a0, i64 %t404, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t410
}

define fastcc i64 @"scheme.base:code_98"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t415 = icmp eq i64 %argc, 2
  br i1 %t415, label %argok81, label %arityerr80
arityerr80:
  call void @rt_arity_error(i64 2, i64 %argc)
  unreachable
argok81:
  %t416 = call i64 @rt_null_p(i64 %a1)
  %t417 = icmp ne i64 %t416, 1
  br i1 %t417, label %then82, label %else83
then82:
  ret i64 1
else83:
  %t418 = call i64 @rt_car(i64 %a1)
  %t419 = call i64 @rt_eqv_p(i64 %a0, i64 %t418)
  %t420 = icmp ne i64 %t419, 1
  br i1 %t420, label %then84, label %else85
then84:
  ret i64 %a1
else85:
  %t421 = call i64 @rt_cdr(i64 %a1)
  %t422 = load i64, ptr @"scheme.base:memv"
  %t423 = and i64 %t422, -8
  %t424 = inttoptr i64 %t423 to ptr
  %t425 = load i64, ptr %t424
  %t426 = inttoptr i64 %t425 to ptr
  %t427 = musttail call fastcc i64 %t426(i64 %t422, i64 2, i64 %a0, i64 %t421, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t427
}

define fastcc i64 @"scheme.base:code_106"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t432 = icmp eq i64 %argc, 2
  br i1 %t432, label %argok87, label %arityerr86
arityerr86:
  call void @rt_arity_error(i64 2, i64 %argc)
  unreachable
argok87:
  %t433 = call i64 @rt_null_p(i64 %a1)
  %t434 = icmp ne i64 %t433, 1
  br i1 %t434, label %then88, label %else89
then88:
  ret i64 1
else89:
  %t435 = call i64 @rt_car(i64 %a1)
  %t436 = call i64 @rt_car(i64 %t435)
  %t437 = call i64 @rt_eq_p(i64 %a0, i64 %t436)
  %t438 = icmp ne i64 %t437, 1
  br i1 %t438, label %then90, label %else91
then90:
  %t439 = call i64 @rt_car(i64 %a1)
  ret i64 %t439
else91:
  %t440 = call i64 @rt_cdr(i64 %a1)
  %t441 = load i64, ptr @"scheme.base:assq"
  %t442 = and i64 %t441, -8
  %t443 = inttoptr i64 %t442 to ptr
  %t444 = load i64, ptr %t443
  %t445 = inttoptr i64 %t444 to ptr
  %t446 = musttail call fastcc i64 %t445(i64 %t441, i64 2, i64 %a0, i64 %t440, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t446
}

define fastcc i64 @"scheme.base:code_110"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t451 = icmp eq i64 %argc, 2
  br i1 %t451, label %argok93, label %arityerr92
arityerr92:
  call void @rt_arity_error(i64 2, i64 %argc)
  unreachable
argok93:
  %t452 = call i64 @rt_null_p(i64 %a1)
  %t453 = icmp ne i64 %t452, 1
  br i1 %t453, label %then94, label %else95
then94:
  ret i64 1
else95:
  %t454 = call i64 @rt_car(i64 %a1)
  %t455 = call i64 @rt_equal(i64 %a0, i64 %t454)
  %t456 = icmp ne i64 %t455, 1
  br i1 %t456, label %then96, label %else97
then96:
  ret i64 %a1
else97:
  %t457 = call i64 @rt_cdr(i64 %a1)
  %t458 = load i64, ptr @"scheme.base:member"
  %t459 = and i64 %t458, -8
  %t460 = inttoptr i64 %t459 to ptr
  %t461 = load i64, ptr %t460
  %t462 = inttoptr i64 %t461 to ptr
  %t463 = musttail call fastcc i64 %t462(i64 %t458, i64 2, i64 %a0, i64 %t457, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t463
}

define fastcc i64 @"scheme.base:code_114"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t468 = icmp eq i64 %argc, 2
  br i1 %t468, label %argok99, label %arityerr98
arityerr98:
  call void @rt_arity_error(i64 2, i64 %argc)
  unreachable
argok99:
  %t469 = call i64 @rt_null_p(i64 %a1)
  %t470 = icmp ne i64 %t469, 1
  br i1 %t470, label %then100, label %else101
then100:
  ret i64 1
else101:
  %t471 = call i64 @rt_car(i64 %a1)
  %t472 = call i64 @rt_car(i64 %t471)
  %t473 = call i64 @rt_equal(i64 %a0, i64 %t472)
  %t474 = icmp ne i64 %t473, 1
  br i1 %t474, label %then102, label %else103
then102:
  %t475 = call i64 @rt_car(i64 %a1)
  ret i64 %t475
else103:
  %t476 = call i64 @rt_cdr(i64 %a1)
  %t477 = load i64, ptr @"scheme.base:assoc"
  %t478 = and i64 %t477, -8
  %t479 = inttoptr i64 %t478 to ptr
  %t480 = load i64, ptr %t479
  %t481 = inttoptr i64 %t480 to ptr
  %t482 = musttail call fastcc i64 %t481(i64 %t477, i64 2, i64 %a0, i64 %t476, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t482
}

define fastcc i64 @"scheme.base:code_118"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t487 = icmp eq i64 %argc, 2
  br i1 %t487, label %argok105, label %arityerr104
arityerr104:
  call void @rt_arity_error(i64 2, i64 %argc)
  unreachable
argok105:
  %t488 = call i64 @rt_null_p(i64 %a1)
  %t489 = icmp ne i64 %t488, 1
  br i1 %t489, label %then106, label %else107
then106:
  ret i64 2
else107:
  %t490 = call i64 @rt_car(i64 %a1)
  %t491 = and i64 %a0, -8
  %t492 = inttoptr i64 %t491 to ptr
  %t493 = load i64, ptr %t492
  %t494 = inttoptr i64 %t493 to ptr
  %t495 = call fastcc i64%t494(i64 %a0, i64 1, i64 %t490, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t496 = icmp ne i64 %t495, 1
  br i1 %t496, label %then108, label %else109
then108:
  %t497 = call i64 @rt_car(i64 %a1)
  %t498 = call i64 @rt_cdr(i64 %a1)
  %t499 = load i64, ptr @"scheme.base:filter"
  %t500 = and i64 %t499, -8
  %t501 = inttoptr i64 %t500 to ptr
  %t502 = load i64, ptr %t501
  %t503 = inttoptr i64 %t502 to ptr
  %t504 = call fastcc i64%t503(i64 %t499, i64 2, i64 %a0, i64 %t498, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t505 = call i64 @rt_cons(i64 %t497, i64 %t504)
  ret i64 %t505
else109:
  %t506 = call i64 @rt_cdr(i64 %a1)
  %t507 = load i64, ptr @"scheme.base:filter"
  %t508 = and i64 %t507, -8
  %t509 = inttoptr i64 %t508 to ptr
  %t510 = load i64, ptr %t509
  %t511 = inttoptr i64 %t510 to ptr
  %t512 = musttail call fastcc i64 %t511(i64 %t507, i64 2, i64 %a0, i64 %t506, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t512
}

define fastcc i64 @"scheme.base:code_123"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t517 = icmp eq i64 %argc, 3
  br i1 %t517, label %argok111, label %arityerr110
arityerr110:
  call void @rt_arity_error(i64 3, i64 %argc)
  unreachable
argok111:
  %t518 = call i64 @rt_null_p(i64 %a2)
  %t519 = icmp ne i64 %t518, 1
  br i1 %t519, label %then112, label %else113
then112:
  ret i64 %a1
else113:
  %t520 = call i64 @rt_car(i64 %a2)
  %t521 = and i64 %a0, -8
  %t522 = inttoptr i64 %t521 to ptr
  %t523 = load i64, ptr %t522
  %t524 = inttoptr i64 %t523 to ptr
  %t525 = call fastcc i64%t524(i64 %a0, i64 2, i64 %a1, i64 %t520, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t526 = call i64 @rt_cdr(i64 %a2)
  %t527 = load i64, ptr @"scheme.base:fold-left"
  %t528 = and i64 %t527, -8
  %t529 = inttoptr i64 %t528 to ptr
  %t530 = load i64, ptr %t529
  %t531 = inttoptr i64 %t530 to ptr
  %t532 = musttail call fastcc i64 %t531(i64 %t527, i64 3, i64 %a0, i64 %t525, i64 %t526, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t532
}

define fastcc i64 @"scheme.base:code_128"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t537 = icmp eq i64 %argc, 3
  br i1 %t537, label %argok115, label %arityerr114
arityerr114:
  call void @rt_arity_error(i64 3, i64 %argc)
  unreachable
argok115:
  %t538 = call i64 @rt_null_p(i64 %a2)
  %t539 = icmp ne i64 %t538, 1
  br i1 %t539, label %then116, label %else117
then116:
  ret i64 %a1
else117:
  %t540 = call i64 @rt_car(i64 %a2)
  %t541 = call i64 @rt_cdr(i64 %a2)
  %t542 = load i64, ptr @"scheme.base:fold-right"
  %t543 = and i64 %t542, -8
  %t544 = inttoptr i64 %t543 to ptr
  %t545 = load i64, ptr %t544
  %t546 = inttoptr i64 %t545 to ptr
  %t547 = call fastcc i64%t546(i64 %t542, i64 3, i64 %a0, i64 %a1, i64 %t541, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t548 = and i64 %a0, -8
  %t549 = inttoptr i64 %t548 to ptr
  %t550 = load i64, ptr %t549
  %t551 = inttoptr i64 %t550 to ptr
  %t552 = musttail call fastcc i64 %t551(i64 %a0, i64 2, i64 %t540, i64 %t547, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t552
}

define fastcc i64 @"scheme.base:code_132"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t557 = icmp eq i64 %argc, 2
  br i1 %t557, label %argok119, label %arityerr118
arityerr118:
  call void @rt_arity_error(i64 2, i64 %argc)
  unreachable
argok119:
  %t558 = call i64 @rt_null_p(i64 %a1)
  %t559 = icmp ne i64 %t558, 1
  br i1 %t559, label %then120, label %else121
then120:
  %t560 = icmp ne i64 1, 1
  br i1 %t560, label %then122, label %else123
then122:
  ret i64 1
else123:
  ret i64 1
else121:
  %t561 = call i64 @rt_car(i64 %a1)
  %t562 = and i64 %a0, -8
  %t563 = inttoptr i64 %t562 to ptr
  %t564 = load i64, ptr %t563
  %t565 = inttoptr i64 %t564 to ptr
  %t566 = call fastcc i64%t565(i64 %a0, i64 1, i64 %t561, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t567 = call i64 @rt_cdr(i64 %a1)
  %t568 = load i64, ptr @"scheme.base:%for-each1"
  %t569 = and i64 %t568, -8
  %t570 = inttoptr i64 %t569 to ptr
  %t571 = load i64, ptr %t570
  %t572 = inttoptr i64 %t571 to ptr
  %t573 = musttail call fastcc i64 %t572(i64 %t568, i64 2, i64 %a0, i64 %t567, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t573
}

define fastcc i64 @"scheme.base:code_140"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t578 = icmp eq i64 %argc, 1
  br i1 %t578, label %argok125, label %arityerr124
arityerr124:
  call void @rt_arity_error(i64 1, i64 %argc)
  unreachable
argok125:
  %t579 = call i64 @rt_car(i64 %a0)
  ret i64 %t579
}

define fastcc i64 @"scheme.base:code_142"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t580 = icmp eq i64 %argc, 1
  br i1 %t580, label %argok127, label %arityerr126
arityerr126:
  call void @rt_arity_error(i64 1, i64 %argc)
  unreachable
argok127:
  %t581 = call i64 @rt_cdr(i64 %a0)
  ret i64 %t581
}

define fastcc i64 @"scheme.base:code_138"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t582 = icmp eq i64 %argc, 2
  br i1 %t582, label %argok129, label %arityerr128
arityerr128:
  call void @rt_arity_error(i64 2, i64 %argc)
  unreachable
argok129:
  %t583 = load i64, ptr @"scheme.base:%any-null?"
  %t584 = and i64 %t583, -8
  %t585 = inttoptr i64 %t584 to ptr
  %t586 = load i64, ptr %t585
  %t587 = inttoptr i64 %t586 to ptr
  %t588 = call fastcc i64%t587(i64 %t583, i64 1, i64 %a1, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t589 = icmp ne i64 %t588, 1
  br i1 %t589, label %then130, label %else131
then130:
  %t590 = icmp ne i64 1, 1
  br i1 %t590, label %then132, label %else133
then132:
  ret i64 1
else133:
  ret i64 1
else131:
  %t591 = call i64 @rt_alloc_words(i64 1)
  %t592 = inttoptr i64 %t591 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_140" to i64), ptr %t592
  %t593 = or i64 %t591, 4
  %t594 = load i64, ptr @"scheme.base:%map1"
  %t595 = and i64 %t594, -8
  %t596 = inttoptr i64 %t595 to ptr
  %t597 = load i64, ptr %t596
  %t598 = inttoptr i64 %t597 to ptr
  %t599 = call fastcc i64%t598(i64 %t594, i64 2, i64 %t593, i64 %a1, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t600 = and i64 %a0, -8
  %t601 = inttoptr i64 %t600 to ptr
  %t602 = load i64, ptr %t601
  %t603 = inttoptr i64 %t602 to ptr
  %t604 = call i64 @rt_list_length(i64 %t599)
  %t605 = add i64 0, %t604
  %t606 = call ptr @rt_apply_argv(i64 0, ptr null, i64 %t599, i64 8)
  %t618 = getelementptr i64, ptr %t606, i64 0
  %t610 = load i64, ptr %t618
  %t619 = getelementptr i64, ptr %t606, i64 1
  %t611 = load i64, ptr %t619
  %t620 = getelementptr i64, ptr %t606, i64 2
  %t612 = load i64, ptr %t620
  %t621 = getelementptr i64, ptr %t606, i64 3
  %t613 = load i64, ptr %t621
  %t622 = getelementptr i64, ptr %t606, i64 4
  %t614 = load i64, ptr %t622
  %t623 = getelementptr i64, ptr %t606, i64 5
  %t615 = load i64, ptr %t623
  %t624 = getelementptr i64, ptr %t606, i64 6
  %t616 = load i64, ptr %t624
  %t625 = getelementptr i64, ptr %t606, i64 7
  %t617 = load i64, ptr %t625
  %t607 = icmp sgt i64 %t605, 8
  %t608 = getelementptr i64, ptr %t606, i64 8
  %t609 = select i1 %t607, ptr %t608, ptr null
  %t626 = call fastcc i64%t603(i64 %a0, i64 %t605, i64 %t610, i64 %t611, i64 %t612, i64 %t613, i64 %t614, i64 %t615, i64 %t616, i64 %t617, ptr %t609)
  %t627 = call i64 @rt_alloc_words(i64 1)
  %t628 = inttoptr i64 %t627 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_142" to i64), ptr %t628
  %t629 = or i64 %t627, 4
  %t630 = load i64, ptr @"scheme.base:%map1"
  %t631 = and i64 %t630, -8
  %t632 = inttoptr i64 %t631 to ptr
  %t633 = load i64, ptr %t632
  %t634 = inttoptr i64 %t633 to ptr
  %t635 = call fastcc i64%t634(i64 %t630, i64 2, i64 %t629, i64 %a1, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t636 = load i64, ptr @"scheme.base:%for-eachn"
  %t637 = and i64 %t636, -8
  %t638 = inttoptr i64 %t637 to ptr
  %t639 = load i64, ptr %t638
  %t640 = inttoptr i64 %t639 to ptr
  %t641 = musttail call fastcc i64 %t640(i64 %t636, i64 2, i64 %a0, i64 %t635, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t641
}

define fastcc i64 @"scheme.base:code_147"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t646 = icmp sge i64 %argc, 2
  br i1 %t646, label %argok135, label %arityerr134
arityerr134:
  call void @rt_arity_error(i64 2, i64 %argc)
  unreachable
argok135:
  %t647 = call i64 @rt_alloc_words(i64 8)
  %t648 = inttoptr i64 %t647 to ptr
  %t649 = getelementptr i64, ptr %t648, i64 0
  store i64 %a0, ptr %t649
  %t650 = getelementptr i64, ptr %t648, i64 1
  store i64 %a1, ptr %t650
  %t651 = getelementptr i64, ptr %t648, i64 2
  store i64 %a2, ptr %t651
  %t652 = getelementptr i64, ptr %t648, i64 3
  store i64 %a3, ptr %t652
  %t653 = getelementptr i64, ptr %t648, i64 4
  store i64 %a4, ptr %t653
  %t654 = getelementptr i64, ptr %t648, i64 5
  store i64 %a5, ptr %t654
  %t655 = getelementptr i64, ptr %t648, i64 6
  store i64 %a6, ptr %t655
  %t656 = getelementptr i64, ptr %t648, i64 7
  store i64 %a7, ptr %t656
  %t657 = call i64 @rt_build_rest(i64 %argc, i64 2, i64 8, ptr %t648, ptr %overflow)
  %t658 = call i64 @rt_null_p(i64 %t657)
  %t659 = icmp ne i64 %t658, 1
  br i1 %t659, label %then136, label %else137
then136:
  %t660 = load i64, ptr @"scheme.base:%for-each1"
  %t661 = and i64 %t660, -8
  %t662 = inttoptr i64 %t661 to ptr
  %t663 = load i64, ptr %t662
  %t664 = inttoptr i64 %t663 to ptr
  %t665 = musttail call fastcc i64 %t664(i64 %t660, i64 2, i64 %a0, i64 %a1, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t665
else137:
  %t666 = call i64 @rt_cons(i64 %a1, i64 %t657)
  %t667 = load i64, ptr @"scheme.base:%for-eachn"
  %t668 = and i64 %t667, -8
  %t669 = inttoptr i64 %t668 to ptr
  %t670 = load i64, ptr %t669
  %t671 = inttoptr i64 %t670 to ptr
  %t672 = musttail call fastcc i64 %t671(i64 %t667, i64 2, i64 %a0, i64 %t666, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t672
}

define fastcc i64 @"scheme.base:code_151"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t677 = icmp eq i64 %argc, 2
  br i1 %t677, label %argok139, label %arityerr138
arityerr138:
  call void @rt_arity_error(i64 2, i64 %argc)
  unreachable
argok139:
  %t678 = call i64 @rt_null_p(i64 %a1)
  %t679 = icmp ne i64 %t678, 1
  br i1 %t679, label %then140, label %else141
then140:
  ret i64 257
else141:
  %t680 = call i64 @rt_car(i64 %a1)
  %t681 = and i64 %a0, -8
  %t682 = inttoptr i64 %t681 to ptr
  %t683 = load i64, ptr %t682
  %t684 = inttoptr i64 %t683 to ptr
  %t685 = call fastcc i64%t684(i64 %a0, i64 1, i64 %t680, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t686 = icmp ne i64 %t685, 1
  br i1 %t686, label %then142, label %else143
then142:
  %t687 = call i64 @rt_cdr(i64 %a1)
  %t688 = load i64, ptr @"scheme.base:andmap"
  %t689 = and i64 %t688, -8
  %t690 = inttoptr i64 %t689 to ptr
  %t691 = load i64, ptr %t690
  %t692 = inttoptr i64 %t691 to ptr
  %t693 = musttail call fastcc i64 %t692(i64 %t688, i64 2, i64 %a0, i64 %t687, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t693
else143:
  ret i64 1
}

define fastcc i64 @"scheme.base:code_155"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t698 = icmp eq i64 %argc, 2
  br i1 %t698, label %argok145, label %arityerr144
arityerr144:
  call void @rt_arity_error(i64 2, i64 %argc)
  unreachable
argok145:
  %t699 = call i64 @rt_null_p(i64 %a1)
  %t700 = icmp ne i64 %t699, 1
  br i1 %t700, label %then146, label %else147
then146:
  ret i64 1
else147:
  %t701 = call i64 @rt_car(i64 %a1)
  %t702 = and i64 %a0, -8
  %t703 = inttoptr i64 %t702 to ptr
  %t704 = load i64, ptr %t703
  %t705 = inttoptr i64 %t704 to ptr
  %t706 = call fastcc i64%t705(i64 %a0, i64 1, i64 %t701, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t707 = icmp ne i64 %t706, 1
  br i1 %t707, label %then148, label %else149
then148:
  ret i64 %a1
else149:
  %t708 = call i64 @rt_cdr(i64 %a1)
  %t709 = load i64, ptr @"scheme.base:memp"
  %t710 = and i64 %t709, -8
  %t711 = inttoptr i64 %t710 to ptr
  %t712 = load i64, ptr %t711
  %t713 = inttoptr i64 %t712 to ptr
  %t714 = musttail call fastcc i64 %t713(i64 %t709, i64 2, i64 %a0, i64 %t708, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t714
}

define fastcc i64 @"scheme.base:code_158"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t719 = icmp eq i64 %argc, 1
  br i1 %t719, label %argok151, label %arityerr150
arityerr150:
  call void @rt_arity_error(i64 1, i64 %argc)
  unreachable
argok151:
  %t720 = load i64, ptr @"scheme.base:cdddr"
  %t721 = and i64 %t720, -8
  %t722 = inttoptr i64 %t721 to ptr
  %t723 = load i64, ptr %t722
  %t724 = inttoptr i64 %t723 to ptr
  %t725 = call fastcc i64%t724(i64 %t720, i64 1, i64 %a0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t726 = call i64 @rt_car(i64 %t725)
  ret i64 %t726
}

define fastcc i64 @"scheme.base:code_161"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t731 = icmp eq i64 %argc, 1
  br i1 %t731, label %argok153, label %arityerr152
arityerr152:
  call void @rt_arity_error(i64 1, i64 %argc)
  unreachable
argok153:
  %t732 = call i64 @rt_null_p(i64 %a0)
  %t733 = icmp ne i64 %t732, 1
  br i1 %t733, label %then154, label %else155
then154:
  ret i64 257
else155:
  %t734 = call i64 @rt_pair_p(i64 %a0)
  %t735 = icmp ne i64 %t734, 1
  br i1 %t735, label %then156, label %else157
then156:
  %t736 = call i64 @rt_cdr(i64 %a0)
  %t737 = load i64, ptr @"scheme.base:list?"
  %t738 = and i64 %t737, -8
  %t739 = inttoptr i64 %t738 to ptr
  %t740 = load i64, ptr %t739
  %t741 = inttoptr i64 %t740 to ptr
  %t742 = musttail call fastcc i64 %t741(i64 %t737, i64 1, i64 %t736, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t742
else157:
  ret i64 1
}

define fastcc i64 @"scheme.base:code_168"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t747 = icmp eq i64 %argc, 1
  br i1 %t747, label %argok159, label %arityerr158
arityerr158:
  call void @rt_arity_error(i64 1, i64 %argc)
  unreachable
argok159:
  %t748 = or i64 %a0, 0
  %t749 = and i64 %t748, 7
  %t750 = icmp eq i64 %t749, 0
  br i1 %t750, label %fixfast160, label %fixslow161
fixfast160:
  %t751 = icmp eq i64 %a0, 0
  %t752 = select i1 %t751, i64 257, i64 1
  br label %fixmerge162
fixslow161:
  %t753 = call i64 @rt_num_eq(i64 %a0, i64 0)
  br label %fixmerge162
fixmerge162:
  %t754 = phi i64 [ %t752, %fixfast160 ], [ %t753, %fixslow161 ]
  ret i64 %t754
}

define fastcc i64 @"scheme.base:code_172"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t759 = icmp eq i64 %argc, 2
  br i1 %t759, label %argok164, label %arityerr163
arityerr163:
  call void @rt_arity_error(i64 2, i64 %argc)
  unreachable
argok164:
  %t760 = load i64, ptr @"scheme.base:zero?"
  %t761 = and i64 %t760, -8
  %t762 = inttoptr i64 %t761 to ptr
  %t763 = load i64, ptr %t762
  %t764 = inttoptr i64 %t763 to ptr
  %t765 = call fastcc i64%t764(i64 %t760, i64 1, i64 %a1, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t766 = icmp ne i64 %t765, 1
  br i1 %t766, label %then165, label %else166
then165:
  ret i64 %a0
else166:
  %t767 = call i64 @rt_cdr(i64 %a0)
  %t768 = or i64 %a1, 8
  %t769 = and i64 %t768, 7
  %t770 = icmp eq i64 %t769, 0
  br i1 %t770, label %fixfast167, label %fixslow168
fixfast167:
  %t771 = sub i64 %a1, 8
  br label %fixmerge169
fixslow168:
  %t772 = call i64 @rt_sub(i64 %a1, i64 8)
  br label %fixmerge169
fixmerge169:
  %t773 = phi i64 [ %t771, %fixfast167 ], [ %t772, %fixslow168 ]
  %t774 = load i64, ptr @"scheme.base:list-tail"
  %t775 = and i64 %t774, -8
  %t776 = inttoptr i64 %t775 to ptr
  %t777 = load i64, ptr %t776
  %t778 = inttoptr i64 %t777 to ptr
  %t779 = musttail call fastcc i64 %t778(i64 %t774, i64 2, i64 %t767, i64 %t773, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t779
}

define fastcc i64 @"scheme.base:code_176"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t784 = icmp eq i64 %argc, 2
  br i1 %t784, label %argok171, label %arityerr170
arityerr170:
  call void @rt_arity_error(i64 2, i64 %argc)
  unreachable
argok171:
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
  br i1 %t796, label %argok173, label %arityerr172
arityerr172:
  call void @rt_arity_error(i64 2, i64 %argc)
  unreachable
argok173:
  %t797 = load i64, ptr @"scheme.base:zero?"
  %t798 = and i64 %t797, -8
  %t799 = inttoptr i64 %t798 to ptr
  %t800 = load i64, ptr %t799
  %t801 = inttoptr i64 %t800 to ptr
  %t802 = call fastcc i64%t801(i64 %t797, i64 1, i64 %a1, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t803 = icmp ne i64 %t802, 1
  br i1 %t803, label %then174, label %else175
then174:
  ret i64 2
else175:
  %t804 = call i64 @rt_car(i64 %a0)
  %t805 = call i64 @rt_cdr(i64 %a0)
  %t806 = or i64 %a1, 8
  %t807 = and i64 %t806, 7
  %t808 = icmp eq i64 %t807, 0
  br i1 %t808, label %fixfast176, label %fixslow177
fixfast176:
  %t809 = sub i64 %a1, 8
  br label %fixmerge178
fixslow177:
  %t810 = call i64 @rt_sub(i64 %a1, i64 8)
  br label %fixmerge178
fixmerge178:
  %t811 = phi i64 [ %t809, %fixfast176 ], [ %t810, %fixslow177 ]
  %t812 = load i64, ptr @"scheme.base:list-head"
  %t813 = and i64 %t812, -8
  %t814 = inttoptr i64 %t813 to ptr
  %t815 = load i64, ptr %t814
  %t816 = inttoptr i64 %t815 to ptr
  %t817 = call fastcc i64%t816(i64 %t812, i64 2, i64 %t805, i64 %t811, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t818 = call i64 @rt_cons(i64 %t804, i64 %t817)
  ret i64 %t818
}

define fastcc i64 @"scheme.base:code_184"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t823 = icmp eq i64 %argc, 2
  br i1 %t823, label %argok180, label %arityerr179
arityerr179:
  call void @rt_arity_error(i64 2, i64 %argc)
  unreachable
argok180:
  %t824 = load i64, ptr @"scheme.base:zero?"
  %t825 = and i64 %t824, -8
  %t826 = inttoptr i64 %t825 to ptr
  %t827 = load i64, ptr %t826
  %t828 = inttoptr i64 %t827 to ptr
  %t829 = call fastcc i64%t828(i64 %t824, i64 1, i64 %a0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t830 = icmp ne i64 %t829, 1
  br i1 %t830, label %then181, label %else182
then181:
  ret i64 2
else182:
  %t831 = or i64 %a0, 8
  %t832 = and i64 %t831, 7
  %t833 = icmp eq i64 %t832, 0
  br i1 %t833, label %fixfast183, label %fixslow184
fixfast183:
  %t834 = sub i64 %a0, 8
  br label %fixmerge185
fixslow184:
  %t835 = call i64 @rt_sub(i64 %a0, i64 8)
  br label %fixmerge185
fixmerge185:
  %t836 = phi i64 [ %t834, %fixfast183 ], [ %t835, %fixslow184 ]
  %t837 = load i64, ptr @"scheme.base:make-list"
  %t838 = and i64 %t837, -8
  %t839 = inttoptr i64 %t838 to ptr
  %t840 = load i64, ptr %t839
  %t841 = inttoptr i64 %t840 to ptr
  %t842 = call fastcc i64%t841(i64 %t837, i64 2, i64 %t836, i64 %a1, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t843 = call i64 @rt_cons(i64 %a1, i64 %t842)
  ret i64 %t843
}

define fastcc i64 @"scheme.base:code_196"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t848 = icmp eq i64 %argc, 2
  br i1 %t848, label %argok187, label %arityerr186
arityerr186:
  call void @rt_arity_error(i64 2, i64 %argc)
  unreachable
argok187:
  %t849 = and i64 %self, -8
  %t850 = inttoptr i64 %t849 to ptr
  %t851 = getelementptr i64, ptr %t850, i64 1
  %t852 = load i64, ptr %t851
  %t853 = or i64 %a0, %t852
  %t854 = and i64 %t853, 7
  %t855 = icmp eq i64 %t854, 0
  br i1 %t855, label %fixfast188, label %fixslow189
fixfast188:
  %t856 = icmp eq i64 %a0, %t852
  %t857 = select i1 %t856, i64 257, i64 1
  br label %fixmerge190
fixslow189:
  %t858 = call i64 @rt_num_eq(i64 %a0, i64 %t852)
  br label %fixmerge190
fixmerge190:
  %t859 = phi i64 [ %t857, %fixfast188 ], [ %t858, %fixslow189 ]
  %t860 = icmp ne i64 %t859, 1
  br i1 %t860, label %then191, label %else192
then191:
  %t861 = load i64, ptr @"scheme.base:reverse"
  %t862 = and i64 %t861, -8
  %t863 = inttoptr i64 %t862 to ptr
  %t864 = load i64, ptr %t863
  %t865 = inttoptr i64 %t864 to ptr
  %t866 = musttail call fastcc i64 %t865(i64 %t861, i64 1, i64 %a1, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t866
else192:
  %t867 = or i64 %a0, 8
  %t868 = and i64 %t867, 7
  %t869 = icmp eq i64 %t868, 0
  br i1 %t869, label %fixfast193, label %fixslow194
fixfast193:
  %t870 = add i64 %a0, 8
  br label %fixmerge195
fixslow194:
  %t871 = call i64 @rt_add(i64 %a0, i64 8)
  br label %fixmerge195
fixmerge195:
  %t872 = phi i64 [ %t870, %fixfast193 ], [ %t871, %fixslow194 ]
  %t873 = call i64 @rt_cons(i64 %a0, i64 %a1)
  %t874 = musttail call fastcc i64 @"scheme.base:code_196"(i64 %self, i64 2, i64 %t872, i64 %t873, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t874
}

define fastcc i64 @"scheme.base:code_194"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t875 = icmp eq i64 %argc, 1
  br i1 %t875, label %argok197, label %arityerr196
arityerr196:
  call void @rt_arity_error(i64 1, i64 %argc)
  unreachable
argok197:
  %t876 = call i64 @rt_alloc_words(i64 3)
  %t877 = inttoptr i64 %t876 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_196" to i64), ptr %t877
  %t878 = or i64 %t876, 4
  %t879 = getelementptr i64, ptr %t877, i64 1
  store i64 %a0, ptr %t879
  %t880 = getelementptr i64, ptr %t877, i64 2
  store i64 %t878, ptr %t880
  %t881 = and i64 %t878, -8
  %t882 = inttoptr i64 %t881 to ptr
  %t883 = load i64, ptr %t882
  %t884 = inttoptr i64 %t883 to ptr
  %t885 = musttail call fastcc i64 %t884(i64 %t878, i64 2, i64 0, i64 2, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t885
}

define fastcc i64 @"scheme.base:code_204"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t890 = icmp eq i64 %argc, 2
  br i1 %t890, label %argok199, label %arityerr198
arityerr198:
  call void @rt_arity_error(i64 2, i64 %argc)
  unreachable
argok199:
  %t891 = or i64 %a0, %a1
  %t892 = and i64 %t891, 7
  %t893 = icmp eq i64 %t892, 0
  br i1 %t893, label %fixfast200, label %fixslow201
fixfast200:
  %t894 = icmp slt i64 %a0, %a1
  %t895 = select i1 %t894, i64 257, i64 1
  br label %fixmerge202
fixslow201:
  %t896 = call i64 @rt_lt(i64 %a0, i64 %a1)
  br label %fixmerge202
fixmerge202:
  %t897 = phi i64 [ %t895, %fixfast200 ], [ %t896, %fixslow201 ]
  %t898 = icmp ne i64 %t897, 1
  br i1 %t898, label %then203, label %else204
then203:
  ret i64 %a1
else204:
  ret i64 %a0
}

define fastcc i64 @"scheme.base:code_206"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t903 = icmp eq i64 %argc, 0
  br i1 %t903, label %argok206, label %arityerr205
arityerr205:
  call void @rt_arity_error(i64 0, i64 %argc)
  unreachable
argok206:
  %t904 = icmp ne i64 1, 1
  br i1 %t904, label %then207, label %else208
then207:
  ret i64 1
else208:
  ret i64 1
}

define fastcc i64 @"scheme.base:code_209"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t909 = icmp sge i64 %argc, 0
  br i1 %t909, label %argok210, label %arityerr209
arityerr209:
  call void @rt_arity_error(i64 0, i64 %argc)
  unreachable
argok210:
  %t910 = call i64 @rt_alloc_words(i64 8)
  %t911 = inttoptr i64 %t910 to ptr
  %t912 = getelementptr i64, ptr %t911, i64 0
  store i64 %a0, ptr %t912
  %t913 = getelementptr i64, ptr %t911, i64 1
  store i64 %a1, ptr %t913
  %t914 = getelementptr i64, ptr %t911, i64 2
  store i64 %a2, ptr %t914
  %t915 = getelementptr i64, ptr %t911, i64 3
  store i64 %a3, ptr %t915
  %t916 = getelementptr i64, ptr %t911, i64 4
  store i64 %a4, ptr %t916
  %t917 = getelementptr i64, ptr %t911, i64 5
  store i64 %a5, ptr %t917
  %t918 = getelementptr i64, ptr %t911, i64 6
  store i64 %a6, ptr %t918
  %t919 = getelementptr i64, ptr %t911, i64 7
  store i64 %a7, ptr %t919
  %t920 = call i64 @rt_build_rest(i64 %argc, i64 0, i64 8, ptr %t911, ptr %overflow)
  %t921 = call i64 @rt_list_to_string(i64 %t920)
  ret i64 %t921
}

define fastcc i64 @"scheme.base:code_212"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t926 = icmp eq i64 %argc, 1
  br i1 %t926, label %argok212, label %arityerr211
arityerr211:
  call void @rt_arity_error(i64 1, i64 %argc)
  unreachable
argok212:
  %t927 = call i64 @rt_null_p(i64 %a0)
  %t928 = icmp ne i64 %t927, 1
  br i1 %t928, label %then213, label %else214
then213:
  %t929 = call i64 @rt_make_string(ptr @.str.lit.0, i64 0)
  ret i64 %t929
else214:
  %t930 = call i64 @rt_car(i64 %a0)
  %t931 = call i64 @rt_cdr(i64 %a0)
  %t932 = load i64, ptr @"scheme.base:%str-concat"
  %t933 = and i64 %t932, -8
  %t934 = inttoptr i64 %t933 to ptr
  %t935 = load i64, ptr %t934
  %t936 = inttoptr i64 %t935 to ptr
  %t937 = call fastcc i64%t936(i64 %t932, i64 1, i64 %t931, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t938 = call i64 @rt_string_append(i64 %t930, i64 %t937)
  ret i64 %t938
}

define fastcc i64 @"scheme.base:code_218"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t943 = icmp eq i64 %argc, 4
  br i1 %t943, label %argok216, label %arityerr215
arityerr215:
  call void @rt_arity_error(i64 4, i64 %argc)
  unreachable
argok216:
  %t944 = call i64 @rt_char_to_integer(i64 %a1)
  %t945 = call i64 @rt_char_to_integer(i64 %a2)
  %t946 = and i64 %a0, -8
  %t947 = inttoptr i64 %t946 to ptr
  %t948 = load i64, ptr %t947
  %t949 = inttoptr i64 %t948 to ptr
  %t950 = call fastcc i64%t949(i64 %a0, i64 2, i64 %t944, i64 %t945, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t951 = icmp ne i64 %t950, 1
  br i1 %t951, label %then217, label %else218
then217:
  %t952 = call i64 @rt_null_p(i64 %a3)
  %t953 = icmp ne i64 %t952, 1
  br i1 %t953, label %then219, label %else220
then219:
  ret i64 257
else220:
  %t954 = call i64 @rt_car(i64 %a3)
  %t955 = call i64 @rt_cdr(i64 %a3)
  %t956 = load i64, ptr @"scheme.base:chr-cmp"
  %t957 = and i64 %t956, -8
  %t958 = inttoptr i64 %t957 to ptr
  %t959 = load i64, ptr %t958
  %t960 = inttoptr i64 %t959 to ptr
  %t961 = musttail call fastcc i64 %t960(i64 %t956, i64 4, i64 %a0, i64 %a2, i64 %t954, i64 %t955, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t961
else218:
  ret i64 1
}

define fastcc i64 @"scheme.base:code_231"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t966 = icmp eq i64 %argc, 2
  br i1 %t966, label %argok222, label %arityerr221
arityerr221:
  call void @rt_arity_error(i64 2, i64 %argc)
  unreachable
argok222:
  %t967 = or i64 %a0, %a1
  %t968 = and i64 %t967, 7
  %t969 = icmp eq i64 %t968, 0
  br i1 %t969, label %fixfast223, label %fixslow224
fixfast223:
  %t970 = icmp eq i64 %a0, %a1
  %t971 = select i1 %t970, i64 257, i64 1
  br label %fixmerge225
fixslow224:
  %t972 = call i64 @rt_num_eq(i64 %a0, i64 %a1)
  br label %fixmerge225
fixmerge225:
  %t973 = phi i64 [ %t971, %fixfast223 ], [ %t972, %fixslow224 ]
  ret i64 %t973
}

define fastcc i64 @"scheme.base:code_229"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t974 = icmp sge i64 %argc, 2
  br i1 %t974, label %argok227, label %arityerr226
arityerr226:
  call void @rt_arity_error(i64 2, i64 %argc)
  unreachable
argok227:
  %t975 = call i64 @rt_alloc_words(i64 8)
  %t976 = inttoptr i64 %t975 to ptr
  %t977 = getelementptr i64, ptr %t976, i64 0
  store i64 %a0, ptr %t977
  %t978 = getelementptr i64, ptr %t976, i64 1
  store i64 %a1, ptr %t978
  %t979 = getelementptr i64, ptr %t976, i64 2
  store i64 %a2, ptr %t979
  %t980 = getelementptr i64, ptr %t976, i64 3
  store i64 %a3, ptr %t980
  %t981 = getelementptr i64, ptr %t976, i64 4
  store i64 %a4, ptr %t981
  %t982 = getelementptr i64, ptr %t976, i64 5
  store i64 %a5, ptr %t982
  %t983 = getelementptr i64, ptr %t976, i64 6
  store i64 %a6, ptr %t983
  %t984 = getelementptr i64, ptr %t976, i64 7
  store i64 %a7, ptr %t984
  %t985 = call i64 @rt_build_rest(i64 %argc, i64 2, i64 8, ptr %t976, ptr %overflow)
  %t986 = call i64 @rt_alloc_words(i64 1)
  %t987 = inttoptr i64 %t986 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_231" to i64), ptr %t987
  %t988 = or i64 %t986, 4
  %t989 = load i64, ptr @"scheme.base:chr-cmp"
  %t990 = and i64 %t989, -8
  %t991 = inttoptr i64 %t990 to ptr
  %t992 = load i64, ptr %t991
  %t993 = inttoptr i64 %t992 to ptr
  %t994 = musttail call fastcc i64 %t993(i64 %t989, i64 4, i64 %t988, i64 %a0, i64 %a1, i64 %t985, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t994
}

define fastcc i64 @"scheme.base:code_244"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t999 = icmp eq i64 %argc, 2
  br i1 %t999, label %argok229, label %arityerr228
arityerr228:
  call void @rt_arity_error(i64 2, i64 %argc)
  unreachable
argok229:
  %t1000 = or i64 %a0, %a1
  %t1001 = and i64 %t1000, 7
  %t1002 = icmp eq i64 %t1001, 0
  br i1 %t1002, label %fixfast230, label %fixslow231
fixfast230:
  %t1003 = icmp slt i64 %a0, %a1
  %t1004 = select i1 %t1003, i64 257, i64 1
  br label %fixmerge232
fixslow231:
  %t1005 = call i64 @rt_lt(i64 %a0, i64 %a1)
  br label %fixmerge232
fixmerge232:
  %t1006 = phi i64 [ %t1004, %fixfast230 ], [ %t1005, %fixslow231 ]
  ret i64 %t1006
}

define fastcc i64 @"scheme.base:code_242"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1007 = icmp sge i64 %argc, 2
  br i1 %t1007, label %argok234, label %arityerr233
arityerr233:
  call void @rt_arity_error(i64 2, i64 %argc)
  unreachable
argok234:
  %t1008 = call i64 @rt_alloc_words(i64 8)
  %t1009 = inttoptr i64 %t1008 to ptr
  %t1010 = getelementptr i64, ptr %t1009, i64 0
  store i64 %a0, ptr %t1010
  %t1011 = getelementptr i64, ptr %t1009, i64 1
  store i64 %a1, ptr %t1011
  %t1012 = getelementptr i64, ptr %t1009, i64 2
  store i64 %a2, ptr %t1012
  %t1013 = getelementptr i64, ptr %t1009, i64 3
  store i64 %a3, ptr %t1013
  %t1014 = getelementptr i64, ptr %t1009, i64 4
  store i64 %a4, ptr %t1014
  %t1015 = getelementptr i64, ptr %t1009, i64 5
  store i64 %a5, ptr %t1015
  %t1016 = getelementptr i64, ptr %t1009, i64 6
  store i64 %a6, ptr %t1016
  %t1017 = getelementptr i64, ptr %t1009, i64 7
  store i64 %a7, ptr %t1017
  %t1018 = call i64 @rt_build_rest(i64 %argc, i64 2, i64 8, ptr %t1009, ptr %overflow)
  %t1019 = call i64 @rt_alloc_words(i64 1)
  %t1020 = inttoptr i64 %t1019 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_244" to i64), ptr %t1020
  %t1021 = or i64 %t1019, 4
  %t1022 = load i64, ptr @"scheme.base:chr-cmp"
  %t1023 = and i64 %t1022, -8
  %t1024 = inttoptr i64 %t1023 to ptr
  %t1025 = load i64, ptr %t1024
  %t1026 = inttoptr i64 %t1025 to ptr
  %t1027 = musttail call fastcc i64 %t1026(i64 %t1022, i64 4, i64 %t1021, i64 %a0, i64 %a1, i64 %t1018, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t1027
}

define fastcc i64 @"scheme.base:code_257"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1032 = icmp eq i64 %argc, 2
  br i1 %t1032, label %argok236, label %arityerr235
arityerr235:
  call void @rt_arity_error(i64 2, i64 %argc)
  unreachable
argok236:
  %t1033 = or i64 %a1, %a0
  %t1034 = and i64 %t1033, 7
  %t1035 = icmp eq i64 %t1034, 0
  br i1 %t1035, label %fixfast237, label %fixslow238
fixfast237:
  %t1036 = icmp slt i64 %a1, %a0
  %t1037 = select i1 %t1036, i64 257, i64 1
  br label %fixmerge239
fixslow238:
  %t1038 = call i64 @rt_lt(i64 %a1, i64 %a0)
  br label %fixmerge239
fixmerge239:
  %t1039 = phi i64 [ %t1037, %fixfast237 ], [ %t1038, %fixslow238 ]
  ret i64 %t1039
}

define fastcc i64 @"scheme.base:code_255"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1040 = icmp sge i64 %argc, 2
  br i1 %t1040, label %argok241, label %arityerr240
arityerr240:
  call void @rt_arity_error(i64 2, i64 %argc)
  unreachable
argok241:
  %t1041 = call i64 @rt_alloc_words(i64 8)
  %t1042 = inttoptr i64 %t1041 to ptr
  %t1043 = getelementptr i64, ptr %t1042, i64 0
  store i64 %a0, ptr %t1043
  %t1044 = getelementptr i64, ptr %t1042, i64 1
  store i64 %a1, ptr %t1044
  %t1045 = getelementptr i64, ptr %t1042, i64 2
  store i64 %a2, ptr %t1045
  %t1046 = getelementptr i64, ptr %t1042, i64 3
  store i64 %a3, ptr %t1046
  %t1047 = getelementptr i64, ptr %t1042, i64 4
  store i64 %a4, ptr %t1047
  %t1048 = getelementptr i64, ptr %t1042, i64 5
  store i64 %a5, ptr %t1048
  %t1049 = getelementptr i64, ptr %t1042, i64 6
  store i64 %a6, ptr %t1049
  %t1050 = getelementptr i64, ptr %t1042, i64 7
  store i64 %a7, ptr %t1050
  %t1051 = call i64 @rt_build_rest(i64 %argc, i64 2, i64 8, ptr %t1042, ptr %overflow)
  %t1052 = call i64 @rt_alloc_words(i64 1)
  %t1053 = inttoptr i64 %t1052 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_257" to i64), ptr %t1053
  %t1054 = or i64 %t1052, 4
  %t1055 = load i64, ptr @"scheme.base:chr-cmp"
  %t1056 = and i64 %t1055, -8
  %t1057 = inttoptr i64 %t1056 to ptr
  %t1058 = load i64, ptr %t1057
  %t1059 = inttoptr i64 %t1058 to ptr
  %t1060 = musttail call fastcc i64 %t1059(i64 %t1055, i64 4, i64 %t1054, i64 %a0, i64 %a1, i64 %t1051, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t1060
}

define fastcc i64 @"scheme.base:code_270"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1065 = icmp eq i64 %argc, 2
  br i1 %t1065, label %argok243, label %arityerr242
arityerr242:
  call void @rt_arity_error(i64 2, i64 %argc)
  unreachable
argok243:
  %t1066 = or i64 %a0, %a1
  %t1067 = and i64 %t1066, 7
  %t1068 = icmp eq i64 %t1067, 0
  br i1 %t1068, label %fixfast244, label %fixslow245
fixfast244:
  %t1069 = icmp slt i64 %a0, %a1
  %t1070 = select i1 %t1069, i64 257, i64 1
  br label %fixmerge246
fixslow245:
  %t1071 = call i64 @rt_lt(i64 %a0, i64 %a1)
  br label %fixmerge246
fixmerge246:
  %t1072 = phi i64 [ %t1070, %fixfast244 ], [ %t1071, %fixslow245 ]
  %t1073 = icmp ne i64 %t1072, 1
  br i1 %t1073, label %then247, label %else248
then247:
  ret i64 257
else248:
  %t1074 = or i64 %a0, %a1
  %t1075 = and i64 %t1074, 7
  %t1076 = icmp eq i64 %t1075, 0
  br i1 %t1076, label %fixfast249, label %fixslow250
fixfast249:
  %t1077 = icmp eq i64 %a0, %a1
  %t1078 = select i1 %t1077, i64 257, i64 1
  br label %fixmerge251
fixslow250:
  %t1079 = call i64 @rt_num_eq(i64 %a0, i64 %a1)
  br label %fixmerge251
fixmerge251:
  %t1080 = phi i64 [ %t1078, %fixfast249 ], [ %t1079, %fixslow250 ]
  ret i64 %t1080
}

define fastcc i64 @"scheme.base:code_268"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1081 = icmp sge i64 %argc, 2
  br i1 %t1081, label %argok253, label %arityerr252
arityerr252:
  call void @rt_arity_error(i64 2, i64 %argc)
  unreachable
argok253:
  %t1082 = call i64 @rt_alloc_words(i64 8)
  %t1083 = inttoptr i64 %t1082 to ptr
  %t1084 = getelementptr i64, ptr %t1083, i64 0
  store i64 %a0, ptr %t1084
  %t1085 = getelementptr i64, ptr %t1083, i64 1
  store i64 %a1, ptr %t1085
  %t1086 = getelementptr i64, ptr %t1083, i64 2
  store i64 %a2, ptr %t1086
  %t1087 = getelementptr i64, ptr %t1083, i64 3
  store i64 %a3, ptr %t1087
  %t1088 = getelementptr i64, ptr %t1083, i64 4
  store i64 %a4, ptr %t1088
  %t1089 = getelementptr i64, ptr %t1083, i64 5
  store i64 %a5, ptr %t1089
  %t1090 = getelementptr i64, ptr %t1083, i64 6
  store i64 %a6, ptr %t1090
  %t1091 = getelementptr i64, ptr %t1083, i64 7
  store i64 %a7, ptr %t1091
  %t1092 = call i64 @rt_build_rest(i64 %argc, i64 2, i64 8, ptr %t1083, ptr %overflow)
  %t1093 = call i64 @rt_alloc_words(i64 1)
  %t1094 = inttoptr i64 %t1093 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_270" to i64), ptr %t1094
  %t1095 = or i64 %t1093, 4
  %t1096 = load i64, ptr @"scheme.base:chr-cmp"
  %t1097 = and i64 %t1096, -8
  %t1098 = inttoptr i64 %t1097 to ptr
  %t1099 = load i64, ptr %t1098
  %t1100 = inttoptr i64 %t1099 to ptr
  %t1101 = musttail call fastcc i64 %t1100(i64 %t1096, i64 4, i64 %t1095, i64 %a0, i64 %a1, i64 %t1092, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t1101
}

define fastcc i64 @"scheme.base:code_283"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1106 = icmp eq i64 %argc, 2
  br i1 %t1106, label %argok255, label %arityerr254
arityerr254:
  call void @rt_arity_error(i64 2, i64 %argc)
  unreachable
argok255:
  %t1107 = or i64 %a1, %a0
  %t1108 = and i64 %t1107, 7
  %t1109 = icmp eq i64 %t1108, 0
  br i1 %t1109, label %fixfast256, label %fixslow257
fixfast256:
  %t1110 = icmp slt i64 %a1, %a0
  %t1111 = select i1 %t1110, i64 257, i64 1
  br label %fixmerge258
fixslow257:
  %t1112 = call i64 @rt_lt(i64 %a1, i64 %a0)
  br label %fixmerge258
fixmerge258:
  %t1113 = phi i64 [ %t1111, %fixfast256 ], [ %t1112, %fixslow257 ]
  %t1114 = icmp ne i64 %t1113, 1
  br i1 %t1114, label %then259, label %else260
then259:
  ret i64 257
else260:
  %t1115 = or i64 %a0, %a1
  %t1116 = and i64 %t1115, 7
  %t1117 = icmp eq i64 %t1116, 0
  br i1 %t1117, label %fixfast261, label %fixslow262
fixfast261:
  %t1118 = icmp eq i64 %a0, %a1
  %t1119 = select i1 %t1118, i64 257, i64 1
  br label %fixmerge263
fixslow262:
  %t1120 = call i64 @rt_num_eq(i64 %a0, i64 %a1)
  br label %fixmerge263
fixmerge263:
  %t1121 = phi i64 [ %t1119, %fixfast261 ], [ %t1120, %fixslow262 ]
  ret i64 %t1121
}

define fastcc i64 @"scheme.base:code_281"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1122 = icmp sge i64 %argc, 2
  br i1 %t1122, label %argok265, label %arityerr264
arityerr264:
  call void @rt_arity_error(i64 2, i64 %argc)
  unreachable
argok265:
  %t1123 = call i64 @rt_alloc_words(i64 8)
  %t1124 = inttoptr i64 %t1123 to ptr
  %t1125 = getelementptr i64, ptr %t1124, i64 0
  store i64 %a0, ptr %t1125
  %t1126 = getelementptr i64, ptr %t1124, i64 1
  store i64 %a1, ptr %t1126
  %t1127 = getelementptr i64, ptr %t1124, i64 2
  store i64 %a2, ptr %t1127
  %t1128 = getelementptr i64, ptr %t1124, i64 3
  store i64 %a3, ptr %t1128
  %t1129 = getelementptr i64, ptr %t1124, i64 4
  store i64 %a4, ptr %t1129
  %t1130 = getelementptr i64, ptr %t1124, i64 5
  store i64 %a5, ptr %t1130
  %t1131 = getelementptr i64, ptr %t1124, i64 6
  store i64 %a6, ptr %t1131
  %t1132 = getelementptr i64, ptr %t1124, i64 7
  store i64 %a7, ptr %t1132
  %t1133 = call i64 @rt_build_rest(i64 %argc, i64 2, i64 8, ptr %t1124, ptr %overflow)
  %t1134 = call i64 @rt_alloc_words(i64 1)
  %t1135 = inttoptr i64 %t1134 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_283" to i64), ptr %t1135
  %t1136 = or i64 %t1134, 4
  %t1137 = load i64, ptr @"scheme.base:chr-cmp"
  %t1138 = and i64 %t1137, -8
  %t1139 = inttoptr i64 %t1138 to ptr
  %t1140 = load i64, ptr %t1139
  %t1141 = inttoptr i64 %t1140 to ptr
  %t1142 = musttail call fastcc i64 %t1141(i64 %t1137, i64 4, i64 %t1136, i64 %a0, i64 %a1, i64 %t1133, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t1142
}

define fastcc i64 @"scheme.base:code_295"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1147 = icmp eq i64 %argc, 2
  br i1 %t1147, label %argok267, label %arityerr266
arityerr266:
  call void @rt_arity_error(i64 2, i64 %argc)
  unreachable
argok267:
  %t1148 = or i64 %a0, 0
  %t1149 = and i64 %t1148, 7
  %t1150 = icmp eq i64 %t1149, 0
  br i1 %t1150, label %fixfast268, label %fixslow269
fixfast268:
  %t1151 = icmp slt i64 %a0, 0
  %t1152 = select i1 %t1151, i64 257, i64 1
  br label %fixmerge270
fixslow269:
  %t1153 = call i64 @rt_lt(i64 %a0, i64 0)
  br label %fixmerge270
fixmerge270:
  %t1154 = phi i64 [ %t1152, %fixfast268 ], [ %t1153, %fixslow269 ]
  %t1155 = icmp ne i64 %t1154, 1
  br i1 %t1155, label %then271, label %else272
then271:
  ret i64 %a1
else272:
  %t1156 = or i64 %a0, 8
  %t1157 = and i64 %t1156, 7
  %t1158 = icmp eq i64 %t1157, 0
  br i1 %t1158, label %fixfast273, label %fixslow274
fixfast273:
  %t1159 = sub i64 %a0, 8
  br label %fixmerge275
fixslow274:
  %t1160 = call i64 @rt_sub(i64 %a0, i64 8)
  br label %fixmerge275
fixmerge275:
  %t1161 = phi i64 [ %t1159, %fixfast273 ], [ %t1160, %fixslow274 ]
  %t1162 = and i64 %self, -8
  %t1163 = inttoptr i64 %t1162 to ptr
  %t1164 = getelementptr i64, ptr %t1163, i64 2
  %t1165 = load i64, ptr %t1164
  %t1166 = call i64 @rt_string_ref(i64 %t1165, i64 %a0)
  %t1167 = call i64 @rt_cons(i64 %t1166, i64 %a1)
  %t1168 = musttail call fastcc i64 @"scheme.base:code_295"(i64 %self, i64 2, i64 %t1161, i64 %t1167, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t1168
}

define fastcc i64 @"scheme.base:code_293"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1169 = icmp eq i64 %argc, 1
  br i1 %t1169, label %argok277, label %arityerr276
arityerr276:
  call void @rt_arity_error(i64 1, i64 %argc)
  unreachable
argok277:
  %t1170 = call i64 @rt_alloc_words(i64 3)
  %t1171 = inttoptr i64 %t1170 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_295" to i64), ptr %t1171
  %t1172 = or i64 %t1170, 4
  %t1173 = getelementptr i64, ptr %t1171, i64 1
  store i64 %t1172, ptr %t1173
  %t1174 = getelementptr i64, ptr %t1171, i64 2
  store i64 %a0, ptr %t1174
  %t1175 = call i64 @rt_string_length(i64 %a0)
  %t1176 = or i64 %t1175, 8
  %t1177 = and i64 %t1176, 7
  %t1178 = icmp eq i64 %t1177, 0
  br i1 %t1178, label %fixfast278, label %fixslow279
fixfast278:
  %t1179 = sub i64 %t1175, 8
  br label %fixmerge280
fixslow279:
  %t1180 = call i64 @rt_sub(i64 %t1175, i64 8)
  br label %fixmerge280
fixmerge280:
  %t1181 = phi i64 [ %t1179, %fixfast278 ], [ %t1180, %fixslow279 ]
  %t1182 = and i64 %t1172, -8
  %t1183 = inttoptr i64 %t1182 to ptr
  %t1184 = load i64, ptr %t1183
  %t1185 = inttoptr i64 %t1184 to ptr
  %t1186 = musttail call fastcc i64 %t1185(i64 %t1172, i64 2, i64 %t1181, i64 2, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t1186
}

define fastcc i64 @"scheme.base:code_305"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1191 = icmp eq i64 %argc, 2
  br i1 %t1191, label %argok282, label %arityerr281
arityerr281:
  call void @rt_arity_error(i64 2, i64 %argc)
  unreachable
argok282:
  %t1192 = call i64 @rt_remainder(i64 %a0, i64 80)
  %t1193 = or i64 0, %t1192
  %t1194 = and i64 %t1193, 7
  %t1195 = icmp eq i64 %t1194, 0
  br i1 %t1195, label %fixfast283, label %fixslow284
fixfast283:
  %t1196 = sub i64 0, %t1192
  br label %fixmerge285
fixslow284:
  %t1197 = call i64 @rt_sub(i64 0, i64 %t1192)
  br label %fixmerge285
fixmerge285:
  %t1198 = phi i64 [ %t1196, %fixfast283 ], [ %t1197, %fixslow284 ]
  %t1199 = or i64 384, %t1198
  %t1200 = and i64 %t1199, 7
  %t1201 = icmp eq i64 %t1200, 0
  br i1 %t1201, label %fixfast286, label %fixslow287
fixfast286:
  %t1202 = add i64 384, %t1198
  br label %fixmerge288
fixslow287:
  %t1203 = call i64 @rt_add(i64 384, i64 %t1198)
  br label %fixmerge288
fixmerge288:
  %t1204 = phi i64 [ %t1202, %fixfast286 ], [ %t1203, %fixslow287 ]
  %t1205 = call i64 @rt_integer_to_char(i64 %t1204)
  %t1206 = call i64 @rt_quotient(i64 %a0, i64 80)
  %t1207 = or i64 %t1206, 0
  %t1208 = and i64 %t1207, 7
  %t1209 = icmp eq i64 %t1208, 0
  br i1 %t1209, label %fixfast289, label %fixslow290
fixfast289:
  %t1210 = icmp eq i64 %t1206, 0
  %t1211 = select i1 %t1210, i64 257, i64 1
  br label %fixmerge291
fixslow290:
  %t1212 = call i64 @rt_num_eq(i64 %t1206, i64 0)
  br label %fixmerge291
fixmerge291:
  %t1213 = phi i64 [ %t1211, %fixfast289 ], [ %t1212, %fixslow290 ]
  %t1214 = icmp ne i64 %t1213, 1
  br i1 %t1214, label %then292, label %else293
then292:
  %t1215 = call i64 @rt_cons(i64 %t1205, i64 %a1)
  ret i64 %t1215
else293:
  %t1216 = call i64 @rt_cons(i64 %t1205, i64 %a1)
  %t1217 = load i64, ptr @"scheme.base:ns-digits"
  %t1218 = and i64 %t1217, -8
  %t1219 = inttoptr i64 %t1218 to ptr
  %t1220 = load i64, ptr %t1219
  %t1221 = inttoptr i64 %t1220 to ptr
  %t1222 = musttail call fastcc i64 %t1221(i64 %t1217, i64 2, i64 %t1206, i64 %t1216, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t1222
}

define fastcc i64 @"scheme.base:code_316"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1227 = icmp eq i64 %argc, 1
  br i1 %t1227, label %argok295, label %arityerr294
arityerr294:
  call void @rt_arity_error(i64 1, i64 %argc)
  unreachable
argok295:
  %t1228 = call i64 @rt_exact_p(i64 %a0)
  %t1229 = icmp ne i64 %t1228, 1
  br i1 %t1229, label %then296, label %else297
then296:
  %t1230 = or i64 %a0, 0
  %t1231 = and i64 %t1230, 7
  %t1232 = icmp eq i64 %t1231, 0
  br i1 %t1232, label %fixfast298, label %fixslow299
fixfast298:
  %t1233 = icmp eq i64 %a0, 0
  %t1234 = select i1 %t1233, i64 257, i64 1
  br label %fixmerge300
fixslow299:
  %t1235 = call i64 @rt_num_eq(i64 %a0, i64 0)
  br label %fixmerge300
fixmerge300:
  %t1236 = phi i64 [ %t1234, %fixfast298 ], [ %t1235, %fixslow299 ]
  %t1237 = icmp ne i64 %t1236, 1
  br i1 %t1237, label %then301, label %else302
then301:
  %t1238 = call i64 @rt_make_string(ptr @.str.lit.1, i64 1)
  ret i64 %t1238
else302:
  %t1239 = or i64 %a0, 0
  %t1240 = and i64 %t1239, 7
  %t1241 = icmp eq i64 %t1240, 0
  br i1 %t1241, label %fixfast303, label %fixslow304
fixfast303:
  %t1242 = icmp slt i64 %a0, 0
  %t1243 = select i1 %t1242, i64 257, i64 1
  br label %fixmerge305
fixslow304:
  %t1244 = call i64 @rt_lt(i64 %a0, i64 0)
  br label %fixmerge305
fixmerge305:
  %t1245 = phi i64 [ %t1243, %fixfast303 ], [ %t1244, %fixslow304 ]
  %t1246 = icmp ne i64 %t1245, 1
  br i1 %t1246, label %then306, label %else307
then306:
  %t1247 = load i64, ptr @"scheme.base:ns-digits"
  %t1248 = and i64 %t1247, -8
  %t1249 = inttoptr i64 %t1248 to ptr
  %t1250 = load i64, ptr %t1249
  %t1251 = inttoptr i64 %t1250 to ptr
  %t1252 = call fastcc i64%t1251(i64 %t1247, i64 2, i64 %a0, i64 2, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t1253 = call i64 @rt_cons(i64 11529, i64 %t1252)
  %t1254 = call i64 @rt_list_to_string(i64 %t1253)
  ret i64 %t1254
else307:
  %t1255 = or i64 0, %a0
  %t1256 = and i64 %t1255, 7
  %t1257 = icmp eq i64 %t1256, 0
  br i1 %t1257, label %fixfast308, label %fixslow309
fixfast308:
  %t1258 = sub i64 0, %a0
  br label %fixmerge310
fixslow309:
  %t1259 = call i64 @rt_sub(i64 0, i64 %a0)
  br label %fixmerge310
fixmerge310:
  %t1260 = phi i64 [ %t1258, %fixfast308 ], [ %t1259, %fixslow309 ]
  %t1261 = load i64, ptr @"scheme.base:ns-digits"
  %t1262 = and i64 %t1261, -8
  %t1263 = inttoptr i64 %t1262 to ptr
  %t1264 = load i64, ptr %t1263
  %t1265 = inttoptr i64 %t1264 to ptr
  %t1266 = call fastcc i64%t1265(i64 %t1261, i64 2, i64 %t1260, i64 2, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t1267 = call i64 @rt_list_to_string(i64 %t1266)
  ret i64 %t1267
else297:
  %t1268 = call i64 @rt_flonum_to_string(i64 %a0)
  ret i64 %t1268
}

define fastcc i64 @"scheme.base:code_320"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1273 = icmp sge i64 %argc, 1
  br i1 %t1273, label %argok312, label %arityerr311
arityerr311:
  call void @rt_arity_error(i64 1, i64 %argc)
  unreachable
argok312:
  %t1274 = call i64 @rt_alloc_words(i64 8)
  %t1275 = inttoptr i64 %t1274 to ptr
  %t1276 = getelementptr i64, ptr %t1275, i64 0
  store i64 %a0, ptr %t1276
  %t1277 = getelementptr i64, ptr %t1275, i64 1
  store i64 %a1, ptr %t1277
  %t1278 = getelementptr i64, ptr %t1275, i64 2
  store i64 %a2, ptr %t1278
  %t1279 = getelementptr i64, ptr %t1275, i64 3
  store i64 %a3, ptr %t1279
  %t1280 = getelementptr i64, ptr %t1275, i64 4
  store i64 %a4, ptr %t1280
  %t1281 = getelementptr i64, ptr %t1275, i64 5
  store i64 %a5, ptr %t1281
  %t1282 = getelementptr i64, ptr %t1275, i64 6
  store i64 %a6, ptr %t1282
  %t1283 = getelementptr i64, ptr %t1275, i64 7
  store i64 %a7, ptr %t1283
  %t1284 = call i64 @rt_build_rest(i64 %argc, i64 1, i64 8, ptr %t1275, ptr %overflow)
  %t1285 = call i64 @rt_string_p(i64 %a0)
  %t1286 = icmp ne i64 %t1285, 1
  br i1 %t1286, label %then313, label %else314
then313:
  %t1287 = call i64 @rt_error(i64 %a0, i64 %t1284)
  ret i64 %t1287
else314:
  %t1288 = call i64 @rt_symbol_to_string(i64 %a0)
  %t1289 = call i64 @rt_make_string(ptr @.str.lit.2, i64 2)
  %t1290 = call i64 @rt_car(i64 %t1284)
  %t1291 = call i64 @rt_string_append(i64 %t1289, i64 %t1290)
  %t1292 = call i64 @rt_string_append(i64 %t1288, i64 %t1291)
  %t1293 = call i64 @rt_cdr(i64 %t1284)
  %t1294 = call i64 @rt_error(i64 %t1292, i64 %t1293)
  ret i64 %t1294
}

define fastcc i64 @"scheme.base:code_323"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1299 = icmp eq i64 %argc, 1
  br i1 %t1299, label %argok316, label %arityerr315
arityerr315:
  call void @rt_arity_error(i64 1, i64 %argc)
  unreachable
argok316:
  %t1300 = call i64 @rt_raise(i64 %a0)
  ret i64 %t1300
}

define fastcc i64 @"scheme.base:code_326"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1305 = icmp eq i64 %argc, 1
  br i1 %t1305, label %argok318, label %arityerr317
arityerr317:
  call void @rt_arity_error(i64 1, i64 %argc)
  unreachable
argok318:
  %t1306 = call i64 @rt_error_object_p(i64 %a0)
  ret i64 %t1306
}

define fastcc i64 @"scheme.base:code_329"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1311 = icmp eq i64 %argc, 1
  br i1 %t1311, label %argok320, label %arityerr319
arityerr319:
  call void @rt_arity_error(i64 1, i64 %argc)
  unreachable
argok320:
  %t1312 = call i64 @rt_error_object_message(i64 %a0)
  ret i64 %t1312
}

define fastcc i64 @"scheme.base:code_332"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1317 = icmp eq i64 %argc, 1
  br i1 %t1317, label %argok322, label %arityerr321
arityerr321:
  call void @rt_arity_error(i64 1, i64 %argc)
  unreachable
argok322:
  %t1318 = call i64 @rt_error_object_irritants(i64 %a0)
  ret i64 %t1318
}

define fastcc i64 @"scheme.base:code_341"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1323 = icmp eq i64 %argc, 2
  br i1 %t1323, label %argok324, label %arityerr323
arityerr323:
  call void @rt_arity_error(i64 2, i64 %argc)
  unreachable
argok324:
  %t1324 = call i64 @rt_null_p(i64 %a0)
  %t1325 = icmp ne i64 %t1324, 1
  br i1 %t1325, label %then325, label %else326
then325:
  %t1326 = and i64 %self, -8
  %t1327 = inttoptr i64 %t1326 to ptr
  %t1328 = getelementptr i64, ptr %t1327, i64 1
  %t1329 = load i64, ptr %t1328
  ret i64 %t1329
else326:
  %t1330 = and i64 %self, -8
  %t1331 = inttoptr i64 %t1330 to ptr
  %t1332 = getelementptr i64, ptr %t1331, i64 1
  %t1333 = load i64, ptr %t1332
  %t1334 = call i64 @rt_car(i64 %a0)
  %t1335 = call i64 @rt_vector_set(i64 %t1333, i64 %a1, i64 %t1334)
  %t1336 = call i64 @rt_cdr(i64 %a0)
  %t1337 = or i64 %a1, 8
  %t1338 = and i64 %t1337, 7
  %t1339 = icmp eq i64 %t1338, 0
  br i1 %t1339, label %fixfast327, label %fixslow328
fixfast327:
  %t1340 = add i64 %a1, 8
  br label %fixmerge329
fixslow328:
  %t1341 = call i64 @rt_add(i64 %a1, i64 8)
  br label %fixmerge329
fixmerge329:
  %t1342 = phi i64 [ %t1340, %fixfast327 ], [ %t1341, %fixslow328 ]
  %t1343 = musttail call fastcc i64 @"scheme.base:code_341"(i64 %self, i64 2, i64 %t1336, i64 %t1342, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t1343
}

define fastcc i64 @"scheme.base:code_339"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1344 = icmp eq i64 %argc, 1
  br i1 %t1344, label %argok331, label %arityerr330
arityerr330:
  call void @rt_arity_error(i64 1, i64 %argc)
  unreachable
argok331:
  %t1345 = load i64, ptr @"scheme.base:length"
  %t1346 = and i64 %t1345, -8
  %t1347 = inttoptr i64 %t1346 to ptr
  %t1348 = load i64, ptr %t1347
  %t1349 = inttoptr i64 %t1348 to ptr
  %t1350 = call fastcc i64%t1349(i64 %t1345, i64 1, i64 %a0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t1351 = call i64 @rt_make_vector(i64 %t1350, i64 0)
  %t1352 = call i64 @rt_alloc_words(i64 3)
  %t1353 = inttoptr i64 %t1352 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_341" to i64), ptr %t1353
  %t1354 = or i64 %t1352, 4
  %t1355 = getelementptr i64, ptr %t1353, i64 1
  store i64 %t1351, ptr %t1355
  %t1356 = getelementptr i64, ptr %t1353, i64 2
  store i64 %t1354, ptr %t1356
  %t1357 = and i64 %t1354, -8
  %t1358 = inttoptr i64 %t1357 to ptr
  %t1359 = load i64, ptr %t1358
  %t1360 = inttoptr i64 %t1359 to ptr
  %t1361 = musttail call fastcc i64 %t1360(i64 %t1354, i64 2, i64 %a0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t1361
}

define fastcc i64 @"scheme.base:code_344"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1366 = icmp sge i64 %argc, 0
  br i1 %t1366, label %argok333, label %arityerr332
arityerr332:
  call void @rt_arity_error(i64 0, i64 %argc)
  unreachable
argok333:
  %t1367 = call i64 @rt_alloc_words(i64 8)
  %t1368 = inttoptr i64 %t1367 to ptr
  %t1369 = getelementptr i64, ptr %t1368, i64 0
  store i64 %a0, ptr %t1369
  %t1370 = getelementptr i64, ptr %t1368, i64 1
  store i64 %a1, ptr %t1370
  %t1371 = getelementptr i64, ptr %t1368, i64 2
  store i64 %a2, ptr %t1371
  %t1372 = getelementptr i64, ptr %t1368, i64 3
  store i64 %a3, ptr %t1372
  %t1373 = getelementptr i64, ptr %t1368, i64 4
  store i64 %a4, ptr %t1373
  %t1374 = getelementptr i64, ptr %t1368, i64 5
  store i64 %a5, ptr %t1374
  %t1375 = getelementptr i64, ptr %t1368, i64 6
  store i64 %a6, ptr %t1375
  %t1376 = getelementptr i64, ptr %t1368, i64 7
  store i64 %a7, ptr %t1376
  %t1377 = call i64 @rt_build_rest(i64 %argc, i64 0, i64 8, ptr %t1368, ptr %overflow)
  %t1378 = load i64, ptr @"scheme.base:list->vector"
  %t1379 = and i64 %t1378, -8
  %t1380 = inttoptr i64 %t1379 to ptr
  %t1381 = load i64, ptr %t1380
  %t1382 = inttoptr i64 %t1381 to ptr
  %t1383 = musttail call fastcc i64 %t1382(i64 %t1378, i64 1, i64 %t1377, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t1383
}

define fastcc i64 @"scheme.base:code_353"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1388 = icmp eq i64 %argc, 2
  br i1 %t1388, label %argok335, label %arityerr334
arityerr334:
  call void @rt_arity_error(i64 2, i64 %argc)
  unreachable
argok335:
  %t1389 = call i64 @rt_null_p(i64 %a0)
  %t1390 = icmp ne i64 %t1389, 1
  br i1 %t1390, label %then336, label %else337
then336:
  %t1391 = and i64 %self, -8
  %t1392 = inttoptr i64 %t1391 to ptr
  %t1393 = getelementptr i64, ptr %t1392, i64 1
  %t1394 = load i64, ptr %t1393
  ret i64 %t1394
else337:
  %t1395 = and i64 %self, -8
  %t1396 = inttoptr i64 %t1395 to ptr
  %t1397 = getelementptr i64, ptr %t1396, i64 1
  %t1398 = load i64, ptr %t1397
  %t1399 = call i64 @rt_car(i64 %a0)
  %t1400 = call i64 @rt_bytevector_u8_set(i64 %t1398, i64 %a1, i64 %t1399)
  %t1401 = call i64 @rt_cdr(i64 %a0)
  %t1402 = or i64 %a1, 8
  %t1403 = and i64 %t1402, 7
  %t1404 = icmp eq i64 %t1403, 0
  br i1 %t1404, label %fixfast338, label %fixslow339
fixfast338:
  %t1405 = add i64 %a1, 8
  br label %fixmerge340
fixslow339:
  %t1406 = call i64 @rt_add(i64 %a1, i64 8)
  br label %fixmerge340
fixmerge340:
  %t1407 = phi i64 [ %t1405, %fixfast338 ], [ %t1406, %fixslow339 ]
  %t1408 = musttail call fastcc i64 @"scheme.base:code_353"(i64 %self, i64 2, i64 %t1401, i64 %t1407, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t1408
}

define fastcc i64 @"scheme.base:code_351"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1409 = icmp eq i64 %argc, 1
  br i1 %t1409, label %argok342, label %arityerr341
arityerr341:
  call void @rt_arity_error(i64 1, i64 %argc)
  unreachable
argok342:
  %t1410 = load i64, ptr @"scheme.base:length"
  %t1411 = and i64 %t1410, -8
  %t1412 = inttoptr i64 %t1411 to ptr
  %t1413 = load i64, ptr %t1412
  %t1414 = inttoptr i64 %t1413 to ptr
  %t1415 = call fastcc i64%t1414(i64 %t1410, i64 1, i64 %a0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t1416 = call i64 @rt_make_bytevector(i64 %t1415, i64 0)
  %t1417 = call i64 @rt_alloc_words(i64 3)
  %t1418 = inttoptr i64 %t1417 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_353" to i64), ptr %t1418
  %t1419 = or i64 %t1417, 4
  %t1420 = getelementptr i64, ptr %t1418, i64 1
  store i64 %t1416, ptr %t1420
  %t1421 = getelementptr i64, ptr %t1418, i64 2
  store i64 %t1419, ptr %t1421
  %t1422 = and i64 %t1419, -8
  %t1423 = inttoptr i64 %t1422 to ptr
  %t1424 = load i64, ptr %t1423
  %t1425 = inttoptr i64 %t1424 to ptr
  %t1426 = musttail call fastcc i64 %t1425(i64 %t1419, i64 2, i64 %a0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t1426
}

define fastcc i64 @"scheme.base:code_356"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1431 = icmp sge i64 %argc, 0
  br i1 %t1431, label %argok344, label %arityerr343
arityerr343:
  call void @rt_arity_error(i64 0, i64 %argc)
  unreachable
argok344:
  %t1432 = call i64 @rt_alloc_words(i64 8)
  %t1433 = inttoptr i64 %t1432 to ptr
  %t1434 = getelementptr i64, ptr %t1433, i64 0
  store i64 %a0, ptr %t1434
  %t1435 = getelementptr i64, ptr %t1433, i64 1
  store i64 %a1, ptr %t1435
  %t1436 = getelementptr i64, ptr %t1433, i64 2
  store i64 %a2, ptr %t1436
  %t1437 = getelementptr i64, ptr %t1433, i64 3
  store i64 %a3, ptr %t1437
  %t1438 = getelementptr i64, ptr %t1433, i64 4
  store i64 %a4, ptr %t1438
  %t1439 = getelementptr i64, ptr %t1433, i64 5
  store i64 %a5, ptr %t1439
  %t1440 = getelementptr i64, ptr %t1433, i64 6
  store i64 %a6, ptr %t1440
  %t1441 = getelementptr i64, ptr %t1433, i64 7
  store i64 %a7, ptr %t1441
  %t1442 = call i64 @rt_build_rest(i64 %argc, i64 0, i64 8, ptr %t1433, ptr %overflow)
  %t1443 = load i64, ptr @"scheme.base:list->bytevector"
  %t1444 = and i64 %t1443, -8
  %t1445 = inttoptr i64 %t1444 to ptr
  %t1446 = load i64, ptr %t1445
  %t1447 = inttoptr i64 %t1446 to ptr
  %t1448 = musttail call fastcc i64 %t1447(i64 %t1443, i64 1, i64 %t1442, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t1448
}

define fastcc i64 @"scheme.base:code_359"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1453 = icmp sge i64 %argc, 0
  br i1 %t1453, label %argok346, label %arityerr345
arityerr345:
  call void @rt_arity_error(i64 0, i64 %argc)
  unreachable
argok346:
  %t1454 = call i64 @rt_alloc_words(i64 8)
  %t1455 = inttoptr i64 %t1454 to ptr
  %t1456 = getelementptr i64, ptr %t1455, i64 0
  store i64 %a0, ptr %t1456
  %t1457 = getelementptr i64, ptr %t1455, i64 1
  store i64 %a1, ptr %t1457
  %t1458 = getelementptr i64, ptr %t1455, i64 2
  store i64 %a2, ptr %t1458
  %t1459 = getelementptr i64, ptr %t1455, i64 3
  store i64 %a3, ptr %t1459
  %t1460 = getelementptr i64, ptr %t1455, i64 4
  store i64 %a4, ptr %t1460
  %t1461 = getelementptr i64, ptr %t1455, i64 5
  store i64 %a5, ptr %t1461
  %t1462 = getelementptr i64, ptr %t1455, i64 6
  store i64 %a6, ptr %t1462
  %t1463 = getelementptr i64, ptr %t1455, i64 7
  store i64 %a7, ptr %t1463
  %t1464 = call i64 @rt_build_rest(i64 %argc, i64 0, i64 8, ptr %t1455, ptr %overflow)
  %t1465 = call i64 @rt_pair_p(i64 %t1464)
  %t1466 = icmp ne i64 %t1465, 1
  br i1 %t1466, label %then347, label %else348
then347:
  %t1467 = call i64 @rt_cdr(i64 %t1464)
  %t1468 = call i64 @rt_null_p(i64 %t1467)
  br label %merge349
else348:
  br label %merge349
merge349:
  %t1469 = phi i64 [ %t1468, %then347 ], [ 1, %else348 ]
  %t1470 = icmp ne i64 %t1469, 1
  br i1 %t1470, label %then350, label %else351
then350:
  %t1471 = call i64 @rt_car(i64 %t1464)
  ret i64 %t1471
else351:
  %t1472 = call i64 @rt_list_to_mv(i64 %t1464)
  ret i64 %t1472
}

define fastcc i64 @"scheme.base:code_364"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1477 = icmp eq i64 %argc, 2
  br i1 %t1477, label %argok353, label %arityerr352
arityerr352:
  call void @rt_arity_error(i64 2, i64 %argc)
  unreachable
argok353:
  %t1478 = and i64 %a0, -8
  %t1479 = inttoptr i64 %t1478 to ptr
  %t1480 = load i64, ptr %t1479
  %t1481 = inttoptr i64 %t1480 to ptr
  %t1482 = call fastcc i64%t1481(i64 %a0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t1483 = call i64 @rt_mv_p(i64 %t1482)
  %t1484 = icmp ne i64 %t1483, 1
  br i1 %t1484, label %then354, label %else355
then354:
  %t1485 = call i64 @rt_mv_to_list(i64 %t1482)
  %t1486 = and i64 %a1, -8
  %t1487 = inttoptr i64 %t1486 to ptr
  %t1488 = load i64, ptr %t1487
  %t1489 = inttoptr i64 %t1488 to ptr
  %t1490 = call i64 @rt_list_length(i64 %t1485)
  %t1491 = add i64 0, %t1490
  %t1492 = call ptr @rt_apply_argv(i64 0, ptr null, i64 %t1485, i64 8)
  %t1504 = getelementptr i64, ptr %t1492, i64 0
  %t1496 = load i64, ptr %t1504
  %t1505 = getelementptr i64, ptr %t1492, i64 1
  %t1497 = load i64, ptr %t1505
  %t1506 = getelementptr i64, ptr %t1492, i64 2
  %t1498 = load i64, ptr %t1506
  %t1507 = getelementptr i64, ptr %t1492, i64 3
  %t1499 = load i64, ptr %t1507
  %t1508 = getelementptr i64, ptr %t1492, i64 4
  %t1500 = load i64, ptr %t1508
  %t1509 = getelementptr i64, ptr %t1492, i64 5
  %t1501 = load i64, ptr %t1509
  %t1510 = getelementptr i64, ptr %t1492, i64 6
  %t1502 = load i64, ptr %t1510
  %t1511 = getelementptr i64, ptr %t1492, i64 7
  %t1503 = load i64, ptr %t1511
  %t1493 = icmp sgt i64 %t1491, 8
  %t1494 = getelementptr i64, ptr %t1492, i64 8
  %t1495 = select i1 %t1493, ptr %t1494, ptr null
  %t1512 = musttail call fastcc i64 %t1489(i64 %a1, i64 %t1491, i64 %t1496, i64 %t1497, i64 %t1498, i64 %t1499, i64 %t1500, i64 %t1501, i64 %t1502, i64 %t1503, ptr %t1495)
  ret i64 %t1512
else355:
  %t1513 = and i64 %a1, -8
  %t1514 = inttoptr i64 %t1513 to ptr
  %t1515 = load i64, ptr %t1514
  %t1516 = inttoptr i64 %t1515 to ptr
  %t1517 = musttail call fastcc i64 %t1516(i64 %a1, i64 1, i64 %t1482, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t1517
}

define fastcc i64 @"scheme.base:code_366"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1524 = icmp eq i64 %argc, 0
  br i1 %t1524, label %argok357, label %arityerr356
arityerr356:
  call void @rt_arity_error(i64 0, i64 %argc)
  unreachable
argok357:
  %t1525 = load i64, ptr @"scheme.base:%ht-initial-buckets"
  %t1526 = call i64 @rt_make_vector(i64 %t1525, i64 2)
  %t1527 = load i64, ptr @"scheme.base:vector"
  %t1528 = and i64 %t1527, -8
  %t1529 = inttoptr i64 %t1528 to ptr
  %t1530 = load i64, ptr %t1529
  %t1531 = inttoptr i64 %t1530 to ptr
  %t1532 = call fastcc i64%t1531(i64 %t1527, i64 3, i64 0, i64 %t1526, i64 1, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t1533 = call i64 @rt_make_hash_table(i64 %t1532)
  ret i64 %t1533
}

define fastcc i64 @"scheme.base:code_369"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1538 = icmp eq i64 %argc, 1
  br i1 %t1538, label %argok359, label %arityerr358
arityerr358:
  call void @rt_arity_error(i64 1, i64 %argc)
  unreachable
argok359:
  %t1539 = call i64 @rt_hash_table_p(i64 %a0)
  ret i64 %t1539
}

define fastcc i64 @"scheme.base:code_372"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1544 = icmp eq i64 %argc, 1
  br i1 %t1544, label %argok361, label %arityerr360
arityerr360:
  call void @rt_arity_error(i64 1, i64 %argc)
  unreachable
argok361:
  %t1545 = call i64 @rt_hash_table_spine(i64 %a0)
  %t1546 = call i64 @rt_vector_ref(i64 %t1545, i64 0)
  ret i64 %t1546
}

define fastcc i64 @"scheme.base:code_375"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1551 = icmp eq i64 %argc, 1
  br i1 %t1551, label %argok363, label %arityerr362
arityerr362:
  call void @rt_arity_error(i64 1, i64 %argc)
  unreachable
argok363:
  %t1552 = call i64 @rt_hash_table_spine(i64 %a0)
  %t1553 = call i64 @rt_vector_ref(i64 %t1552, i64 8)
  ret i64 %t1553
}

define fastcc i64 @"scheme.base:code_379"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1558 = icmp eq i64 %argc, 2
  br i1 %t1558, label %argok365, label %arityerr364
arityerr364:
  call void @rt_arity_error(i64 2, i64 %argc)
  unreachable
argok365:
  %t1559 = call i64 @rt_hash_table_spine(i64 %a0)
  %t1560 = call i64 @rt_vector_set(i64 %t1559, i64 0, i64 %a1)
  ret i64 %t1560
}

define fastcc i64 @"scheme.base:code_383"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1565 = icmp eq i64 %argc, 2
  br i1 %t1565, label %argok367, label %arityerr366
arityerr366:
  call void @rt_arity_error(i64 2, i64 %argc)
  unreachable
argok367:
  %t1566 = call i64 @rt_hash_table_spine(i64 %a0)
  %t1567 = call i64 @rt_vector_set(i64 %t1566, i64 8, i64 %a1)
  ret i64 %t1567
}

define fastcc i64 @"scheme.base:code_387"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1572 = icmp eq i64 %argc, 2
  br i1 %t1572, label %argok369, label %arityerr368
arityerr368:
  call void @rt_arity_error(i64 2, i64 %argc)
  unreachable
argok369:
  %t1573 = call i64 @rt_hash(i64 %a0)
  %t1574 = call i64 @rt_remainder(i64 %t1573, i64 %a1)
  ret i64 %t1574
}

define fastcc i64 @"scheme.base:code_391"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1579 = icmp eq i64 %argc, 2
  br i1 %t1579, label %argok371, label %arityerr370
arityerr370:
  call void @rt_arity_error(i64 2, i64 %argc)
  unreachable
argok371:
  %t1580 = call i64 @rt_null_p(i64 %a1)
  %t1581 = icmp ne i64 %t1580, 1
  br i1 %t1581, label %then372, label %else373
then372:
  ret i64 1
else373:
  %t1582 = call i64 @rt_car(i64 %a1)
  %t1583 = call i64 @rt_car(i64 %t1582)
  %t1584 = call i64 @rt_equal(i64 %a0, i64 %t1583)
  %t1585 = icmp ne i64 %t1584, 1
  br i1 %t1585, label %then374, label %else375
then374:
  %t1586 = call i64 @rt_car(i64 %a1)
  ret i64 %t1586
else375:
  %t1587 = call i64 @rt_cdr(i64 %a1)
  %t1588 = load i64, ptr @"scheme.base:%ht-assoc"
  %t1589 = and i64 %t1588, -8
  %t1590 = inttoptr i64 %t1589 to ptr
  %t1591 = load i64, ptr %t1590
  %t1592 = inttoptr i64 %t1591 to ptr
  %t1593 = musttail call fastcc i64 %t1592(i64 %t1588, i64 2, i64 %a0, i64 %t1587, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t1593
}

define fastcc i64 @"scheme.base:code_395"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1598 = icmp eq i64 %argc, 2
  br i1 %t1598, label %argok377, label %arityerr376
arityerr376:
  call void @rt_arity_error(i64 2, i64 %argc)
  unreachable
argok377:
  %t1599 = call i64 @rt_null_p(i64 %a1)
  %t1600 = icmp ne i64 %t1599, 1
  br i1 %t1600, label %then378, label %else379
then378:
  ret i64 2
else379:
  %t1601 = call i64 @rt_car(i64 %a1)
  %t1602 = call i64 @rt_car(i64 %t1601)
  %t1603 = call i64 @rt_equal(i64 %a0, i64 %t1602)
  %t1604 = icmp ne i64 %t1603, 1
  br i1 %t1604, label %then380, label %else381
then380:
  %t1605 = call i64 @rt_cdr(i64 %a1)
  ret i64 %t1605
else381:
  %t1606 = call i64 @rt_car(i64 %a1)
  %t1607 = call i64 @rt_cdr(i64 %a1)
  %t1608 = load i64, ptr @"scheme.base:%ht-remove"
  %t1609 = and i64 %t1608, -8
  %t1610 = inttoptr i64 %t1609 to ptr
  %t1611 = load i64, ptr %t1610
  %t1612 = inttoptr i64 %t1611 to ptr
  %t1613 = call fastcc i64%t1612(i64 %t1608, i64 2, i64 %a0, i64 %t1607, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t1614 = call i64 @rt_cons(i64 %t1606, i64 %t1613)
  ret i64 %t1614
}

define fastcc i64 @"scheme.base:code_402"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1619 = icmp eq i64 %argc, 3
  br i1 %t1619, label %argok383, label %arityerr382
arityerr382:
  call void @rt_arity_error(i64 3, i64 %argc)
  unreachable
argok383:
  %t1620 = load i64, ptr @"scheme.base:%ht-buckets"
  %t1621 = and i64 %t1620, -8
  %t1622 = inttoptr i64 %t1621 to ptr
  %t1623 = load i64, ptr %t1622
  %t1624 = inttoptr i64 %t1623 to ptr
  %t1625 = call fastcc i64%t1624(i64 %t1620, i64 1, i64 %a0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t1626 = call i64 @rt_vector_length(i64 %t1625)
  %t1627 = load i64, ptr @"scheme.base:%ht-index"
  %t1628 = and i64 %t1627, -8
  %t1629 = inttoptr i64 %t1628 to ptr
  %t1630 = load i64, ptr %t1629
  %t1631 = inttoptr i64 %t1630 to ptr
  %t1632 = call fastcc i64%t1631(i64 %t1627, i64 2, i64 %a1, i64 %t1626, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t1633 = call i64 @rt_vector_ref(i64 %t1625, i64 %t1632)
  %t1634 = load i64, ptr @"scheme.base:%ht-assoc"
  %t1635 = and i64 %t1634, -8
  %t1636 = inttoptr i64 %t1635 to ptr
  %t1637 = load i64, ptr %t1636
  %t1638 = inttoptr i64 %t1637 to ptr
  %t1639 = call fastcc i64%t1638(i64 %t1634, i64 2, i64 %a1, i64 %t1633, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t1640 = icmp ne i64 %t1639, 1
  br i1 %t1640, label %then384, label %else385
then384:
  %t1641 = call i64 @rt_cdr(i64 %t1639)
  ret i64 %t1641
else385:
  ret i64 %a2
}

define fastcc i64 @"scheme.base:code_407"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1646 = icmp eq i64 %argc, 2
  br i1 %t1646, label %argok387, label %arityerr386
arityerr386:
  call void @rt_arity_error(i64 2, i64 %argc)
  unreachable
argok387:
  %t1647 = load i64, ptr @"scheme.base:%ht-buckets"
  %t1648 = and i64 %t1647, -8
  %t1649 = inttoptr i64 %t1648 to ptr
  %t1650 = load i64, ptr %t1649
  %t1651 = inttoptr i64 %t1650 to ptr
  %t1652 = call fastcc i64%t1651(i64 %t1647, i64 1, i64 %a0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t1653 = call i64 @rt_vector_length(i64 %t1652)
  %t1654 = load i64, ptr @"scheme.base:%ht-index"
  %t1655 = and i64 %t1654, -8
  %t1656 = inttoptr i64 %t1655 to ptr
  %t1657 = load i64, ptr %t1656
  %t1658 = inttoptr i64 %t1657 to ptr
  %t1659 = call fastcc i64%t1658(i64 %t1654, i64 2, i64 %a1, i64 %t1653, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t1660 = call i64 @rt_vector_ref(i64 %t1652, i64 %t1659)
  %t1661 = load i64, ptr @"scheme.base:%ht-assoc"
  %t1662 = and i64 %t1661, -8
  %t1663 = inttoptr i64 %t1662 to ptr
  %t1664 = load i64, ptr %t1663
  %t1665 = inttoptr i64 %t1664 to ptr
  %t1666 = call fastcc i64%t1665(i64 %t1661, i64 2, i64 %a1, i64 %t1660, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t1667 = icmp ne i64 %t1666, 1
  br i1 %t1667, label %then388, label %else389
then388:
  ret i64 257
else389:
  ret i64 1
}

define fastcc i64 @"scheme.base:code_413"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1672 = icmp eq i64 %argc, 2
  br i1 %t1672, label %argok391, label %arityerr390
arityerr390:
  call void @rt_arity_error(i64 2, i64 %argc)
  unreachable
argok391:
  %t1673 = load i64, ptr @"scheme.base:%ht-buckets"
  %t1674 = and i64 %t1673, -8
  %t1675 = inttoptr i64 %t1674 to ptr
  %t1676 = load i64, ptr %t1675
  %t1677 = inttoptr i64 %t1676 to ptr
  %t1678 = call fastcc i64%t1677(i64 %t1673, i64 1, i64 %a0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t1679 = call i64 @rt_vector_length(i64 %t1678)
  %t1680 = load i64, ptr @"scheme.base:%ht-index"
  %t1681 = and i64 %t1680, -8
  %t1682 = inttoptr i64 %t1681 to ptr
  %t1683 = load i64, ptr %t1682
  %t1684 = inttoptr i64 %t1683 to ptr
  %t1685 = call fastcc i64%t1684(i64 %t1680, i64 2, i64 %a1, i64 %t1679, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t1686 = call i64 @rt_vector_ref(i64 %t1678, i64 %t1685)
  %t1687 = load i64, ptr @"scheme.base:%ht-assoc"
  %t1688 = and i64 %t1687, -8
  %t1689 = inttoptr i64 %t1688 to ptr
  %t1690 = load i64, ptr %t1689
  %t1691 = inttoptr i64 %t1690 to ptr
  %t1692 = call fastcc i64%t1691(i64 %t1687, i64 2, i64 %a1, i64 %t1686, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t1693 = icmp ne i64 %t1692, 1
  br i1 %t1693, label %then392, label %else393
then392:
  %t1694 = call i64 @rt_cdr(i64 %t1692)
  ret i64 %t1694
else393:
  %t1695 = call i64 @rt_make_string(ptr @.str.lit.3, i64 29)
  %t1696 = load i64, ptr @"scheme.base:error"
  %t1697 = and i64 %t1696, -8
  %t1698 = inttoptr i64 %t1697 to ptr
  %t1699 = load i64, ptr %t1698
  %t1700 = inttoptr i64 %t1699 to ptr
  %t1701 = musttail call fastcc i64 %t1700(i64 %t1696, i64 2, i64 %t1695, i64 %a1, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t1701
}

define fastcc i64 @"scheme.base:code_427"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1706 = icmp eq i64 %argc, 3
  br i1 %t1706, label %argok395, label %arityerr394
arityerr394:
  call void @rt_arity_error(i64 3, i64 %argc)
  unreachable
argok395:
  %t1707 = load i64, ptr @"scheme.base:%ht-buckets"
  %t1708 = and i64 %t1707, -8
  %t1709 = inttoptr i64 %t1708 to ptr
  %t1710 = load i64, ptr %t1709
  %t1711 = inttoptr i64 %t1710 to ptr
  %t1712 = call fastcc i64%t1711(i64 %t1707, i64 1, i64 %a0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t1713 = call i64 @rt_vector_length(i64 %t1712)
  %t1714 = load i64, ptr @"scheme.base:%ht-index"
  %t1715 = and i64 %t1714, -8
  %t1716 = inttoptr i64 %t1715 to ptr
  %t1717 = load i64, ptr %t1716
  %t1718 = inttoptr i64 %t1717 to ptr
  %t1719 = call fastcc i64%t1718(i64 %t1714, i64 2, i64 %a1, i64 %t1713, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t1720 = call i64 @rt_vector_ref(i64 %t1712, i64 %t1719)
  %t1721 = load i64, ptr @"scheme.base:%ht-assoc"
  %t1722 = and i64 %t1721, -8
  %t1723 = inttoptr i64 %t1722 to ptr
  %t1724 = load i64, ptr %t1723
  %t1725 = inttoptr i64 %t1724 to ptr
  %t1726 = call fastcc i64%t1725(i64 %t1721, i64 2, i64 %a1, i64 %t1720, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t1727 = call i64 @rt_cons(i64 %a1, i64 %a2)
  %t1728 = icmp ne i64 %t1726, 1
  br i1 %t1728, label %then396, label %else397
then396:
  %t1729 = load i64, ptr @"scheme.base:%ht-remove"
  %t1730 = and i64 %t1729, -8
  %t1731 = inttoptr i64 %t1730 to ptr
  %t1732 = load i64, ptr %t1731
  %t1733 = inttoptr i64 %t1732 to ptr
  %t1734 = call fastcc i64%t1733(i64 %t1729, i64 2, i64 %a1, i64 %t1720, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  br label %merge398
else397:
  br label %merge398
merge398:
  %t1735 = phi i64 [ %t1734, %then396 ], [ %t1720, %else397 ]
  %t1736 = call i64 @rt_cons(i64 %t1727, i64 %t1735)
  %t1737 = call i64 @rt_vector_set(i64 %t1712, i64 %t1719, i64 %t1736)
  %t1738 = icmp ne i64 %t1726, 1
  br i1 %t1738, label %then399, label %else400
then399:
  ret i64 1
else400:
  %t1739 = load i64, ptr @"scheme.base:%ht-count"
  %t1740 = and i64 %t1739, -8
  %t1741 = inttoptr i64 %t1740 to ptr
  %t1742 = load i64, ptr %t1741
  %t1743 = inttoptr i64 %t1742 to ptr
  %t1744 = call fastcc i64%t1743(i64 %t1739, i64 1, i64 %a0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t1745 = or i64 %t1744, 8
  %t1746 = and i64 %t1745, 7
  %t1747 = icmp eq i64 %t1746, 0
  br i1 %t1747, label %fixfast401, label %fixslow402
fixfast401:
  %t1748 = add i64 %t1744, 8
  br label %fixmerge403
fixslow402:
  %t1749 = call i64 @rt_add(i64 %t1744, i64 8)
  br label %fixmerge403
fixmerge403:
  %t1750 = phi i64 [ %t1748, %fixfast401 ], [ %t1749, %fixslow402 ]
  %t1751 = load i64, ptr @"scheme.base:%ht-set-count!"
  %t1752 = and i64 %t1751, -8
  %t1753 = inttoptr i64 %t1752 to ptr
  %t1754 = load i64, ptr %t1753
  %t1755 = inttoptr i64 %t1754 to ptr
  %t1756 = call fastcc i64%t1755(i64 %t1751, i64 2, i64 %a0, i64 %t1750, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t1757 = load i64, ptr @"scheme.base:%ht-count"
  %t1758 = and i64 %t1757, -8
  %t1759 = inttoptr i64 %t1758 to ptr
  %t1760 = load i64, ptr %t1759
  %t1761 = inttoptr i64 %t1760 to ptr
  %t1762 = call fastcc i64%t1761(i64 %t1757, i64 1, i64 %a0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t1763 = load i64, ptr @"scheme.base:%ht-load-factor"
  %t1764 = or i64 %t1763, %t1713
  %t1765 = and i64 %t1764, 7
  %t1766 = icmp eq i64 %t1765, 0
  br i1 %t1766, label %fixfast404, label %fixslow405
fixfast404:
  %t1767 = ashr i64 %t1763, 3
  %t1768 = mul i64 %t1767, %t1713
  br label %fixmerge406
fixslow405:
  %t1769 = call i64 @rt_mul(i64 %t1763, i64 %t1713)
  br label %fixmerge406
fixmerge406:
  %t1770 = phi i64 [ %t1768, %fixfast404 ], [ %t1769, %fixslow405 ]
  %t1771 = or i64 %t1770, %t1762
  %t1772 = and i64 %t1771, 7
  %t1773 = icmp eq i64 %t1772, 0
  br i1 %t1773, label %fixfast407, label %fixslow408
fixfast407:
  %t1774 = icmp slt i64 %t1770, %t1762
  %t1775 = select i1 %t1774, i64 257, i64 1
  br label %fixmerge409
fixslow408:
  %t1776 = call i64 @rt_lt(i64 %t1770, i64 %t1762)
  br label %fixmerge409
fixmerge409:
  %t1777 = phi i64 [ %t1775, %fixfast407 ], [ %t1776, %fixslow408 ]
  %t1778 = icmp ne i64 %t1777, 1
  br i1 %t1778, label %then410, label %else411
then410:
  %t1779 = load i64, ptr @"scheme.base:%ht-grow!"
  %t1780 = and i64 %t1779, -8
  %t1781 = inttoptr i64 %t1780 to ptr
  %t1782 = load i64, ptr %t1781
  %t1783 = inttoptr i64 %t1782 to ptr
  %t1784 = musttail call fastcc i64 %t1783(i64 %t1779, i64 1, i64 %a0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t1784
else411:
  ret i64 1
}

define fastcc i64 @"scheme.base:code_434"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1789 = icmp eq i64 %argc, 2
  br i1 %t1789, label %argok413, label %arityerr412
arityerr412:
  call void @rt_arity_error(i64 2, i64 %argc)
  unreachable
argok413:
  %t1790 = load i64, ptr @"scheme.base:%ht-buckets"
  %t1791 = and i64 %t1790, -8
  %t1792 = inttoptr i64 %t1791 to ptr
  %t1793 = load i64, ptr %t1792
  %t1794 = inttoptr i64 %t1793 to ptr
  %t1795 = call fastcc i64%t1794(i64 %t1790, i64 1, i64 %a0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t1796 = call i64 @rt_vector_length(i64 %t1795)
  %t1797 = load i64, ptr @"scheme.base:%ht-index"
  %t1798 = and i64 %t1797, -8
  %t1799 = inttoptr i64 %t1798 to ptr
  %t1800 = load i64, ptr %t1799
  %t1801 = inttoptr i64 %t1800 to ptr
  %t1802 = call fastcc i64%t1801(i64 %t1797, i64 2, i64 %a1, i64 %t1796, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t1803 = call i64 @rt_vector_ref(i64 %t1795, i64 %t1802)
  %t1804 = load i64, ptr @"scheme.base:%ht-assoc"
  %t1805 = and i64 %t1804, -8
  %t1806 = inttoptr i64 %t1805 to ptr
  %t1807 = load i64, ptr %t1806
  %t1808 = inttoptr i64 %t1807 to ptr
  %t1809 = call fastcc i64%t1808(i64 %t1804, i64 2, i64 %a1, i64 %t1803, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t1810 = icmp ne i64 %t1809, 1
  br i1 %t1810, label %then414, label %else415
then414:
  %t1811 = load i64, ptr @"scheme.base:%ht-remove"
  %t1812 = and i64 %t1811, -8
  %t1813 = inttoptr i64 %t1812 to ptr
  %t1814 = load i64, ptr %t1813
  %t1815 = inttoptr i64 %t1814 to ptr
  %t1816 = call fastcc i64%t1815(i64 %t1811, i64 2, i64 %a1, i64 %t1803, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t1817 = call i64 @rt_vector_set(i64 %t1795, i64 %t1802, i64 %t1816)
  %t1818 = load i64, ptr @"scheme.base:%ht-count"
  %t1819 = and i64 %t1818, -8
  %t1820 = inttoptr i64 %t1819 to ptr
  %t1821 = load i64, ptr %t1820
  %t1822 = inttoptr i64 %t1821 to ptr
  %t1823 = call fastcc i64%t1822(i64 %t1818, i64 1, i64 %a0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t1824 = or i64 %t1823, 8
  %t1825 = and i64 %t1824, 7
  %t1826 = icmp eq i64 %t1825, 0
  br i1 %t1826, label %fixfast416, label %fixslow417
fixfast416:
  %t1827 = sub i64 %t1823, 8
  br label %fixmerge418
fixslow417:
  %t1828 = call i64 @rt_sub(i64 %t1823, i64 8)
  br label %fixmerge418
fixmerge418:
  %t1829 = phi i64 [ %t1827, %fixfast416 ], [ %t1828, %fixslow417 ]
  %t1830 = load i64, ptr @"scheme.base:%ht-set-count!"
  %t1831 = and i64 %t1830, -8
  %t1832 = inttoptr i64 %t1831 to ptr
  %t1833 = load i64, ptr %t1832
  %t1834 = inttoptr i64 %t1833 to ptr
  %t1835 = musttail call fastcc i64 %t1834(i64 %t1830, i64 2, i64 %a0, i64 %t1829, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t1835
else415:
  ret i64 1
}

define fastcc i64 @"scheme.base:code_454"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1840 = icmp eq i64 %argc, 1
  br i1 %t1840, label %argok420, label %arityerr419
arityerr419:
  call void @rt_arity_error(i64 1, i64 %argc)
  unreachable
argok420:
  %t1841 = call i64 @rt_null_p(i64 %a0)
  %t1842 = icmp ne i64 %t1841, 1
  br i1 %t1842, label %then421, label %else422
then421:
  ret i64 1
else422:
  %t1843 = call i64 @rt_car(i64 %a0)
  %t1844 = call i64 @rt_car(i64 %t1843)
  %t1845 = and i64 %self, -8
  %t1846 = inttoptr i64 %t1845 to ptr
  %t1847 = getelementptr i64, ptr %t1846, i64 1
  %t1848 = load i64, ptr %t1847
  %t1849 = load i64, ptr @"scheme.base:%ht-index"
  %t1850 = and i64 %t1849, -8
  %t1851 = inttoptr i64 %t1850 to ptr
  %t1852 = load i64, ptr %t1851
  %t1853 = inttoptr i64 %t1852 to ptr
  %t1854 = call fastcc i64%t1853(i64 %t1849, i64 2, i64 %t1844, i64 %t1848, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t1855 = and i64 %self, -8
  %t1856 = inttoptr i64 %t1855 to ptr
  %t1857 = getelementptr i64, ptr %t1856, i64 2
  %t1858 = load i64, ptr %t1857
  %t1859 = and i64 %self, -8
  %t1860 = inttoptr i64 %t1859 to ptr
  %t1861 = getelementptr i64, ptr %t1860, i64 2
  %t1862 = load i64, ptr %t1861
  %t1863 = call i64 @rt_vector_ref(i64 %t1862, i64 %t1854)
  %t1864 = call i64 @rt_cons(i64 %t1843, i64 %t1863)
  %t1865 = call i64 @rt_vector_set(i64 %t1858, i64 %t1854, i64 %t1864)
  %t1866 = call i64 @rt_cdr(i64 %a0)
  %t1867 = musttail call fastcc i64 @"scheme.base:code_454"(i64 %self, i64 1, i64 %t1866, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t1867
}

define fastcc i64 @"scheme.base:code_452"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1868 = icmp eq i64 %argc, 1
  br i1 %t1868, label %argok424, label %arityerr423
arityerr423:
  call void @rt_arity_error(i64 1, i64 %argc)
  unreachable
argok424:
  %t1869 = and i64 %self, -8
  %t1870 = inttoptr i64 %t1869 to ptr
  %t1871 = getelementptr i64, ptr %t1870, i64 1
  %t1872 = load i64, ptr %t1871
  %t1873 = call i64 @rt_vector_length(i64 %t1872)
  %t1874 = or i64 %a0, %t1873
  %t1875 = and i64 %t1874, 7
  %t1876 = icmp eq i64 %t1875, 0
  br i1 %t1876, label %fixfast425, label %fixslow426
fixfast425:
  %t1877 = icmp slt i64 %a0, %t1873
  %t1878 = select i1 %t1877, i64 257, i64 1
  br label %fixmerge427
fixslow426:
  %t1879 = call i64 @rt_lt(i64 %a0, i64 %t1873)
  br label %fixmerge427
fixmerge427:
  %t1880 = phi i64 [ %t1878, %fixfast425 ], [ %t1879, %fixslow426 ]
  %t1881 = icmp ne i64 %t1880, 1
  br i1 %t1881, label %then428, label %else429
then428:
  %t1882 = call i64 @rt_alloc_words(i64 4)
  %t1883 = inttoptr i64 %t1882 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_454" to i64), ptr %t1883
  %t1884 = or i64 %t1882, 4
  %t1885 = and i64 %self, -8
  %t1886 = inttoptr i64 %t1885 to ptr
  %t1887 = getelementptr i64, ptr %t1886, i64 2
  %t1888 = load i64, ptr %t1887
  %t1889 = getelementptr i64, ptr %t1883, i64 1
  store i64 %t1888, ptr %t1889
  %t1890 = and i64 %self, -8
  %t1891 = inttoptr i64 %t1890 to ptr
  %t1892 = getelementptr i64, ptr %t1891, i64 3
  %t1893 = load i64, ptr %t1892
  %t1894 = getelementptr i64, ptr %t1883, i64 2
  store i64 %t1893, ptr %t1894
  %t1895 = getelementptr i64, ptr %t1883, i64 3
  store i64 %t1884, ptr %t1895
  %t1896 = and i64 %self, -8
  %t1897 = inttoptr i64 %t1896 to ptr
  %t1898 = getelementptr i64, ptr %t1897, i64 1
  %t1899 = load i64, ptr %t1898
  %t1900 = call i64 @rt_vector_ref(i64 %t1899, i64 %a0)
  %t1901 = and i64 %t1884, -8
  %t1902 = inttoptr i64 %t1901 to ptr
  %t1903 = load i64, ptr %t1902
  %t1904 = inttoptr i64 %t1903 to ptr
  %t1905 = call fastcc i64%t1904(i64 %t1884, i64 1, i64 %t1900, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t1906 = or i64 %a0, 8
  %t1907 = and i64 %t1906, 7
  %t1908 = icmp eq i64 %t1907, 0
  br i1 %t1908, label %fixfast430, label %fixslow431
fixfast430:
  %t1909 = add i64 %a0, 8
  br label %fixmerge432
fixslow431:
  %t1910 = call i64 @rt_add(i64 %a0, i64 8)
  br label %fixmerge432
fixmerge432:
  %t1911 = phi i64 [ %t1909, %fixfast430 ], [ %t1910, %fixslow431 ]
  %t1912 = musttail call fastcc i64 @"scheme.base:code_452"(i64 %self, i64 1, i64 %t1911, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t1912
else429:
  ret i64 1
}

define fastcc i64 @"scheme.base:code_450"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1913 = icmp eq i64 %argc, 1
  br i1 %t1913, label %argok434, label %arityerr433
arityerr433:
  call void @rt_arity_error(i64 1, i64 %argc)
  unreachable
argok434:
  %t1914 = load i64, ptr @"scheme.base:%ht-buckets"
  %t1915 = and i64 %t1914, -8
  %t1916 = inttoptr i64 %t1915 to ptr
  %t1917 = load i64, ptr %t1916
  %t1918 = inttoptr i64 %t1917 to ptr
  %t1919 = call fastcc i64%t1918(i64 %t1914, i64 1, i64 %a0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t1920 = call i64 @rt_vector_length(i64 %t1919)
  %t1921 = or i64 16, %t1920
  %t1922 = and i64 %t1921, 7
  %t1923 = icmp eq i64 %t1922, 0
  br i1 %t1923, label %fixfast435, label %fixslow436
fixfast435:
  %t1924 = ashr i64 16, 3
  %t1925 = mul i64 %t1924, %t1920
  br label %fixmerge437
fixslow436:
  %t1926 = call i64 @rt_mul(i64 16, i64 %t1920)
  br label %fixmerge437
fixmerge437:
  %t1927 = phi i64 [ %t1925, %fixfast435 ], [ %t1926, %fixslow436 ]
  %t1928 = call i64 @rt_make_vector(i64 %t1927, i64 2)
  %t1929 = call i64 @rt_alloc_words(i64 5)
  %t1930 = inttoptr i64 %t1929 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_452" to i64), ptr %t1930
  %t1931 = or i64 %t1929, 4
  %t1932 = getelementptr i64, ptr %t1930, i64 1
  store i64 %t1919, ptr %t1932
  %t1933 = getelementptr i64, ptr %t1930, i64 2
  store i64 %t1927, ptr %t1933
  %t1934 = getelementptr i64, ptr %t1930, i64 3
  store i64 %t1928, ptr %t1934
  %t1935 = getelementptr i64, ptr %t1930, i64 4
  store i64 %t1931, ptr %t1935
  %t1936 = and i64 %t1931, -8
  %t1937 = inttoptr i64 %t1936 to ptr
  %t1938 = load i64, ptr %t1937
  %t1939 = inttoptr i64 %t1938 to ptr
  %t1940 = call fastcc i64%t1939(i64 %t1931, i64 1, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t1941 = load i64, ptr @"scheme.base:%ht-set-buckets!"
  %t1942 = and i64 %t1941, -8
  %t1943 = inttoptr i64 %t1942 to ptr
  %t1944 = load i64, ptr %t1943
  %t1945 = inttoptr i64 %t1944 to ptr
  %t1946 = musttail call fastcc i64 %t1945(i64 %t1941, i64 2, i64 %a0, i64 %t1928, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t1946
}

define fastcc i64 @"scheme.base:code_457"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1951 = icmp eq i64 %argc, 1
  br i1 %t1951, label %argok439, label %arityerr438
arityerr438:
  call void @rt_arity_error(i64 1, i64 %argc)
  unreachable
argok439:
  %t1952 = load i64, ptr @"scheme.base:%ht-count"
  %t1953 = and i64 %t1952, -8
  %t1954 = inttoptr i64 %t1953 to ptr
  %t1955 = load i64, ptr %t1954
  %t1956 = inttoptr i64 %t1955 to ptr
  %t1957 = musttail call fastcc i64 %t1956(i64 %t1952, i64 1, i64 %a0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t1957
}

define fastcc i64 @"scheme.base:code_461"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1962 = icmp eq i64 %argc, 2
  br i1 %t1962, label %argok441, label %arityerr440
arityerr440:
  call void @rt_arity_error(i64 2, i64 %argc)
  unreachable
argok441:
  %t1963 = call i64 @rt_null_p(i64 %a0)
  %t1964 = icmp ne i64 %t1963, 1
  br i1 %t1964, label %then442, label %else443
then442:
  ret i64 %a1
else443:
  %t1965 = call i64 @rt_car(i64 %a0)
  %t1966 = call i64 @rt_car(i64 %t1965)
  %t1967 = call i64 @rt_car(i64 %a0)
  %t1968 = call i64 @rt_cdr(i64 %t1967)
  %t1969 = call i64 @rt_cons(i64 %t1966, i64 %t1968)
  %t1970 = call i64 @rt_cdr(i64 %a0)
  %t1971 = load i64, ptr @"scheme.base:%ht-fold-buckets"
  %t1972 = and i64 %t1971, -8
  %t1973 = inttoptr i64 %t1972 to ptr
  %t1974 = load i64, ptr %t1973
  %t1975 = inttoptr i64 %t1974 to ptr
  %t1976 = call fastcc i64%t1975(i64 %t1971, i64 2, i64 %t1970, i64 %a1, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t1977 = call i64 @rt_cons(i64 %t1969, i64 %t1976)
  ret i64 %t1977
}

define fastcc i64 @"scheme.base:code_474"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1982 = icmp eq i64 %argc, 2
  br i1 %t1982, label %argok445, label %arityerr444
arityerr444:
  call void @rt_arity_error(i64 2, i64 %argc)
  unreachable
argok445:
  %t1983 = and i64 %self, -8
  %t1984 = inttoptr i64 %t1983 to ptr
  %t1985 = getelementptr i64, ptr %t1984, i64 1
  %t1986 = load i64, ptr %t1985
  %t1987 = call i64 @rt_vector_length(i64 %t1986)
  %t1988 = or i64 %a0, %t1987
  %t1989 = and i64 %t1988, 7
  %t1990 = icmp eq i64 %t1989, 0
  br i1 %t1990, label %fixfast446, label %fixslow447
fixfast446:
  %t1991 = icmp slt i64 %a0, %t1987
  %t1992 = select i1 %t1991, i64 257, i64 1
  br label %fixmerge448
fixslow447:
  %t1993 = call i64 @rt_lt(i64 %a0, i64 %t1987)
  br label %fixmerge448
fixmerge448:
  %t1994 = phi i64 [ %t1992, %fixfast446 ], [ %t1993, %fixslow447 ]
  %t1995 = icmp ne i64 %t1994, 1
  br i1 %t1995, label %then449, label %else450
then449:
  %t1996 = or i64 %a0, 8
  %t1997 = and i64 %t1996, 7
  %t1998 = icmp eq i64 %t1997, 0
  br i1 %t1998, label %fixfast451, label %fixslow452
fixfast451:
  %t1999 = add i64 %a0, 8
  br label %fixmerge453
fixslow452:
  %t2000 = call i64 @rt_add(i64 %a0, i64 8)
  br label %fixmerge453
fixmerge453:
  %t2001 = phi i64 [ %t1999, %fixfast451 ], [ %t2000, %fixslow452 ]
  %t2002 = and i64 %self, -8
  %t2003 = inttoptr i64 %t2002 to ptr
  %t2004 = getelementptr i64, ptr %t2003, i64 1
  %t2005 = load i64, ptr %t2004
  %t2006 = call i64 @rt_vector_ref(i64 %t2005, i64 %a0)
  %t2007 = load i64, ptr @"scheme.base:%ht-fold-buckets"
  %t2008 = and i64 %t2007, -8
  %t2009 = inttoptr i64 %t2008 to ptr
  %t2010 = load i64, ptr %t2009
  %t2011 = inttoptr i64 %t2010 to ptr
  %t2012 = call fastcc i64%t2011(i64 %t2007, i64 2, i64 %t2006, i64 %a1, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t2013 = musttail call fastcc i64 @"scheme.base:code_474"(i64 %self, i64 2, i64 %t2001, i64 %t2012, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t2013
else450:
  ret i64 %a1
}

define fastcc i64 @"scheme.base:code_472"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t2014 = icmp eq i64 %argc, 1
  br i1 %t2014, label %argok455, label %arityerr454
arityerr454:
  call void @rt_arity_error(i64 1, i64 %argc)
  unreachable
argok455:
  %t2015 = load i64, ptr @"scheme.base:%ht-buckets"
  %t2016 = and i64 %t2015, -8
  %t2017 = inttoptr i64 %t2016 to ptr
  %t2018 = load i64, ptr %t2017
  %t2019 = inttoptr i64 %t2018 to ptr
  %t2020 = call fastcc i64%t2019(i64 %t2015, i64 1, i64 %a0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t2021 = call i64 @rt_alloc_words(i64 3)
  %t2022 = inttoptr i64 %t2021 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_474" to i64), ptr %t2022
  %t2023 = or i64 %t2021, 4
  %t2024 = getelementptr i64, ptr %t2022, i64 1
  store i64 %t2020, ptr %t2024
  %t2025 = getelementptr i64, ptr %t2022, i64 2
  store i64 %t2023, ptr %t2025
  %t2026 = and i64 %t2023, -8
  %t2027 = inttoptr i64 %t2026 to ptr
  %t2028 = load i64, ptr %t2027
  %t2029 = inttoptr i64 %t2028 to ptr
  %t2030 = musttail call fastcc i64 %t2029(i64 %t2023, i64 2, i64 0, i64 2, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t2030
}

define fastcc i64 @"scheme.base:code_480"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t2035 = icmp eq i64 %argc, 1
  br i1 %t2035, label %argok457, label %arityerr456
arityerr456:
  call void @rt_arity_error(i64 1, i64 %argc)
  unreachable
argok457:
  %t2036 = call i64 @rt_car(i64 %a0)
  ret i64 %t2036
}

define fastcc i64 @"scheme.base:code_478"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t2037 = icmp eq i64 %argc, 1
  br i1 %t2037, label %argok459, label %arityerr458
arityerr458:
  call void @rt_arity_error(i64 1, i64 %argc)
  unreachable
argok459:
  %t2038 = call i64 @rt_alloc_words(i64 1)
  %t2039 = inttoptr i64 %t2038 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_480" to i64), ptr %t2039
  %t2040 = or i64 %t2038, 4
  %t2041 = load i64, ptr @"scheme.base:hash-table->alist"
  %t2042 = and i64 %t2041, -8
  %t2043 = inttoptr i64 %t2042 to ptr
  %t2044 = load i64, ptr %t2043
  %t2045 = inttoptr i64 %t2044 to ptr
  %t2046 = call fastcc i64%t2045(i64 %t2041, i64 1, i64 %a0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t2047 = load i64, ptr @"scheme.base:map"
  %t2048 = and i64 %t2047, -8
  %t2049 = inttoptr i64 %t2048 to ptr
  %t2050 = load i64, ptr %t2049
  %t2051 = inttoptr i64 %t2050 to ptr
  %t2052 = musttail call fastcc i64 %t2051(i64 %t2047, i64 2, i64 %t2040, i64 %t2046, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t2052
}

define fastcc i64 @"scheme.base:code_486"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t2057 = icmp eq i64 %argc, 1
  br i1 %t2057, label %argok461, label %arityerr460
arityerr460:
  call void @rt_arity_error(i64 1, i64 %argc)
  unreachable
argok461:
  %t2058 = call i64 @rt_cdr(i64 %a0)
  ret i64 %t2058
}

define fastcc i64 @"scheme.base:code_484"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t2059 = icmp eq i64 %argc, 1
  br i1 %t2059, label %argok463, label %arityerr462
arityerr462:
  call void @rt_arity_error(i64 1, i64 %argc)
  unreachable
argok463:
  %t2060 = call i64 @rt_alloc_words(i64 1)
  %t2061 = inttoptr i64 %t2060 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_486" to i64), ptr %t2061
  %t2062 = or i64 %t2060, 4
  %t2063 = load i64, ptr @"scheme.base:hash-table->alist"
  %t2064 = and i64 %t2063, -8
  %t2065 = inttoptr i64 %t2064 to ptr
  %t2066 = load i64, ptr %t2065
  %t2067 = inttoptr i64 %t2066 to ptr
  %t2068 = call fastcc i64%t2067(i64 %t2063, i64 1, i64 %a0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t2069 = load i64, ptr @"scheme.base:map"
  %t2070 = and i64 %t2069, -8
  %t2071 = inttoptr i64 %t2070 to ptr
  %t2072 = load i64, ptr %t2071
  %t2073 = inttoptr i64 %t2072 to ptr
  %t2074 = musttail call fastcc i64 %t2073(i64 %t2069, i64 2, i64 %t2062, i64 %t2068, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t2074
}

define fastcc i64 @"scheme.base:code_512"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t2079 = icmp eq i64 %argc, 1
  br i1 %t2079, label %argok465, label %arityerr464
arityerr464:
  call void @rt_arity_error(i64 1, i64 %argc)
  unreachable
argok465:
  %t2080 = call i64 @rt_char_to_integer(i64 %a0)
  %t2081 = or i64 %t2080, 256
  %t2082 = and i64 %t2081, 7
  %t2083 = icmp eq i64 %t2082, 0
  br i1 %t2083, label %fixfast466, label %fixslow467
fixfast466:
  %t2084 = icmp eq i64 %t2080, 256
  %t2085 = select i1 %t2084, i64 257, i64 1
  br label %fixmerge468
fixslow467:
  %t2086 = call i64 @rt_num_eq(i64 %t2080, i64 256)
  br label %fixmerge468
fixmerge468:
  %t2087 = phi i64 [ %t2085, %fixfast466 ], [ %t2086, %fixslow467 ]
  %t2088 = icmp ne i64 %t2087, 1
  br i1 %t2088, label %then469, label %else470
then469:
  ret i64 %t2087
else470:
  %t2089 = or i64 %t2080, 72
  %t2090 = and i64 %t2089, 7
  %t2091 = icmp eq i64 %t2090, 0
  br i1 %t2091, label %fixfast471, label %fixslow472
fixfast471:
  %t2092 = icmp eq i64 %t2080, 72
  %t2093 = select i1 %t2092, i64 257, i64 1
  br label %fixmerge473
fixslow472:
  %t2094 = call i64 @rt_num_eq(i64 %t2080, i64 72)
  br label %fixmerge473
fixmerge473:
  %t2095 = phi i64 [ %t2093, %fixfast471 ], [ %t2094, %fixslow472 ]
  %t2096 = icmp ne i64 %t2095, 1
  br i1 %t2096, label %then474, label %else475
then474:
  ret i64 %t2095
else475:
  %t2097 = or i64 %t2080, 80
  %t2098 = and i64 %t2097, 7
  %t2099 = icmp eq i64 %t2098, 0
  br i1 %t2099, label %fixfast476, label %fixslow477
fixfast476:
  %t2100 = icmp eq i64 %t2080, 80
  %t2101 = select i1 %t2100, i64 257, i64 1
  br label %fixmerge478
fixslow477:
  %t2102 = call i64 @rt_num_eq(i64 %t2080, i64 80)
  br label %fixmerge478
fixmerge478:
  %t2103 = phi i64 [ %t2101, %fixfast476 ], [ %t2102, %fixslow477 ]
  %t2104 = icmp ne i64 %t2103, 1
  br i1 %t2104, label %then479, label %else480
then479:
  ret i64 %t2103
else480:
  %t2105 = or i64 %t2080, 104
  %t2106 = and i64 %t2105, 7
  %t2107 = icmp eq i64 %t2106, 0
  br i1 %t2107, label %fixfast481, label %fixslow482
fixfast481:
  %t2108 = icmp eq i64 %t2080, 104
  %t2109 = select i1 %t2108, i64 257, i64 1
  br label %fixmerge483
fixslow482:
  %t2110 = call i64 @rt_num_eq(i64 %t2080, i64 104)
  br label %fixmerge483
fixmerge483:
  %t2111 = phi i64 [ %t2109, %fixfast481 ], [ %t2110, %fixslow482 ]
  ret i64 %t2111
}

define fastcc i64 @"scheme.base:code_524"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t2116 = icmp eq i64 %argc, 1
  br i1 %t2116, label %argok485, label %arityerr484
arityerr484:
  call void @rt_arity_error(i64 1, i64 %argc)
  unreachable
argok485:
  %t2117 = call i64 @rt_char_to_integer(i64 %a0)
  %t2118 = or i64 376, %t2117
  %t2119 = and i64 %t2118, 7
  %t2120 = icmp eq i64 %t2119, 0
  br i1 %t2120, label %fixfast486, label %fixslow487
fixfast486:
  %t2121 = icmp slt i64 376, %t2117
  %t2122 = select i1 %t2121, i64 257, i64 1
  br label %fixmerge488
fixslow487:
  %t2123 = call i64 @rt_lt(i64 376, i64 %t2117)
  br label %fixmerge488
fixmerge488:
  %t2124 = phi i64 [ %t2122, %fixfast486 ], [ %t2123, %fixslow487 ]
  %t2125 = icmp ne i64 %t2124, 1
  br i1 %t2125, label %then489, label %else490
then489:
  %t2126 = or i64 %t2117, 464
  %t2127 = and i64 %t2126, 7
  %t2128 = icmp eq i64 %t2127, 0
  br i1 %t2128, label %fixfast491, label %fixslow492
fixfast491:
  %t2129 = icmp slt i64 %t2117, 464
  %t2130 = select i1 %t2129, i64 257, i64 1
  br label %fixmerge493
fixslow492:
  %t2131 = call i64 @rt_lt(i64 %t2117, i64 464)
  br label %fixmerge493
fixmerge493:
  %t2132 = phi i64 [ %t2130, %fixfast491 ], [ %t2131, %fixslow492 ]
  ret i64 %t2132
else490:
  ret i64 1
}

define fastcc i64 @"scheme.base:code_564"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t2137 = icmp eq i64 %argc, 1
  br i1 %t2137, label %argok495, label %arityerr494
arityerr494:
  call void @rt_arity_error(i64 1, i64 %argc)
  unreachable
argok495:
  %t2138 = call i64 @rt_char_to_integer(i64 %a0)
  %t2139 = load i64, ptr @"scheme.base:rd-ws?"
  %t2140 = and i64 %t2139, -8
  %t2141 = inttoptr i64 %t2140 to ptr
  %t2142 = load i64, ptr %t2141
  %t2143 = inttoptr i64 %t2142 to ptr
  %t2144 = call fastcc i64%t2143(i64 %t2139, i64 1, i64 %a0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t2145 = icmp ne i64 %t2144, 1
  br i1 %t2145, label %then496, label %else497
then496:
  ret i64 %t2144
else497:
  %t2146 = or i64 %t2138, 320
  %t2147 = and i64 %t2146, 7
  %t2148 = icmp eq i64 %t2147, 0
  br i1 %t2148, label %fixfast498, label %fixslow499
fixfast498:
  %t2149 = icmp eq i64 %t2138, 320
  %t2150 = select i1 %t2149, i64 257, i64 1
  br label %fixmerge500
fixslow499:
  %t2151 = call i64 @rt_num_eq(i64 %t2138, i64 320)
  br label %fixmerge500
fixmerge500:
  %t2152 = phi i64 [ %t2150, %fixfast498 ], [ %t2151, %fixslow499 ]
  %t2153 = icmp ne i64 %t2152, 1
  br i1 %t2153, label %then501, label %else502
then501:
  ret i64 %t2152
else502:
  %t2154 = or i64 %t2138, 328
  %t2155 = and i64 %t2154, 7
  %t2156 = icmp eq i64 %t2155, 0
  br i1 %t2156, label %fixfast503, label %fixslow504
fixfast503:
  %t2157 = icmp eq i64 %t2138, 328
  %t2158 = select i1 %t2157, i64 257, i64 1
  br label %fixmerge505
fixslow504:
  %t2159 = call i64 @rt_num_eq(i64 %t2138, i64 328)
  br label %fixmerge505
fixmerge505:
  %t2160 = phi i64 [ %t2158, %fixfast503 ], [ %t2159, %fixslow504 ]
  %t2161 = icmp ne i64 %t2160, 1
  br i1 %t2161, label %then506, label %else507
then506:
  ret i64 %t2160
else507:
  %t2162 = or i64 %t2138, 728
  %t2163 = and i64 %t2162, 7
  %t2164 = icmp eq i64 %t2163, 0
  br i1 %t2164, label %fixfast508, label %fixslow509
fixfast508:
  %t2165 = icmp eq i64 %t2138, 728
  %t2166 = select i1 %t2165, i64 257, i64 1
  br label %fixmerge510
fixslow509:
  %t2167 = call i64 @rt_num_eq(i64 %t2138, i64 728)
  br label %fixmerge510
fixmerge510:
  %t2168 = phi i64 [ %t2166, %fixfast508 ], [ %t2167, %fixslow509 ]
  %t2169 = icmp ne i64 %t2168, 1
  br i1 %t2169, label %then511, label %else512
then511:
  ret i64 %t2168
else512:
  %t2170 = or i64 %t2138, 744
  %t2171 = and i64 %t2170, 7
  %t2172 = icmp eq i64 %t2171, 0
  br i1 %t2172, label %fixfast513, label %fixslow514
fixfast513:
  %t2173 = icmp eq i64 %t2138, 744
  %t2174 = select i1 %t2173, i64 257, i64 1
  br label %fixmerge515
fixslow514:
  %t2175 = call i64 @rt_num_eq(i64 %t2138, i64 744)
  br label %fixmerge515
fixmerge515:
  %t2176 = phi i64 [ %t2174, %fixfast513 ], [ %t2175, %fixslow514 ]
  %t2177 = icmp ne i64 %t2176, 1
  br i1 %t2177, label %then516, label %else517
then516:
  ret i64 %t2176
else517:
  %t2178 = or i64 %t2138, 272
  %t2179 = and i64 %t2178, 7
  %t2180 = icmp eq i64 %t2179, 0
  br i1 %t2180, label %fixfast518, label %fixslow519
fixfast518:
  %t2181 = icmp eq i64 %t2138, 272
  %t2182 = select i1 %t2181, i64 257, i64 1
  br label %fixmerge520
fixslow519:
  %t2183 = call i64 @rt_num_eq(i64 %t2138, i64 272)
  br label %fixmerge520
fixmerge520:
  %t2184 = phi i64 [ %t2182, %fixfast518 ], [ %t2183, %fixslow519 ]
  %t2185 = icmp ne i64 %t2184, 1
  br i1 %t2185, label %then521, label %else522
then521:
  ret i64 %t2184
else522:
  %t2186 = or i64 %t2138, 472
  %t2187 = and i64 %t2186, 7
  %t2188 = icmp eq i64 %t2187, 0
  br i1 %t2188, label %fixfast523, label %fixslow524
fixfast523:
  %t2189 = icmp eq i64 %t2138, 472
  %t2190 = select i1 %t2189, i64 257, i64 1
  br label %fixmerge525
fixslow524:
  %t2191 = call i64 @rt_num_eq(i64 %t2138, i64 472)
  br label %fixmerge525
fixmerge525:
  %t2192 = phi i64 [ %t2190, %fixfast523 ], [ %t2191, %fixslow524 ]
  ret i64 %t2192
}

define fastcc i64 @"scheme.base:code_577"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t2197 = icmp eq i64 %argc, 3
  br i1 %t2197, label %argok527, label %arityerr526
arityerr526:
  call void @rt_arity_error(i64 3, i64 %argc)
  unreachable
argok527:
  %t2198 = or i64 %a2, %a1
  %t2199 = and i64 %t2198, 7
  %t2200 = icmp eq i64 %t2199, 0
  br i1 %t2200, label %fixfast528, label %fixslow529
fixfast528:
  %t2201 = icmp slt i64 %a2, %a1
  %t2202 = select i1 %t2201, i64 257, i64 1
  br label %fixmerge530
fixslow529:
  %t2203 = call i64 @rt_lt(i64 %a2, i64 %a1)
  br label %fixmerge530
fixmerge530:
  %t2204 = phi i64 [ %t2202, %fixfast528 ], [ %t2203, %fixslow529 ]
  %t2205 = icmp ne i64 %t2204, 1
  br i1 %t2205, label %then531, label %else532
then531:
  %t2206 = call i64 @rt_string_ref(i64 %a0, i64 %a2)
  %t2207 = call i64 @rt_char_to_integer(i64 %t2206)
  %t2208 = or i64 %t2207, 80
  %t2209 = and i64 %t2208, 7
  %t2210 = icmp eq i64 %t2209, 0
  br i1 %t2210, label %fixfast533, label %fixslow534
fixfast533:
  %t2211 = icmp eq i64 %t2207, 80
  %t2212 = select i1 %t2211, i64 257, i64 1
  br label %fixmerge535
fixslow534:
  %t2213 = call i64 @rt_num_eq(i64 %t2207, i64 80)
  br label %fixmerge535
fixmerge535:
  %t2214 = phi i64 [ %t2212, %fixfast533 ], [ %t2213, %fixslow534 ]
  %t2215 = icmp ne i64 %t2214, 1
  br i1 %t2215, label %then536, label %else537
then536:
  %t2216 = or i64 %a2, 8
  %t2217 = and i64 %t2216, 7
  %t2218 = icmp eq i64 %t2217, 0
  br i1 %t2218, label %fixfast538, label %fixslow539
fixfast538:
  %t2219 = add i64 %a2, 8
  br label %fixmerge540
fixslow539:
  %t2220 = call i64 @rt_add(i64 %a2, i64 8)
  br label %fixmerge540
fixmerge540:
  %t2221 = phi i64 [ %t2219, %fixfast538 ], [ %t2220, %fixslow539 ]
  ret i64 %t2221
else537:
  %t2222 = or i64 %a2, 8
  %t2223 = and i64 %t2222, 7
  %t2224 = icmp eq i64 %t2223, 0
  br i1 %t2224, label %fixfast541, label %fixslow542
fixfast541:
  %t2225 = add i64 %a2, 8
  br label %fixmerge543
fixslow542:
  %t2226 = call i64 @rt_add(i64 %a2, i64 8)
  br label %fixmerge543
fixmerge543:
  %t2227 = phi i64 [ %t2225, %fixfast541 ], [ %t2226, %fixslow542 ]
  %t2228 = load i64, ptr @"scheme.base:rd-skip-line"
  %t2229 = and i64 %t2228, -8
  %t2230 = inttoptr i64 %t2229 to ptr
  %t2231 = load i64, ptr %t2230
  %t2232 = inttoptr i64 %t2231 to ptr
  %t2233 = musttail call fastcc i64 %t2232(i64 %t2228, i64 3, i64 %a0, i64 %a1, i64 %t2227, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t2233
else532:
  ret i64 %a2
}

define fastcc i64 @"scheme.base:code_591"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t2238 = icmp eq i64 %argc, 3
  br i1 %t2238, label %argok545, label %arityerr544
arityerr544:
  call void @rt_arity_error(i64 3, i64 %argc)
  unreachable
argok545:
  %t2239 = or i64 %a2, %a1
  %t2240 = and i64 %t2239, 7
  %t2241 = icmp eq i64 %t2240, 0
  br i1 %t2241, label %fixfast546, label %fixslow547
fixfast546:
  %t2242 = icmp slt i64 %a2, %a1
  %t2243 = select i1 %t2242, i64 257, i64 1
  br label %fixmerge548
fixslow547:
  %t2244 = call i64 @rt_lt(i64 %a2, i64 %a1)
  br label %fixmerge548
fixmerge548:
  %t2245 = phi i64 [ %t2243, %fixfast546 ], [ %t2244, %fixslow547 ]
  %t2246 = icmp ne i64 %t2245, 1
  br i1 %t2246, label %then549, label %else550
then549:
  %t2247 = call i64 @rt_string_ref(i64 %a0, i64 %a2)
  %t2248 = load i64, ptr @"scheme.base:rd-ws?"
  %t2249 = and i64 %t2248, -8
  %t2250 = inttoptr i64 %t2249 to ptr
  %t2251 = load i64, ptr %t2250
  %t2252 = inttoptr i64 %t2251 to ptr
  %t2253 = call fastcc i64%t2252(i64 %t2248, i64 1, i64 %t2247, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t2254 = icmp ne i64 %t2253, 1
  br i1 %t2254, label %then551, label %else552
then551:
  %t2255 = or i64 %a2, 8
  %t2256 = and i64 %t2255, 7
  %t2257 = icmp eq i64 %t2256, 0
  br i1 %t2257, label %fixfast553, label %fixslow554
fixfast553:
  %t2258 = add i64 %a2, 8
  br label %fixmerge555
fixslow554:
  %t2259 = call i64 @rt_add(i64 %a2, i64 8)
  br label %fixmerge555
fixmerge555:
  %t2260 = phi i64 [ %t2258, %fixfast553 ], [ %t2259, %fixslow554 ]
  %t2261 = load i64, ptr @"scheme.base:rd-skip-ws"
  %t2262 = and i64 %t2261, -8
  %t2263 = inttoptr i64 %t2262 to ptr
  %t2264 = load i64, ptr %t2263
  %t2265 = inttoptr i64 %t2264 to ptr
  %t2266 = musttail call fastcc i64 %t2265(i64 %t2261, i64 3, i64 %a0, i64 %a1, i64 %t2260, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t2266
else552:
  %t2267 = call i64 @rt_char_to_integer(i64 %t2247)
  %t2268 = or i64 %t2267, 472
  %t2269 = and i64 %t2268, 7
  %t2270 = icmp eq i64 %t2269, 0
  br i1 %t2270, label %fixfast556, label %fixslow557
fixfast556:
  %t2271 = icmp eq i64 %t2267, 472
  %t2272 = select i1 %t2271, i64 257, i64 1
  br label %fixmerge558
fixslow557:
  %t2273 = call i64 @rt_num_eq(i64 %t2267, i64 472)
  br label %fixmerge558
fixmerge558:
  %t2274 = phi i64 [ %t2272, %fixfast556 ], [ %t2273, %fixslow557 ]
  %t2275 = icmp ne i64 %t2274, 1
  br i1 %t2275, label %then559, label %else560
then559:
  %t2276 = or i64 %a2, 8
  %t2277 = and i64 %t2276, 7
  %t2278 = icmp eq i64 %t2277, 0
  br i1 %t2278, label %fixfast561, label %fixslow562
fixfast561:
  %t2279 = add i64 %a2, 8
  br label %fixmerge563
fixslow562:
  %t2280 = call i64 @rt_add(i64 %a2, i64 8)
  br label %fixmerge563
fixmerge563:
  %t2281 = phi i64 [ %t2279, %fixfast561 ], [ %t2280, %fixslow562 ]
  %t2282 = load i64, ptr @"scheme.base:rd-skip-line"
  %t2283 = and i64 %t2282, -8
  %t2284 = inttoptr i64 %t2283 to ptr
  %t2285 = load i64, ptr %t2284
  %t2286 = inttoptr i64 %t2285 to ptr
  %t2287 = call fastcc i64%t2286(i64 %t2282, i64 3, i64 %a0, i64 %a1, i64 %t2281, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t2288 = load i64, ptr @"scheme.base:rd-skip-ws"
  %t2289 = and i64 %t2288, -8
  %t2290 = inttoptr i64 %t2289 to ptr
  %t2291 = load i64, ptr %t2290
  %t2292 = inttoptr i64 %t2291 to ptr
  %t2293 = musttail call fastcc i64 %t2292(i64 %t2288, i64 3, i64 %a0, i64 %a1, i64 %t2287, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t2293
else560:
  ret i64 %a2
else550:
  ret i64 %a2
}

define fastcc i64 @"scheme.base:code_600"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t2298 = icmp eq i64 %argc, 3
  br i1 %t2298, label %argok565, label %arityerr564
arityerr564:
  call void @rt_arity_error(i64 3, i64 %argc)
  unreachable
argok565:
  %t2299 = or i64 %a2, %a1
  %t2300 = and i64 %t2299, 7
  %t2301 = icmp eq i64 %t2300, 0
  br i1 %t2301, label %fixfast566, label %fixslow567
fixfast566:
  %t2302 = icmp slt i64 %a2, %a1
  %t2303 = select i1 %t2302, i64 257, i64 1
  br label %fixmerge568
fixslow567:
  %t2304 = call i64 @rt_lt(i64 %a2, i64 %a1)
  br label %fixmerge568
fixmerge568:
  %t2305 = phi i64 [ %t2303, %fixfast566 ], [ %t2304, %fixslow567 ]
  %t2306 = icmp ne i64 %t2305, 1
  br i1 %t2306, label %then569, label %else570
then569:
  %t2307 = call i64 @rt_string_ref(i64 %a0, i64 %a2)
  %t2308 = load i64, ptr @"scheme.base:rd-delim?"
  %t2309 = and i64 %t2308, -8
  %t2310 = inttoptr i64 %t2309 to ptr
  %t2311 = load i64, ptr %t2310
  %t2312 = inttoptr i64 %t2311 to ptr
  %t2313 = call fastcc i64%t2312(i64 %t2308, i64 1, i64 %t2307, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t2314 = icmp ne i64 %t2313, 1
  br i1 %t2314, label %then571, label %else572
then571:
  ret i64 %a2
else572:
  %t2315 = or i64 %a2, 8
  %t2316 = and i64 %t2315, 7
  %t2317 = icmp eq i64 %t2316, 0
  br i1 %t2317, label %fixfast573, label %fixslow574
fixfast573:
  %t2318 = add i64 %a2, 8
  br label %fixmerge575
fixslow574:
  %t2319 = call i64 @rt_add(i64 %a2, i64 8)
  br label %fixmerge575
fixmerge575:
  %t2320 = phi i64 [ %t2318, %fixfast573 ], [ %t2319, %fixslow574 ]
  %t2321 = load i64, ptr @"scheme.base:rd-token-end"
  %t2322 = and i64 %t2321, -8
  %t2323 = inttoptr i64 %t2322 to ptr
  %t2324 = load i64, ptr %t2323
  %t2325 = inttoptr i64 %t2324 to ptr
  %t2326 = musttail call fastcc i64 %t2325(i64 %t2321, i64 3, i64 %a0, i64 %a1, i64 %t2320, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t2326
else570:
  ret i64 %a2
}

define fastcc i64 @"scheme.base:code_609"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t2331 = icmp eq i64 %argc, 3
  br i1 %t2331, label %argok577, label %arityerr576
arityerr576:
  call void @rt_arity_error(i64 3, i64 %argc)
  unreachable
argok577:
  %t2332 = or i64 %a1, %a2
  %t2333 = and i64 %t2332, 7
  %t2334 = icmp eq i64 %t2333, 0
  br i1 %t2334, label %fixfast578, label %fixslow579
fixfast578:
  %t2335 = icmp slt i64 %a1, %a2
  %t2336 = select i1 %t2335, i64 257, i64 1
  br label %fixmerge580
fixslow579:
  %t2337 = call i64 @rt_lt(i64 %a1, i64 %a2)
  br label %fixmerge580
fixmerge580:
  %t2338 = phi i64 [ %t2336, %fixfast578 ], [ %t2337, %fixslow579 ]
  %t2339 = icmp ne i64 %t2338, 1
  br i1 %t2339, label %then581, label %else582
then581:
  %t2340 = call i64 @rt_string_ref(i64 %a0, i64 %a1)
  %t2341 = load i64, ptr @"scheme.base:rd-digit?"
  %t2342 = and i64 %t2341, -8
  %t2343 = inttoptr i64 %t2342 to ptr
  %t2344 = load i64, ptr %t2343
  %t2345 = inttoptr i64 %t2344 to ptr
  %t2346 = call fastcc i64%t2345(i64 %t2341, i64 1, i64 %t2340, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t2347 = icmp ne i64 %t2346, 1
  br i1 %t2347, label %then583, label %else584
then583:
  %t2348 = or i64 %a1, 8
  %t2349 = and i64 %t2348, 7
  %t2350 = icmp eq i64 %t2349, 0
  br i1 %t2350, label %fixfast585, label %fixslow586
fixfast585:
  %t2351 = add i64 %a1, 8
  br label %fixmerge587
fixslow586:
  %t2352 = call i64 @rt_add(i64 %a1, i64 8)
  br label %fixmerge587
fixmerge587:
  %t2353 = phi i64 [ %t2351, %fixfast585 ], [ %t2352, %fixslow586 ]
  %t2354 = load i64, ptr @"scheme.base:rd-all-digits?"
  %t2355 = and i64 %t2354, -8
  %t2356 = inttoptr i64 %t2355 to ptr
  %t2357 = load i64, ptr %t2356
  %t2358 = inttoptr i64 %t2357 to ptr
  %t2359 = musttail call fastcc i64 %t2358(i64 %t2354, i64 3, i64 %a0, i64 %t2353, i64 %a2, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t2359
else584:
  ret i64 1
else582:
  ret i64 257
}

define fastcc i64 @"scheme.base:code_632"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t2364 = icmp eq i64 %argc, 1
  br i1 %t2364, label %argok589, label %arityerr588
arityerr588:
  call void @rt_arity_error(i64 1, i64 %argc)
  unreachable
argok589:
  %t2365 = call i64 @rt_string_length(i64 %a0)
  %t2366 = or i64 0, %t2365
  %t2367 = and i64 %t2366, 7
  %t2368 = icmp eq i64 %t2367, 0
  br i1 %t2368, label %fixfast590, label %fixslow591
fixfast590:
  %t2369 = icmp slt i64 0, %t2365
  %t2370 = select i1 %t2369, i64 257, i64 1
  br label %fixmerge592
fixslow591:
  %t2371 = call i64 @rt_lt(i64 0, i64 %t2365)
  br label %fixmerge592
fixmerge592:
  %t2372 = phi i64 [ %t2370, %fixfast590 ], [ %t2371, %fixslow591 ]
  %t2373 = icmp ne i64 %t2372, 1
  br i1 %t2373, label %then593, label %else594
then593:
  %t2374 = call i64 @rt_string_ref(i64 %a0, i64 0)
  %t2375 = call i64 @rt_char_to_integer(i64 %t2374)
  %t2376 = call i64 @rt_string_ref(i64 %a0, i64 0)
  %t2377 = load i64, ptr @"scheme.base:rd-digit?"
  %t2378 = and i64 %t2377, -8
  %t2379 = inttoptr i64 %t2378 to ptr
  %t2380 = load i64, ptr %t2379
  %t2381 = inttoptr i64 %t2380 to ptr
  %t2382 = call fastcc i64%t2381(i64 %t2377, i64 1, i64 %t2376, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t2383 = icmp ne i64 %t2382, 1
  br i1 %t2383, label %then595, label %else596
then595:
  %t2384 = load i64, ptr @"scheme.base:rd-all-digits?"
  %t2385 = and i64 %t2384, -8
  %t2386 = inttoptr i64 %t2385 to ptr
  %t2387 = load i64, ptr %t2386
  %t2388 = inttoptr i64 %t2387 to ptr
  %t2389 = musttail call fastcc i64 %t2388(i64 %t2384, i64 3, i64 %a0, i64 0, i64 %t2365, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t2389
else596:
  %t2390 = or i64 %t2375, 360
  %t2391 = and i64 %t2390, 7
  %t2392 = icmp eq i64 %t2391, 0
  br i1 %t2392, label %fixfast597, label %fixslow598
fixfast597:
  %t2393 = icmp eq i64 %t2375, 360
  %t2394 = select i1 %t2393, i64 257, i64 1
  br label %fixmerge599
fixslow598:
  %t2395 = call i64 @rt_num_eq(i64 %t2375, i64 360)
  br label %fixmerge599
fixmerge599:
  %t2396 = phi i64 [ %t2394, %fixfast597 ], [ %t2395, %fixslow598 ]
  %t2397 = icmp ne i64 %t2396, 1
  br i1 %t2397, label %then600, label %else601
then600:
  br label %merge602
else601:
  %t2398 = or i64 %t2375, 344
  %t2399 = and i64 %t2398, 7
  %t2400 = icmp eq i64 %t2399, 0
  br i1 %t2400, label %fixfast603, label %fixslow604
fixfast603:
  %t2401 = icmp eq i64 %t2375, 344
  %t2402 = select i1 %t2401, i64 257, i64 1
  br label %fixmerge605
fixslow604:
  %t2403 = call i64 @rt_num_eq(i64 %t2375, i64 344)
  br label %fixmerge605
fixmerge605:
  %t2404 = phi i64 [ %t2402, %fixfast603 ], [ %t2403, %fixslow604 ]
  br label %merge602
merge602:
  %t2405 = phi i64 [ %t2396, %then600 ], [ %t2404, %fixmerge605 ]
  %t2406 = icmp ne i64 %t2405, 1
  br i1 %t2406, label %then606, label %else607
then606:
  %t2407 = or i64 8, %t2365
  %t2408 = and i64 %t2407, 7
  %t2409 = icmp eq i64 %t2408, 0
  br i1 %t2409, label %fixfast608, label %fixslow609
fixfast608:
  %t2410 = icmp slt i64 8, %t2365
  %t2411 = select i1 %t2410, i64 257, i64 1
  br label %fixmerge610
fixslow609:
  %t2412 = call i64 @rt_lt(i64 8, i64 %t2365)
  br label %fixmerge610
fixmerge610:
  %t2413 = phi i64 [ %t2411, %fixfast608 ], [ %t2412, %fixslow609 ]
  %t2414 = icmp ne i64 %t2413, 1
  br i1 %t2414, label %then611, label %else612
then611:
  %t2415 = load i64, ptr @"scheme.base:rd-all-digits?"
  %t2416 = and i64 %t2415, -8
  %t2417 = inttoptr i64 %t2416 to ptr
  %t2418 = load i64, ptr %t2417
  %t2419 = inttoptr i64 %t2418 to ptr
  %t2420 = musttail call fastcc i64 %t2419(i64 %t2415, i64 3, i64 %a0, i64 8, i64 %t2365, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t2420
else612:
  ret i64 1
else607:
  ret i64 1
else594:
  ret i64 1
}

define fastcc i64 @"scheme.base:code_642"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t2425 = icmp eq i64 %argc, 4
  br i1 %t2425, label %argok614, label %arityerr613
arityerr613:
  call void @rt_arity_error(i64 4, i64 %argc)
  unreachable
argok614:
  %t2426 = or i64 %a1, %a2
  %t2427 = and i64 %t2426, 7
  %t2428 = icmp eq i64 %t2427, 0
  br i1 %t2428, label %fixfast615, label %fixslow616
fixfast615:
  %t2429 = icmp slt i64 %a1, %a2
  %t2430 = select i1 %t2429, i64 257, i64 1
  br label %fixmerge617
fixslow616:
  %t2431 = call i64 @rt_lt(i64 %a1, i64 %a2)
  br label %fixmerge617
fixmerge617:
  %t2432 = phi i64 [ %t2430, %fixfast615 ], [ %t2431, %fixslow616 ]
  %t2433 = icmp ne i64 %t2432, 1
  br i1 %t2433, label %then618, label %else619
then618:
  %t2434 = or i64 %a1, 8
  %t2435 = and i64 %t2434, 7
  %t2436 = icmp eq i64 %t2435, 0
  br i1 %t2436, label %fixfast620, label %fixslow621
fixfast620:
  %t2437 = add i64 %a1, 8
  br label %fixmerge622
fixslow621:
  %t2438 = call i64 @rt_add(i64 %a1, i64 8)
  br label %fixmerge622
fixmerge622:
  %t2439 = phi i64 [ %t2437, %fixfast620 ], [ %t2438, %fixslow621 ]
  %t2440 = or i64 %a3, 80
  %t2441 = and i64 %t2440, 7
  %t2442 = icmp eq i64 %t2441, 0
  br i1 %t2442, label %fixfast623, label %fixslow624
fixfast623:
  %t2443 = ashr i64 %a3, 3
  %t2444 = mul i64 %t2443, 80
  br label %fixmerge625
fixslow624:
  %t2445 = call i64 @rt_mul(i64 %a3, i64 80)
  br label %fixmerge625
fixmerge625:
  %t2446 = phi i64 [ %t2444, %fixfast623 ], [ %t2445, %fixslow624 ]
  %t2447 = call i64 @rt_string_ref(i64 %a0, i64 %a1)
  %t2448 = call i64 @rt_char_to_integer(i64 %t2447)
  %t2449 = or i64 %t2448, 384
  %t2450 = and i64 %t2449, 7
  %t2451 = icmp eq i64 %t2450, 0
  br i1 %t2451, label %fixfast626, label %fixslow627
fixfast626:
  %t2452 = sub i64 %t2448, 384
  br label %fixmerge628
fixslow627:
  %t2453 = call i64 @rt_sub(i64 %t2448, i64 384)
  br label %fixmerge628
fixmerge628:
  %t2454 = phi i64 [ %t2452, %fixfast626 ], [ %t2453, %fixslow627 ]
  %t2455 = or i64 %t2446, %t2454
  %t2456 = and i64 %t2455, 7
  %t2457 = icmp eq i64 %t2456, 0
  br i1 %t2457, label %fixfast629, label %fixslow630
fixfast629:
  %t2458 = add i64 %t2446, %t2454
  br label %fixmerge631
fixslow630:
  %t2459 = call i64 @rt_add(i64 %t2446, i64 %t2454)
  br label %fixmerge631
fixmerge631:
  %t2460 = phi i64 [ %t2458, %fixfast629 ], [ %t2459, %fixslow630 ]
  %t2461 = load i64, ptr @"scheme.base:rd-digits"
  %t2462 = and i64 %t2461, -8
  %t2463 = inttoptr i64 %t2462 to ptr
  %t2464 = load i64, ptr %t2463
  %t2465 = inttoptr i64 %t2464 to ptr
  %t2466 = musttail call fastcc i64 %t2465(i64 %t2461, i64 4, i64 %a0, i64 %t2439, i64 %a2, i64 %t2460, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t2466
else619:
  ret i64 %a3
}

define fastcc i64 @"scheme.base:code_655"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t2471 = icmp eq i64 %argc, 1
  br i1 %t2471, label %argok633, label %arityerr632
arityerr632:
  call void @rt_arity_error(i64 1, i64 %argc)
  unreachable
argok633:
  %t2472 = call i64 @rt_string_length(i64 %a0)
  %t2473 = call i64 @rt_string_ref(i64 %a0, i64 0)
  %t2474 = call i64 @rt_char_to_integer(i64 %t2473)
  %t2475 = or i64 %t2474, 360
  %t2476 = and i64 %t2475, 7
  %t2477 = icmp eq i64 %t2476, 0
  br i1 %t2477, label %fixfast634, label %fixslow635
fixfast634:
  %t2478 = icmp eq i64 %t2474, 360
  %t2479 = select i1 %t2478, i64 257, i64 1
  br label %fixmerge636
fixslow635:
  %t2480 = call i64 @rt_num_eq(i64 %t2474, i64 360)
  br label %fixmerge636
fixmerge636:
  %t2481 = phi i64 [ %t2479, %fixfast634 ], [ %t2480, %fixslow635 ]
  %t2482 = icmp ne i64 %t2481, 1
  br i1 %t2482, label %then637, label %else638
then637:
  %t2483 = load i64, ptr @"scheme.base:rd-digits"
  %t2484 = and i64 %t2483, -8
  %t2485 = inttoptr i64 %t2484 to ptr
  %t2486 = load i64, ptr %t2485
  %t2487 = inttoptr i64 %t2486 to ptr
  %t2488 = call fastcc i64%t2487(i64 %t2483, i64 4, i64 %a0, i64 8, i64 %t2472, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t2489 = or i64 0, %t2488
  %t2490 = and i64 %t2489, 7
  %t2491 = icmp eq i64 %t2490, 0
  br i1 %t2491, label %fixfast639, label %fixslow640
fixfast639:
  %t2492 = sub i64 0, %t2488
  br label %fixmerge641
fixslow640:
  %t2493 = call i64 @rt_sub(i64 0, i64 %t2488)
  br label %fixmerge641
fixmerge641:
  %t2494 = phi i64 [ %t2492, %fixfast639 ], [ %t2493, %fixslow640 ]
  ret i64 %t2494
else638:
  %t2495 = or i64 %t2474, 344
  %t2496 = and i64 %t2495, 7
  %t2497 = icmp eq i64 %t2496, 0
  br i1 %t2497, label %fixfast642, label %fixslow643
fixfast642:
  %t2498 = icmp eq i64 %t2474, 344
  %t2499 = select i1 %t2498, i64 257, i64 1
  br label %fixmerge644
fixslow643:
  %t2500 = call i64 @rt_num_eq(i64 %t2474, i64 344)
  br label %fixmerge644
fixmerge644:
  %t2501 = phi i64 [ %t2499, %fixfast642 ], [ %t2500, %fixslow643 ]
  %t2502 = icmp ne i64 %t2501, 1
  br i1 %t2502, label %then645, label %else646
then645:
  %t2503 = load i64, ptr @"scheme.base:rd-digits"
  %t2504 = and i64 %t2503, -8
  %t2505 = inttoptr i64 %t2504 to ptr
  %t2506 = load i64, ptr %t2505
  %t2507 = inttoptr i64 %t2506 to ptr
  %t2508 = musttail call fastcc i64 %t2507(i64 %t2503, i64 4, i64 %a0, i64 8, i64 %t2472, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t2508
else646:
  %t2509 = load i64, ptr @"scheme.base:rd-digits"
  %t2510 = and i64 %t2509, -8
  %t2511 = inttoptr i64 %t2510 to ptr
  %t2512 = load i64, ptr %t2511
  %t2513 = inttoptr i64 %t2512 to ptr
  %t2514 = musttail call fastcc i64 %t2513(i64 %t2509, i64 4, i64 %a0, i64 0, i64 %t2472, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t2514
}

define fastcc i64 @"scheme.base:code_662"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t2519 = icmp eq i64 %argc, 1
  br i1 %t2519, label %argok648, label %arityerr647
arityerr647:
  call void @rt_arity_error(i64 1, i64 %argc)
  unreachable
argok648:
  %t2520 = call i64 @rt_char_to_integer(i64 %a0)
  %t2521 = or i64 %t2520, 368
  %t2522 = and i64 %t2521, 7
  %t2523 = icmp eq i64 %t2522, 0
  br i1 %t2523, label %fixfast649, label %fixslow650
fixfast649:
  %t2524 = icmp eq i64 %t2520, 368
  %t2525 = select i1 %t2524, i64 257, i64 1
  br label %fixmerge651
fixslow650:
  %t2526 = call i64 @rt_num_eq(i64 %t2520, i64 368)
  br label %fixmerge651
fixmerge651:
  %t2527 = phi i64 [ %t2525, %fixfast649 ], [ %t2526, %fixslow650 ]
  ret i64 %t2527
}

define fastcc i64 @"scheme.base:code_676"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t2532 = icmp eq i64 %argc, 1
  br i1 %t2532, label %argok653, label %arityerr652
arityerr652:
  call void @rt_arity_error(i64 1, i64 %argc)
  unreachable
argok653:
  %t2533 = call i64 @rt_char_to_integer(i64 %a0)
  %t2534 = or i64 %t2533, 808
  %t2535 = and i64 %t2534, 7
  %t2536 = icmp eq i64 %t2535, 0
  br i1 %t2536, label %fixfast654, label %fixslow655
fixfast654:
  %t2537 = icmp eq i64 %t2533, 808
  %t2538 = select i1 %t2537, i64 257, i64 1
  br label %fixmerge656
fixslow655:
  %t2539 = call i64 @rt_num_eq(i64 %t2533, i64 808)
  br label %fixmerge656
fixmerge656:
  %t2540 = phi i64 [ %t2538, %fixfast654 ], [ %t2539, %fixslow655 ]
  %t2541 = icmp ne i64 %t2540, 1
  br i1 %t2541, label %then657, label %else658
then657:
  ret i64 %t2540
else658:
  %t2542 = or i64 %t2533, 552
  %t2543 = and i64 %t2542, 7
  %t2544 = icmp eq i64 %t2543, 0
  br i1 %t2544, label %fixfast659, label %fixslow660
fixfast659:
  %t2545 = icmp eq i64 %t2533, 552
  %t2546 = select i1 %t2545, i64 257, i64 1
  br label %fixmerge661
fixslow660:
  %t2547 = call i64 @rt_num_eq(i64 %t2533, i64 552)
  br label %fixmerge661
fixmerge661:
  %t2548 = phi i64 [ %t2546, %fixfast659 ], [ %t2547, %fixslow660 ]
  ret i64 %t2548
}

define fastcc i64 @"scheme.base:code_690"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t2553 = icmp eq i64 %argc, 1
  br i1 %t2553, label %argok663, label %arityerr662
arityerr662:
  call void @rt_arity_error(i64 1, i64 %argc)
  unreachable
argok663:
  %t2554 = call i64 @rt_char_to_integer(i64 %a0)
  %t2555 = or i64 %t2554, 344
  %t2556 = and i64 %t2555, 7
  %t2557 = icmp eq i64 %t2556, 0
  br i1 %t2557, label %fixfast664, label %fixslow665
fixfast664:
  %t2558 = icmp eq i64 %t2554, 344
  %t2559 = select i1 %t2558, i64 257, i64 1
  br label %fixmerge666
fixslow665:
  %t2560 = call i64 @rt_num_eq(i64 %t2554, i64 344)
  br label %fixmerge666
fixmerge666:
  %t2561 = phi i64 [ %t2559, %fixfast664 ], [ %t2560, %fixslow665 ]
  %t2562 = icmp ne i64 %t2561, 1
  br i1 %t2562, label %then667, label %else668
then667:
  ret i64 %t2561
else668:
  %t2563 = or i64 %t2554, 360
  %t2564 = and i64 %t2563, 7
  %t2565 = icmp eq i64 %t2564, 0
  br i1 %t2565, label %fixfast669, label %fixslow670
fixfast669:
  %t2566 = icmp eq i64 %t2554, 360
  %t2567 = select i1 %t2566, i64 257, i64 1
  br label %fixmerge671
fixslow670:
  %t2568 = call i64 @rt_num_eq(i64 %t2554, i64 360)
  br label %fixmerge671
fixmerge671:
  %t2569 = phi i64 [ %t2567, %fixfast669 ], [ %t2568, %fixslow670 ]
  ret i64 %t2569
}

define fastcc i64 @"scheme.base:code_699"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t2574 = icmp eq i64 %argc, 3
  br i1 %t2574, label %argok673, label %arityerr672
arityerr672:
  call void @rt_arity_error(i64 3, i64 %argc)
  unreachable
argok673:
  %t2575 = or i64 %a1, %a2
  %t2576 = and i64 %t2575, 7
  %t2577 = icmp eq i64 %t2576, 0
  br i1 %t2577, label %fixfast674, label %fixslow675
fixfast674:
  %t2578 = icmp slt i64 %a1, %a2
  %t2579 = select i1 %t2578, i64 257, i64 1
  br label %fixmerge676
fixslow675:
  %t2580 = call i64 @rt_lt(i64 %a1, i64 %a2)
  br label %fixmerge676
fixmerge676:
  %t2581 = phi i64 [ %t2579, %fixfast674 ], [ %t2580, %fixslow675 ]
  %t2582 = icmp ne i64 %t2581, 1
  br i1 %t2582, label %then677, label %else678
then677:
  %t2583 = call i64 @rt_string_ref(i64 %a0, i64 %a1)
  %t2584 = load i64, ptr @"scheme.base:rd-digit?"
  %t2585 = and i64 %t2584, -8
  %t2586 = inttoptr i64 %t2585 to ptr
  %t2587 = load i64, ptr %t2586
  %t2588 = inttoptr i64 %t2587 to ptr
  %t2589 = call fastcc i64%t2588(i64 %t2584, i64 1, i64 %t2583, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  br label %merge679
else678:
  br label %merge679
merge679:
  %t2590 = phi i64 [ %t2589, %then677 ], [ 1, %else678 ]
  %t2591 = icmp ne i64 %t2590, 1
  br i1 %t2591, label %then680, label %else681
then680:
  %t2592 = or i64 %a1, 8
  %t2593 = and i64 %t2592, 7
  %t2594 = icmp eq i64 %t2593, 0
  br i1 %t2594, label %fixfast682, label %fixslow683
fixfast682:
  %t2595 = add i64 %a1, 8
  br label %fixmerge684
fixslow683:
  %t2596 = call i64 @rt_add(i64 %a1, i64 8)
  br label %fixmerge684
fixmerge684:
  %t2597 = phi i64 [ %t2595, %fixfast682 ], [ %t2596, %fixslow683 ]
  %t2598 = load i64, ptr @"scheme.base:rd-scan-digits"
  %t2599 = and i64 %t2598, -8
  %t2600 = inttoptr i64 %t2599 to ptr
  %t2601 = load i64, ptr %t2600
  %t2602 = inttoptr i64 %t2601 to ptr
  %t2603 = musttail call fastcc i64 %t2602(i64 %t2598, i64 3, i64 %a0, i64 %t2597, i64 %a2, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t2603
else681:
  ret i64 %a1
}

define fastcc i64 @"scheme.base:code_759"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t2608 = icmp eq i64 %argc, 1
  br i1 %t2608, label %argok686, label %arityerr685
arityerr685:
  call void @rt_arity_error(i64 1, i64 %argc)
  unreachable
argok686:
  %t2609 = call i64 @rt_string_length(i64 %a0)
  %t2610 = or i64 0, %t2609
  %t2611 = and i64 %t2610, 7
  %t2612 = icmp eq i64 %t2611, 0
  br i1 %t2612, label %fixfast687, label %fixslow688
fixfast687:
  %t2613 = icmp slt i64 0, %t2609
  %t2614 = select i1 %t2613, i64 257, i64 1
  br label %fixmerge689
fixslow688:
  %t2615 = call i64 @rt_lt(i64 0, i64 %t2609)
  br label %fixmerge689
fixmerge689:
  %t2616 = phi i64 [ %t2614, %fixfast687 ], [ %t2615, %fixslow688 ]
  %t2617 = icmp ne i64 %t2616, 1
  br i1 %t2617, label %then690, label %else691
then690:
  %t2618 = call i64 @rt_string_ref(i64 %a0, i64 0)
  %t2619 = load i64, ptr @"scheme.base:rd-sign-char?"
  %t2620 = and i64 %t2619, -8
  %t2621 = inttoptr i64 %t2620 to ptr
  %t2622 = load i64, ptr %t2621
  %t2623 = inttoptr i64 %t2622 to ptr
  %t2624 = call fastcc i64%t2623(i64 %t2619, i64 1, i64 %t2618, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t2625 = icmp ne i64 %t2624, 1
  br i1 %t2625, label %then692, label %else693
then692:
  br label %merge694
else693:
  br label %merge694
merge694:
  %t2626 = phi i64 [ 8, %then692 ], [ 0, %else693 ]
  %t2627 = load i64, ptr @"scheme.base:rd-scan-digits"
  %t2628 = and i64 %t2627, -8
  %t2629 = inttoptr i64 %t2628 to ptr
  %t2630 = load i64, ptr %t2629
  %t2631 = inttoptr i64 %t2630 to ptr
  %t2632 = call fastcc i64%t2631(i64 %t2627, i64 3, i64 %a0, i64 %t2626, i64 %t2609, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t2633 = or i64 %t2632, %t2609
  %t2634 = and i64 %t2633, 7
  %t2635 = icmp eq i64 %t2634, 0
  br i1 %t2635, label %fixfast695, label %fixslow696
fixfast695:
  %t2636 = icmp slt i64 %t2632, %t2609
  %t2637 = select i1 %t2636, i64 257, i64 1
  br label %fixmerge697
fixslow696:
  %t2638 = call i64 @rt_lt(i64 %t2632, i64 %t2609)
  br label %fixmerge697
fixmerge697:
  %t2639 = phi i64 [ %t2637, %fixfast695 ], [ %t2638, %fixslow696 ]
  %t2640 = icmp ne i64 %t2639, 1
  br i1 %t2640, label %then698, label %else699
then698:
  %t2641 = call i64 @rt_string_ref(i64 %a0, i64 %t2632)
  %t2642 = load i64, ptr @"scheme.base:rd-dotchar?"
  %t2643 = and i64 %t2642, -8
  %t2644 = inttoptr i64 %t2643 to ptr
  %t2645 = load i64, ptr %t2644
  %t2646 = inttoptr i64 %t2645 to ptr
  %t2647 = call fastcc i64%t2646(i64 %t2642, i64 1, i64 %t2641, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  br label %merge700
else699:
  br label %merge700
merge700:
  %t2648 = phi i64 [ %t2647, %then698 ], [ 1, %else699 ]
  %t2649 = icmp ne i64 %t2648, 1
  br i1 %t2649, label %then701, label %else702
then701:
  %t2650 = or i64 %t2632, 8
  %t2651 = and i64 %t2650, 7
  %t2652 = icmp eq i64 %t2651, 0
  br i1 %t2652, label %fixfast704, label %fixslow705
fixfast704:
  %t2653 = add i64 %t2632, 8
  br label %fixmerge706
fixslow705:
  %t2654 = call i64 @rt_add(i64 %t2632, i64 8)
  br label %fixmerge706
fixmerge706:
  %t2655 = phi i64 [ %t2653, %fixfast704 ], [ %t2654, %fixslow705 ]
  br label %merge703
else702:
  br label %merge703
merge703:
  %t2656 = phi i64 [ %t2655, %fixmerge706 ], [ %t2632, %else702 ]
  %t2657 = or i64 %t2632, %t2656
  %t2658 = and i64 %t2657, 7
  %t2659 = icmp eq i64 %t2658, 0
  br i1 %t2659, label %fixfast707, label %fixslow708
fixfast707:
  %t2660 = icmp slt i64 %t2632, %t2656
  %t2661 = select i1 %t2660, i64 257, i64 1
  br label %fixmerge709
fixslow708:
  %t2662 = call i64 @rt_lt(i64 %t2632, i64 %t2656)
  br label %fixmerge709
fixmerge709:
  %t2663 = phi i64 [ %t2661, %fixfast707 ], [ %t2662, %fixslow708 ]
  %t2664 = load i64, ptr @"scheme.base:rd-scan-digits"
  %t2665 = and i64 %t2664, -8
  %t2666 = inttoptr i64 %t2665 to ptr
  %t2667 = load i64, ptr %t2666
  %t2668 = inttoptr i64 %t2667 to ptr
  %t2669 = call fastcc i64%t2668(i64 %t2664, i64 3, i64 %a0, i64 %t2656, i64 %t2609, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t2670 = or i64 %t2626, %t2632
  %t2671 = and i64 %t2670, 7
  %t2672 = icmp eq i64 %t2671, 0
  br i1 %t2672, label %fixfast710, label %fixslow711
fixfast710:
  %t2673 = icmp slt i64 %t2626, %t2632
  %t2674 = select i1 %t2673, i64 257, i64 1
  br label %fixmerge712
fixslow711:
  %t2675 = call i64 @rt_lt(i64 %t2626, i64 %t2632)
  br label %fixmerge712
fixmerge712:
  %t2676 = phi i64 [ %t2674, %fixfast710 ], [ %t2675, %fixslow711 ]
  %t2677 = icmp ne i64 %t2676, 1
  br i1 %t2677, label %then713, label %else714
then713:
  br label %merge715
else714:
  %t2678 = or i64 %t2656, %t2669
  %t2679 = and i64 %t2678, 7
  %t2680 = icmp eq i64 %t2679, 0
  br i1 %t2680, label %fixfast716, label %fixslow717
fixfast716:
  %t2681 = icmp slt i64 %t2656, %t2669
  %t2682 = select i1 %t2681, i64 257, i64 1
  br label %fixmerge718
fixslow717:
  %t2683 = call i64 @rt_lt(i64 %t2656, i64 %t2669)
  br label %fixmerge718
fixmerge718:
  %t2684 = phi i64 [ %t2682, %fixfast716 ], [ %t2683, %fixslow717 ]
  br label %merge715
merge715:
  %t2685 = phi i64 [ %t2676, %then713 ], [ %t2684, %fixmerge718 ]
  %t2686 = icmp ne i64 %t2685, 1
  br i1 %t2686, label %then719, label %else720
then719:
  %t2687 = or i64 %t2669, %t2609
  %t2688 = and i64 %t2687, 7
  %t2689 = icmp eq i64 %t2688, 0
  br i1 %t2689, label %fixfast721, label %fixslow722
fixfast721:
  %t2690 = icmp slt i64 %t2669, %t2609
  %t2691 = select i1 %t2690, i64 257, i64 1
  br label %fixmerge723
fixslow722:
  %t2692 = call i64 @rt_lt(i64 %t2669, i64 %t2609)
  br label %fixmerge723
fixmerge723:
  %t2693 = phi i64 [ %t2691, %fixfast721 ], [ %t2692, %fixslow722 ]
  %t2694 = icmp ne i64 %t2693, 1
  br i1 %t2694, label %then724, label %else725
then724:
  %t2695 = call i64 @rt_string_ref(i64 %a0, i64 %t2669)
  %t2696 = load i64, ptr @"scheme.base:rd-exp-char?"
  %t2697 = and i64 %t2696, -8
  %t2698 = inttoptr i64 %t2697 to ptr
  %t2699 = load i64, ptr %t2698
  %t2700 = inttoptr i64 %t2699 to ptr
  %t2701 = call fastcc i64%t2700(i64 %t2696, i64 1, i64 %t2695, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  br label %merge726
else725:
  br label %merge726
merge726:
  %t2702 = phi i64 [ %t2701, %then724 ], [ 1, %else725 ]
  %t2703 = icmp ne i64 %t2702, 1
  br i1 %t2703, label %then727, label %else728
then727:
  %t2704 = or i64 %t2669, 8
  %t2705 = and i64 %t2704, 7
  %t2706 = icmp eq i64 %t2705, 0
  br i1 %t2706, label %fixfast730, label %fixslow731
fixfast730:
  %t2707 = add i64 %t2669, 8
  br label %fixmerge732
fixslow731:
  %t2708 = call i64 @rt_add(i64 %t2669, i64 8)
  br label %fixmerge732
fixmerge732:
  %t2709 = phi i64 [ %t2707, %fixfast730 ], [ %t2708, %fixslow731 ]
  %t2710 = or i64 %t2709, %t2609
  %t2711 = and i64 %t2710, 7
  %t2712 = icmp eq i64 %t2711, 0
  br i1 %t2712, label %fixfast733, label %fixslow734
fixfast733:
  %t2713 = icmp slt i64 %t2709, %t2609
  %t2714 = select i1 %t2713, i64 257, i64 1
  br label %fixmerge735
fixslow734:
  %t2715 = call i64 @rt_lt(i64 %t2709, i64 %t2609)
  br label %fixmerge735
fixmerge735:
  %t2716 = phi i64 [ %t2714, %fixfast733 ], [ %t2715, %fixslow734 ]
  %t2717 = icmp ne i64 %t2716, 1
  br i1 %t2717, label %then736, label %else737
then736:
  %t2718 = or i64 %t2669, 8
  %t2719 = and i64 %t2718, 7
  %t2720 = icmp eq i64 %t2719, 0
  br i1 %t2720, label %fixfast739, label %fixslow740
fixfast739:
  %t2721 = add i64 %t2669, 8
  br label %fixmerge741
fixslow740:
  %t2722 = call i64 @rt_add(i64 %t2669, i64 8)
  br label %fixmerge741
fixmerge741:
  %t2723 = phi i64 [ %t2721, %fixfast739 ], [ %t2722, %fixslow740 ]
  %t2724 = call i64 @rt_string_ref(i64 %a0, i64 %t2723)
  %t2725 = load i64, ptr @"scheme.base:rd-sign-char?"
  %t2726 = and i64 %t2725, -8
  %t2727 = inttoptr i64 %t2726 to ptr
  %t2728 = load i64, ptr %t2727
  %t2729 = inttoptr i64 %t2728 to ptr
  %t2730 = call fastcc i64%t2729(i64 %t2725, i64 1, i64 %t2724, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  br label %merge738
else737:
  br label %merge738
merge738:
  %t2731 = phi i64 [ %t2730, %fixmerge741 ], [ 1, %else737 ]
  %t2732 = icmp ne i64 %t2731, 1
  br i1 %t2732, label %then742, label %else743
then742:
  %t2733 = or i64 %t2669, 16
  %t2734 = and i64 %t2733, 7
  %t2735 = icmp eq i64 %t2734, 0
  br i1 %t2735, label %fixfast745, label %fixslow746
fixfast745:
  %t2736 = add i64 %t2669, 16
  br label %fixmerge747
fixslow746:
  %t2737 = call i64 @rt_add(i64 %t2669, i64 16)
  br label %fixmerge747
fixmerge747:
  %t2738 = phi i64 [ %t2736, %fixfast745 ], [ %t2737, %fixslow746 ]
  br label %merge744
else743:
  %t2739 = or i64 %t2669, 8
  %t2740 = and i64 %t2739, 7
  %t2741 = icmp eq i64 %t2740, 0
  br i1 %t2741, label %fixfast748, label %fixslow749
fixfast748:
  %t2742 = add i64 %t2669, 8
  br label %fixmerge750
fixslow749:
  %t2743 = call i64 @rt_add(i64 %t2669, i64 8)
  br label %fixmerge750
fixmerge750:
  %t2744 = phi i64 [ %t2742, %fixfast748 ], [ %t2743, %fixslow749 ]
  br label %merge744
merge744:
  %t2745 = phi i64 [ %t2738, %fixmerge747 ], [ %t2744, %fixmerge750 ]
  %t2746 = load i64, ptr @"scheme.base:rd-scan-digits"
  %t2747 = and i64 %t2746, -8
  %t2748 = inttoptr i64 %t2747 to ptr
  %t2749 = load i64, ptr %t2748
  %t2750 = inttoptr i64 %t2749 to ptr
  %t2751 = call fastcc i64%t2750(i64 %t2746, i64 3, i64 %a0, i64 %t2745, i64 %t2609, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t2752 = or i64 %t2745, %t2751
  %t2753 = and i64 %t2752, 7
  %t2754 = icmp eq i64 %t2753, 0
  br i1 %t2754, label %fixfast751, label %fixslow752
fixfast751:
  %t2755 = icmp slt i64 %t2745, %t2751
  %t2756 = select i1 %t2755, i64 257, i64 1
  br label %fixmerge753
fixslow752:
  %t2757 = call i64 @rt_lt(i64 %t2745, i64 %t2751)
  br label %fixmerge753
fixmerge753:
  %t2758 = phi i64 [ %t2756, %fixfast751 ], [ %t2757, %fixslow752 ]
  %t2759 = icmp ne i64 %t2758, 1
  br i1 %t2759, label %then754, label %else755
then754:
  br label %merge756
else755:
  br label %merge756
merge756:
  %t2760 = phi i64 [ %t2751, %then754 ], [ -8, %else755 ]
  br label %merge729
else728:
  br label %merge729
merge729:
  %t2761 = phi i64 [ %t2760, %merge756 ], [ %t2669, %else728 ]
  %t2762 = or i64 -8, %t2761
  %t2763 = and i64 %t2762, 7
  %t2764 = icmp eq i64 %t2763, 0
  br i1 %t2764, label %fixfast757, label %fixslow758
fixfast757:
  %t2765 = icmp slt i64 -8, %t2761
  %t2766 = select i1 %t2765, i64 257, i64 1
  br label %fixmerge759
fixslow758:
  %t2767 = call i64 @rt_lt(i64 -8, i64 %t2761)
  br label %fixmerge759
fixmerge759:
  %t2768 = phi i64 [ %t2766, %fixfast757 ], [ %t2767, %fixslow758 ]
  %t2769 = icmp ne i64 %t2768, 1
  br i1 %t2769, label %then760, label %else761
then760:
  %t2770 = or i64 %t2761, %t2609
  %t2771 = and i64 %t2770, 7
  %t2772 = icmp eq i64 %t2771, 0
  br i1 %t2772, label %fixfast762, label %fixslow763
fixfast762:
  %t2773 = icmp eq i64 %t2761, %t2609
  %t2774 = select i1 %t2773, i64 257, i64 1
  br label %fixmerge764
fixslow763:
  %t2775 = call i64 @rt_num_eq(i64 %t2761, i64 %t2609)
  br label %fixmerge764
fixmerge764:
  %t2776 = phi i64 [ %t2774, %fixfast762 ], [ %t2775, %fixslow763 ]
  %t2777 = icmp ne i64 %t2776, 1
  br i1 %t2777, label %then765, label %else766
then765:
  %t2778 = icmp ne i64 %t2663, 1
  br i1 %t2778, label %then767, label %else768
then767:
  ret i64 %t2663
else768:
  %t2779 = or i64 %t2669, %t2761
  %t2780 = and i64 %t2779, 7
  %t2781 = icmp eq i64 %t2780, 0
  br i1 %t2781, label %fixfast769, label %fixslow770
fixfast769:
  %t2782 = icmp slt i64 %t2669, %t2761
  %t2783 = select i1 %t2782, i64 257, i64 1
  br label %fixmerge771
fixslow770:
  %t2784 = call i64 @rt_lt(i64 %t2669, i64 %t2761)
  br label %fixmerge771
fixmerge771:
  %t2785 = phi i64 [ %t2783, %fixfast769 ], [ %t2784, %fixslow770 ]
  ret i64 %t2785
else766:
  ret i64 1
else761:
  ret i64 1
else720:
  ret i64 1
else691:
  ret i64 1
}

define fastcc i64 @"scheme.base:code_766"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t2790 = icmp eq i64 %argc, 3
  br i1 %t2790, label %argok773, label %arityerr772
arityerr772:
  call void @rt_arity_error(i64 3, i64 %argc)
  unreachable
argok773:
  %t2791 = load i64, ptr @"scheme.base:rd-token-end"
  %t2792 = and i64 %t2791, -8
  %t2793 = inttoptr i64 %t2792 to ptr
  %t2794 = load i64, ptr %t2793
  %t2795 = inttoptr i64 %t2794 to ptr
  %t2796 = call fastcc i64%t2795(i64 %t2791, i64 3, i64 %a0, i64 %a1, i64 %a2, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t2797 = call i64 @rt_substring(i64 %a0, i64 %a2, i64 %t2796)
  %t2798 = load i64, ptr @"scheme.base:rd-numeric?"
  %t2799 = and i64 %t2798, -8
  %t2800 = inttoptr i64 %t2799 to ptr
  %t2801 = load i64, ptr %t2800
  %t2802 = inttoptr i64 %t2801 to ptr
  %t2803 = call fastcc i64%t2802(i64 %t2798, i64 1, i64 %t2797, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t2804 = icmp ne i64 %t2803, 1
  br i1 %t2804, label %then774, label %else775
then774:
  %t2805 = load i64, ptr @"scheme.base:rd-parse-int"
  %t2806 = and i64 %t2805, -8
  %t2807 = inttoptr i64 %t2806 to ptr
  %t2808 = load i64, ptr %t2807
  %t2809 = inttoptr i64 %t2808 to ptr
  %t2810 = call fastcc i64%t2809(i64 %t2805, i64 1, i64 %t2797, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  br label %merge776
else775:
  %t2811 = load i64, ptr @"scheme.base:rd-flonum?"
  %t2812 = and i64 %t2811, -8
  %t2813 = inttoptr i64 %t2812 to ptr
  %t2814 = load i64, ptr %t2813
  %t2815 = inttoptr i64 %t2814 to ptr
  %t2816 = call fastcc i64%t2815(i64 %t2811, i64 1, i64 %t2797, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t2817 = icmp ne i64 %t2816, 1
  br i1 %t2817, label %then777, label %else778
then777:
  %t2818 = call i64 @rt_string_to_flonum(i64 %t2797)
  br label %merge779
else778:
  %t2819 = call i64 @rt_string_to_symbol(i64 %t2797)
  br label %merge779
merge779:
  %t2820 = phi i64 [ %t2818, %then777 ], [ %t2819, %else778 ]
  br label %merge776
merge776:
  %t2821 = phi i64 [ %t2810, %then774 ], [ %t2820, %merge779 ]
  %t2822 = call i64 @rt_cons(i64 %t2821, i64 %t2796)
  ret i64 %t2822
}

define fastcc i64 @"scheme.base:code_794"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t2827 = icmp eq i64 %argc, 1
  br i1 %t2827, label %argok781, label %arityerr780
arityerr780:
  call void @rt_arity_error(i64 1, i64 %argc)
  unreachable
argok781:
  %t2828 = call i64 @rt_char_to_integer(i64 %a0)
  %t2829 = or i64 376, %t2828
  %t2830 = and i64 %t2829, 7
  %t2831 = icmp eq i64 %t2830, 0
  br i1 %t2831, label %fixfast782, label %fixslow783
fixfast782:
  %t2832 = icmp slt i64 376, %t2828
  %t2833 = select i1 %t2832, i64 257, i64 1
  br label %fixmerge784
fixslow783:
  %t2834 = call i64 @rt_lt(i64 376, i64 %t2828)
  br label %fixmerge784
fixmerge784:
  %t2835 = phi i64 [ %t2833, %fixfast782 ], [ %t2834, %fixslow783 ]
  %t2836 = icmp ne i64 %t2835, 1
  br i1 %t2836, label %then785, label %else786
then785:
  %t2837 = or i64 %t2828, 464
  %t2838 = and i64 %t2837, 7
  %t2839 = icmp eq i64 %t2838, 0
  br i1 %t2839, label %fixfast788, label %fixslow789
fixfast788:
  %t2840 = icmp slt i64 %t2828, 464
  %t2841 = select i1 %t2840, i64 257, i64 1
  br label %fixmerge790
fixslow789:
  %t2842 = call i64 @rt_lt(i64 %t2828, i64 464)
  br label %fixmerge790
fixmerge790:
  %t2843 = phi i64 [ %t2841, %fixfast788 ], [ %t2842, %fixslow789 ]
  br label %merge787
else786:
  br label %merge787
merge787:
  %t2844 = phi i64 [ %t2843, %fixmerge790 ], [ 1, %else786 ]
  %t2845 = icmp ne i64 %t2844, 1
  br i1 %t2845, label %then791, label %else792
then791:
  %t2846 = or i64 %t2828, 384
  %t2847 = and i64 %t2846, 7
  %t2848 = icmp eq i64 %t2847, 0
  br i1 %t2848, label %fixfast793, label %fixslow794
fixfast793:
  %t2849 = sub i64 %t2828, 384
  br label %fixmerge795
fixslow794:
  %t2850 = call i64 @rt_sub(i64 %t2828, i64 384)
  br label %fixmerge795
fixmerge795:
  %t2851 = phi i64 [ %t2849, %fixfast793 ], [ %t2850, %fixslow794 ]
  ret i64 %t2851
else792:
  %t2852 = or i64 768, %t2828
  %t2853 = and i64 %t2852, 7
  %t2854 = icmp eq i64 %t2853, 0
  br i1 %t2854, label %fixfast796, label %fixslow797
fixfast796:
  %t2855 = icmp slt i64 768, %t2828
  %t2856 = select i1 %t2855, i64 257, i64 1
  br label %fixmerge798
fixslow797:
  %t2857 = call i64 @rt_lt(i64 768, i64 %t2828)
  br label %fixmerge798
fixmerge798:
  %t2858 = phi i64 [ %t2856, %fixfast796 ], [ %t2857, %fixslow797 ]
  %t2859 = icmp ne i64 %t2858, 1
  br i1 %t2859, label %then799, label %else800
then799:
  %t2860 = or i64 %t2828, 824
  %t2861 = and i64 %t2860, 7
  %t2862 = icmp eq i64 %t2861, 0
  br i1 %t2862, label %fixfast802, label %fixslow803
fixfast802:
  %t2863 = icmp slt i64 %t2828, 824
  %t2864 = select i1 %t2863, i64 257, i64 1
  br label %fixmerge804
fixslow803:
  %t2865 = call i64 @rt_lt(i64 %t2828, i64 824)
  br label %fixmerge804
fixmerge804:
  %t2866 = phi i64 [ %t2864, %fixfast802 ], [ %t2865, %fixslow803 ]
  br label %merge801
else800:
  br label %merge801
merge801:
  %t2867 = phi i64 [ %t2866, %fixmerge804 ], [ 1, %else800 ]
  %t2868 = icmp ne i64 %t2867, 1
  br i1 %t2868, label %then805, label %else806
then805:
  %t2869 = or i64 %t2828, 696
  %t2870 = and i64 %t2869, 7
  %t2871 = icmp eq i64 %t2870, 0
  br i1 %t2871, label %fixfast807, label %fixslow808
fixfast807:
  %t2872 = sub i64 %t2828, 696
  br label %fixmerge809
fixslow808:
  %t2873 = call i64 @rt_sub(i64 %t2828, i64 696)
  br label %fixmerge809
fixmerge809:
  %t2874 = phi i64 [ %t2872, %fixfast807 ], [ %t2873, %fixslow808 ]
  ret i64 %t2874
else806:
  %t2875 = or i64 512, %t2828
  %t2876 = and i64 %t2875, 7
  %t2877 = icmp eq i64 %t2876, 0
  br i1 %t2877, label %fixfast810, label %fixslow811
fixfast810:
  %t2878 = icmp slt i64 512, %t2828
  %t2879 = select i1 %t2878, i64 257, i64 1
  br label %fixmerge812
fixslow811:
  %t2880 = call i64 @rt_lt(i64 512, i64 %t2828)
  br label %fixmerge812
fixmerge812:
  %t2881 = phi i64 [ %t2879, %fixfast810 ], [ %t2880, %fixslow811 ]
  %t2882 = icmp ne i64 %t2881, 1
  br i1 %t2882, label %then813, label %else814
then813:
  %t2883 = or i64 %t2828, 568
  %t2884 = and i64 %t2883, 7
  %t2885 = icmp eq i64 %t2884, 0
  br i1 %t2885, label %fixfast816, label %fixslow817
fixfast816:
  %t2886 = icmp slt i64 %t2828, 568
  %t2887 = select i1 %t2886, i64 257, i64 1
  br label %fixmerge818
fixslow817:
  %t2888 = call i64 @rt_lt(i64 %t2828, i64 568)
  br label %fixmerge818
fixmerge818:
  %t2889 = phi i64 [ %t2887, %fixfast816 ], [ %t2888, %fixslow817 ]
  br label %merge815
else814:
  br label %merge815
merge815:
  %t2890 = phi i64 [ %t2889, %fixmerge818 ], [ 1, %else814 ]
  %t2891 = icmp ne i64 %t2890, 1
  br i1 %t2891, label %then819, label %else820
then819:
  %t2892 = or i64 %t2828, 440
  %t2893 = and i64 %t2892, 7
  %t2894 = icmp eq i64 %t2893, 0
  br i1 %t2894, label %fixfast821, label %fixslow822
fixfast821:
  %t2895 = sub i64 %t2828, 440
  br label %fixmerge823
fixslow822:
  %t2896 = call i64 @rt_sub(i64 %t2828, i64 440)
  br label %fixmerge823
fixmerge823:
  %t2897 = phi i64 [ %t2895, %fixfast821 ], [ %t2896, %fixslow822 ]
  ret i64 %t2897
else820:
  ret i64 0
}

define fastcc i64 @"scheme.base:code_808"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t2902 = icmp eq i64 %argc, 4
  br i1 %t2902, label %argok825, label %arityerr824
arityerr824:
  call void @rt_arity_error(i64 4, i64 %argc)
  unreachable
argok825:
  %t2903 = or i64 %a2, %a1
  %t2904 = and i64 %t2903, 7
  %t2905 = icmp eq i64 %t2904, 0
  br i1 %t2905, label %fixfast826, label %fixslow827
fixfast826:
  %t2906 = icmp slt i64 %a2, %a1
  %t2907 = select i1 %t2906, i64 257, i64 1
  br label %fixmerge828
fixslow827:
  %t2908 = call i64 @rt_lt(i64 %a2, i64 %a1)
  br label %fixmerge828
fixmerge828:
  %t2909 = phi i64 [ %t2907, %fixfast826 ], [ %t2908, %fixslow827 ]
  %t2910 = icmp ne i64 %t2909, 1
  br i1 %t2910, label %then829, label %else830
then829:
  %t2911 = call i64 @rt_string_ref(i64 %a0, i64 %a2)
  %t2912 = call i64 @rt_char_to_integer(i64 %t2911)
  %t2913 = or i64 %t2912, 472
  %t2914 = and i64 %t2913, 7
  %t2915 = icmp eq i64 %t2914, 0
  br i1 %t2915, label %fixfast831, label %fixslow832
fixfast831:
  %t2916 = icmp eq i64 %t2912, 472
  %t2917 = select i1 %t2916, i64 257, i64 1
  br label %fixmerge833
fixslow832:
  %t2918 = call i64 @rt_num_eq(i64 %t2912, i64 472)
  br label %fixmerge833
fixmerge833:
  %t2919 = phi i64 [ %t2917, %fixfast831 ], [ %t2918, %fixslow832 ]
  %t2920 = icmp ne i64 %t2919, 1
  br i1 %t2920, label %then834, label %else835
then834:
  %t2921 = or i64 %a2, 8
  %t2922 = and i64 %t2921, 7
  %t2923 = icmp eq i64 %t2922, 0
  br i1 %t2923, label %fixfast836, label %fixslow837
fixfast836:
  %t2924 = add i64 %a2, 8
  br label %fixmerge838
fixslow837:
  %t2925 = call i64 @rt_add(i64 %a2, i64 8)
  br label %fixmerge838
fixmerge838:
  %t2926 = phi i64 [ %t2924, %fixfast836 ], [ %t2925, %fixslow837 ]
  %t2927 = call i64 @rt_cons(i64 %a3, i64 %t2926)
  ret i64 %t2927
else835:
  %t2928 = or i64 %a2, 8
  %t2929 = and i64 %t2928, 7
  %t2930 = icmp eq i64 %t2929, 0
  br i1 %t2930, label %fixfast839, label %fixslow840
fixfast839:
  %t2931 = add i64 %a2, 8
  br label %fixmerge841
fixslow840:
  %t2932 = call i64 @rt_add(i64 %a2, i64 8)
  br label %fixmerge841
fixmerge841:
  %t2933 = phi i64 [ %t2931, %fixfast839 ], [ %t2932, %fixslow840 ]
  %t2934 = or i64 %a3, 128
  %t2935 = and i64 %t2934, 7
  %t2936 = icmp eq i64 %t2935, 0
  br i1 %t2936, label %fixfast842, label %fixslow843
fixfast842:
  %t2937 = ashr i64 %a3, 3
  %t2938 = mul i64 %t2937, 128
  br label %fixmerge844
fixslow843:
  %t2939 = call i64 @rt_mul(i64 %a3, i64 128)
  br label %fixmerge844
fixmerge844:
  %t2940 = phi i64 [ %t2938, %fixfast842 ], [ %t2939, %fixslow843 ]
  %t2941 = call i64 @rt_string_ref(i64 %a0, i64 %a2)
  %t2942 = load i64, ptr @"scheme.base:rd-hex-digit"
  %t2943 = and i64 %t2942, -8
  %t2944 = inttoptr i64 %t2943 to ptr
  %t2945 = load i64, ptr %t2944
  %t2946 = inttoptr i64 %t2945 to ptr
  %t2947 = call fastcc i64%t2946(i64 %t2942, i64 1, i64 %t2941, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t2948 = or i64 %t2940, %t2947
  %t2949 = and i64 %t2948, 7
  %t2950 = icmp eq i64 %t2949, 0
  br i1 %t2950, label %fixfast845, label %fixslow846
fixfast845:
  %t2951 = add i64 %t2940, %t2947
  br label %fixmerge847
fixslow846:
  %t2952 = call i64 @rt_add(i64 %t2940, i64 %t2947)
  br label %fixmerge847
fixmerge847:
  %t2953 = phi i64 [ %t2951, %fixfast845 ], [ %t2952, %fixslow846 ]
  %t2954 = load i64, ptr @"scheme.base:rd-hex"
  %t2955 = and i64 %t2954, -8
  %t2956 = inttoptr i64 %t2955 to ptr
  %t2957 = load i64, ptr %t2956
  %t2958 = inttoptr i64 %t2957 to ptr
  %t2959 = musttail call fastcc i64 %t2958(i64 %t2954, i64 4, i64 %a0, i64 %a1, i64 %t2933, i64 %t2953, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t2959
else830:
  %t2960 = call i64 @rt_cons(i64 %a3, i64 %a2)
  ret i64 %t2960
}

define fastcc i64 @"scheme.base:code_824"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t2965 = icmp eq i64 %argc, 1
  br i1 %t2965, label %argok849, label %arityerr848
arityerr848:
  call void @rt_arity_error(i64 1, i64 %argc)
  unreachable
argok849:
  %t2966 = call i64 @rt_char_to_integer(i64 %a0)
  %t2967 = or i64 %t2966, 880
  %t2968 = and i64 %t2967, 7
  %t2969 = icmp eq i64 %t2968, 0
  br i1 %t2969, label %fixfast850, label %fixslow851
fixfast850:
  %t2970 = icmp eq i64 %t2966, 880
  %t2971 = select i1 %t2970, i64 257, i64 1
  br label %fixmerge852
fixslow851:
  %t2972 = call i64 @rt_num_eq(i64 %t2966, i64 880)
  br label %fixmerge852
fixmerge852:
  %t2973 = phi i64 [ %t2971, %fixfast850 ], [ %t2972, %fixslow851 ]
  %t2974 = icmp ne i64 %t2973, 1
  br i1 %t2974, label %then853, label %else854
then853:
  %t2975 = call i64 @rt_integer_to_char(i64 80)
  ret i64 %t2975
else854:
  %t2976 = or i64 %t2966, 928
  %t2977 = and i64 %t2976, 7
  %t2978 = icmp eq i64 %t2977, 0
  br i1 %t2978, label %fixfast855, label %fixslow856
fixfast855:
  %t2979 = icmp eq i64 %t2966, 928
  %t2980 = select i1 %t2979, i64 257, i64 1
  br label %fixmerge857
fixslow856:
  %t2981 = call i64 @rt_num_eq(i64 %t2966, i64 928)
  br label %fixmerge857
fixmerge857:
  %t2982 = phi i64 [ %t2980, %fixfast855 ], [ %t2981, %fixslow856 ]
  %t2983 = icmp ne i64 %t2982, 1
  br i1 %t2983, label %then858, label %else859
then858:
  %t2984 = call i64 @rt_integer_to_char(i64 72)
  ret i64 %t2984
else859:
  %t2985 = or i64 %t2966, 912
  %t2986 = and i64 %t2985, 7
  %t2987 = icmp eq i64 %t2986, 0
  br i1 %t2987, label %fixfast860, label %fixslow861
fixfast860:
  %t2988 = icmp eq i64 %t2966, 912
  %t2989 = select i1 %t2988, i64 257, i64 1
  br label %fixmerge862
fixslow861:
  %t2990 = call i64 @rt_num_eq(i64 %t2966, i64 912)
  br label %fixmerge862
fixmerge862:
  %t2991 = phi i64 [ %t2989, %fixfast860 ], [ %t2990, %fixslow861 ]
  %t2992 = icmp ne i64 %t2991, 1
  br i1 %t2992, label %then863, label %else864
then863:
  %t2993 = call i64 @rt_integer_to_char(i64 104)
  ret i64 %t2993
else864:
  ret i64 %a0
}

define fastcc i64 @"scheme.base:code_854"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t2998 = icmp eq i64 %argc, 2
  br i1 %t2998, label %argok866, label %arityerr865
arityerr865:
  call void @rt_arity_error(i64 2, i64 %argc)
  unreachable
argok866:
  %t2999 = and i64 %self, -8
  %t3000 = inttoptr i64 %t2999 to ptr
  %t3001 = getelementptr i64, ptr %t3000, i64 1
  %t3002 = load i64, ptr %t3001
  %t3003 = or i64 %a0, %t3002
  %t3004 = and i64 %t3003, 7
  %t3005 = icmp eq i64 %t3004, 0
  br i1 %t3005, label %fixfast867, label %fixslow868
fixfast867:
  %t3006 = icmp slt i64 %a0, %t3002
  %t3007 = select i1 %t3006, i64 257, i64 1
  br label %fixmerge869
fixslow868:
  %t3008 = call i64 @rt_lt(i64 %a0, i64 %t3002)
  br label %fixmerge869
fixmerge869:
  %t3009 = phi i64 [ %t3007, %fixfast867 ], [ %t3008, %fixslow868 ]
  %t3010 = icmp ne i64 %t3009, 1
  br i1 %t3010, label %then870, label %else871
then870:
  %t3011 = and i64 %self, -8
  %t3012 = inttoptr i64 %t3011 to ptr
  %t3013 = getelementptr i64, ptr %t3012, i64 2
  %t3014 = load i64, ptr %t3013
  %t3015 = call i64 @rt_string_ref(i64 %t3014, i64 %a0)
  %t3016 = call i64 @rt_char_to_integer(i64 %t3015)
  %t3017 = or i64 %t3016, 272
  %t3018 = and i64 %t3017, 7
  %t3019 = icmp eq i64 %t3018, 0
  br i1 %t3019, label %fixfast872, label %fixslow873
fixfast872:
  %t3020 = icmp eq i64 %t3016, 272
  %t3021 = select i1 %t3020, i64 257, i64 1
  br label %fixmerge874
fixslow873:
  %t3022 = call i64 @rt_num_eq(i64 %t3016, i64 272)
  br label %fixmerge874
fixmerge874:
  %t3023 = phi i64 [ %t3021, %fixfast872 ], [ %t3022, %fixslow873 ]
  %t3024 = icmp ne i64 %t3023, 1
  br i1 %t3024, label %then875, label %else876
then875:
  %t3025 = load i64, ptr @"scheme.base:reverse"
  %t3026 = and i64 %t3025, -8
  %t3027 = inttoptr i64 %t3026 to ptr
  %t3028 = load i64, ptr %t3027
  %t3029 = inttoptr i64 %t3028 to ptr
  %t3030 = call fastcc i64%t3029(i64 %t3025, i64 1, i64 %a1, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t3031 = call i64 @rt_list_to_string(i64 %t3030)
  %t3032 = or i64 %a0, 8
  %t3033 = and i64 %t3032, 7
  %t3034 = icmp eq i64 %t3033, 0
  br i1 %t3034, label %fixfast877, label %fixslow878
fixfast877:
  %t3035 = add i64 %a0, 8
  br label %fixmerge879
fixslow878:
  %t3036 = call i64 @rt_add(i64 %a0, i64 8)
  br label %fixmerge879
fixmerge879:
  %t3037 = phi i64 [ %t3035, %fixfast877 ], [ %t3036, %fixslow878 ]
  %t3038 = call i64 @rt_cons(i64 %t3031, i64 %t3037)
  ret i64 %t3038
else876:
  %t3039 = or i64 %t3016, 736
  %t3040 = and i64 %t3039, 7
  %t3041 = icmp eq i64 %t3040, 0
  br i1 %t3041, label %fixfast880, label %fixslow881
fixfast880:
  %t3042 = icmp eq i64 %t3016, 736
  %t3043 = select i1 %t3042, i64 257, i64 1
  br label %fixmerge882
fixslow881:
  %t3044 = call i64 @rt_num_eq(i64 %t3016, i64 736)
  br label %fixmerge882
fixmerge882:
  %t3045 = phi i64 [ %t3043, %fixfast880 ], [ %t3044, %fixslow881 ]
  %t3046 = icmp ne i64 %t3045, 1
  br i1 %t3046, label %then883, label %else884
then883:
  %t3047 = and i64 %self, -8
  %t3048 = inttoptr i64 %t3047 to ptr
  %t3049 = getelementptr i64, ptr %t3048, i64 2
  %t3050 = load i64, ptr %t3049
  %t3051 = or i64 %a0, 8
  %t3052 = and i64 %t3051, 7
  %t3053 = icmp eq i64 %t3052, 0
  br i1 %t3053, label %fixfast885, label %fixslow886
fixfast885:
  %t3054 = add i64 %a0, 8
  br label %fixmerge887
fixslow886:
  %t3055 = call i64 @rt_add(i64 %a0, i64 8)
  br label %fixmerge887
fixmerge887:
  %t3056 = phi i64 [ %t3054, %fixfast885 ], [ %t3055, %fixslow886 ]
  %t3057 = call i64 @rt_string_ref(i64 %t3050, i64 %t3056)
  %t3058 = call i64 @rt_char_to_integer(i64 %t3057)
  %t3059 = or i64 %t3058, 960
  %t3060 = and i64 %t3059, 7
  %t3061 = icmp eq i64 %t3060, 0
  br i1 %t3061, label %fixfast888, label %fixslow889
fixfast888:
  %t3062 = icmp eq i64 %t3058, 960
  %t3063 = select i1 %t3062, i64 257, i64 1
  br label %fixmerge890
fixslow889:
  %t3064 = call i64 @rt_num_eq(i64 %t3058, i64 960)
  br label %fixmerge890
fixmerge890:
  %t3065 = phi i64 [ %t3063, %fixfast888 ], [ %t3064, %fixslow889 ]
  %t3066 = icmp ne i64 %t3065, 1
  br i1 %t3066, label %then891, label %else892
then891:
  %t3067 = and i64 %self, -8
  %t3068 = inttoptr i64 %t3067 to ptr
  %t3069 = getelementptr i64, ptr %t3068, i64 2
  %t3070 = load i64, ptr %t3069
  %t3071 = and i64 %self, -8
  %t3072 = inttoptr i64 %t3071 to ptr
  %t3073 = getelementptr i64, ptr %t3072, i64 1
  %t3074 = load i64, ptr %t3073
  %t3075 = or i64 %a0, 16
  %t3076 = and i64 %t3075, 7
  %t3077 = icmp eq i64 %t3076, 0
  br i1 %t3077, label %fixfast893, label %fixslow894
fixfast893:
  %t3078 = add i64 %a0, 16
  br label %fixmerge895
fixslow894:
  %t3079 = call i64 @rt_add(i64 %a0, i64 16)
  br label %fixmerge895
fixmerge895:
  %t3080 = phi i64 [ %t3078, %fixfast893 ], [ %t3079, %fixslow894 ]
  %t3081 = load i64, ptr @"scheme.base:rd-hex"
  %t3082 = and i64 %t3081, -8
  %t3083 = inttoptr i64 %t3082 to ptr
  %t3084 = load i64, ptr %t3083
  %t3085 = inttoptr i64 %t3084 to ptr
  %t3086 = call fastcc i64%t3085(i64 %t3081, i64 4, i64 %t3070, i64 %t3074, i64 %t3080, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t3087 = call i64 @rt_cdr(i64 %t3086)
  %t3088 = call i64 @rt_car(i64 %t3086)
  %t3089 = call i64 @rt_integer_to_char(i64 %t3088)
  %t3090 = call i64 @rt_cons(i64 %t3089, i64 %a1)
  %t3091 = musttail call fastcc i64 @"scheme.base:code_854"(i64 %self, i64 2, i64 %t3087, i64 %t3090, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t3091
else892:
  %t3092 = or i64 %a0, 16
  %t3093 = and i64 %t3092, 7
  %t3094 = icmp eq i64 %t3093, 0
  br i1 %t3094, label %fixfast896, label %fixslow897
fixfast896:
  %t3095 = add i64 %a0, 16
  br label %fixmerge898
fixslow897:
  %t3096 = call i64 @rt_add(i64 %a0, i64 16)
  br label %fixmerge898
fixmerge898:
  %t3097 = phi i64 [ %t3095, %fixfast896 ], [ %t3096, %fixslow897 ]
  %t3098 = load i64, ptr @"scheme.base:rd-str-esc"
  %t3099 = and i64 %t3098, -8
  %t3100 = inttoptr i64 %t3099 to ptr
  %t3101 = load i64, ptr %t3100
  %t3102 = inttoptr i64 %t3101 to ptr
  %t3103 = call fastcc i64%t3102(i64 %t3098, i64 1, i64 %t3057, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t3104 = call i64 @rt_cons(i64 %t3103, i64 %a1)
  %t3105 = musttail call fastcc i64 @"scheme.base:code_854"(i64 %self, i64 2, i64 %t3097, i64 %t3104, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t3105
else884:
  %t3106 = or i64 %a0, 8
  %t3107 = and i64 %t3106, 7
  %t3108 = icmp eq i64 %t3107, 0
  br i1 %t3108, label %fixfast899, label %fixslow900
fixfast899:
  %t3109 = add i64 %a0, 8
  br label %fixmerge901
fixslow900:
  %t3110 = call i64 @rt_add(i64 %a0, i64 8)
  br label %fixmerge901
fixmerge901:
  %t3111 = phi i64 [ %t3109, %fixfast899 ], [ %t3110, %fixslow900 ]
  %t3112 = call i64 @rt_cons(i64 %t3015, i64 %a1)
  %t3113 = musttail call fastcc i64 @"scheme.base:code_854"(i64 %self, i64 2, i64 %t3111, i64 %t3112, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t3113
else871:
  %t3114 = load i64, ptr @"scheme.base:reverse"
  %t3115 = and i64 %t3114, -8
  %t3116 = inttoptr i64 %t3115 to ptr
  %t3117 = load i64, ptr %t3116
  %t3118 = inttoptr i64 %t3117 to ptr
  %t3119 = call fastcc i64%t3118(i64 %t3114, i64 1, i64 %a1, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t3120 = call i64 @rt_list_to_string(i64 %t3119)
  %t3121 = call i64 @rt_cons(i64 %t3120, i64 %a0)
  ret i64 %t3121
}

define fastcc i64 @"scheme.base:code_852"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t3122 = icmp eq i64 %argc, 3
  br i1 %t3122, label %argok903, label %arityerr902
arityerr902:
  call void @rt_arity_error(i64 3, i64 %argc)
  unreachable
argok903:
  %t3123 = call i64 @rt_alloc_words(i64 4)
  %t3124 = inttoptr i64 %t3123 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_854" to i64), ptr %t3124
  %t3125 = or i64 %t3123, 4
  %t3126 = getelementptr i64, ptr %t3124, i64 1
  store i64 %a1, ptr %t3126
  %t3127 = getelementptr i64, ptr %t3124, i64 2
  store i64 %a0, ptr %t3127
  %t3128 = getelementptr i64, ptr %t3124, i64 3
  store i64 %t3125, ptr %t3128
  %t3129 = and i64 %t3125, -8
  %t3130 = inttoptr i64 %t3129 to ptr
  %t3131 = load i64, ptr %t3130
  %t3132 = inttoptr i64 %t3131 to ptr
  %t3133 = musttail call fastcc i64 %t3132(i64 %t3125, i64 2, i64 %a2, i64 2, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t3133
}

define fastcc i64 @"scheme.base:code_895"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t3138 = icmp eq i64 %argc, 3
  br i1 %t3138, label %argok905, label %arityerr904
arityerr904:
  call void @rt_arity_error(i64 3, i64 %argc)
  unreachable
argok905:
  %t3139 = call i64 @rt_string_ref(i64 %a0, i64 %a2)
  %t3140 = call i64 @rt_char_to_integer(i64 %t3139)
  %t3141 = or i64 %t3140, 928
  %t3142 = and i64 %t3141, 7
  %t3143 = icmp eq i64 %t3142, 0
  br i1 %t3143, label %fixfast906, label %fixslow907
fixfast906:
  %t3144 = icmp eq i64 %t3140, 928
  %t3145 = select i1 %t3144, i64 257, i64 1
  br label %fixmerge908
fixslow907:
  %t3146 = call i64 @rt_num_eq(i64 %t3140, i64 928)
  br label %fixmerge908
fixmerge908:
  %t3147 = phi i64 [ %t3145, %fixfast906 ], [ %t3146, %fixslow907 ]
  %t3148 = icmp ne i64 %t3147, 1
  br i1 %t3148, label %then909, label %else910
then909:
  %t3149 = or i64 %a2, 8
  %t3150 = and i64 %t3149, 7
  %t3151 = icmp eq i64 %t3150, 0
  br i1 %t3151, label %fixfast911, label %fixslow912
fixfast911:
  %t3152 = add i64 %a2, 8
  br label %fixmerge913
fixslow912:
  %t3153 = call i64 @rt_add(i64 %a2, i64 8)
  br label %fixmerge913
fixmerge913:
  %t3154 = phi i64 [ %t3152, %fixfast911 ], [ %t3153, %fixslow912 ]
  %t3155 = call i64 @rt_cons(i64 257, i64 %t3154)
  ret i64 %t3155
else910:
  %t3156 = or i64 %t3140, 816
  %t3157 = and i64 %t3156, 7
  %t3158 = icmp eq i64 %t3157, 0
  br i1 %t3158, label %fixfast914, label %fixslow915
fixfast914:
  %t3159 = icmp eq i64 %t3140, 816
  %t3160 = select i1 %t3159, i64 257, i64 1
  br label %fixmerge916
fixslow915:
  %t3161 = call i64 @rt_num_eq(i64 %t3140, i64 816)
  br label %fixmerge916
fixmerge916:
  %t3162 = phi i64 [ %t3160, %fixfast914 ], [ %t3161, %fixslow915 ]
  %t3163 = icmp ne i64 %t3162, 1
  br i1 %t3163, label %then917, label %else918
then917:
  %t3164 = or i64 %a2, 8
  %t3165 = and i64 %t3164, 7
  %t3166 = icmp eq i64 %t3165, 0
  br i1 %t3166, label %fixfast919, label %fixslow920
fixfast919:
  %t3167 = add i64 %a2, 8
  br label %fixmerge921
fixslow920:
  %t3168 = call i64 @rt_add(i64 %a2, i64 8)
  br label %fixmerge921
fixmerge921:
  %t3169 = phi i64 [ %t3167, %fixfast919 ], [ %t3168, %fixslow920 ]
  %t3170 = call i64 @rt_cons(i64 1, i64 %t3169)
  ret i64 %t3170
else918:
  %t3171 = or i64 %t3140, 736
  %t3172 = and i64 %t3171, 7
  %t3173 = icmp eq i64 %t3172, 0
  br i1 %t3173, label %fixfast922, label %fixslow923
fixfast922:
  %t3174 = icmp eq i64 %t3140, 736
  %t3175 = select i1 %t3174, i64 257, i64 1
  br label %fixmerge924
fixslow923:
  %t3176 = call i64 @rt_num_eq(i64 %t3140, i64 736)
  br label %fixmerge924
fixmerge924:
  %t3177 = phi i64 [ %t3175, %fixfast922 ], [ %t3176, %fixslow923 ]
  %t3178 = icmp ne i64 %t3177, 1
  br i1 %t3178, label %then925, label %else926
then925:
  %t3179 = load i64, ptr @"scheme.base:rd-char"
  %t3180 = and i64 %t3179, -8
  %t3181 = inttoptr i64 %t3180 to ptr
  %t3182 = load i64, ptr %t3181
  %t3183 = inttoptr i64 %t3182 to ptr
  %t3184 = musttail call fastcc i64 %t3183(i64 %t3179, i64 3, i64 %a0, i64 %a1, i64 %a2, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t3184
else926:
  %t3185 = or i64 %t3140, 320
  %t3186 = and i64 %t3185, 7
  %t3187 = icmp eq i64 %t3186, 0
  br i1 %t3187, label %fixfast927, label %fixslow928
fixfast927:
  %t3188 = icmp eq i64 %t3140, 320
  %t3189 = select i1 %t3188, i64 257, i64 1
  br label %fixmerge929
fixslow928:
  %t3190 = call i64 @rt_num_eq(i64 %t3140, i64 320)
  br label %fixmerge929
fixmerge929:
  %t3191 = phi i64 [ %t3189, %fixfast927 ], [ %t3190, %fixslow928 ]
  %t3192 = icmp ne i64 %t3191, 1
  br i1 %t3192, label %then930, label %else931
then930:
  %t3193 = or i64 %a2, 8
  %t3194 = and i64 %t3193, 7
  %t3195 = icmp eq i64 %t3194, 0
  br i1 %t3195, label %fixfast932, label %fixslow933
fixfast932:
  %t3196 = add i64 %a2, 8
  br label %fixmerge934
fixslow933:
  %t3197 = call i64 @rt_add(i64 %a2, i64 8)
  br label %fixmerge934
fixmerge934:
  %t3198 = phi i64 [ %t3196, %fixfast932 ], [ %t3197, %fixslow933 ]
  %t3199 = load i64, ptr @"scheme.base:rd-list"
  %t3200 = and i64 %t3199, -8
  %t3201 = inttoptr i64 %t3200 to ptr
  %t3202 = load i64, ptr %t3201
  %t3203 = inttoptr i64 %t3202 to ptr
  %t3204 = call fastcc i64%t3203(i64 %t3199, i64 4, i64 %a0, i64 %a1, i64 %t3198, i64 2, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t3205 = call i64 @rt_car(i64 %t3204)
  %t3206 = load i64, ptr @"scheme.base:list->vector"
  %t3207 = and i64 %t3206, -8
  %t3208 = inttoptr i64 %t3207 to ptr
  %t3209 = load i64, ptr %t3208
  %t3210 = inttoptr i64 %t3209 to ptr
  %t3211 = call fastcc i64%t3210(i64 %t3206, i64 1, i64 %t3205, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t3212 = call i64 @rt_cdr(i64 %t3204)
  %t3213 = call i64 @rt_cons(i64 %t3211, i64 %t3212)
  ret i64 %t3213
else931:
  %t3214 = or i64 %t3140, 936
  %t3215 = and i64 %t3214, 7
  %t3216 = icmp eq i64 %t3215, 0
  br i1 %t3216, label %fixfast935, label %fixslow936
fixfast935:
  %t3217 = icmp eq i64 %t3140, 936
  %t3218 = select i1 %t3217, i64 257, i64 1
  br label %fixmerge937
fixslow936:
  %t3219 = call i64 @rt_num_eq(i64 %t3140, i64 936)
  br label %fixmerge937
fixmerge937:
  %t3220 = phi i64 [ %t3218, %fixfast935 ], [ %t3219, %fixslow936 ]
  %t3221 = icmp ne i64 %t3220, 1
  br i1 %t3221, label %then938, label %else939
then938:
  %t3222 = or i64 %a2, 16
  %t3223 = and i64 %t3222, 7
  %t3224 = icmp eq i64 %t3223, 0
  br i1 %t3224, label %fixfast941, label %fixslow942
fixfast941:
  %t3225 = add i64 %a2, 16
  br label %fixmerge943
fixslow942:
  %t3226 = call i64 @rt_add(i64 %a2, i64 16)
  br label %fixmerge943
fixmerge943:
  %t3227 = phi i64 [ %t3225, %fixfast941 ], [ %t3226, %fixslow942 ]
  %t3228 = or i64 %t3227, %a1
  %t3229 = and i64 %t3228, 7
  %t3230 = icmp eq i64 %t3229, 0
  br i1 %t3230, label %fixfast944, label %fixslow945
fixfast944:
  %t3231 = icmp slt i64 %t3227, %a1
  %t3232 = select i1 %t3231, i64 257, i64 1
  br label %fixmerge946
fixslow945:
  %t3233 = call i64 @rt_lt(i64 %t3227, i64 %a1)
  br label %fixmerge946
fixmerge946:
  %t3234 = phi i64 [ %t3232, %fixfast944 ], [ %t3233, %fixslow945 ]
  %t3235 = icmp ne i64 %t3234, 1
  br i1 %t3235, label %then947, label %else948
then947:
  %t3236 = or i64 %a2, 8
  %t3237 = and i64 %t3236, 7
  %t3238 = icmp eq i64 %t3237, 0
  br i1 %t3238, label %fixfast950, label %fixslow951
fixfast950:
  %t3239 = add i64 %a2, 8
  br label %fixmerge952
fixslow951:
  %t3240 = call i64 @rt_add(i64 %a2, i64 8)
  br label %fixmerge952
fixmerge952:
  %t3241 = phi i64 [ %t3239, %fixfast950 ], [ %t3240, %fixslow951 ]
  %t3242 = call i64 @rt_string_ref(i64 %a0, i64 %t3241)
  %t3243 = call i64 @rt_char_to_integer(i64 %t3242)
  %t3244 = or i64 %t3243, 448
  %t3245 = and i64 %t3244, 7
  %t3246 = icmp eq i64 %t3245, 0
  br i1 %t3246, label %fixfast953, label %fixslow954
fixfast953:
  %t3247 = icmp eq i64 %t3243, 448
  %t3248 = select i1 %t3247, i64 257, i64 1
  br label %fixmerge955
fixslow954:
  %t3249 = call i64 @rt_num_eq(i64 %t3243, i64 448)
  br label %fixmerge955
fixmerge955:
  %t3250 = phi i64 [ %t3248, %fixfast953 ], [ %t3249, %fixslow954 ]
  %t3251 = icmp ne i64 %t3250, 1
  br i1 %t3251, label %then956, label %else957
then956:
  %t3252 = or i64 %a2, 16
  %t3253 = and i64 %t3252, 7
  %t3254 = icmp eq i64 %t3253, 0
  br i1 %t3254, label %fixfast959, label %fixslow960
fixfast959:
  %t3255 = add i64 %a2, 16
  br label %fixmerge961
fixslow960:
  %t3256 = call i64 @rt_add(i64 %a2, i64 16)
  br label %fixmerge961
fixmerge961:
  %t3257 = phi i64 [ %t3255, %fixfast959 ], [ %t3256, %fixslow960 ]
  %t3258 = call i64 @rt_string_ref(i64 %a0, i64 %t3257)
  %t3259 = call i64 @rt_char_to_integer(i64 %t3258)
  %t3260 = or i64 %t3259, 320
  %t3261 = and i64 %t3260, 7
  %t3262 = icmp eq i64 %t3261, 0
  br i1 %t3262, label %fixfast962, label %fixslow963
fixfast962:
  %t3263 = icmp eq i64 %t3259, 320
  %t3264 = select i1 %t3263, i64 257, i64 1
  br label %fixmerge964
fixslow963:
  %t3265 = call i64 @rt_num_eq(i64 %t3259, i64 320)
  br label %fixmerge964
fixmerge964:
  %t3266 = phi i64 [ %t3264, %fixfast962 ], [ %t3265, %fixslow963 ]
  br label %merge958
else957:
  br label %merge958
merge958:
  %t3267 = phi i64 [ %t3266, %fixmerge964 ], [ 1, %else957 ]
  br label %merge949
else948:
  br label %merge949
merge949:
  %t3268 = phi i64 [ %t3267, %merge958 ], [ 1, %else948 ]
  br label %merge940
else939:
  br label %merge940
merge940:
  %t3269 = phi i64 [ %t3268, %merge949 ], [ 1, %else939 ]
  %t3270 = icmp ne i64 %t3269, 1
  br i1 %t3270, label %then965, label %else966
then965:
  %t3271 = or i64 %a2, 24
  %t3272 = and i64 %t3271, 7
  %t3273 = icmp eq i64 %t3272, 0
  br i1 %t3273, label %fixfast967, label %fixslow968
fixfast967:
  %t3274 = add i64 %a2, 24
  br label %fixmerge969
fixslow968:
  %t3275 = call i64 @rt_add(i64 %a2, i64 24)
  br label %fixmerge969
fixmerge969:
  %t3276 = phi i64 [ %t3274, %fixfast967 ], [ %t3275, %fixslow968 ]
  %t3277 = load i64, ptr @"scheme.base:rd-list"
  %t3278 = and i64 %t3277, -8
  %t3279 = inttoptr i64 %t3278 to ptr
  %t3280 = load i64, ptr %t3279
  %t3281 = inttoptr i64 %t3280 to ptr
  %t3282 = call fastcc i64%t3281(i64 %t3277, i64 4, i64 %a0, i64 %a1, i64 %t3276, i64 2, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t3283 = call i64 @rt_car(i64 %t3282)
  %t3284 = load i64, ptr @"scheme.base:list->bytevector"
  %t3285 = and i64 %t3284, -8
  %t3286 = inttoptr i64 %t3285 to ptr
  %t3287 = load i64, ptr %t3286
  %t3288 = inttoptr i64 %t3287 to ptr
  %t3289 = call fastcc i64%t3288(i64 %t3284, i64 1, i64 %t3283, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t3290 = call i64 @rt_cdr(i64 %t3282)
  %t3291 = call i64 @rt_cons(i64 %t3289, i64 %t3290)
  ret i64 %t3291
else966:
  %t3292 = load i64, ptr @"scheme.base:rd-token-end"
  %t3293 = and i64 %t3292, -8
  %t3294 = inttoptr i64 %t3293 to ptr
  %t3295 = load i64, ptr %t3294
  %t3296 = inttoptr i64 %t3295 to ptr
  %t3297 = call fastcc i64%t3296(i64 %t3292, i64 3, i64 %a0, i64 %a1, i64 %a2, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t3298 = call i64 @rt_substring(i64 %a0, i64 %a2, i64 %t3297)
  %t3299 = call i64 @rt_string_to_symbol(i64 %t3298)
  %t3300 = call i64 @rt_cons(i64 %t3299, i64 %t3297)
  ret i64 %t3300
}

define fastcc i64 @"scheme.base:code_898"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t3305 = icmp eq i64 %argc, 1
  br i1 %t3305, label %argok971, label %arityerr970
arityerr970:
  call void @rt_arity_error(i64 1, i64 %argc)
  unreachable
argok971:
  %t3306 = call i64 @rt_make_string(ptr @.str.lit.4, i64 5)
  %t3307 = call i64 @rt_string_eq(i64 %a0, i64 %t3306)
  %t3308 = icmp ne i64 %t3307, 1
  br i1 %t3308, label %then972, label %else973
then972:
  %t3309 = call i64 @rt_integer_to_char(i64 256)
  ret i64 %t3309
else973:
  %t3310 = call i64 @rt_make_string(ptr @.str.lit.5, i64 7)
  %t3311 = call i64 @rt_string_eq(i64 %a0, i64 %t3310)
  %t3312 = icmp ne i64 %t3311, 1
  br i1 %t3312, label %then974, label %else975
then974:
  %t3313 = call i64 @rt_integer_to_char(i64 80)
  ret i64 %t3313
else975:
  %t3314 = call i64 @rt_make_string(ptr @.str.lit.6, i64 3)
  %t3315 = call i64 @rt_string_eq(i64 %a0, i64 %t3314)
  %t3316 = icmp ne i64 %t3315, 1
  br i1 %t3316, label %then976, label %else977
then976:
  %t3317 = call i64 @rt_integer_to_char(i64 72)
  ret i64 %t3317
else977:
  %t3318 = call i64 @rt_make_string(ptr @.str.lit.7, i64 6)
  %t3319 = call i64 @rt_string_eq(i64 %a0, i64 %t3318)
  %t3320 = icmp ne i64 %t3319, 1
  br i1 %t3320, label %then978, label %else979
then978:
  %t3321 = call i64 @rt_integer_to_char(i64 104)
  ret i64 %t3321
else979:
  %t3322 = call i64 @rt_make_string(ptr @.str.lit.8, i64 3)
  %t3323 = call i64 @rt_string_eq(i64 %a0, i64 %t3322)
  %t3324 = icmp ne i64 %t3323, 1
  br i1 %t3324, label %then980, label %else981
then980:
  %t3325 = call i64 @rt_integer_to_char(i64 0)
  ret i64 %t3325
else981:
  %t3326 = call i64 @rt_make_string(ptr @.str.lit.9, i64 4)
  %t3327 = call i64 @rt_string_eq(i64 %a0, i64 %t3326)
  %t3328 = icmp ne i64 %t3327, 1
  br i1 %t3328, label %then982, label %else983
then982:
  %t3329 = call i64 @rt_integer_to_char(i64 0)
  ret i64 %t3329
else983:
  %t3330 = call i64 @rt_make_string(ptr @.str.lit.10, i64 6)
  %t3331 = call i64 @rt_string_eq(i64 %a0, i64 %t3330)
  %t3332 = icmp ne i64 %t3331, 1
  br i1 %t3332, label %then984, label %else985
then984:
  %t3333 = call i64 @rt_integer_to_char(i64 1016)
  ret i64 %t3333
else985:
  %t3334 = call i64 @rt_make_string(ptr @.str.lit.11, i64 7)
  %t3335 = call i64 @rt_string_eq(i64 %a0, i64 %t3334)
  %t3336 = icmp ne i64 %t3335, 1
  br i1 %t3336, label %then986, label %else987
then986:
  %t3337 = call i64 @rt_integer_to_char(i64 216)
  ret i64 %t3337
else987:
  %t3338 = call i64 @rt_make_string(ptr @.str.lit.12, i64 3)
  %t3339 = call i64 @rt_string_eq(i64 %a0, i64 %t3338)
  %t3340 = icmp ne i64 %t3339, 1
  br i1 %t3340, label %then988, label %else989
then988:
  %t3341 = call i64 @rt_integer_to_char(i64 216)
  ret i64 %t3341
else989:
  %t3342 = call i64 @rt_string_ref(i64 %a0, i64 0)
  ret i64 %t3342
}

define fastcc i64 @"scheme.base:code_910"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t3347 = icmp eq i64 %argc, 3
  br i1 %t3347, label %argok991, label %arityerr990
arityerr990:
  call void @rt_arity_error(i64 3, i64 %argc)
  unreachable
argok991:
  %t3348 = or i64 %a2, 8
  %t3349 = and i64 %t3348, 7
  %t3350 = icmp eq i64 %t3349, 0
  br i1 %t3350, label %fixfast992, label %fixslow993
fixfast992:
  %t3351 = add i64 %a2, 8
  br label %fixmerge994
fixslow993:
  %t3352 = call i64 @rt_add(i64 %a2, i64 8)
  br label %fixmerge994
fixmerge994:
  %t3353 = phi i64 [ %t3351, %fixfast992 ], [ %t3352, %fixslow993 ]
  %t3354 = or i64 %t3353, 8
  %t3355 = and i64 %t3354, 7
  %t3356 = icmp eq i64 %t3355, 0
  br i1 %t3356, label %fixfast995, label %fixslow996
fixfast995:
  %t3357 = add i64 %t3353, 8
  br label %fixmerge997
fixslow996:
  %t3358 = call i64 @rt_add(i64 %t3353, i64 8)
  br label %fixmerge997
fixmerge997:
  %t3359 = phi i64 [ %t3357, %fixfast995 ], [ %t3358, %fixslow996 ]
  %t3360 = load i64, ptr @"scheme.base:rd-token-end"
  %t3361 = and i64 %t3360, -8
  %t3362 = inttoptr i64 %t3361 to ptr
  %t3363 = load i64, ptr %t3362
  %t3364 = inttoptr i64 %t3363 to ptr
  %t3365 = call fastcc i64%t3364(i64 %t3360, i64 3, i64 %a0, i64 %a1, i64 %t3359, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t3366 = call i64 @rt_substring(i64 %a0, i64 %t3353, i64 %t3365)
  %t3367 = call i64 @rt_string_length(i64 %t3366)
  %t3368 = or i64 %t3367, 8
  %t3369 = and i64 %t3368, 7
  %t3370 = icmp eq i64 %t3369, 0
  br i1 %t3370, label %fixfast998, label %fixslow999
fixfast998:
  %t3371 = icmp eq i64 %t3367, 8
  %t3372 = select i1 %t3371, i64 257, i64 1
  br label %fixmerge1000
fixslow999:
  %t3373 = call i64 @rt_num_eq(i64 %t3367, i64 8)
  br label %fixmerge1000
fixmerge1000:
  %t3374 = phi i64 [ %t3372, %fixfast998 ], [ %t3373, %fixslow999 ]
  %t3375 = icmp ne i64 %t3374, 1
  br i1 %t3375, label %then1001, label %else1002
then1001:
  %t3376 = call i64 @rt_string_ref(i64 %a0, i64 %t3353)
  %t3377 = call i64 @rt_cons(i64 %t3376, i64 %t3365)
  ret i64 %t3377
else1002:
  %t3378 = load i64, ptr @"scheme.base:rd-char-name"
  %t3379 = and i64 %t3378, -8
  %t3380 = inttoptr i64 %t3379 to ptr
  %t3381 = load i64, ptr %t3380
  %t3382 = inttoptr i64 %t3381 to ptr
  %t3383 = call fastcc i64%t3382(i64 %t3378, i64 1, i64 %t3366, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t3384 = call i64 @rt_cons(i64 %t3383, i64 %t3365)
  ret i64 %t3384
}

define fastcc i64 @"scheme.base:code_917"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t3389 = icmp eq i64 %argc, 3
  br i1 %t3389, label %argok1004, label %arityerr1003
arityerr1003:
  call void @rt_arity_error(i64 3, i64 %argc)
  unreachable
argok1004:
  %t3390 = load i64, ptr @"scheme.base:rd-skip-ws"
  %t3391 = and i64 %t3390, -8
  %t3392 = inttoptr i64 %t3391 to ptr
  %t3393 = load i64, ptr %t3392
  %t3394 = inttoptr i64 %t3393 to ptr
  %t3395 = call fastcc i64%t3394(i64 %t3390, i64 3, i64 %a0, i64 %a1, i64 %a2, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t3396 = load i64, ptr @"scheme.base:rd-datum"
  %t3397 = and i64 %t3396, -8
  %t3398 = inttoptr i64 %t3397 to ptr
  %t3399 = load i64, ptr %t3398
  %t3400 = inttoptr i64 %t3399 to ptr
  %t3401 = call fastcc i64%t3400(i64 %t3396, i64 3, i64 %a0, i64 %a1, i64 %t3395, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t3402 = call i64 @rt_intern(ptr @.str.sym.13)
  %t3403 = call i64 @rt_car(i64 %t3401)
  %t3404 = load i64, ptr @"scheme.base:list"
  %t3405 = and i64 %t3404, -8
  %t3406 = inttoptr i64 %t3405 to ptr
  %t3407 = load i64, ptr %t3406
  %t3408 = inttoptr i64 %t3407 to ptr
  %t3409 = call fastcc i64%t3408(i64 %t3404, i64 2, i64 %t3402, i64 %t3403, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t3410 = call i64 @rt_cdr(i64 %t3401)
  %t3411 = call i64 @rt_cons(i64 %t3409, i64 %t3410)
  ret i64 %t3411
}

define fastcc i64 @"scheme.base:code_924"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t3416 = icmp eq i64 %argc, 3
  br i1 %t3416, label %argok1006, label %arityerr1005
arityerr1005:
  call void @rt_arity_error(i64 3, i64 %argc)
  unreachable
argok1006:
  %t3417 = load i64, ptr @"scheme.base:rd-skip-ws"
  %t3418 = and i64 %t3417, -8
  %t3419 = inttoptr i64 %t3418 to ptr
  %t3420 = load i64, ptr %t3419
  %t3421 = inttoptr i64 %t3420 to ptr
  %t3422 = call fastcc i64%t3421(i64 %t3417, i64 3, i64 %a0, i64 %a1, i64 %a2, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t3423 = load i64, ptr @"scheme.base:rd-datum"
  %t3424 = and i64 %t3423, -8
  %t3425 = inttoptr i64 %t3424 to ptr
  %t3426 = load i64, ptr %t3425
  %t3427 = inttoptr i64 %t3426 to ptr
  %t3428 = call fastcc i64%t3427(i64 %t3423, i64 3, i64 %a0, i64 %a1, i64 %t3422, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t3429 = call i64 @rt_intern(ptr @.str.sym.14)
  %t3430 = call i64 @rt_car(i64 %t3428)
  %t3431 = load i64, ptr @"scheme.base:list"
  %t3432 = and i64 %t3431, -8
  %t3433 = inttoptr i64 %t3432 to ptr
  %t3434 = load i64, ptr %t3433
  %t3435 = inttoptr i64 %t3434 to ptr
  %t3436 = call fastcc i64%t3435(i64 %t3431, i64 2, i64 %t3429, i64 %t3430, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t3437 = call i64 @rt_cdr(i64 %t3428)
  %t3438 = call i64 @rt_cons(i64 %t3436, i64 %t3437)
  ret i64 %t3438
}

define fastcc i64 @"scheme.base:code_941"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t3443 = icmp eq i64 %argc, 3
  br i1 %t3443, label %argok1008, label %arityerr1007
arityerr1007:
  call void @rt_arity_error(i64 3, i64 %argc)
  unreachable
argok1008:
  %t3444 = or i64 %a2, %a1
  %t3445 = and i64 %t3444, 7
  %t3446 = icmp eq i64 %t3445, 0
  br i1 %t3446, label %fixfast1009, label %fixslow1010
fixfast1009:
  %t3447 = icmp slt i64 %a2, %a1
  %t3448 = select i1 %t3447, i64 257, i64 1
  br label %fixmerge1011
fixslow1010:
  %t3449 = call i64 @rt_lt(i64 %a2, i64 %a1)
  br label %fixmerge1011
fixmerge1011:
  %t3450 = phi i64 [ %t3448, %fixfast1009 ], [ %t3449, %fixslow1010 ]
  %t3451 = icmp ne i64 %t3450, 1
  br i1 %t3451, label %then1012, label %else1013
then1012:
  %t3452 = call i64 @rt_string_ref(i64 %a0, i64 %a2)
  %t3453 = call i64 @rt_char_to_integer(i64 %t3452)
  %t3454 = or i64 %t3453, 512
  %t3455 = and i64 %t3454, 7
  %t3456 = icmp eq i64 %t3455, 0
  br i1 %t3456, label %fixfast1015, label %fixslow1016
fixfast1015:
  %t3457 = icmp eq i64 %t3453, 512
  %t3458 = select i1 %t3457, i64 257, i64 1
  br label %fixmerge1017
fixslow1016:
  %t3459 = call i64 @rt_num_eq(i64 %t3453, i64 512)
  br label %fixmerge1017
fixmerge1017:
  %t3460 = phi i64 [ %t3458, %fixfast1015 ], [ %t3459, %fixslow1016 ]
  br label %merge1014
else1013:
  br label %merge1014
merge1014:
  %t3461 = phi i64 [ %t3460, %fixmerge1017 ], [ 1, %else1013 ]
  %t3462 = icmp ne i64 %t3461, 1
  br i1 %t3462, label %then1018, label %else1019
then1018:
  %t3463 = or i64 %a2, 8
  %t3464 = and i64 %t3463, 7
  %t3465 = icmp eq i64 %t3464, 0
  br i1 %t3465, label %fixfast1020, label %fixslow1021
fixfast1020:
  %t3466 = add i64 %a2, 8
  br label %fixmerge1022
fixslow1021:
  %t3467 = call i64 @rt_add(i64 %a2, i64 8)
  br label %fixmerge1022
fixmerge1022:
  %t3468 = phi i64 [ %t3466, %fixfast1020 ], [ %t3467, %fixslow1021 ]
  %t3469 = load i64, ptr @"scheme.base:rd-skip-ws"
  %t3470 = and i64 %t3469, -8
  %t3471 = inttoptr i64 %t3470 to ptr
  %t3472 = load i64, ptr %t3471
  %t3473 = inttoptr i64 %t3472 to ptr
  %t3474 = call fastcc i64%t3473(i64 %t3469, i64 3, i64 %a0, i64 %a1, i64 %t3468, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t3475 = load i64, ptr @"scheme.base:rd-datum"
  %t3476 = and i64 %t3475, -8
  %t3477 = inttoptr i64 %t3476 to ptr
  %t3478 = load i64, ptr %t3477
  %t3479 = inttoptr i64 %t3478 to ptr
  %t3480 = call fastcc i64%t3479(i64 %t3475, i64 3, i64 %a0, i64 %a1, i64 %t3474, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t3481 = call i64 @rt_intern(ptr @.str.sym.15)
  %t3482 = call i64 @rt_car(i64 %t3480)
  %t3483 = load i64, ptr @"scheme.base:list"
  %t3484 = and i64 %t3483, -8
  %t3485 = inttoptr i64 %t3484 to ptr
  %t3486 = load i64, ptr %t3485
  %t3487 = inttoptr i64 %t3486 to ptr
  %t3488 = call fastcc i64%t3487(i64 %t3483, i64 2, i64 %t3481, i64 %t3482, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t3489 = call i64 @rt_cdr(i64 %t3480)
  %t3490 = call i64 @rt_cons(i64 %t3488, i64 %t3489)
  ret i64 %t3490
else1019:
  %t3491 = load i64, ptr @"scheme.base:rd-skip-ws"
  %t3492 = and i64 %t3491, -8
  %t3493 = inttoptr i64 %t3492 to ptr
  %t3494 = load i64, ptr %t3493
  %t3495 = inttoptr i64 %t3494 to ptr
  %t3496 = call fastcc i64%t3495(i64 %t3491, i64 3, i64 %a0, i64 %a1, i64 %a2, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t3497 = load i64, ptr @"scheme.base:rd-datum"
  %t3498 = and i64 %t3497, -8
  %t3499 = inttoptr i64 %t3498 to ptr
  %t3500 = load i64, ptr %t3499
  %t3501 = inttoptr i64 %t3500 to ptr
  %t3502 = call fastcc i64%t3501(i64 %t3497, i64 3, i64 %a0, i64 %a1, i64 %t3496, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t3503 = call i64 @rt_intern(ptr @.str.sym.16)
  %t3504 = call i64 @rt_car(i64 %t3502)
  %t3505 = load i64, ptr @"scheme.base:list"
  %t3506 = and i64 %t3505, -8
  %t3507 = inttoptr i64 %t3506 to ptr
  %t3508 = load i64, ptr %t3507
  %t3509 = inttoptr i64 %t3508 to ptr
  %t3510 = call fastcc i64%t3509(i64 %t3505, i64 2, i64 %t3503, i64 %t3504, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t3511 = call i64 @rt_cdr(i64 %t3502)
  %t3512 = call i64 @rt_cons(i64 %t3510, i64 %t3511)
  ret i64 %t3512
}

define fastcc i64 @"scheme.base:code_954"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t3517 = icmp eq i64 %argc, 3
  br i1 %t3517, label %argok1024, label %arityerr1023
arityerr1023:
  call void @rt_arity_error(i64 3, i64 %argc)
  unreachable
argok1024:
  %t3518 = call i64 @rt_string_ref(i64 %a0, i64 %a2)
  %t3519 = call i64 @rt_char_to_integer(i64 %t3518)
  %t3520 = or i64 %t3519, 368
  %t3521 = and i64 %t3520, 7
  %t3522 = icmp eq i64 %t3521, 0
  br i1 %t3522, label %fixfast1025, label %fixslow1026
fixfast1025:
  %t3523 = icmp eq i64 %t3519, 368
  %t3524 = select i1 %t3523, i64 257, i64 1
  br label %fixmerge1027
fixslow1026:
  %t3525 = call i64 @rt_num_eq(i64 %t3519, i64 368)
  br label %fixmerge1027
fixmerge1027:
  %t3526 = phi i64 [ %t3524, %fixfast1025 ], [ %t3525, %fixslow1026 ]
  %t3527 = icmp ne i64 %t3526, 1
  br i1 %t3527, label %then1028, label %else1029
then1028:
  %t3528 = or i64 %a2, 8
  %t3529 = and i64 %t3528, 7
  %t3530 = icmp eq i64 %t3529, 0
  br i1 %t3530, label %fixfast1030, label %fixslow1031
fixfast1030:
  %t3531 = add i64 %a2, 8
  br label %fixmerge1032
fixslow1031:
  %t3532 = call i64 @rt_add(i64 %a2, i64 8)
  br label %fixmerge1032
fixmerge1032:
  %t3533 = phi i64 [ %t3531, %fixfast1030 ], [ %t3532, %fixslow1031 ]
  %t3534 = load i64, ptr @"scheme.base:rd-token-end"
  %t3535 = and i64 %t3534, -8
  %t3536 = inttoptr i64 %t3535 to ptr
  %t3537 = load i64, ptr %t3536
  %t3538 = inttoptr i64 %t3537 to ptr
  %t3539 = call fastcc i64%t3538(i64 %t3534, i64 3, i64 %a0, i64 %a1, i64 %t3533, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t3540 = or i64 %a2, 8
  %t3541 = and i64 %t3540, 7
  %t3542 = icmp eq i64 %t3541, 0
  br i1 %t3542, label %fixfast1033, label %fixslow1034
fixfast1033:
  %t3543 = add i64 %a2, 8
  br label %fixmerge1035
fixslow1034:
  %t3544 = call i64 @rt_add(i64 %a2, i64 8)
  br label %fixmerge1035
fixmerge1035:
  %t3545 = phi i64 [ %t3543, %fixfast1033 ], [ %t3544, %fixslow1034 ]
  %t3546 = or i64 %t3539, %t3545
  %t3547 = and i64 %t3546, 7
  %t3548 = icmp eq i64 %t3547, 0
  br i1 %t3548, label %fixfast1036, label %fixslow1037
fixfast1036:
  %t3549 = icmp eq i64 %t3539, %t3545
  %t3550 = select i1 %t3549, i64 257, i64 1
  br label %fixmerge1038
fixslow1037:
  %t3551 = call i64 @rt_num_eq(i64 %t3539, i64 %t3545)
  br label %fixmerge1038
fixmerge1038:
  %t3552 = phi i64 [ %t3550, %fixfast1036 ], [ %t3551, %fixslow1037 ]
  ret i64 %t3552
else1029:
  ret i64 1
}

define fastcc i64 @"scheme.base:code_958"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t3557 = icmp eq i64 %argc, 2
  br i1 %t3557, label %argok1040, label %arityerr1039
arityerr1039:
  call void @rt_arity_error(i64 2, i64 %argc)
  unreachable
argok1040:
  %t3558 = call i64 @rt_null_p(i64 %a0)
  %t3559 = icmp ne i64 %t3558, 1
  br i1 %t3559, label %then1041, label %else1042
then1041:
  ret i64 %a1
else1042:
  %t3560 = call i64 @rt_cdr(i64 %a0)
  %t3561 = call i64 @rt_car(i64 %a0)
  %t3562 = call i64 @rt_cons(i64 %t3561, i64 %a1)
  %t3563 = load i64, ptr @"scheme.base:rd-append-reverse"
  %t3564 = and i64 %t3563, -8
  %t3565 = inttoptr i64 %t3564 to ptr
  %t3566 = load i64, ptr %t3565
  %t3567 = inttoptr i64 %t3566 to ptr
  %t3568 = musttail call fastcc i64 %t3567(i64 %t3563, i64 2, i64 %t3560, i64 %t3562, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t3568
}

define fastcc i64 @"scheme.base:code_983"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t3573 = icmp eq i64 %argc, 4
  br i1 %t3573, label %argok1044, label %arityerr1043
arityerr1043:
  call void @rt_arity_error(i64 4, i64 %argc)
  unreachable
argok1044:
  %t3574 = load i64, ptr @"scheme.base:rd-skip-ws"
  %t3575 = and i64 %t3574, -8
  %t3576 = inttoptr i64 %t3575 to ptr
  %t3577 = load i64, ptr %t3576
  %t3578 = inttoptr i64 %t3577 to ptr
  %t3579 = call fastcc i64%t3578(i64 %t3574, i64 3, i64 %a0, i64 %a1, i64 %a2, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t3580 = or i64 %t3579, %a1
  %t3581 = and i64 %t3580, 7
  %t3582 = icmp eq i64 %t3581, 0
  br i1 %t3582, label %fixfast1045, label %fixslow1046
fixfast1045:
  %t3583 = icmp slt i64 %t3579, %a1
  %t3584 = select i1 %t3583, i64 257, i64 1
  br label %fixmerge1047
fixslow1046:
  %t3585 = call i64 @rt_lt(i64 %t3579, i64 %a1)
  br label %fixmerge1047
fixmerge1047:
  %t3586 = phi i64 [ %t3584, %fixfast1045 ], [ %t3585, %fixslow1046 ]
  %t3587 = icmp ne i64 %t3586, 1
  br i1 %t3587, label %then1048, label %else1049
then1048:
  %t3588 = call i64 @rt_string_ref(i64 %a0, i64 %t3579)
  %t3589 = call i64 @rt_char_to_integer(i64 %t3588)
  %t3590 = or i64 %t3589, 328
  %t3591 = and i64 %t3590, 7
  %t3592 = icmp eq i64 %t3591, 0
  br i1 %t3592, label %fixfast1050, label %fixslow1051
fixfast1050:
  %t3593 = icmp eq i64 %t3589, 328
  %t3594 = select i1 %t3593, i64 257, i64 1
  br label %fixmerge1052
fixslow1051:
  %t3595 = call i64 @rt_num_eq(i64 %t3589, i64 328)
  br label %fixmerge1052
fixmerge1052:
  %t3596 = phi i64 [ %t3594, %fixfast1050 ], [ %t3595, %fixslow1051 ]
  %t3597 = icmp ne i64 %t3596, 1
  br i1 %t3597, label %then1053, label %else1054
then1053:
  br label %merge1055
else1054:
  %t3598 = or i64 %t3589, 744
  %t3599 = and i64 %t3598, 7
  %t3600 = icmp eq i64 %t3599, 0
  br i1 %t3600, label %fixfast1056, label %fixslow1057
fixfast1056:
  %t3601 = icmp eq i64 %t3589, 744
  %t3602 = select i1 %t3601, i64 257, i64 1
  br label %fixmerge1058
fixslow1057:
  %t3603 = call i64 @rt_num_eq(i64 %t3589, i64 744)
  br label %fixmerge1058
fixmerge1058:
  %t3604 = phi i64 [ %t3602, %fixfast1056 ], [ %t3603, %fixslow1057 ]
  br label %merge1055
merge1055:
  %t3605 = phi i64 [ %t3596, %then1053 ], [ %t3604, %fixmerge1058 ]
  %t3606 = icmp ne i64 %t3605, 1
  br i1 %t3606, label %then1059, label %else1060
then1059:
  %t3607 = load i64, ptr @"scheme.base:reverse"
  %t3608 = and i64 %t3607, -8
  %t3609 = inttoptr i64 %t3608 to ptr
  %t3610 = load i64, ptr %t3609
  %t3611 = inttoptr i64 %t3610 to ptr
  %t3612 = call fastcc i64%t3611(i64 %t3607, i64 1, i64 %a3, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t3613 = or i64 %t3579, 8
  %t3614 = and i64 %t3613, 7
  %t3615 = icmp eq i64 %t3614, 0
  br i1 %t3615, label %fixfast1061, label %fixslow1062
fixfast1061:
  %t3616 = add i64 %t3579, 8
  br label %fixmerge1063
fixslow1062:
  %t3617 = call i64 @rt_add(i64 %t3579, i64 8)
  br label %fixmerge1063
fixmerge1063:
  %t3618 = phi i64 [ %t3616, %fixfast1061 ], [ %t3617, %fixslow1062 ]
  %t3619 = call i64 @rt_cons(i64 %t3612, i64 %t3618)
  ret i64 %t3619
else1060:
  %t3620 = load i64, ptr @"scheme.base:rd-dot?"
  %t3621 = and i64 %t3620, -8
  %t3622 = inttoptr i64 %t3621 to ptr
  %t3623 = load i64, ptr %t3622
  %t3624 = inttoptr i64 %t3623 to ptr
  %t3625 = call fastcc i64%t3624(i64 %t3620, i64 3, i64 %a0, i64 %a1, i64 %t3579, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t3626 = icmp ne i64 %t3625, 1
  br i1 %t3626, label %then1064, label %else1065
then1064:
  %t3627 = or i64 %t3579, 8
  %t3628 = and i64 %t3627, 7
  %t3629 = icmp eq i64 %t3628, 0
  br i1 %t3629, label %fixfast1066, label %fixslow1067
fixfast1066:
  %t3630 = add i64 %t3579, 8
  br label %fixmerge1068
fixslow1067:
  %t3631 = call i64 @rt_add(i64 %t3579, i64 8)
  br label %fixmerge1068
fixmerge1068:
  %t3632 = phi i64 [ %t3630, %fixfast1066 ], [ %t3631, %fixslow1067 ]
  %t3633 = load i64, ptr @"scheme.base:rd-skip-ws"
  %t3634 = and i64 %t3633, -8
  %t3635 = inttoptr i64 %t3634 to ptr
  %t3636 = load i64, ptr %t3635
  %t3637 = inttoptr i64 %t3636 to ptr
  %t3638 = call fastcc i64%t3637(i64 %t3633, i64 3, i64 %a0, i64 %a1, i64 %t3632, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t3639 = load i64, ptr @"scheme.base:rd-datum"
  %t3640 = and i64 %t3639, -8
  %t3641 = inttoptr i64 %t3640 to ptr
  %t3642 = load i64, ptr %t3641
  %t3643 = inttoptr i64 %t3642 to ptr
  %t3644 = call fastcc i64%t3643(i64 %t3639, i64 3, i64 %a0, i64 %a1, i64 %t3638, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t3645 = call i64 @rt_cdr(i64 %t3644)
  %t3646 = load i64, ptr @"scheme.base:rd-skip-ws"
  %t3647 = and i64 %t3646, -8
  %t3648 = inttoptr i64 %t3647 to ptr
  %t3649 = load i64, ptr %t3648
  %t3650 = inttoptr i64 %t3649 to ptr
  %t3651 = call fastcc i64%t3650(i64 %t3646, i64 3, i64 %a0, i64 %a1, i64 %t3645, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t3652 = call i64 @rt_car(i64 %t3644)
  %t3653 = load i64, ptr @"scheme.base:rd-append-reverse"
  %t3654 = and i64 %t3653, -8
  %t3655 = inttoptr i64 %t3654 to ptr
  %t3656 = load i64, ptr %t3655
  %t3657 = inttoptr i64 %t3656 to ptr
  %t3658 = call fastcc i64%t3657(i64 %t3653, i64 2, i64 %a3, i64 %t3652, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t3659 = or i64 %t3651, 8
  %t3660 = and i64 %t3659, 7
  %t3661 = icmp eq i64 %t3660, 0
  br i1 %t3661, label %fixfast1069, label %fixslow1070
fixfast1069:
  %t3662 = add i64 %t3651, 8
  br label %fixmerge1071
fixslow1070:
  %t3663 = call i64 @rt_add(i64 %t3651, i64 8)
  br label %fixmerge1071
fixmerge1071:
  %t3664 = phi i64 [ %t3662, %fixfast1069 ], [ %t3663, %fixslow1070 ]
  %t3665 = call i64 @rt_cons(i64 %t3658, i64 %t3664)
  ret i64 %t3665
else1065:
  %t3666 = load i64, ptr @"scheme.base:rd-datum"
  %t3667 = and i64 %t3666, -8
  %t3668 = inttoptr i64 %t3667 to ptr
  %t3669 = load i64, ptr %t3668
  %t3670 = inttoptr i64 %t3669 to ptr
  %t3671 = call fastcc i64%t3670(i64 %t3666, i64 3, i64 %a0, i64 %a1, i64 %t3579, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t3672 = call i64 @rt_cdr(i64 %t3671)
  %t3673 = call i64 @rt_car(i64 %t3671)
  %t3674 = call i64 @rt_cons(i64 %t3673, i64 %a3)
  %t3675 = load i64, ptr @"scheme.base:rd-list"
  %t3676 = and i64 %t3675, -8
  %t3677 = inttoptr i64 %t3676 to ptr
  %t3678 = load i64, ptr %t3677
  %t3679 = inttoptr i64 %t3678 to ptr
  %t3680 = musttail call fastcc i64 %t3679(i64 %t3675, i64 4, i64 %a0, i64 %a1, i64 %t3672, i64 %t3674, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t3680
else1049:
  %t3681 = load i64, ptr @"scheme.base:reverse"
  %t3682 = and i64 %t3681, -8
  %t3683 = inttoptr i64 %t3682 to ptr
  %t3684 = load i64, ptr %t3683
  %t3685 = inttoptr i64 %t3684 to ptr
  %t3686 = call fastcc i64%t3685(i64 %t3681, i64 1, i64 %a3, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t3687 = call i64 @rt_cons(i64 %t3686, i64 %t3579)
  ret i64 %t3687
}

define fastcc i64 @"scheme.base:code_1017"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t3692 = icmp eq i64 %argc, 3
  br i1 %t3692, label %argok1073, label %arityerr1072
arityerr1072:
  call void @rt_arity_error(i64 3, i64 %argc)
  unreachable
argok1073:
  %t3693 = call i64 @rt_string_ref(i64 %a0, i64 %a2)
  %t3694 = call i64 @rt_char_to_integer(i64 %t3693)
  %t3695 = or i64 %t3694, 320
  %t3696 = and i64 %t3695, 7
  %t3697 = icmp eq i64 %t3696, 0
  br i1 %t3697, label %fixfast1074, label %fixslow1075
fixfast1074:
  %t3698 = icmp eq i64 %t3694, 320
  %t3699 = select i1 %t3698, i64 257, i64 1
  br label %fixmerge1076
fixslow1075:
  %t3700 = call i64 @rt_num_eq(i64 %t3694, i64 320)
  br label %fixmerge1076
fixmerge1076:
  %t3701 = phi i64 [ %t3699, %fixfast1074 ], [ %t3700, %fixslow1075 ]
  %t3702 = icmp ne i64 %t3701, 1
  br i1 %t3702, label %then1077, label %else1078
then1077:
  %t3703 = or i64 %a2, 8
  %t3704 = and i64 %t3703, 7
  %t3705 = icmp eq i64 %t3704, 0
  br i1 %t3705, label %fixfast1079, label %fixslow1080
fixfast1079:
  %t3706 = add i64 %a2, 8
  br label %fixmerge1081
fixslow1080:
  %t3707 = call i64 @rt_add(i64 %a2, i64 8)
  br label %fixmerge1081
fixmerge1081:
  %t3708 = phi i64 [ %t3706, %fixfast1079 ], [ %t3707, %fixslow1080 ]
  %t3709 = load i64, ptr @"scheme.base:rd-list"
  %t3710 = and i64 %t3709, -8
  %t3711 = inttoptr i64 %t3710 to ptr
  %t3712 = load i64, ptr %t3711
  %t3713 = inttoptr i64 %t3712 to ptr
  %t3714 = musttail call fastcc i64 %t3713(i64 %t3709, i64 4, i64 %a0, i64 %a1, i64 %t3708, i64 2, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t3714
else1078:
  %t3715 = or i64 %t3694, 728
  %t3716 = and i64 %t3715, 7
  %t3717 = icmp eq i64 %t3716, 0
  br i1 %t3717, label %fixfast1082, label %fixslow1083
fixfast1082:
  %t3718 = icmp eq i64 %t3694, 728
  %t3719 = select i1 %t3718, i64 257, i64 1
  br label %fixmerge1084
fixslow1083:
  %t3720 = call i64 @rt_num_eq(i64 %t3694, i64 728)
  br label %fixmerge1084
fixmerge1084:
  %t3721 = phi i64 [ %t3719, %fixfast1082 ], [ %t3720, %fixslow1083 ]
  %t3722 = icmp ne i64 %t3721, 1
  br i1 %t3722, label %then1085, label %else1086
then1085:
  %t3723 = or i64 %a2, 8
  %t3724 = and i64 %t3723, 7
  %t3725 = icmp eq i64 %t3724, 0
  br i1 %t3725, label %fixfast1087, label %fixslow1088
fixfast1087:
  %t3726 = add i64 %a2, 8
  br label %fixmerge1089
fixslow1088:
  %t3727 = call i64 @rt_add(i64 %a2, i64 8)
  br label %fixmerge1089
fixmerge1089:
  %t3728 = phi i64 [ %t3726, %fixfast1087 ], [ %t3727, %fixslow1088 ]
  %t3729 = load i64, ptr @"scheme.base:rd-list"
  %t3730 = and i64 %t3729, -8
  %t3731 = inttoptr i64 %t3730 to ptr
  %t3732 = load i64, ptr %t3731
  %t3733 = inttoptr i64 %t3732 to ptr
  %t3734 = musttail call fastcc i64 %t3733(i64 %t3729, i64 4, i64 %a0, i64 %a1, i64 %t3728, i64 2, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t3734
else1086:
  %t3735 = or i64 %t3694, 312
  %t3736 = and i64 %t3735, 7
  %t3737 = icmp eq i64 %t3736, 0
  br i1 %t3737, label %fixfast1090, label %fixslow1091
fixfast1090:
  %t3738 = icmp eq i64 %t3694, 312
  %t3739 = select i1 %t3738, i64 257, i64 1
  br label %fixmerge1092
fixslow1091:
  %t3740 = call i64 @rt_num_eq(i64 %t3694, i64 312)
  br label %fixmerge1092
fixmerge1092:
  %t3741 = phi i64 [ %t3739, %fixfast1090 ], [ %t3740, %fixslow1091 ]
  %t3742 = icmp ne i64 %t3741, 1
  br i1 %t3742, label %then1093, label %else1094
then1093:
  %t3743 = or i64 %a2, 8
  %t3744 = and i64 %t3743, 7
  %t3745 = icmp eq i64 %t3744, 0
  br i1 %t3745, label %fixfast1095, label %fixslow1096
fixfast1095:
  %t3746 = add i64 %a2, 8
  br label %fixmerge1097
fixslow1096:
  %t3747 = call i64 @rt_add(i64 %a2, i64 8)
  br label %fixmerge1097
fixmerge1097:
  %t3748 = phi i64 [ %t3746, %fixfast1095 ], [ %t3747, %fixslow1096 ]
  %t3749 = load i64, ptr @"scheme.base:rd-quote"
  %t3750 = and i64 %t3749, -8
  %t3751 = inttoptr i64 %t3750 to ptr
  %t3752 = load i64, ptr %t3751
  %t3753 = inttoptr i64 %t3752 to ptr
  %t3754 = musttail call fastcc i64 %t3753(i64 %t3749, i64 3, i64 %a0, i64 %a1, i64 %t3748, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t3754
else1094:
  %t3755 = or i64 %t3694, 768
  %t3756 = and i64 %t3755, 7
  %t3757 = icmp eq i64 %t3756, 0
  br i1 %t3757, label %fixfast1098, label %fixslow1099
fixfast1098:
  %t3758 = icmp eq i64 %t3694, 768
  %t3759 = select i1 %t3758, i64 257, i64 1
  br label %fixmerge1100
fixslow1099:
  %t3760 = call i64 @rt_num_eq(i64 %t3694, i64 768)
  br label %fixmerge1100
fixmerge1100:
  %t3761 = phi i64 [ %t3759, %fixfast1098 ], [ %t3760, %fixslow1099 ]
  %t3762 = icmp ne i64 %t3761, 1
  br i1 %t3762, label %then1101, label %else1102
then1101:
  %t3763 = or i64 %a2, 8
  %t3764 = and i64 %t3763, 7
  %t3765 = icmp eq i64 %t3764, 0
  br i1 %t3765, label %fixfast1103, label %fixslow1104
fixfast1103:
  %t3766 = add i64 %a2, 8
  br label %fixmerge1105
fixslow1104:
  %t3767 = call i64 @rt_add(i64 %a2, i64 8)
  br label %fixmerge1105
fixmerge1105:
  %t3768 = phi i64 [ %t3766, %fixfast1103 ], [ %t3767, %fixslow1104 ]
  %t3769 = load i64, ptr @"scheme.base:rd-quasi"
  %t3770 = and i64 %t3769, -8
  %t3771 = inttoptr i64 %t3770 to ptr
  %t3772 = load i64, ptr %t3771
  %t3773 = inttoptr i64 %t3772 to ptr
  %t3774 = musttail call fastcc i64 %t3773(i64 %t3769, i64 3, i64 %a0, i64 %a1, i64 %t3768, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t3774
else1102:
  %t3775 = or i64 %t3694, 352
  %t3776 = and i64 %t3775, 7
  %t3777 = icmp eq i64 %t3776, 0
  br i1 %t3777, label %fixfast1106, label %fixslow1107
fixfast1106:
  %t3778 = icmp eq i64 %t3694, 352
  %t3779 = select i1 %t3778, i64 257, i64 1
  br label %fixmerge1108
fixslow1107:
  %t3780 = call i64 @rt_num_eq(i64 %t3694, i64 352)
  br label %fixmerge1108
fixmerge1108:
  %t3781 = phi i64 [ %t3779, %fixfast1106 ], [ %t3780, %fixslow1107 ]
  %t3782 = icmp ne i64 %t3781, 1
  br i1 %t3782, label %then1109, label %else1110
then1109:
  %t3783 = or i64 %a2, 8
  %t3784 = and i64 %t3783, 7
  %t3785 = icmp eq i64 %t3784, 0
  br i1 %t3785, label %fixfast1111, label %fixslow1112
fixfast1111:
  %t3786 = add i64 %a2, 8
  br label %fixmerge1113
fixslow1112:
  %t3787 = call i64 @rt_add(i64 %a2, i64 8)
  br label %fixmerge1113
fixmerge1113:
  %t3788 = phi i64 [ %t3786, %fixfast1111 ], [ %t3787, %fixslow1112 ]
  %t3789 = load i64, ptr @"scheme.base:rd-unquote"
  %t3790 = and i64 %t3789, -8
  %t3791 = inttoptr i64 %t3790 to ptr
  %t3792 = load i64, ptr %t3791
  %t3793 = inttoptr i64 %t3792 to ptr
  %t3794 = musttail call fastcc i64 %t3793(i64 %t3789, i64 3, i64 %a0, i64 %a1, i64 %t3788, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t3794
else1110:
  %t3795 = or i64 %t3694, 272
  %t3796 = and i64 %t3795, 7
  %t3797 = icmp eq i64 %t3796, 0
  br i1 %t3797, label %fixfast1114, label %fixslow1115
fixfast1114:
  %t3798 = icmp eq i64 %t3694, 272
  %t3799 = select i1 %t3798, i64 257, i64 1
  br label %fixmerge1116
fixslow1115:
  %t3800 = call i64 @rt_num_eq(i64 %t3694, i64 272)
  br label %fixmerge1116
fixmerge1116:
  %t3801 = phi i64 [ %t3799, %fixfast1114 ], [ %t3800, %fixslow1115 ]
  %t3802 = icmp ne i64 %t3801, 1
  br i1 %t3802, label %then1117, label %else1118
then1117:
  %t3803 = or i64 %a2, 8
  %t3804 = and i64 %t3803, 7
  %t3805 = icmp eq i64 %t3804, 0
  br i1 %t3805, label %fixfast1119, label %fixslow1120
fixfast1119:
  %t3806 = add i64 %a2, 8
  br label %fixmerge1121
fixslow1120:
  %t3807 = call i64 @rt_add(i64 %a2, i64 8)
  br label %fixmerge1121
fixmerge1121:
  %t3808 = phi i64 [ %t3806, %fixfast1119 ], [ %t3807, %fixslow1120 ]
  %t3809 = load i64, ptr @"scheme.base:rd-string"
  %t3810 = and i64 %t3809, -8
  %t3811 = inttoptr i64 %t3810 to ptr
  %t3812 = load i64, ptr %t3811
  %t3813 = inttoptr i64 %t3812 to ptr
  %t3814 = musttail call fastcc i64 %t3813(i64 %t3809, i64 3, i64 %a0, i64 %a1, i64 %t3808, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t3814
else1118:
  %t3815 = or i64 %t3694, 280
  %t3816 = and i64 %t3815, 7
  %t3817 = icmp eq i64 %t3816, 0
  br i1 %t3817, label %fixfast1122, label %fixslow1123
fixfast1122:
  %t3818 = icmp eq i64 %t3694, 280
  %t3819 = select i1 %t3818, i64 257, i64 1
  br label %fixmerge1124
fixslow1123:
  %t3820 = call i64 @rt_num_eq(i64 %t3694, i64 280)
  br label %fixmerge1124
fixmerge1124:
  %t3821 = phi i64 [ %t3819, %fixfast1122 ], [ %t3820, %fixslow1123 ]
  %t3822 = icmp ne i64 %t3821, 1
  br i1 %t3822, label %then1125, label %else1126
then1125:
  %t3823 = or i64 %a2, 8
  %t3824 = and i64 %t3823, 7
  %t3825 = icmp eq i64 %t3824, 0
  br i1 %t3825, label %fixfast1127, label %fixslow1128
fixfast1127:
  %t3826 = add i64 %a2, 8
  br label %fixmerge1129
fixslow1128:
  %t3827 = call i64 @rt_add(i64 %a2, i64 8)
  br label %fixmerge1129
fixmerge1129:
  %t3828 = phi i64 [ %t3826, %fixfast1127 ], [ %t3827, %fixslow1128 ]
  %t3829 = load i64, ptr @"scheme.base:rd-hash"
  %t3830 = and i64 %t3829, -8
  %t3831 = inttoptr i64 %t3830 to ptr
  %t3832 = load i64, ptr %t3831
  %t3833 = inttoptr i64 %t3832 to ptr
  %t3834 = musttail call fastcc i64 %t3833(i64 %t3829, i64 3, i64 %a0, i64 %a1, i64 %t3828, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t3834
else1126:
  %t3835 = load i64, ptr @"scheme.base:rd-atom"
  %t3836 = and i64 %t3835, -8
  %t3837 = inttoptr i64 %t3836 to ptr
  %t3838 = load i64, ptr %t3837
  %t3839 = inttoptr i64 %t3838 to ptr
  %t3840 = musttail call fastcc i64 %t3839(i64 %t3835, i64 3, i64 %a0, i64 %a1, i64 %a2, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t3840
}

define fastcc i64 @"scheme.base:code_1021"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t3845 = icmp eq i64 %argc, 1
  br i1 %t3845, label %argok1131, label %arityerr1130
arityerr1130:
  call void @rt_arity_error(i64 1, i64 %argc)
  unreachable
argok1131:
  %t3846 = call i64 @rt_string_length(i64 %a0)
  %t3847 = load i64, ptr @"scheme.base:rd-skip-ws"
  %t3848 = and i64 %t3847, -8
  %t3849 = inttoptr i64 %t3848 to ptr
  %t3850 = load i64, ptr %t3849
  %t3851 = inttoptr i64 %t3850 to ptr
  %t3852 = call fastcc i64%t3851(i64 %t3847, i64 3, i64 %a0, i64 %t3846, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t3853 = load i64, ptr @"scheme.base:rd-datum"
  %t3854 = and i64 %t3853, -8
  %t3855 = inttoptr i64 %t3854 to ptr
  %t3856 = load i64, ptr %t3855
  %t3857 = inttoptr i64 %t3856 to ptr
  %t3858 = call fastcc i64%t3857(i64 %t3853, i64 3, i64 %a0, i64 %t3846, i64 %t3852, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t3859 = call i64 @rt_car(i64 %t3858)
  ret i64 %t3859
}

define fastcc i64 @"scheme.base:code_1035"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t3864 = icmp eq i64 %argc, 2
  br i1 %t3864, label %argok1133, label %arityerr1132
arityerr1132:
  call void @rt_arity_error(i64 2, i64 %argc)
  unreachable
argok1133:
  %t3865 = and i64 %self, -8
  %t3866 = inttoptr i64 %t3865 to ptr
  %t3867 = getelementptr i64, ptr %t3866, i64 1
  %t3868 = load i64, ptr %t3867
  %t3869 = or i64 %a0, %t3868
  %t3870 = and i64 %t3869, 7
  %t3871 = icmp eq i64 %t3870, 0
  br i1 %t3871, label %fixfast1134, label %fixslow1135
fixfast1134:
  %t3872 = icmp slt i64 %a0, %t3868
  %t3873 = select i1 %t3872, i64 257, i64 1
  br label %fixmerge1136
fixslow1135:
  %t3874 = call i64 @rt_lt(i64 %a0, i64 %t3868)
  br label %fixmerge1136
fixmerge1136:
  %t3875 = phi i64 [ %t3873, %fixfast1134 ], [ %t3874, %fixslow1135 ]
  %t3876 = icmp ne i64 %t3875, 1
  br i1 %t3876, label %then1137, label %else1138
then1137:
  %t3877 = and i64 %self, -8
  %t3878 = inttoptr i64 %t3877 to ptr
  %t3879 = getelementptr i64, ptr %t3878, i64 2
  %t3880 = load i64, ptr %t3879
  %t3881 = and i64 %self, -8
  %t3882 = inttoptr i64 %t3881 to ptr
  %t3883 = getelementptr i64, ptr %t3882, i64 1
  %t3884 = load i64, ptr %t3883
  %t3885 = load i64, ptr @"scheme.base:rd-datum"
  %t3886 = and i64 %t3885, -8
  %t3887 = inttoptr i64 %t3886 to ptr
  %t3888 = load i64, ptr %t3887
  %t3889 = inttoptr i64 %t3888 to ptr
  %t3890 = call fastcc i64%t3889(i64 %t3885, i64 3, i64 %t3880, i64 %t3884, i64 %a0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t3891 = and i64 %self, -8
  %t3892 = inttoptr i64 %t3891 to ptr
  %t3893 = getelementptr i64, ptr %t3892, i64 2
  %t3894 = load i64, ptr %t3893
  %t3895 = and i64 %self, -8
  %t3896 = inttoptr i64 %t3895 to ptr
  %t3897 = getelementptr i64, ptr %t3896, i64 1
  %t3898 = load i64, ptr %t3897
  %t3899 = call i64 @rt_cdr(i64 %t3890)
  %t3900 = load i64, ptr @"scheme.base:rd-skip-ws"
  %t3901 = and i64 %t3900, -8
  %t3902 = inttoptr i64 %t3901 to ptr
  %t3903 = load i64, ptr %t3902
  %t3904 = inttoptr i64 %t3903 to ptr
  %t3905 = call fastcc i64%t3904(i64 %t3900, i64 3, i64 %t3894, i64 %t3898, i64 %t3899, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t3906 = call i64 @rt_car(i64 %t3890)
  %t3907 = call i64 @rt_cons(i64 %t3906, i64 %a1)
  %t3908 = musttail call fastcc i64 @"scheme.base:code_1035"(i64 %self, i64 2, i64 %t3905, i64 %t3907, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t3908
else1138:
  %t3909 = load i64, ptr @"scheme.base:reverse"
  %t3910 = and i64 %t3909, -8
  %t3911 = inttoptr i64 %t3910 to ptr
  %t3912 = load i64, ptr %t3911
  %t3913 = inttoptr i64 %t3912 to ptr
  %t3914 = musttail call fastcc i64 %t3913(i64 %t3909, i64 1, i64 %a1, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t3914
}

define fastcc i64 @"scheme.base:code_1033"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t3915 = icmp eq i64 %argc, 1
  br i1 %t3915, label %argok1140, label %arityerr1139
arityerr1139:
  call void @rt_arity_error(i64 1, i64 %argc)
  unreachable
argok1140:
  %t3916 = call i64 @rt_string_length(i64 %a0)
  %t3917 = call i64 @rt_alloc_words(i64 4)
  %t3918 = inttoptr i64 %t3917 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_1035" to i64), ptr %t3918
  %t3919 = or i64 %t3917, 4
  %t3920 = getelementptr i64, ptr %t3918, i64 1
  store i64 %t3916, ptr %t3920
  %t3921 = getelementptr i64, ptr %t3918, i64 2
  store i64 %a0, ptr %t3921
  %t3922 = getelementptr i64, ptr %t3918, i64 3
  store i64 %t3919, ptr %t3922
  %t3923 = load i64, ptr @"scheme.base:rd-skip-ws"
  %t3924 = and i64 %t3923, -8
  %t3925 = inttoptr i64 %t3924 to ptr
  %t3926 = load i64, ptr %t3925
  %t3927 = inttoptr i64 %t3926 to ptr
  %t3928 = call fastcc i64%t3927(i64 %t3923, i64 3, i64 %a0, i64 %t3916, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t3929 = and i64 %t3919, -8
  %t3930 = inttoptr i64 %t3929 to ptr
  %t3931 = load i64, ptr %t3930
  %t3932 = inttoptr i64 %t3931 to ptr
  %t3933 = musttail call fastcc i64 %t3932(i64 %t3919, i64 2, i64 %t3928, i64 2, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t3933
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
  %t162 = call i64 @rt_alloc_words(i64 1)
  %t163 = inttoptr i64 %t162 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_43" to i64), ptr %t163
  %t164 = or i64 %t162, 4
  %t165 = call i64 @rt_root(i64 %t164)
  store i64 %t165, ptr @"scheme.base:length"
  ret i64 %t165
}

define i64 @"scheme.base:__init_15"() {
entry:
  %t183 = call i64 @rt_alloc_words(i64 1)
  %t184 = inttoptr i64 %t183 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_51" to i64), ptr %t184
  %t185 = or i64 %t183, 4
  %t186 = call i64 @rt_root(i64 %t185)
  store i64 %t186, ptr @"scheme.base:reverse"
  ret i64 %t186
}

define i64 @"scheme.base:__init_16"() {
entry:
  %t199 = call i64 @rt_alloc_words(i64 1)
  %t200 = inttoptr i64 %t199 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_57" to i64), ptr %t200
  %t201 = or i64 %t199, 4
  %t202 = call i64 @rt_root(i64 %t201)
  store i64 %t202, ptr @"scheme.base:%append2"
  ret i64 %t202
}

define i64 @"scheme.base:__init_17"() {
entry:
  %t257 = call i64 @rt_alloc_words(i64 1)
  %t258 = inttoptr i64 %t257 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_60" to i64), ptr %t258
  %t259 = or i64 %t257, 4
  %t260 = call i64 @rt_root(i64 %t259)
  store i64 %t260, ptr @"scheme.base:append"
  ret i64 %t260
}

define i64 @"scheme.base:__init_18"() {
entry:
  %t278 = call i64 @rt_alloc_words(i64 1)
  %t279 = inttoptr i64 %t278 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_64" to i64), ptr %t279
  %t280 = or i64 %t278, 4
  %t281 = call i64 @rt_root(i64 %t280)
  store i64 %t281, ptr @"scheme.base:%map1"
  ret i64 %t281
}

define i64 @"scheme.base:__init_19"() {
entry:
  %t295 = call i64 @rt_alloc_words(i64 1)
  %t296 = inttoptr i64 %t295 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_67" to i64), ptr %t296
  %t297 = or i64 %t295, 4
  %t298 = call i64 @rt_root(i64 %t297)
  store i64 %t298, ptr @"scheme.base:%any-null?"
  ret i64 %t298
}

define i64 @"scheme.base:__init_20"() {
entry:
  %t363 = call i64 @rt_alloc_words(i64 1)
  %t364 = inttoptr i64 %t363 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_73" to i64), ptr %t364
  %t365 = or i64 %t363, 4
  %t366 = call i64 @rt_root(i64 %t365)
  store i64 %t366, ptr @"scheme.base:%mapn"
  ret i64 %t366
}

define i64 @"scheme.base:__init_21"() {
entry:
  %t394 = call i64 @rt_alloc_words(i64 1)
  %t395 = inttoptr i64 %t394 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_82" to i64), ptr %t395
  %t396 = or i64 %t394, 4
  %t397 = call i64 @rt_root(i64 %t396)
  store i64 %t397, ptr @"scheme.base:map"
  ret i64 %t397
}

define i64 @"scheme.base:__init_22"() {
entry:
  %t411 = call i64 @rt_alloc_words(i64 1)
  %t412 = inttoptr i64 %t411 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_90" to i64), ptr %t412
  %t413 = or i64 %t411, 4
  %t414 = call i64 @rt_root(i64 %t413)
  store i64 %t414, ptr @"scheme.base:memq"
  ret i64 %t414
}

define i64 @"scheme.base:__init_23"() {
entry:
  %t428 = call i64 @rt_alloc_words(i64 1)
  %t429 = inttoptr i64 %t428 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_98" to i64), ptr %t429
  %t430 = or i64 %t428, 4
  %t431 = call i64 @rt_root(i64 %t430)
  store i64 %t431, ptr @"scheme.base:memv"
  ret i64 %t431
}

define i64 @"scheme.base:__init_24"() {
entry:
  %t447 = call i64 @rt_alloc_words(i64 1)
  %t448 = inttoptr i64 %t447 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_106" to i64), ptr %t448
  %t449 = or i64 %t447, 4
  %t450 = call i64 @rt_root(i64 %t449)
  store i64 %t450, ptr @"scheme.base:assq"
  ret i64 %t450
}

define i64 @"scheme.base:__init_25"() {
entry:
  %t464 = call i64 @rt_alloc_words(i64 1)
  %t465 = inttoptr i64 %t464 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_110" to i64), ptr %t465
  %t466 = or i64 %t464, 4
  %t467 = call i64 @rt_root(i64 %t466)
  store i64 %t467, ptr @"scheme.base:member"
  ret i64 %t467
}

define i64 @"scheme.base:__init_26"() {
entry:
  %t483 = call i64 @rt_alloc_words(i64 1)
  %t484 = inttoptr i64 %t483 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_114" to i64), ptr %t484
  %t485 = or i64 %t483, 4
  %t486 = call i64 @rt_root(i64 %t485)
  store i64 %t486, ptr @"scheme.base:assoc"
  ret i64 %t486
}

define i64 @"scheme.base:__init_27"() {
entry:
  %t513 = call i64 @rt_alloc_words(i64 1)
  %t514 = inttoptr i64 %t513 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_118" to i64), ptr %t514
  %t515 = or i64 %t513, 4
  %t516 = call i64 @rt_root(i64 %t515)
  store i64 %t516, ptr @"scheme.base:filter"
  ret i64 %t516
}

define i64 @"scheme.base:__init_28"() {
entry:
  %t533 = call i64 @rt_alloc_words(i64 1)
  %t534 = inttoptr i64 %t533 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_123" to i64), ptr %t534
  %t535 = or i64 %t533, 4
  %t536 = call i64 @rt_root(i64 %t535)
  store i64 %t536, ptr @"scheme.base:fold-left"
  ret i64 %t536
}

define i64 @"scheme.base:__init_29"() {
entry:
  %t553 = call i64 @rt_alloc_words(i64 1)
  %t554 = inttoptr i64 %t553 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_128" to i64), ptr %t554
  %t555 = or i64 %t553, 4
  %t556 = call i64 @rt_root(i64 %t555)
  store i64 %t556, ptr @"scheme.base:fold-right"
  ret i64 %t556
}

define i64 @"scheme.base:__init_30"() {
entry:
  %t574 = call i64 @rt_alloc_words(i64 1)
  %t575 = inttoptr i64 %t574 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_132" to i64), ptr %t575
  %t576 = or i64 %t574, 4
  %t577 = call i64 @rt_root(i64 %t576)
  store i64 %t577, ptr @"scheme.base:%for-each1"
  ret i64 %t577
}

define i64 @"scheme.base:__init_31"() {
entry:
  %t642 = call i64 @rt_alloc_words(i64 1)
  %t643 = inttoptr i64 %t642 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_138" to i64), ptr %t643
  %t644 = or i64 %t642, 4
  %t645 = call i64 @rt_root(i64 %t644)
  store i64 %t645, ptr @"scheme.base:%for-eachn"
  ret i64 %t645
}

define i64 @"scheme.base:__init_32"() {
entry:
  %t673 = call i64 @rt_alloc_words(i64 1)
  %t674 = inttoptr i64 %t673 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_147" to i64), ptr %t674
  %t675 = or i64 %t673, 4
  %t676 = call i64 @rt_root(i64 %t675)
  store i64 %t676, ptr @"scheme.base:for-each"
  ret i64 %t676
}

define i64 @"scheme.base:__init_33"() {
entry:
  %t694 = call i64 @rt_alloc_words(i64 1)
  %t695 = inttoptr i64 %t694 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_151" to i64), ptr %t695
  %t696 = or i64 %t694, 4
  %t697 = call i64 @rt_root(i64 %t696)
  store i64 %t697, ptr @"scheme.base:andmap"
  ret i64 %t697
}

define i64 @"scheme.base:__init_34"() {
entry:
  %t715 = call i64 @rt_alloc_words(i64 1)
  %t716 = inttoptr i64 %t715 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_155" to i64), ptr %t716
  %t717 = or i64 %t715, 4
  %t718 = call i64 @rt_root(i64 %t717)
  store i64 %t718, ptr @"scheme.base:memp"
  ret i64 %t718
}

define i64 @"scheme.base:__init_35"() {
entry:
  %t727 = call i64 @rt_alloc_words(i64 1)
  %t728 = inttoptr i64 %t727 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_158" to i64), ptr %t728
  %t729 = or i64 %t727, 4
  %t730 = call i64 @rt_root(i64 %t729)
  store i64 %t730, ptr @"scheme.base:cadddr"
  ret i64 %t730
}

define i64 @"scheme.base:__init_36"() {
entry:
  %t743 = call i64 @rt_alloc_words(i64 1)
  %t744 = inttoptr i64 %t743 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_161" to i64), ptr %t744
  %t745 = or i64 %t743, 4
  %t746 = call i64 @rt_root(i64 %t745)
  store i64 %t746, ptr @"scheme.base:list?"
  ret i64 %t746
}

define i64 @"scheme.base:__init_37"() {
entry:
  %t755 = call i64 @rt_alloc_words(i64 1)
  %t756 = inttoptr i64 %t755 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_168" to i64), ptr %t756
  %t757 = or i64 %t755, 4
  %t758 = call i64 @rt_root(i64 %t757)
  store i64 %t758, ptr @"scheme.base:zero?"
  ret i64 %t758
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
  %t819 = call i64 @rt_alloc_words(i64 1)
  %t820 = inttoptr i64 %t819 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_180" to i64), ptr %t820
  %t821 = or i64 %t819, 4
  %t822 = call i64 @rt_root(i64 %t821)
  store i64 %t822, ptr @"scheme.base:list-head"
  ret i64 %t822
}

define i64 @"scheme.base:__init_41"() {
entry:
  %t844 = call i64 @rt_alloc_words(i64 1)
  %t845 = inttoptr i64 %t844 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_184" to i64), ptr %t845
  %t846 = or i64 %t844, 4
  %t847 = call i64 @rt_root(i64 %t846)
  store i64 %t847, ptr @"scheme.base:make-list"
  ret i64 %t847
}

define i64 @"scheme.base:__init_42"() {
entry:
  %t886 = call i64 @rt_alloc_words(i64 1)
  %t887 = inttoptr i64 %t886 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_194" to i64), ptr %t887
  %t888 = or i64 %t886, 4
  %t889 = call i64 @rt_root(i64 %t888)
  store i64 %t889, ptr @"scheme.base:iota"
  ret i64 %t889
}

define i64 @"scheme.base:__init_43"() {
entry:
  %t899 = call i64 @rt_alloc_words(i64 1)
  %t900 = inttoptr i64 %t899 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_204" to i64), ptr %t900
  %t901 = or i64 %t899, 4
  %t902 = call i64 @rt_root(i64 %t901)
  store i64 %t902, ptr @"scheme.base:max"
  ret i64 %t902
}

define i64 @"scheme.base:__init_44"() {
entry:
  %t905 = call i64 @rt_alloc_words(i64 1)
  %t906 = inttoptr i64 %t905 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_206" to i64), ptr %t906
  %t907 = or i64 %t905, 4
  %t908 = call i64 @rt_root(i64 %t907)
  store i64 %t908, ptr @"scheme.base:void"
  ret i64 %t908
}

define i64 @"scheme.base:__init_45"() {
entry:
  %t922 = call i64 @rt_alloc_words(i64 1)
  %t923 = inttoptr i64 %t922 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_209" to i64), ptr %t923
  %t924 = or i64 %t922, 4
  %t925 = call i64 @rt_root(i64 %t924)
  store i64 %t925, ptr @"scheme.base:string"
  ret i64 %t925
}

define i64 @"scheme.base:__init_46"() {
entry:
  %t939 = call i64 @rt_alloc_words(i64 1)
  %t940 = inttoptr i64 %t939 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_212" to i64), ptr %t940
  %t941 = or i64 %t939, 4
  %t942 = call i64 @rt_root(i64 %t941)
  store i64 %t942, ptr @"scheme.base:%str-concat"
  ret i64 %t942
}

define i64 @"scheme.base:__init_47"() {
entry:
  %t962 = call i64 @rt_alloc_words(i64 1)
  %t963 = inttoptr i64 %t962 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_218" to i64), ptr %t963
  %t964 = or i64 %t962, 4
  %t965 = call i64 @rt_root(i64 %t964)
  store i64 %t965, ptr @"scheme.base:chr-cmp"
  ret i64 %t965
}

define i64 @"scheme.base:__init_48"() {
entry:
  %t995 = call i64 @rt_alloc_words(i64 1)
  %t996 = inttoptr i64 %t995 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_229" to i64), ptr %t996
  %t997 = or i64 %t995, 4
  %t998 = call i64 @rt_root(i64 %t997)
  store i64 %t998, ptr @"scheme.base:char=?"
  ret i64 %t998
}

define i64 @"scheme.base:__init_49"() {
entry:
  %t1028 = call i64 @rt_alloc_words(i64 1)
  %t1029 = inttoptr i64 %t1028 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_242" to i64), ptr %t1029
  %t1030 = or i64 %t1028, 4
  %t1031 = call i64 @rt_root(i64 %t1030)
  store i64 %t1031, ptr @"scheme.base:char<?"
  ret i64 %t1031
}

define i64 @"scheme.base:__init_50"() {
entry:
  %t1061 = call i64 @rt_alloc_words(i64 1)
  %t1062 = inttoptr i64 %t1061 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_255" to i64), ptr %t1062
  %t1063 = or i64 %t1061, 4
  %t1064 = call i64 @rt_root(i64 %t1063)
  store i64 %t1064, ptr @"scheme.base:char>?"
  ret i64 %t1064
}

define i64 @"scheme.base:__init_51"() {
entry:
  %t1102 = call i64 @rt_alloc_words(i64 1)
  %t1103 = inttoptr i64 %t1102 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_268" to i64), ptr %t1103
  %t1104 = or i64 %t1102, 4
  %t1105 = call i64 @rt_root(i64 %t1104)
  store i64 %t1105, ptr @"scheme.base:char<=?"
  ret i64 %t1105
}

define i64 @"scheme.base:__init_52"() {
entry:
  %t1143 = call i64 @rt_alloc_words(i64 1)
  %t1144 = inttoptr i64 %t1143 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_281" to i64), ptr %t1144
  %t1145 = or i64 %t1143, 4
  %t1146 = call i64 @rt_root(i64 %t1145)
  store i64 %t1146, ptr @"scheme.base:char>=?"
  ret i64 %t1146
}

define i64 @"scheme.base:__init_53"() {
entry:
  %t1187 = call i64 @rt_alloc_words(i64 1)
  %t1188 = inttoptr i64 %t1187 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_293" to i64), ptr %t1188
  %t1189 = or i64 %t1187, 4
  %t1190 = call i64 @rt_root(i64 %t1189)
  store i64 %t1190, ptr @"scheme.base:string->list"
  ret i64 %t1190
}

define i64 @"scheme.base:__init_54"() {
entry:
  %t1223 = call i64 @rt_alloc_words(i64 1)
  %t1224 = inttoptr i64 %t1223 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_305" to i64), ptr %t1224
  %t1225 = or i64 %t1223, 4
  %t1226 = call i64 @rt_root(i64 %t1225)
  store i64 %t1226, ptr @"scheme.base:ns-digits"
  ret i64 %t1226
}

define i64 @"scheme.base:__init_55"() {
entry:
  %t1269 = call i64 @rt_alloc_words(i64 1)
  %t1270 = inttoptr i64 %t1269 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_316" to i64), ptr %t1270
  %t1271 = or i64 %t1269, 4
  %t1272 = call i64 @rt_root(i64 %t1271)
  store i64 %t1272, ptr @"scheme.base:number->string"
  ret i64 %t1272
}

define i64 @"scheme.base:__init_56"() {
entry:
  %t1295 = call i64 @rt_alloc_words(i64 1)
  %t1296 = inttoptr i64 %t1295 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_320" to i64), ptr %t1296
  %t1297 = or i64 %t1295, 4
  %t1298 = call i64 @rt_root(i64 %t1297)
  store i64 %t1298, ptr @"scheme.base:error"
  ret i64 %t1298
}

define i64 @"scheme.base:__init_57"() {
entry:
  %t1301 = call i64 @rt_alloc_words(i64 1)
  %t1302 = inttoptr i64 %t1301 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_323" to i64), ptr %t1302
  %t1303 = or i64 %t1301, 4
  %t1304 = call i64 @rt_root(i64 %t1303)
  store i64 %t1304, ptr @"scheme.base:raise"
  ret i64 %t1304
}

define i64 @"scheme.base:__init_58"() {
entry:
  %t1307 = call i64 @rt_alloc_words(i64 1)
  %t1308 = inttoptr i64 %t1307 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_326" to i64), ptr %t1308
  %t1309 = or i64 %t1307, 4
  %t1310 = call i64 @rt_root(i64 %t1309)
  store i64 %t1310, ptr @"scheme.base:error-object?"
  ret i64 %t1310
}

define i64 @"scheme.base:__init_59"() {
entry:
  %t1313 = call i64 @rt_alloc_words(i64 1)
  %t1314 = inttoptr i64 %t1313 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_329" to i64), ptr %t1314
  %t1315 = or i64 %t1313, 4
  %t1316 = call i64 @rt_root(i64 %t1315)
  store i64 %t1316, ptr @"scheme.base:error-object-message"
  ret i64 %t1316
}

define i64 @"scheme.base:__init_60"() {
entry:
  %t1319 = call i64 @rt_alloc_words(i64 1)
  %t1320 = inttoptr i64 %t1319 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_332" to i64), ptr %t1320
  %t1321 = or i64 %t1319, 4
  %t1322 = call i64 @rt_root(i64 %t1321)
  store i64 %t1322, ptr @"scheme.base:error-object-irritants"
  ret i64 %t1322
}

define i64 @"scheme.base:__init_61"() {
entry:
  %t1362 = call i64 @rt_alloc_words(i64 1)
  %t1363 = inttoptr i64 %t1362 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_339" to i64), ptr %t1363
  %t1364 = or i64 %t1362, 4
  %t1365 = call i64 @rt_root(i64 %t1364)
  store i64 %t1365, ptr @"scheme.base:list->vector"
  ret i64 %t1365
}

define i64 @"scheme.base:__init_62"() {
entry:
  %t1384 = call i64 @rt_alloc_words(i64 1)
  %t1385 = inttoptr i64 %t1384 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_344" to i64), ptr %t1385
  %t1386 = or i64 %t1384, 4
  %t1387 = call i64 @rt_root(i64 %t1386)
  store i64 %t1387, ptr @"scheme.base:vector"
  ret i64 %t1387
}

define i64 @"scheme.base:__init_63"() {
entry:
  %t1427 = call i64 @rt_alloc_words(i64 1)
  %t1428 = inttoptr i64 %t1427 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_351" to i64), ptr %t1428
  %t1429 = or i64 %t1427, 4
  %t1430 = call i64 @rt_root(i64 %t1429)
  store i64 %t1430, ptr @"scheme.base:list->bytevector"
  ret i64 %t1430
}

define i64 @"scheme.base:__init_64"() {
entry:
  %t1449 = call i64 @rt_alloc_words(i64 1)
  %t1450 = inttoptr i64 %t1449 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_356" to i64), ptr %t1450
  %t1451 = or i64 %t1449, 4
  %t1452 = call i64 @rt_root(i64 %t1451)
  store i64 %t1452, ptr @"scheme.base:bytevector"
  ret i64 %t1452
}

define i64 @"scheme.base:__init_65"() {
entry:
  %t1473 = call i64 @rt_alloc_words(i64 1)
  %t1474 = inttoptr i64 %t1473 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_359" to i64), ptr %t1474
  %t1475 = or i64 %t1473, 4
  %t1476 = call i64 @rt_root(i64 %t1475)
  store i64 %t1476, ptr @"scheme.base:values"
  ret i64 %t1476
}

define i64 @"scheme.base:__init_66"() {
entry:
  %t1518 = call i64 @rt_alloc_words(i64 1)
  %t1519 = inttoptr i64 %t1518 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_364" to i64), ptr %t1519
  %t1520 = or i64 %t1518, 4
  %t1521 = call i64 @rt_root(i64 %t1520)
  store i64 %t1521, ptr @"scheme.base:call-with-values"
  ret i64 %t1521
}

define i64 @"scheme.base:__init_67"() {
entry:
  %t1522 = call i64 @rt_root(i64 64)
  store i64 %t1522, ptr @"scheme.base:%ht-initial-buckets"
  ret i64 %t1522
}

define i64 @"scheme.base:__init_68"() {
entry:
  %t1523 = call i64 @rt_root(i64 24)
  store i64 %t1523, ptr @"scheme.base:%ht-load-factor"
  ret i64 %t1523
}

define i64 @"scheme.base:__init_69"() {
entry:
  %t1534 = call i64 @rt_alloc_words(i64 1)
  %t1535 = inttoptr i64 %t1534 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_366" to i64), ptr %t1535
  %t1536 = or i64 %t1534, 4
  %t1537 = call i64 @rt_root(i64 %t1536)
  store i64 %t1537, ptr @"scheme.base:make-hash-table"
  ret i64 %t1537
}

define i64 @"scheme.base:__init_70"() {
entry:
  %t1540 = call i64 @rt_alloc_words(i64 1)
  %t1541 = inttoptr i64 %t1540 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_369" to i64), ptr %t1541
  %t1542 = or i64 %t1540, 4
  %t1543 = call i64 @rt_root(i64 %t1542)
  store i64 %t1543, ptr @"scheme.base:hash-table?"
  ret i64 %t1543
}

define i64 @"scheme.base:__init_71"() {
entry:
  %t1547 = call i64 @rt_alloc_words(i64 1)
  %t1548 = inttoptr i64 %t1547 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_372" to i64), ptr %t1548
  %t1549 = or i64 %t1547, 4
  %t1550 = call i64 @rt_root(i64 %t1549)
  store i64 %t1550, ptr @"scheme.base:%ht-count"
  ret i64 %t1550
}

define i64 @"scheme.base:__init_72"() {
entry:
  %t1554 = call i64 @rt_alloc_words(i64 1)
  %t1555 = inttoptr i64 %t1554 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_375" to i64), ptr %t1555
  %t1556 = or i64 %t1554, 4
  %t1557 = call i64 @rt_root(i64 %t1556)
  store i64 %t1557, ptr @"scheme.base:%ht-buckets"
  ret i64 %t1557
}

define i64 @"scheme.base:__init_73"() {
entry:
  %t1561 = call i64 @rt_alloc_words(i64 1)
  %t1562 = inttoptr i64 %t1561 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_379" to i64), ptr %t1562
  %t1563 = or i64 %t1561, 4
  %t1564 = call i64 @rt_root(i64 %t1563)
  store i64 %t1564, ptr @"scheme.base:%ht-set-count!"
  ret i64 %t1564
}

define i64 @"scheme.base:__init_74"() {
entry:
  %t1568 = call i64 @rt_alloc_words(i64 1)
  %t1569 = inttoptr i64 %t1568 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_383" to i64), ptr %t1569
  %t1570 = or i64 %t1568, 4
  %t1571 = call i64 @rt_root(i64 %t1570)
  store i64 %t1571, ptr @"scheme.base:%ht-set-buckets!"
  ret i64 %t1571
}

define i64 @"scheme.base:__init_75"() {
entry:
  %t1575 = call i64 @rt_alloc_words(i64 1)
  %t1576 = inttoptr i64 %t1575 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_387" to i64), ptr %t1576
  %t1577 = or i64 %t1575, 4
  %t1578 = call i64 @rt_root(i64 %t1577)
  store i64 %t1578, ptr @"scheme.base:%ht-index"
  ret i64 %t1578
}

define i64 @"scheme.base:__init_76"() {
entry:
  %t1594 = call i64 @rt_alloc_words(i64 1)
  %t1595 = inttoptr i64 %t1594 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_391" to i64), ptr %t1595
  %t1596 = or i64 %t1594, 4
  %t1597 = call i64 @rt_root(i64 %t1596)
  store i64 %t1597, ptr @"scheme.base:%ht-assoc"
  ret i64 %t1597
}

define i64 @"scheme.base:__init_77"() {
entry:
  %t1615 = call i64 @rt_alloc_words(i64 1)
  %t1616 = inttoptr i64 %t1615 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_395" to i64), ptr %t1616
  %t1617 = or i64 %t1615, 4
  %t1618 = call i64 @rt_root(i64 %t1617)
  store i64 %t1618, ptr @"scheme.base:%ht-remove"
  ret i64 %t1618
}

define i64 @"scheme.base:__init_78"() {
entry:
  %t1642 = call i64 @rt_alloc_words(i64 1)
  %t1643 = inttoptr i64 %t1642 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_402" to i64), ptr %t1643
  %t1644 = or i64 %t1642, 4
  %t1645 = call i64 @rt_root(i64 %t1644)
  store i64 %t1645, ptr @"scheme.base:hash-table-ref/default"
  ret i64 %t1645
}

define i64 @"scheme.base:__init_79"() {
entry:
  %t1668 = call i64 @rt_alloc_words(i64 1)
  %t1669 = inttoptr i64 %t1668 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_407" to i64), ptr %t1669
  %t1670 = or i64 %t1668, 4
  %t1671 = call i64 @rt_root(i64 %t1670)
  store i64 %t1671, ptr @"scheme.base:hash-table-contains?"
  ret i64 %t1671
}

define i64 @"scheme.base:__init_80"() {
entry:
  %t1702 = call i64 @rt_alloc_words(i64 1)
  %t1703 = inttoptr i64 %t1702 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_413" to i64), ptr %t1703
  %t1704 = or i64 %t1702, 4
  %t1705 = call i64 @rt_root(i64 %t1704)
  store i64 %t1705, ptr @"scheme.base:hash-table-ref"
  ret i64 %t1705
}

define i64 @"scheme.base:__init_81"() {
entry:
  %t1785 = call i64 @rt_alloc_words(i64 1)
  %t1786 = inttoptr i64 %t1785 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_427" to i64), ptr %t1786
  %t1787 = or i64 %t1785, 4
  %t1788 = call i64 @rt_root(i64 %t1787)
  store i64 %t1788, ptr @"scheme.base:hash-table-set!"
  ret i64 %t1788
}

define i64 @"scheme.base:__init_82"() {
entry:
  %t1836 = call i64 @rt_alloc_words(i64 1)
  %t1837 = inttoptr i64 %t1836 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_434" to i64), ptr %t1837
  %t1838 = or i64 %t1836, 4
  %t1839 = call i64 @rt_root(i64 %t1838)
  store i64 %t1839, ptr @"scheme.base:hash-table-delete!"
  ret i64 %t1839
}

define i64 @"scheme.base:__init_83"() {
entry:
  %t1947 = call i64 @rt_alloc_words(i64 1)
  %t1948 = inttoptr i64 %t1947 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_450" to i64), ptr %t1948
  %t1949 = or i64 %t1947, 4
  %t1950 = call i64 @rt_root(i64 %t1949)
  store i64 %t1950, ptr @"scheme.base:%ht-grow!"
  ret i64 %t1950
}

define i64 @"scheme.base:__init_84"() {
entry:
  %t1958 = call i64 @rt_alloc_words(i64 1)
  %t1959 = inttoptr i64 %t1958 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_457" to i64), ptr %t1959
  %t1960 = or i64 %t1958, 4
  %t1961 = call i64 @rt_root(i64 %t1960)
  store i64 %t1961, ptr @"scheme.base:hash-table-size"
  ret i64 %t1961
}

define i64 @"scheme.base:__init_85"() {
entry:
  %t1978 = call i64 @rt_alloc_words(i64 1)
  %t1979 = inttoptr i64 %t1978 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_461" to i64), ptr %t1979
  %t1980 = or i64 %t1978, 4
  %t1981 = call i64 @rt_root(i64 %t1980)
  store i64 %t1981, ptr @"scheme.base:%ht-fold-buckets"
  ret i64 %t1981
}

define i64 @"scheme.base:__init_86"() {
entry:
  %t2031 = call i64 @rt_alloc_words(i64 1)
  %t2032 = inttoptr i64 %t2031 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_472" to i64), ptr %t2032
  %t2033 = or i64 %t2031, 4
  %t2034 = call i64 @rt_root(i64 %t2033)
  store i64 %t2034, ptr @"scheme.base:hash-table->alist"
  ret i64 %t2034
}

define i64 @"scheme.base:__init_87"() {
entry:
  %t2053 = call i64 @rt_alloc_words(i64 1)
  %t2054 = inttoptr i64 %t2053 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_478" to i64), ptr %t2054
  %t2055 = or i64 %t2053, 4
  %t2056 = call i64 @rt_root(i64 %t2055)
  store i64 %t2056, ptr @"scheme.base:hash-table-keys"
  ret i64 %t2056
}

define i64 @"scheme.base:__init_88"() {
entry:
  %t2075 = call i64 @rt_alloc_words(i64 1)
  %t2076 = inttoptr i64 %t2075 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_484" to i64), ptr %t2076
  %t2077 = or i64 %t2075, 4
  %t2078 = call i64 @rt_root(i64 %t2077)
  store i64 %t2078, ptr @"scheme.base:hash-table-values"
  ret i64 %t2078
}

define i64 @"scheme.base:__init_89"() {
entry:
  %t2112 = call i64 @rt_alloc_words(i64 1)
  %t2113 = inttoptr i64 %t2112 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_512" to i64), ptr %t2113
  %t2114 = or i64 %t2112, 4
  %t2115 = call i64 @rt_root(i64 %t2114)
  store i64 %t2115, ptr @"scheme.base:rd-ws?"
  ret i64 %t2115
}

define i64 @"scheme.base:__init_90"() {
entry:
  %t2133 = call i64 @rt_alloc_words(i64 1)
  %t2134 = inttoptr i64 %t2133 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_524" to i64), ptr %t2134
  %t2135 = or i64 %t2133, 4
  %t2136 = call i64 @rt_root(i64 %t2135)
  store i64 %t2136, ptr @"scheme.base:rd-digit?"
  ret i64 %t2136
}

define i64 @"scheme.base:__init_91"() {
entry:
  %t2193 = call i64 @rt_alloc_words(i64 1)
  %t2194 = inttoptr i64 %t2193 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_564" to i64), ptr %t2194
  %t2195 = or i64 %t2193, 4
  %t2196 = call i64 @rt_root(i64 %t2195)
  store i64 %t2196, ptr @"scheme.base:rd-delim?"
  ret i64 %t2196
}

define i64 @"scheme.base:__init_92"() {
entry:
  %t2234 = call i64 @rt_alloc_words(i64 1)
  %t2235 = inttoptr i64 %t2234 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_577" to i64), ptr %t2235
  %t2236 = or i64 %t2234, 4
  %t2237 = call i64 @rt_root(i64 %t2236)
  store i64 %t2237, ptr @"scheme.base:rd-skip-line"
  ret i64 %t2237
}

define i64 @"scheme.base:__init_93"() {
entry:
  %t2294 = call i64 @rt_alloc_words(i64 1)
  %t2295 = inttoptr i64 %t2294 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_591" to i64), ptr %t2295
  %t2296 = or i64 %t2294, 4
  %t2297 = call i64 @rt_root(i64 %t2296)
  store i64 %t2297, ptr @"scheme.base:rd-skip-ws"
  ret i64 %t2297
}

define i64 @"scheme.base:__init_94"() {
entry:
  %t2327 = call i64 @rt_alloc_words(i64 1)
  %t2328 = inttoptr i64 %t2327 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_600" to i64), ptr %t2328
  %t2329 = or i64 %t2327, 4
  %t2330 = call i64 @rt_root(i64 %t2329)
  store i64 %t2330, ptr @"scheme.base:rd-token-end"
  ret i64 %t2330
}

define i64 @"scheme.base:__init_95"() {
entry:
  %t2360 = call i64 @rt_alloc_words(i64 1)
  %t2361 = inttoptr i64 %t2360 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_609" to i64), ptr %t2361
  %t2362 = or i64 %t2360, 4
  %t2363 = call i64 @rt_root(i64 %t2362)
  store i64 %t2363, ptr @"scheme.base:rd-all-digits?"
  ret i64 %t2363
}

define i64 @"scheme.base:__init_96"() {
entry:
  %t2421 = call i64 @rt_alloc_words(i64 1)
  %t2422 = inttoptr i64 %t2421 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_632" to i64), ptr %t2422
  %t2423 = or i64 %t2421, 4
  %t2424 = call i64 @rt_root(i64 %t2423)
  store i64 %t2424, ptr @"scheme.base:rd-numeric?"
  ret i64 %t2424
}

define i64 @"scheme.base:__init_97"() {
entry:
  %t2467 = call i64 @rt_alloc_words(i64 1)
  %t2468 = inttoptr i64 %t2467 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_642" to i64), ptr %t2468
  %t2469 = or i64 %t2467, 4
  %t2470 = call i64 @rt_root(i64 %t2469)
  store i64 %t2470, ptr @"scheme.base:rd-digits"
  ret i64 %t2470
}

define i64 @"scheme.base:__init_98"() {
entry:
  %t2515 = call i64 @rt_alloc_words(i64 1)
  %t2516 = inttoptr i64 %t2515 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_655" to i64), ptr %t2516
  %t2517 = or i64 %t2515, 4
  %t2518 = call i64 @rt_root(i64 %t2517)
  store i64 %t2518, ptr @"scheme.base:rd-parse-int"
  ret i64 %t2518
}

define i64 @"scheme.base:__init_99"() {
entry:
  %t2528 = call i64 @rt_alloc_words(i64 1)
  %t2529 = inttoptr i64 %t2528 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_662" to i64), ptr %t2529
  %t2530 = or i64 %t2528, 4
  %t2531 = call i64 @rt_root(i64 %t2530)
  store i64 %t2531, ptr @"scheme.base:rd-dotchar?"
  ret i64 %t2531
}

define i64 @"scheme.base:__init_100"() {
entry:
  %t2549 = call i64 @rt_alloc_words(i64 1)
  %t2550 = inttoptr i64 %t2549 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_676" to i64), ptr %t2550
  %t2551 = or i64 %t2549, 4
  %t2552 = call i64 @rt_root(i64 %t2551)
  store i64 %t2552, ptr @"scheme.base:rd-exp-char?"
  ret i64 %t2552
}

define i64 @"scheme.base:__init_101"() {
entry:
  %t2570 = call i64 @rt_alloc_words(i64 1)
  %t2571 = inttoptr i64 %t2570 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_690" to i64), ptr %t2571
  %t2572 = or i64 %t2570, 4
  %t2573 = call i64 @rt_root(i64 %t2572)
  store i64 %t2573, ptr @"scheme.base:rd-sign-char?"
  ret i64 %t2573
}

define i64 @"scheme.base:__init_102"() {
entry:
  %t2604 = call i64 @rt_alloc_words(i64 1)
  %t2605 = inttoptr i64 %t2604 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_699" to i64), ptr %t2605
  %t2606 = or i64 %t2604, 4
  %t2607 = call i64 @rt_root(i64 %t2606)
  store i64 %t2607, ptr @"scheme.base:rd-scan-digits"
  ret i64 %t2607
}

define i64 @"scheme.base:__init_103"() {
entry:
  %t2786 = call i64 @rt_alloc_words(i64 1)
  %t2787 = inttoptr i64 %t2786 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_759" to i64), ptr %t2787
  %t2788 = or i64 %t2786, 4
  %t2789 = call i64 @rt_root(i64 %t2788)
  store i64 %t2789, ptr @"scheme.base:rd-flonum?"
  ret i64 %t2789
}

define i64 @"scheme.base:__init_104"() {
entry:
  %t2823 = call i64 @rt_alloc_words(i64 1)
  %t2824 = inttoptr i64 %t2823 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_766" to i64), ptr %t2824
  %t2825 = or i64 %t2823, 4
  %t2826 = call i64 @rt_root(i64 %t2825)
  store i64 %t2826, ptr @"scheme.base:rd-atom"
  ret i64 %t2826
}

define i64 @"scheme.base:__init_105"() {
entry:
  %t2898 = call i64 @rt_alloc_words(i64 1)
  %t2899 = inttoptr i64 %t2898 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_794" to i64), ptr %t2899
  %t2900 = or i64 %t2898, 4
  %t2901 = call i64 @rt_root(i64 %t2900)
  store i64 %t2901, ptr @"scheme.base:rd-hex-digit"
  ret i64 %t2901
}

define i64 @"scheme.base:__init_106"() {
entry:
  %t2961 = call i64 @rt_alloc_words(i64 1)
  %t2962 = inttoptr i64 %t2961 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_808" to i64), ptr %t2962
  %t2963 = or i64 %t2961, 4
  %t2964 = call i64 @rt_root(i64 %t2963)
  store i64 %t2964, ptr @"scheme.base:rd-hex"
  ret i64 %t2964
}

define i64 @"scheme.base:__init_107"() {
entry:
  %t2994 = call i64 @rt_alloc_words(i64 1)
  %t2995 = inttoptr i64 %t2994 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_824" to i64), ptr %t2995
  %t2996 = or i64 %t2994, 4
  %t2997 = call i64 @rt_root(i64 %t2996)
  store i64 %t2997, ptr @"scheme.base:rd-str-esc"
  ret i64 %t2997
}

define i64 @"scheme.base:__init_108"() {
entry:
  %t3134 = call i64 @rt_alloc_words(i64 1)
  %t3135 = inttoptr i64 %t3134 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_852" to i64), ptr %t3135
  %t3136 = or i64 %t3134, 4
  %t3137 = call i64 @rt_root(i64 %t3136)
  store i64 %t3137, ptr @"scheme.base:rd-string"
  ret i64 %t3137
}

define i64 @"scheme.base:__init_109"() {
entry:
  %t3301 = call i64 @rt_alloc_words(i64 1)
  %t3302 = inttoptr i64 %t3301 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_895" to i64), ptr %t3302
  %t3303 = or i64 %t3301, 4
  %t3304 = call i64 @rt_root(i64 %t3303)
  store i64 %t3304, ptr @"scheme.base:rd-hash"
  ret i64 %t3304
}

define i64 @"scheme.base:__init_110"() {
entry:
  %t3343 = call i64 @rt_alloc_words(i64 1)
  %t3344 = inttoptr i64 %t3343 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_898" to i64), ptr %t3344
  %t3345 = or i64 %t3343, 4
  %t3346 = call i64 @rt_root(i64 %t3345)
  store i64 %t3346, ptr @"scheme.base:rd-char-name"
  ret i64 %t3346
}

define i64 @"scheme.base:__init_111"() {
entry:
  %t3385 = call i64 @rt_alloc_words(i64 1)
  %t3386 = inttoptr i64 %t3385 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_910" to i64), ptr %t3386
  %t3387 = or i64 %t3385, 4
  %t3388 = call i64 @rt_root(i64 %t3387)
  store i64 %t3388, ptr @"scheme.base:rd-char"
  ret i64 %t3388
}

define i64 @"scheme.base:__init_112"() {
entry:
  %t3412 = call i64 @rt_alloc_words(i64 1)
  %t3413 = inttoptr i64 %t3412 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_917" to i64), ptr %t3413
  %t3414 = or i64 %t3412, 4
  %t3415 = call i64 @rt_root(i64 %t3414)
  store i64 %t3415, ptr @"scheme.base:rd-quote"
  ret i64 %t3415
}

define i64 @"scheme.base:__init_113"() {
entry:
  %t3439 = call i64 @rt_alloc_words(i64 1)
  %t3440 = inttoptr i64 %t3439 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_924" to i64), ptr %t3440
  %t3441 = or i64 %t3439, 4
  %t3442 = call i64 @rt_root(i64 %t3441)
  store i64 %t3442, ptr @"scheme.base:rd-quasi"
  ret i64 %t3442
}

define i64 @"scheme.base:__init_114"() {
entry:
  %t3513 = call i64 @rt_alloc_words(i64 1)
  %t3514 = inttoptr i64 %t3513 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_941" to i64), ptr %t3514
  %t3515 = or i64 %t3513, 4
  %t3516 = call i64 @rt_root(i64 %t3515)
  store i64 %t3516, ptr @"scheme.base:rd-unquote"
  ret i64 %t3516
}

define i64 @"scheme.base:__init_115"() {
entry:
  %t3553 = call i64 @rt_alloc_words(i64 1)
  %t3554 = inttoptr i64 %t3553 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_954" to i64), ptr %t3554
  %t3555 = or i64 %t3553, 4
  %t3556 = call i64 @rt_root(i64 %t3555)
  store i64 %t3556, ptr @"scheme.base:rd-dot?"
  ret i64 %t3556
}

define i64 @"scheme.base:__init_116"() {
entry:
  %t3569 = call i64 @rt_alloc_words(i64 1)
  %t3570 = inttoptr i64 %t3569 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_958" to i64), ptr %t3570
  %t3571 = or i64 %t3569, 4
  %t3572 = call i64 @rt_root(i64 %t3571)
  store i64 %t3572, ptr @"scheme.base:rd-append-reverse"
  ret i64 %t3572
}

define i64 @"scheme.base:__init_117"() {
entry:
  %t3688 = call i64 @rt_alloc_words(i64 1)
  %t3689 = inttoptr i64 %t3688 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_983" to i64), ptr %t3689
  %t3690 = or i64 %t3688, 4
  %t3691 = call i64 @rt_root(i64 %t3690)
  store i64 %t3691, ptr @"scheme.base:rd-list"
  ret i64 %t3691
}

define i64 @"scheme.base:__init_118"() {
entry:
  %t3841 = call i64 @rt_alloc_words(i64 1)
  %t3842 = inttoptr i64 %t3841 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_1017" to i64), ptr %t3842
  %t3843 = or i64 %t3841, 4
  %t3844 = call i64 @rt_root(i64 %t3843)
  store i64 %t3844, ptr @"scheme.base:rd-datum"
  ret i64 %t3844
}

define i64 @"scheme.base:__init_119"() {
entry:
  %t3860 = call i64 @rt_alloc_words(i64 1)
  %t3861 = inttoptr i64 %t3860 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_1021" to i64), ptr %t3861
  %t3862 = or i64 %t3860, 4
  %t3863 = call i64 @rt_root(i64 %t3862)
  store i64 %t3863, ptr @"scheme.base:read-from-string"
  ret i64 %t3863
}

define i64 @"scheme.base:__init_120"() {
entry:
  %t3934 = call i64 @rt_alloc_words(i64 1)
  %t3935 = inttoptr i64 %t3934 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_1033" to i64), ptr %t3935
  %t3936 = or i64 %t3934, 4
  %t3937 = call i64 @rt_root(i64 %t3936)
  store i64 %t3937, ptr @"scheme.base:read-all-from-string"
  ret i64 %t3937
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
  call i64 @"scheme.base:__init_90"()
  call i64 @"scheme.base:__init_91"()
  call i64 @"scheme.base:__init_92"()
  call i64 @"scheme.base:__init_93"()
  call i64 @"scheme.base:__init_94"()
  call i64 @"scheme.base:__init_95"()
  call i64 @"scheme.base:__init_96"()
  call i64 @"scheme.base:__init_97"()
  call i64 @"scheme.base:__init_98"()
  call i64 @"scheme.base:__init_99"()
  call i64 @"scheme.base:__init_100"()
  call i64 @"scheme.base:__init_101"()
  call i64 @"scheme.base:__init_102"()
  call i64 @"scheme.base:__init_103"()
  call i64 @"scheme.base:__init_104"()
  call i64 @"scheme.base:__init_105"()
  call i64 @"scheme.base:__init_106"()
  call i64 @"scheme.base:__init_107"()
  call i64 @"scheme.base:__init_108"()
  call i64 @"scheme.base:__init_109"()
  call i64 @"scheme.base:__init_110"()
  call i64 @"scheme.base:__init_111"()
  call i64 @"scheme.base:__init_112"()
  call i64 @"scheme.base:__init_113"()
  call i64 @"scheme.base:__init_114"()
  call i64 @"scheme.base:__init_115"()
  call i64 @"scheme.base:__init_116"()
  call i64 @"scheme.base:__init_117"()
  call i64 @"scheme.base:__init_118"()
  call i64 @"scheme.base:__init_119"()
  call i64 @"scheme.base:__init_120"()
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

