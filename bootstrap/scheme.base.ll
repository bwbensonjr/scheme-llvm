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
  %t1228 = or i64 %a0, 0
  %t1229 = and i64 %t1228, 7
  %t1230 = icmp eq i64 %t1229, 0
  br i1 %t1230, label %fixfast296, label %fixslow297
fixfast296:
  %t1231 = icmp eq i64 %a0, 0
  %t1232 = select i1 %t1231, i64 257, i64 1
  br label %fixmerge298
fixslow297:
  %t1233 = call i64 @rt_num_eq(i64 %a0, i64 0)
  br label %fixmerge298
fixmerge298:
  %t1234 = phi i64 [ %t1232, %fixfast296 ], [ %t1233, %fixslow297 ]
  %t1235 = icmp ne i64 %t1234, 1
  br i1 %t1235, label %then299, label %else300
then299:
  %t1236 = call i64 @rt_make_string(ptr @.str.lit.1, i64 1)
  ret i64 %t1236
else300:
  %t1237 = or i64 %a0, 0
  %t1238 = and i64 %t1237, 7
  %t1239 = icmp eq i64 %t1238, 0
  br i1 %t1239, label %fixfast301, label %fixslow302
fixfast301:
  %t1240 = icmp slt i64 %a0, 0
  %t1241 = select i1 %t1240, i64 257, i64 1
  br label %fixmerge303
fixslow302:
  %t1242 = call i64 @rt_lt(i64 %a0, i64 0)
  br label %fixmerge303
fixmerge303:
  %t1243 = phi i64 [ %t1241, %fixfast301 ], [ %t1242, %fixslow302 ]
  %t1244 = icmp ne i64 %t1243, 1
  br i1 %t1244, label %then304, label %else305
then304:
  %t1245 = load i64, ptr @"scheme.base:ns-digits"
  %t1246 = and i64 %t1245, -8
  %t1247 = inttoptr i64 %t1246 to ptr
  %t1248 = load i64, ptr %t1247
  %t1249 = inttoptr i64 %t1248 to ptr
  %t1250 = call fastcc i64%t1249(i64 %t1245, i64 2, i64 %a0, i64 2, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t1251 = call i64 @rt_cons(i64 11529, i64 %t1250)
  %t1252 = call i64 @rt_list_to_string(i64 %t1251)
  ret i64 %t1252
else305:
  %t1253 = or i64 0, %a0
  %t1254 = and i64 %t1253, 7
  %t1255 = icmp eq i64 %t1254, 0
  br i1 %t1255, label %fixfast306, label %fixslow307
fixfast306:
  %t1256 = sub i64 0, %a0
  br label %fixmerge308
fixslow307:
  %t1257 = call i64 @rt_sub(i64 0, i64 %a0)
  br label %fixmerge308
fixmerge308:
  %t1258 = phi i64 [ %t1256, %fixfast306 ], [ %t1257, %fixslow307 ]
  %t1259 = load i64, ptr @"scheme.base:ns-digits"
  %t1260 = and i64 %t1259, -8
  %t1261 = inttoptr i64 %t1260 to ptr
  %t1262 = load i64, ptr %t1261
  %t1263 = inttoptr i64 %t1262 to ptr
  %t1264 = call fastcc i64%t1263(i64 %t1259, i64 2, i64 %t1258, i64 2, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t1265 = call i64 @rt_list_to_string(i64 %t1264)
  ret i64 %t1265
}

define fastcc i64 @"scheme.base:code_320"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1270 = icmp sge i64 %argc, 1
  br i1 %t1270, label %argok310, label %arityerr309
arityerr309:
  call void @rt_arity_error(i64 1, i64 %argc)
  unreachable
argok310:
  %t1271 = call i64 @rt_alloc_words(i64 8)
  %t1272 = inttoptr i64 %t1271 to ptr
  %t1273 = getelementptr i64, ptr %t1272, i64 0
  store i64 %a0, ptr %t1273
  %t1274 = getelementptr i64, ptr %t1272, i64 1
  store i64 %a1, ptr %t1274
  %t1275 = getelementptr i64, ptr %t1272, i64 2
  store i64 %a2, ptr %t1275
  %t1276 = getelementptr i64, ptr %t1272, i64 3
  store i64 %a3, ptr %t1276
  %t1277 = getelementptr i64, ptr %t1272, i64 4
  store i64 %a4, ptr %t1277
  %t1278 = getelementptr i64, ptr %t1272, i64 5
  store i64 %a5, ptr %t1278
  %t1279 = getelementptr i64, ptr %t1272, i64 6
  store i64 %a6, ptr %t1279
  %t1280 = getelementptr i64, ptr %t1272, i64 7
  store i64 %a7, ptr %t1280
  %t1281 = call i64 @rt_build_rest(i64 %argc, i64 1, i64 8, ptr %t1272, ptr %overflow)
  %t1282 = call i64 @rt_string_p(i64 %a0)
  %t1283 = icmp ne i64 %t1282, 1
  br i1 %t1283, label %then311, label %else312
then311:
  %t1284 = call i64 @rt_error(i64 %a0, i64 %t1281)
  ret i64 %t1284
else312:
  %t1285 = call i64 @rt_symbol_to_string(i64 %a0)
  %t1286 = call i64 @rt_make_string(ptr @.str.lit.2, i64 2)
  %t1287 = call i64 @rt_car(i64 %t1281)
  %t1288 = call i64 @rt_string_append(i64 %t1286, i64 %t1287)
  %t1289 = call i64 @rt_string_append(i64 %t1285, i64 %t1288)
  %t1290 = call i64 @rt_cdr(i64 %t1281)
  %t1291 = call i64 @rt_error(i64 %t1289, i64 %t1290)
  ret i64 %t1291
}

define fastcc i64 @"scheme.base:code_323"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1296 = icmp eq i64 %argc, 1
  br i1 %t1296, label %argok314, label %arityerr313
arityerr313:
  call void @rt_arity_error(i64 1, i64 %argc)
  unreachable
argok314:
  %t1297 = call i64 @rt_raise(i64 %a0)
  ret i64 %t1297
}

define fastcc i64 @"scheme.base:code_326"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1302 = icmp eq i64 %argc, 1
  br i1 %t1302, label %argok316, label %arityerr315
arityerr315:
  call void @rt_arity_error(i64 1, i64 %argc)
  unreachable
argok316:
  %t1303 = call i64 @rt_error_object_p(i64 %a0)
  ret i64 %t1303
}

define fastcc i64 @"scheme.base:code_329"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1308 = icmp eq i64 %argc, 1
  br i1 %t1308, label %argok318, label %arityerr317
arityerr317:
  call void @rt_arity_error(i64 1, i64 %argc)
  unreachable
argok318:
  %t1309 = call i64 @rt_error_object_message(i64 %a0)
  ret i64 %t1309
}

define fastcc i64 @"scheme.base:code_332"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1314 = icmp eq i64 %argc, 1
  br i1 %t1314, label %argok320, label %arityerr319
arityerr319:
  call void @rt_arity_error(i64 1, i64 %argc)
  unreachable
argok320:
  %t1315 = call i64 @rt_error_object_irritants(i64 %a0)
  ret i64 %t1315
}

define fastcc i64 @"scheme.base:code_341"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1320 = icmp eq i64 %argc, 2
  br i1 %t1320, label %argok322, label %arityerr321
arityerr321:
  call void @rt_arity_error(i64 2, i64 %argc)
  unreachable
argok322:
  %t1321 = call i64 @rt_null_p(i64 %a0)
  %t1322 = icmp ne i64 %t1321, 1
  br i1 %t1322, label %then323, label %else324
then323:
  %t1323 = and i64 %self, -8
  %t1324 = inttoptr i64 %t1323 to ptr
  %t1325 = getelementptr i64, ptr %t1324, i64 1
  %t1326 = load i64, ptr %t1325
  ret i64 %t1326
else324:
  %t1327 = and i64 %self, -8
  %t1328 = inttoptr i64 %t1327 to ptr
  %t1329 = getelementptr i64, ptr %t1328, i64 1
  %t1330 = load i64, ptr %t1329
  %t1331 = call i64 @rt_car(i64 %a0)
  %t1332 = call i64 @rt_vector_set(i64 %t1330, i64 %a1, i64 %t1331)
  %t1333 = call i64 @rt_cdr(i64 %a0)
  %t1334 = or i64 %a1, 8
  %t1335 = and i64 %t1334, 7
  %t1336 = icmp eq i64 %t1335, 0
  br i1 %t1336, label %fixfast325, label %fixslow326
fixfast325:
  %t1337 = add i64 %a1, 8
  br label %fixmerge327
fixslow326:
  %t1338 = call i64 @rt_add(i64 %a1, i64 8)
  br label %fixmerge327
fixmerge327:
  %t1339 = phi i64 [ %t1337, %fixfast325 ], [ %t1338, %fixslow326 ]
  %t1340 = musttail call fastcc i64 @"scheme.base:code_341"(i64 %self, i64 2, i64 %t1333, i64 %t1339, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t1340
}

define fastcc i64 @"scheme.base:code_339"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1341 = icmp eq i64 %argc, 1
  br i1 %t1341, label %argok329, label %arityerr328
arityerr328:
  call void @rt_arity_error(i64 1, i64 %argc)
  unreachable
argok329:
  %t1342 = load i64, ptr @"scheme.base:length"
  %t1343 = and i64 %t1342, -8
  %t1344 = inttoptr i64 %t1343 to ptr
  %t1345 = load i64, ptr %t1344
  %t1346 = inttoptr i64 %t1345 to ptr
  %t1347 = call fastcc i64%t1346(i64 %t1342, i64 1, i64 %a0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t1348 = call i64 @rt_make_vector(i64 %t1347, i64 0)
  %t1349 = call i64 @rt_alloc_words(i64 3)
  %t1350 = inttoptr i64 %t1349 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_341" to i64), ptr %t1350
  %t1351 = or i64 %t1349, 4
  %t1352 = getelementptr i64, ptr %t1350, i64 1
  store i64 %t1348, ptr %t1352
  %t1353 = getelementptr i64, ptr %t1350, i64 2
  store i64 %t1351, ptr %t1353
  %t1354 = and i64 %t1351, -8
  %t1355 = inttoptr i64 %t1354 to ptr
  %t1356 = load i64, ptr %t1355
  %t1357 = inttoptr i64 %t1356 to ptr
  %t1358 = musttail call fastcc i64 %t1357(i64 %t1351, i64 2, i64 %a0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t1358
}

define fastcc i64 @"scheme.base:code_344"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1363 = icmp sge i64 %argc, 0
  br i1 %t1363, label %argok331, label %arityerr330
arityerr330:
  call void @rt_arity_error(i64 0, i64 %argc)
  unreachable
argok331:
  %t1364 = call i64 @rt_alloc_words(i64 8)
  %t1365 = inttoptr i64 %t1364 to ptr
  %t1366 = getelementptr i64, ptr %t1365, i64 0
  store i64 %a0, ptr %t1366
  %t1367 = getelementptr i64, ptr %t1365, i64 1
  store i64 %a1, ptr %t1367
  %t1368 = getelementptr i64, ptr %t1365, i64 2
  store i64 %a2, ptr %t1368
  %t1369 = getelementptr i64, ptr %t1365, i64 3
  store i64 %a3, ptr %t1369
  %t1370 = getelementptr i64, ptr %t1365, i64 4
  store i64 %a4, ptr %t1370
  %t1371 = getelementptr i64, ptr %t1365, i64 5
  store i64 %a5, ptr %t1371
  %t1372 = getelementptr i64, ptr %t1365, i64 6
  store i64 %a6, ptr %t1372
  %t1373 = getelementptr i64, ptr %t1365, i64 7
  store i64 %a7, ptr %t1373
  %t1374 = call i64 @rt_build_rest(i64 %argc, i64 0, i64 8, ptr %t1365, ptr %overflow)
  %t1375 = load i64, ptr @"scheme.base:list->vector"
  %t1376 = and i64 %t1375, -8
  %t1377 = inttoptr i64 %t1376 to ptr
  %t1378 = load i64, ptr %t1377
  %t1379 = inttoptr i64 %t1378 to ptr
  %t1380 = musttail call fastcc i64 %t1379(i64 %t1375, i64 1, i64 %t1374, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t1380
}

define fastcc i64 @"scheme.base:code_353"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1385 = icmp eq i64 %argc, 2
  br i1 %t1385, label %argok333, label %arityerr332
arityerr332:
  call void @rt_arity_error(i64 2, i64 %argc)
  unreachable
argok333:
  %t1386 = call i64 @rt_null_p(i64 %a0)
  %t1387 = icmp ne i64 %t1386, 1
  br i1 %t1387, label %then334, label %else335
then334:
  %t1388 = and i64 %self, -8
  %t1389 = inttoptr i64 %t1388 to ptr
  %t1390 = getelementptr i64, ptr %t1389, i64 1
  %t1391 = load i64, ptr %t1390
  ret i64 %t1391
else335:
  %t1392 = and i64 %self, -8
  %t1393 = inttoptr i64 %t1392 to ptr
  %t1394 = getelementptr i64, ptr %t1393, i64 1
  %t1395 = load i64, ptr %t1394
  %t1396 = call i64 @rt_car(i64 %a0)
  %t1397 = call i64 @rt_bytevector_u8_set(i64 %t1395, i64 %a1, i64 %t1396)
  %t1398 = call i64 @rt_cdr(i64 %a0)
  %t1399 = or i64 %a1, 8
  %t1400 = and i64 %t1399, 7
  %t1401 = icmp eq i64 %t1400, 0
  br i1 %t1401, label %fixfast336, label %fixslow337
fixfast336:
  %t1402 = add i64 %a1, 8
  br label %fixmerge338
fixslow337:
  %t1403 = call i64 @rt_add(i64 %a1, i64 8)
  br label %fixmerge338
fixmerge338:
  %t1404 = phi i64 [ %t1402, %fixfast336 ], [ %t1403, %fixslow337 ]
  %t1405 = musttail call fastcc i64 @"scheme.base:code_353"(i64 %self, i64 2, i64 %t1398, i64 %t1404, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t1405
}

define fastcc i64 @"scheme.base:code_351"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1406 = icmp eq i64 %argc, 1
  br i1 %t1406, label %argok340, label %arityerr339
arityerr339:
  call void @rt_arity_error(i64 1, i64 %argc)
  unreachable
argok340:
  %t1407 = load i64, ptr @"scheme.base:length"
  %t1408 = and i64 %t1407, -8
  %t1409 = inttoptr i64 %t1408 to ptr
  %t1410 = load i64, ptr %t1409
  %t1411 = inttoptr i64 %t1410 to ptr
  %t1412 = call fastcc i64%t1411(i64 %t1407, i64 1, i64 %a0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t1413 = call i64 @rt_make_bytevector(i64 %t1412, i64 0)
  %t1414 = call i64 @rt_alloc_words(i64 3)
  %t1415 = inttoptr i64 %t1414 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_353" to i64), ptr %t1415
  %t1416 = or i64 %t1414, 4
  %t1417 = getelementptr i64, ptr %t1415, i64 1
  store i64 %t1413, ptr %t1417
  %t1418 = getelementptr i64, ptr %t1415, i64 2
  store i64 %t1416, ptr %t1418
  %t1419 = and i64 %t1416, -8
  %t1420 = inttoptr i64 %t1419 to ptr
  %t1421 = load i64, ptr %t1420
  %t1422 = inttoptr i64 %t1421 to ptr
  %t1423 = musttail call fastcc i64 %t1422(i64 %t1416, i64 2, i64 %a0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t1423
}

define fastcc i64 @"scheme.base:code_356"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1428 = icmp sge i64 %argc, 0
  br i1 %t1428, label %argok342, label %arityerr341
arityerr341:
  call void @rt_arity_error(i64 0, i64 %argc)
  unreachable
argok342:
  %t1429 = call i64 @rt_alloc_words(i64 8)
  %t1430 = inttoptr i64 %t1429 to ptr
  %t1431 = getelementptr i64, ptr %t1430, i64 0
  store i64 %a0, ptr %t1431
  %t1432 = getelementptr i64, ptr %t1430, i64 1
  store i64 %a1, ptr %t1432
  %t1433 = getelementptr i64, ptr %t1430, i64 2
  store i64 %a2, ptr %t1433
  %t1434 = getelementptr i64, ptr %t1430, i64 3
  store i64 %a3, ptr %t1434
  %t1435 = getelementptr i64, ptr %t1430, i64 4
  store i64 %a4, ptr %t1435
  %t1436 = getelementptr i64, ptr %t1430, i64 5
  store i64 %a5, ptr %t1436
  %t1437 = getelementptr i64, ptr %t1430, i64 6
  store i64 %a6, ptr %t1437
  %t1438 = getelementptr i64, ptr %t1430, i64 7
  store i64 %a7, ptr %t1438
  %t1439 = call i64 @rt_build_rest(i64 %argc, i64 0, i64 8, ptr %t1430, ptr %overflow)
  %t1440 = load i64, ptr @"scheme.base:list->bytevector"
  %t1441 = and i64 %t1440, -8
  %t1442 = inttoptr i64 %t1441 to ptr
  %t1443 = load i64, ptr %t1442
  %t1444 = inttoptr i64 %t1443 to ptr
  %t1445 = musttail call fastcc i64 %t1444(i64 %t1440, i64 1, i64 %t1439, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t1445
}

define fastcc i64 @"scheme.base:code_358"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1452 = icmp eq i64 %argc, 0
  br i1 %t1452, label %argok344, label %arityerr343
arityerr343:
  call void @rt_arity_error(i64 0, i64 %argc)
  unreachable
argok344:
  %t1453 = load i64, ptr @"scheme.base:%ht-initial-buckets"
  %t1454 = call i64 @rt_make_vector(i64 %t1453, i64 2)
  %t1455 = load i64, ptr @"scheme.base:vector"
  %t1456 = and i64 %t1455, -8
  %t1457 = inttoptr i64 %t1456 to ptr
  %t1458 = load i64, ptr %t1457
  %t1459 = inttoptr i64 %t1458 to ptr
  %t1460 = call fastcc i64%t1459(i64 %t1455, i64 3, i64 0, i64 %t1454, i64 1, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t1461 = call i64 @rt_make_hash_table(i64 %t1460)
  ret i64 %t1461
}

define fastcc i64 @"scheme.base:code_361"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1466 = icmp eq i64 %argc, 1
  br i1 %t1466, label %argok346, label %arityerr345
arityerr345:
  call void @rt_arity_error(i64 1, i64 %argc)
  unreachable
argok346:
  %t1467 = call i64 @rt_hash_table_p(i64 %a0)
  ret i64 %t1467
}

define fastcc i64 @"scheme.base:code_364"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1472 = icmp eq i64 %argc, 1
  br i1 %t1472, label %argok348, label %arityerr347
arityerr347:
  call void @rt_arity_error(i64 1, i64 %argc)
  unreachable
argok348:
  %t1473 = call i64 @rt_hash_table_spine(i64 %a0)
  %t1474 = call i64 @rt_vector_ref(i64 %t1473, i64 0)
  ret i64 %t1474
}

define fastcc i64 @"scheme.base:code_367"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1479 = icmp eq i64 %argc, 1
  br i1 %t1479, label %argok350, label %arityerr349
arityerr349:
  call void @rt_arity_error(i64 1, i64 %argc)
  unreachable
argok350:
  %t1480 = call i64 @rt_hash_table_spine(i64 %a0)
  %t1481 = call i64 @rt_vector_ref(i64 %t1480, i64 8)
  ret i64 %t1481
}

define fastcc i64 @"scheme.base:code_371"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1486 = icmp eq i64 %argc, 2
  br i1 %t1486, label %argok352, label %arityerr351
arityerr351:
  call void @rt_arity_error(i64 2, i64 %argc)
  unreachable
argok352:
  %t1487 = call i64 @rt_hash_table_spine(i64 %a0)
  %t1488 = call i64 @rt_vector_set(i64 %t1487, i64 0, i64 %a1)
  ret i64 %t1488
}

define fastcc i64 @"scheme.base:code_375"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1493 = icmp eq i64 %argc, 2
  br i1 %t1493, label %argok354, label %arityerr353
arityerr353:
  call void @rt_arity_error(i64 2, i64 %argc)
  unreachable
argok354:
  %t1494 = call i64 @rt_hash_table_spine(i64 %a0)
  %t1495 = call i64 @rt_vector_set(i64 %t1494, i64 8, i64 %a1)
  ret i64 %t1495
}

define fastcc i64 @"scheme.base:code_379"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1500 = icmp eq i64 %argc, 2
  br i1 %t1500, label %argok356, label %arityerr355
arityerr355:
  call void @rt_arity_error(i64 2, i64 %argc)
  unreachable
argok356:
  %t1501 = call i64 @rt_hash(i64 %a0)
  %t1502 = call i64 @rt_remainder(i64 %t1501, i64 %a1)
  ret i64 %t1502
}

define fastcc i64 @"scheme.base:code_383"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1507 = icmp eq i64 %argc, 2
  br i1 %t1507, label %argok358, label %arityerr357
arityerr357:
  call void @rt_arity_error(i64 2, i64 %argc)
  unreachable
argok358:
  %t1508 = call i64 @rt_null_p(i64 %a1)
  %t1509 = icmp ne i64 %t1508, 1
  br i1 %t1509, label %then359, label %else360
then359:
  ret i64 1
else360:
  %t1510 = call i64 @rt_car(i64 %a1)
  %t1511 = call i64 @rt_car(i64 %t1510)
  %t1512 = call i64 @rt_equal(i64 %a0, i64 %t1511)
  %t1513 = icmp ne i64 %t1512, 1
  br i1 %t1513, label %then361, label %else362
then361:
  %t1514 = call i64 @rt_car(i64 %a1)
  ret i64 %t1514
else362:
  %t1515 = call i64 @rt_cdr(i64 %a1)
  %t1516 = load i64, ptr @"scheme.base:%ht-assoc"
  %t1517 = and i64 %t1516, -8
  %t1518 = inttoptr i64 %t1517 to ptr
  %t1519 = load i64, ptr %t1518
  %t1520 = inttoptr i64 %t1519 to ptr
  %t1521 = musttail call fastcc i64 %t1520(i64 %t1516, i64 2, i64 %a0, i64 %t1515, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t1521
}

define fastcc i64 @"scheme.base:code_387"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1526 = icmp eq i64 %argc, 2
  br i1 %t1526, label %argok364, label %arityerr363
arityerr363:
  call void @rt_arity_error(i64 2, i64 %argc)
  unreachable
argok364:
  %t1527 = call i64 @rt_null_p(i64 %a1)
  %t1528 = icmp ne i64 %t1527, 1
  br i1 %t1528, label %then365, label %else366
then365:
  ret i64 2
else366:
  %t1529 = call i64 @rt_car(i64 %a1)
  %t1530 = call i64 @rt_car(i64 %t1529)
  %t1531 = call i64 @rt_equal(i64 %a0, i64 %t1530)
  %t1532 = icmp ne i64 %t1531, 1
  br i1 %t1532, label %then367, label %else368
then367:
  %t1533 = call i64 @rt_cdr(i64 %a1)
  ret i64 %t1533
else368:
  %t1534 = call i64 @rt_car(i64 %a1)
  %t1535 = call i64 @rt_cdr(i64 %a1)
  %t1536 = load i64, ptr @"scheme.base:%ht-remove"
  %t1537 = and i64 %t1536, -8
  %t1538 = inttoptr i64 %t1537 to ptr
  %t1539 = load i64, ptr %t1538
  %t1540 = inttoptr i64 %t1539 to ptr
  %t1541 = call fastcc i64%t1540(i64 %t1536, i64 2, i64 %a0, i64 %t1535, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t1542 = call i64 @rt_cons(i64 %t1534, i64 %t1541)
  ret i64 %t1542
}

define fastcc i64 @"scheme.base:code_394"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1547 = icmp eq i64 %argc, 3
  br i1 %t1547, label %argok370, label %arityerr369
arityerr369:
  call void @rt_arity_error(i64 3, i64 %argc)
  unreachable
argok370:
  %t1548 = load i64, ptr @"scheme.base:%ht-buckets"
  %t1549 = and i64 %t1548, -8
  %t1550 = inttoptr i64 %t1549 to ptr
  %t1551 = load i64, ptr %t1550
  %t1552 = inttoptr i64 %t1551 to ptr
  %t1553 = call fastcc i64%t1552(i64 %t1548, i64 1, i64 %a0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t1554 = call i64 @rt_vector_length(i64 %t1553)
  %t1555 = load i64, ptr @"scheme.base:%ht-index"
  %t1556 = and i64 %t1555, -8
  %t1557 = inttoptr i64 %t1556 to ptr
  %t1558 = load i64, ptr %t1557
  %t1559 = inttoptr i64 %t1558 to ptr
  %t1560 = call fastcc i64%t1559(i64 %t1555, i64 2, i64 %a1, i64 %t1554, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t1561 = call i64 @rt_vector_ref(i64 %t1553, i64 %t1560)
  %t1562 = load i64, ptr @"scheme.base:%ht-assoc"
  %t1563 = and i64 %t1562, -8
  %t1564 = inttoptr i64 %t1563 to ptr
  %t1565 = load i64, ptr %t1564
  %t1566 = inttoptr i64 %t1565 to ptr
  %t1567 = call fastcc i64%t1566(i64 %t1562, i64 2, i64 %a1, i64 %t1561, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t1568 = icmp ne i64 %t1567, 1
  br i1 %t1568, label %then371, label %else372
then371:
  %t1569 = call i64 @rt_cdr(i64 %t1567)
  ret i64 %t1569
else372:
  ret i64 %a2
}

define fastcc i64 @"scheme.base:code_399"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1574 = icmp eq i64 %argc, 2
  br i1 %t1574, label %argok374, label %arityerr373
arityerr373:
  call void @rt_arity_error(i64 2, i64 %argc)
  unreachable
argok374:
  %t1575 = load i64, ptr @"scheme.base:%ht-buckets"
  %t1576 = and i64 %t1575, -8
  %t1577 = inttoptr i64 %t1576 to ptr
  %t1578 = load i64, ptr %t1577
  %t1579 = inttoptr i64 %t1578 to ptr
  %t1580 = call fastcc i64%t1579(i64 %t1575, i64 1, i64 %a0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t1581 = call i64 @rt_vector_length(i64 %t1580)
  %t1582 = load i64, ptr @"scheme.base:%ht-index"
  %t1583 = and i64 %t1582, -8
  %t1584 = inttoptr i64 %t1583 to ptr
  %t1585 = load i64, ptr %t1584
  %t1586 = inttoptr i64 %t1585 to ptr
  %t1587 = call fastcc i64%t1586(i64 %t1582, i64 2, i64 %a1, i64 %t1581, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t1588 = call i64 @rt_vector_ref(i64 %t1580, i64 %t1587)
  %t1589 = load i64, ptr @"scheme.base:%ht-assoc"
  %t1590 = and i64 %t1589, -8
  %t1591 = inttoptr i64 %t1590 to ptr
  %t1592 = load i64, ptr %t1591
  %t1593 = inttoptr i64 %t1592 to ptr
  %t1594 = call fastcc i64%t1593(i64 %t1589, i64 2, i64 %a1, i64 %t1588, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t1595 = icmp ne i64 %t1594, 1
  br i1 %t1595, label %then375, label %else376
then375:
  ret i64 257
else376:
  ret i64 1
}

define fastcc i64 @"scheme.base:code_405"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1600 = icmp eq i64 %argc, 2
  br i1 %t1600, label %argok378, label %arityerr377
arityerr377:
  call void @rt_arity_error(i64 2, i64 %argc)
  unreachable
argok378:
  %t1601 = load i64, ptr @"scheme.base:%ht-buckets"
  %t1602 = and i64 %t1601, -8
  %t1603 = inttoptr i64 %t1602 to ptr
  %t1604 = load i64, ptr %t1603
  %t1605 = inttoptr i64 %t1604 to ptr
  %t1606 = call fastcc i64%t1605(i64 %t1601, i64 1, i64 %a0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t1607 = call i64 @rt_vector_length(i64 %t1606)
  %t1608 = load i64, ptr @"scheme.base:%ht-index"
  %t1609 = and i64 %t1608, -8
  %t1610 = inttoptr i64 %t1609 to ptr
  %t1611 = load i64, ptr %t1610
  %t1612 = inttoptr i64 %t1611 to ptr
  %t1613 = call fastcc i64%t1612(i64 %t1608, i64 2, i64 %a1, i64 %t1607, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t1614 = call i64 @rt_vector_ref(i64 %t1606, i64 %t1613)
  %t1615 = load i64, ptr @"scheme.base:%ht-assoc"
  %t1616 = and i64 %t1615, -8
  %t1617 = inttoptr i64 %t1616 to ptr
  %t1618 = load i64, ptr %t1617
  %t1619 = inttoptr i64 %t1618 to ptr
  %t1620 = call fastcc i64%t1619(i64 %t1615, i64 2, i64 %a1, i64 %t1614, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t1621 = icmp ne i64 %t1620, 1
  br i1 %t1621, label %then379, label %else380
then379:
  %t1622 = call i64 @rt_cdr(i64 %t1620)
  ret i64 %t1622
else380:
  %t1623 = call i64 @rt_make_string(ptr @.str.lit.3, i64 29)
  %t1624 = load i64, ptr @"scheme.base:error"
  %t1625 = and i64 %t1624, -8
  %t1626 = inttoptr i64 %t1625 to ptr
  %t1627 = load i64, ptr %t1626
  %t1628 = inttoptr i64 %t1627 to ptr
  %t1629 = musttail call fastcc i64 %t1628(i64 %t1624, i64 2, i64 %t1623, i64 %a1, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t1629
}

define fastcc i64 @"scheme.base:code_419"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1634 = icmp eq i64 %argc, 3
  br i1 %t1634, label %argok382, label %arityerr381
arityerr381:
  call void @rt_arity_error(i64 3, i64 %argc)
  unreachable
argok382:
  %t1635 = load i64, ptr @"scheme.base:%ht-buckets"
  %t1636 = and i64 %t1635, -8
  %t1637 = inttoptr i64 %t1636 to ptr
  %t1638 = load i64, ptr %t1637
  %t1639 = inttoptr i64 %t1638 to ptr
  %t1640 = call fastcc i64%t1639(i64 %t1635, i64 1, i64 %a0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t1641 = call i64 @rt_vector_length(i64 %t1640)
  %t1642 = load i64, ptr @"scheme.base:%ht-index"
  %t1643 = and i64 %t1642, -8
  %t1644 = inttoptr i64 %t1643 to ptr
  %t1645 = load i64, ptr %t1644
  %t1646 = inttoptr i64 %t1645 to ptr
  %t1647 = call fastcc i64%t1646(i64 %t1642, i64 2, i64 %a1, i64 %t1641, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t1648 = call i64 @rt_vector_ref(i64 %t1640, i64 %t1647)
  %t1649 = load i64, ptr @"scheme.base:%ht-assoc"
  %t1650 = and i64 %t1649, -8
  %t1651 = inttoptr i64 %t1650 to ptr
  %t1652 = load i64, ptr %t1651
  %t1653 = inttoptr i64 %t1652 to ptr
  %t1654 = call fastcc i64%t1653(i64 %t1649, i64 2, i64 %a1, i64 %t1648, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t1655 = call i64 @rt_cons(i64 %a1, i64 %a2)
  %t1656 = icmp ne i64 %t1654, 1
  br i1 %t1656, label %then383, label %else384
then383:
  %t1657 = load i64, ptr @"scheme.base:%ht-remove"
  %t1658 = and i64 %t1657, -8
  %t1659 = inttoptr i64 %t1658 to ptr
  %t1660 = load i64, ptr %t1659
  %t1661 = inttoptr i64 %t1660 to ptr
  %t1662 = call fastcc i64%t1661(i64 %t1657, i64 2, i64 %a1, i64 %t1648, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  br label %merge385
else384:
  br label %merge385
merge385:
  %t1663 = phi i64 [ %t1662, %then383 ], [ %t1648, %else384 ]
  %t1664 = call i64 @rt_cons(i64 %t1655, i64 %t1663)
  %t1665 = call i64 @rt_vector_set(i64 %t1640, i64 %t1647, i64 %t1664)
  %t1666 = icmp ne i64 %t1654, 1
  br i1 %t1666, label %then386, label %else387
then386:
  ret i64 1
else387:
  %t1667 = load i64, ptr @"scheme.base:%ht-count"
  %t1668 = and i64 %t1667, -8
  %t1669 = inttoptr i64 %t1668 to ptr
  %t1670 = load i64, ptr %t1669
  %t1671 = inttoptr i64 %t1670 to ptr
  %t1672 = call fastcc i64%t1671(i64 %t1667, i64 1, i64 %a0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t1673 = or i64 %t1672, 8
  %t1674 = and i64 %t1673, 7
  %t1675 = icmp eq i64 %t1674, 0
  br i1 %t1675, label %fixfast388, label %fixslow389
fixfast388:
  %t1676 = add i64 %t1672, 8
  br label %fixmerge390
fixslow389:
  %t1677 = call i64 @rt_add(i64 %t1672, i64 8)
  br label %fixmerge390
fixmerge390:
  %t1678 = phi i64 [ %t1676, %fixfast388 ], [ %t1677, %fixslow389 ]
  %t1679 = load i64, ptr @"scheme.base:%ht-set-count!"
  %t1680 = and i64 %t1679, -8
  %t1681 = inttoptr i64 %t1680 to ptr
  %t1682 = load i64, ptr %t1681
  %t1683 = inttoptr i64 %t1682 to ptr
  %t1684 = call fastcc i64%t1683(i64 %t1679, i64 2, i64 %a0, i64 %t1678, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t1685 = load i64, ptr @"scheme.base:%ht-count"
  %t1686 = and i64 %t1685, -8
  %t1687 = inttoptr i64 %t1686 to ptr
  %t1688 = load i64, ptr %t1687
  %t1689 = inttoptr i64 %t1688 to ptr
  %t1690 = call fastcc i64%t1689(i64 %t1685, i64 1, i64 %a0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t1691 = load i64, ptr @"scheme.base:%ht-load-factor"
  %t1692 = or i64 %t1691, %t1641
  %t1693 = and i64 %t1692, 7
  %t1694 = icmp eq i64 %t1693, 0
  br i1 %t1694, label %fixfast391, label %fixslow392
fixfast391:
  %t1695 = ashr i64 %t1691, 3
  %t1696 = mul i64 %t1695, %t1641
  br label %fixmerge393
fixslow392:
  %t1697 = call i64 @rt_mul(i64 %t1691, i64 %t1641)
  br label %fixmerge393
fixmerge393:
  %t1698 = phi i64 [ %t1696, %fixfast391 ], [ %t1697, %fixslow392 ]
  %t1699 = or i64 %t1698, %t1690
  %t1700 = and i64 %t1699, 7
  %t1701 = icmp eq i64 %t1700, 0
  br i1 %t1701, label %fixfast394, label %fixslow395
fixfast394:
  %t1702 = icmp slt i64 %t1698, %t1690
  %t1703 = select i1 %t1702, i64 257, i64 1
  br label %fixmerge396
fixslow395:
  %t1704 = call i64 @rt_lt(i64 %t1698, i64 %t1690)
  br label %fixmerge396
fixmerge396:
  %t1705 = phi i64 [ %t1703, %fixfast394 ], [ %t1704, %fixslow395 ]
  %t1706 = icmp ne i64 %t1705, 1
  br i1 %t1706, label %then397, label %else398
then397:
  %t1707 = load i64, ptr @"scheme.base:%ht-grow!"
  %t1708 = and i64 %t1707, -8
  %t1709 = inttoptr i64 %t1708 to ptr
  %t1710 = load i64, ptr %t1709
  %t1711 = inttoptr i64 %t1710 to ptr
  %t1712 = musttail call fastcc i64 %t1711(i64 %t1707, i64 1, i64 %a0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t1712
else398:
  ret i64 1
}

define fastcc i64 @"scheme.base:code_426"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1717 = icmp eq i64 %argc, 2
  br i1 %t1717, label %argok400, label %arityerr399
arityerr399:
  call void @rt_arity_error(i64 2, i64 %argc)
  unreachable
argok400:
  %t1718 = load i64, ptr @"scheme.base:%ht-buckets"
  %t1719 = and i64 %t1718, -8
  %t1720 = inttoptr i64 %t1719 to ptr
  %t1721 = load i64, ptr %t1720
  %t1722 = inttoptr i64 %t1721 to ptr
  %t1723 = call fastcc i64%t1722(i64 %t1718, i64 1, i64 %a0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t1724 = call i64 @rt_vector_length(i64 %t1723)
  %t1725 = load i64, ptr @"scheme.base:%ht-index"
  %t1726 = and i64 %t1725, -8
  %t1727 = inttoptr i64 %t1726 to ptr
  %t1728 = load i64, ptr %t1727
  %t1729 = inttoptr i64 %t1728 to ptr
  %t1730 = call fastcc i64%t1729(i64 %t1725, i64 2, i64 %a1, i64 %t1724, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t1731 = call i64 @rt_vector_ref(i64 %t1723, i64 %t1730)
  %t1732 = load i64, ptr @"scheme.base:%ht-assoc"
  %t1733 = and i64 %t1732, -8
  %t1734 = inttoptr i64 %t1733 to ptr
  %t1735 = load i64, ptr %t1734
  %t1736 = inttoptr i64 %t1735 to ptr
  %t1737 = call fastcc i64%t1736(i64 %t1732, i64 2, i64 %a1, i64 %t1731, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t1738 = icmp ne i64 %t1737, 1
  br i1 %t1738, label %then401, label %else402
then401:
  %t1739 = load i64, ptr @"scheme.base:%ht-remove"
  %t1740 = and i64 %t1739, -8
  %t1741 = inttoptr i64 %t1740 to ptr
  %t1742 = load i64, ptr %t1741
  %t1743 = inttoptr i64 %t1742 to ptr
  %t1744 = call fastcc i64%t1743(i64 %t1739, i64 2, i64 %a1, i64 %t1731, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t1745 = call i64 @rt_vector_set(i64 %t1723, i64 %t1730, i64 %t1744)
  %t1746 = load i64, ptr @"scheme.base:%ht-count"
  %t1747 = and i64 %t1746, -8
  %t1748 = inttoptr i64 %t1747 to ptr
  %t1749 = load i64, ptr %t1748
  %t1750 = inttoptr i64 %t1749 to ptr
  %t1751 = call fastcc i64%t1750(i64 %t1746, i64 1, i64 %a0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t1752 = or i64 %t1751, 8
  %t1753 = and i64 %t1752, 7
  %t1754 = icmp eq i64 %t1753, 0
  br i1 %t1754, label %fixfast403, label %fixslow404
fixfast403:
  %t1755 = sub i64 %t1751, 8
  br label %fixmerge405
fixslow404:
  %t1756 = call i64 @rt_sub(i64 %t1751, i64 8)
  br label %fixmerge405
fixmerge405:
  %t1757 = phi i64 [ %t1755, %fixfast403 ], [ %t1756, %fixslow404 ]
  %t1758 = load i64, ptr @"scheme.base:%ht-set-count!"
  %t1759 = and i64 %t1758, -8
  %t1760 = inttoptr i64 %t1759 to ptr
  %t1761 = load i64, ptr %t1760
  %t1762 = inttoptr i64 %t1761 to ptr
  %t1763 = musttail call fastcc i64 %t1762(i64 %t1758, i64 2, i64 %a0, i64 %t1757, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t1763
else402:
  ret i64 1
}

define fastcc i64 @"scheme.base:code_446"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1768 = icmp eq i64 %argc, 1
  br i1 %t1768, label %argok407, label %arityerr406
arityerr406:
  call void @rt_arity_error(i64 1, i64 %argc)
  unreachable
argok407:
  %t1769 = call i64 @rt_null_p(i64 %a0)
  %t1770 = icmp ne i64 %t1769, 1
  br i1 %t1770, label %then408, label %else409
then408:
  ret i64 1
else409:
  %t1771 = call i64 @rt_car(i64 %a0)
  %t1772 = call i64 @rt_car(i64 %t1771)
  %t1773 = and i64 %self, -8
  %t1774 = inttoptr i64 %t1773 to ptr
  %t1775 = getelementptr i64, ptr %t1774, i64 1
  %t1776 = load i64, ptr %t1775
  %t1777 = load i64, ptr @"scheme.base:%ht-index"
  %t1778 = and i64 %t1777, -8
  %t1779 = inttoptr i64 %t1778 to ptr
  %t1780 = load i64, ptr %t1779
  %t1781 = inttoptr i64 %t1780 to ptr
  %t1782 = call fastcc i64%t1781(i64 %t1777, i64 2, i64 %t1772, i64 %t1776, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t1783 = and i64 %self, -8
  %t1784 = inttoptr i64 %t1783 to ptr
  %t1785 = getelementptr i64, ptr %t1784, i64 2
  %t1786 = load i64, ptr %t1785
  %t1787 = and i64 %self, -8
  %t1788 = inttoptr i64 %t1787 to ptr
  %t1789 = getelementptr i64, ptr %t1788, i64 2
  %t1790 = load i64, ptr %t1789
  %t1791 = call i64 @rt_vector_ref(i64 %t1790, i64 %t1782)
  %t1792 = call i64 @rt_cons(i64 %t1771, i64 %t1791)
  %t1793 = call i64 @rt_vector_set(i64 %t1786, i64 %t1782, i64 %t1792)
  %t1794 = call i64 @rt_cdr(i64 %a0)
  %t1795 = musttail call fastcc i64 @"scheme.base:code_446"(i64 %self, i64 1, i64 %t1794, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t1795
}

define fastcc i64 @"scheme.base:code_444"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1796 = icmp eq i64 %argc, 1
  br i1 %t1796, label %argok411, label %arityerr410
arityerr410:
  call void @rt_arity_error(i64 1, i64 %argc)
  unreachable
argok411:
  %t1797 = and i64 %self, -8
  %t1798 = inttoptr i64 %t1797 to ptr
  %t1799 = getelementptr i64, ptr %t1798, i64 1
  %t1800 = load i64, ptr %t1799
  %t1801 = call i64 @rt_vector_length(i64 %t1800)
  %t1802 = or i64 %a0, %t1801
  %t1803 = and i64 %t1802, 7
  %t1804 = icmp eq i64 %t1803, 0
  br i1 %t1804, label %fixfast412, label %fixslow413
fixfast412:
  %t1805 = icmp slt i64 %a0, %t1801
  %t1806 = select i1 %t1805, i64 257, i64 1
  br label %fixmerge414
fixslow413:
  %t1807 = call i64 @rt_lt(i64 %a0, i64 %t1801)
  br label %fixmerge414
fixmerge414:
  %t1808 = phi i64 [ %t1806, %fixfast412 ], [ %t1807, %fixslow413 ]
  %t1809 = icmp ne i64 %t1808, 1
  br i1 %t1809, label %then415, label %else416
then415:
  %t1810 = call i64 @rt_alloc_words(i64 4)
  %t1811 = inttoptr i64 %t1810 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_446" to i64), ptr %t1811
  %t1812 = or i64 %t1810, 4
  %t1813 = and i64 %self, -8
  %t1814 = inttoptr i64 %t1813 to ptr
  %t1815 = getelementptr i64, ptr %t1814, i64 2
  %t1816 = load i64, ptr %t1815
  %t1817 = getelementptr i64, ptr %t1811, i64 1
  store i64 %t1816, ptr %t1817
  %t1818 = and i64 %self, -8
  %t1819 = inttoptr i64 %t1818 to ptr
  %t1820 = getelementptr i64, ptr %t1819, i64 3
  %t1821 = load i64, ptr %t1820
  %t1822 = getelementptr i64, ptr %t1811, i64 2
  store i64 %t1821, ptr %t1822
  %t1823 = getelementptr i64, ptr %t1811, i64 3
  store i64 %t1812, ptr %t1823
  %t1824 = and i64 %self, -8
  %t1825 = inttoptr i64 %t1824 to ptr
  %t1826 = getelementptr i64, ptr %t1825, i64 1
  %t1827 = load i64, ptr %t1826
  %t1828 = call i64 @rt_vector_ref(i64 %t1827, i64 %a0)
  %t1829 = and i64 %t1812, -8
  %t1830 = inttoptr i64 %t1829 to ptr
  %t1831 = load i64, ptr %t1830
  %t1832 = inttoptr i64 %t1831 to ptr
  %t1833 = call fastcc i64%t1832(i64 %t1812, i64 1, i64 %t1828, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t1834 = or i64 %a0, 8
  %t1835 = and i64 %t1834, 7
  %t1836 = icmp eq i64 %t1835, 0
  br i1 %t1836, label %fixfast417, label %fixslow418
fixfast417:
  %t1837 = add i64 %a0, 8
  br label %fixmerge419
fixslow418:
  %t1838 = call i64 @rt_add(i64 %a0, i64 8)
  br label %fixmerge419
fixmerge419:
  %t1839 = phi i64 [ %t1837, %fixfast417 ], [ %t1838, %fixslow418 ]
  %t1840 = musttail call fastcc i64 @"scheme.base:code_444"(i64 %self, i64 1, i64 %t1839, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t1840
else416:
  ret i64 1
}

define fastcc i64 @"scheme.base:code_442"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1841 = icmp eq i64 %argc, 1
  br i1 %t1841, label %argok421, label %arityerr420
arityerr420:
  call void @rt_arity_error(i64 1, i64 %argc)
  unreachable
argok421:
  %t1842 = load i64, ptr @"scheme.base:%ht-buckets"
  %t1843 = and i64 %t1842, -8
  %t1844 = inttoptr i64 %t1843 to ptr
  %t1845 = load i64, ptr %t1844
  %t1846 = inttoptr i64 %t1845 to ptr
  %t1847 = call fastcc i64%t1846(i64 %t1842, i64 1, i64 %a0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t1848 = call i64 @rt_vector_length(i64 %t1847)
  %t1849 = or i64 16, %t1848
  %t1850 = and i64 %t1849, 7
  %t1851 = icmp eq i64 %t1850, 0
  br i1 %t1851, label %fixfast422, label %fixslow423
fixfast422:
  %t1852 = ashr i64 16, 3
  %t1853 = mul i64 %t1852, %t1848
  br label %fixmerge424
fixslow423:
  %t1854 = call i64 @rt_mul(i64 16, i64 %t1848)
  br label %fixmerge424
fixmerge424:
  %t1855 = phi i64 [ %t1853, %fixfast422 ], [ %t1854, %fixslow423 ]
  %t1856 = call i64 @rt_make_vector(i64 %t1855, i64 2)
  %t1857 = call i64 @rt_alloc_words(i64 5)
  %t1858 = inttoptr i64 %t1857 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_444" to i64), ptr %t1858
  %t1859 = or i64 %t1857, 4
  %t1860 = getelementptr i64, ptr %t1858, i64 1
  store i64 %t1847, ptr %t1860
  %t1861 = getelementptr i64, ptr %t1858, i64 2
  store i64 %t1855, ptr %t1861
  %t1862 = getelementptr i64, ptr %t1858, i64 3
  store i64 %t1856, ptr %t1862
  %t1863 = getelementptr i64, ptr %t1858, i64 4
  store i64 %t1859, ptr %t1863
  %t1864 = and i64 %t1859, -8
  %t1865 = inttoptr i64 %t1864 to ptr
  %t1866 = load i64, ptr %t1865
  %t1867 = inttoptr i64 %t1866 to ptr
  %t1868 = call fastcc i64%t1867(i64 %t1859, i64 1, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t1869 = load i64, ptr @"scheme.base:%ht-set-buckets!"
  %t1870 = and i64 %t1869, -8
  %t1871 = inttoptr i64 %t1870 to ptr
  %t1872 = load i64, ptr %t1871
  %t1873 = inttoptr i64 %t1872 to ptr
  %t1874 = musttail call fastcc i64 %t1873(i64 %t1869, i64 2, i64 %a0, i64 %t1856, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t1874
}

define fastcc i64 @"scheme.base:code_449"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1879 = icmp eq i64 %argc, 1
  br i1 %t1879, label %argok426, label %arityerr425
arityerr425:
  call void @rt_arity_error(i64 1, i64 %argc)
  unreachable
argok426:
  %t1880 = load i64, ptr @"scheme.base:%ht-count"
  %t1881 = and i64 %t1880, -8
  %t1882 = inttoptr i64 %t1881 to ptr
  %t1883 = load i64, ptr %t1882
  %t1884 = inttoptr i64 %t1883 to ptr
  %t1885 = musttail call fastcc i64 %t1884(i64 %t1880, i64 1, i64 %a0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t1885
}

define fastcc i64 @"scheme.base:code_453"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1890 = icmp eq i64 %argc, 2
  br i1 %t1890, label %argok428, label %arityerr427
arityerr427:
  call void @rt_arity_error(i64 2, i64 %argc)
  unreachable
argok428:
  %t1891 = call i64 @rt_null_p(i64 %a0)
  %t1892 = icmp ne i64 %t1891, 1
  br i1 %t1892, label %then429, label %else430
then429:
  ret i64 %a1
else430:
  %t1893 = call i64 @rt_car(i64 %a0)
  %t1894 = call i64 @rt_car(i64 %t1893)
  %t1895 = call i64 @rt_car(i64 %a0)
  %t1896 = call i64 @rt_cdr(i64 %t1895)
  %t1897 = call i64 @rt_cons(i64 %t1894, i64 %t1896)
  %t1898 = call i64 @rt_cdr(i64 %a0)
  %t1899 = load i64, ptr @"scheme.base:%ht-fold-buckets"
  %t1900 = and i64 %t1899, -8
  %t1901 = inttoptr i64 %t1900 to ptr
  %t1902 = load i64, ptr %t1901
  %t1903 = inttoptr i64 %t1902 to ptr
  %t1904 = call fastcc i64%t1903(i64 %t1899, i64 2, i64 %t1898, i64 %a1, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t1905 = call i64 @rt_cons(i64 %t1897, i64 %t1904)
  ret i64 %t1905
}

define fastcc i64 @"scheme.base:code_466"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1910 = icmp eq i64 %argc, 2
  br i1 %t1910, label %argok432, label %arityerr431
arityerr431:
  call void @rt_arity_error(i64 2, i64 %argc)
  unreachable
argok432:
  %t1911 = and i64 %self, -8
  %t1912 = inttoptr i64 %t1911 to ptr
  %t1913 = getelementptr i64, ptr %t1912, i64 1
  %t1914 = load i64, ptr %t1913
  %t1915 = call i64 @rt_vector_length(i64 %t1914)
  %t1916 = or i64 %a0, %t1915
  %t1917 = and i64 %t1916, 7
  %t1918 = icmp eq i64 %t1917, 0
  br i1 %t1918, label %fixfast433, label %fixslow434
fixfast433:
  %t1919 = icmp slt i64 %a0, %t1915
  %t1920 = select i1 %t1919, i64 257, i64 1
  br label %fixmerge435
fixslow434:
  %t1921 = call i64 @rt_lt(i64 %a0, i64 %t1915)
  br label %fixmerge435
fixmerge435:
  %t1922 = phi i64 [ %t1920, %fixfast433 ], [ %t1921, %fixslow434 ]
  %t1923 = icmp ne i64 %t1922, 1
  br i1 %t1923, label %then436, label %else437
then436:
  %t1924 = or i64 %a0, 8
  %t1925 = and i64 %t1924, 7
  %t1926 = icmp eq i64 %t1925, 0
  br i1 %t1926, label %fixfast438, label %fixslow439
fixfast438:
  %t1927 = add i64 %a0, 8
  br label %fixmerge440
fixslow439:
  %t1928 = call i64 @rt_add(i64 %a0, i64 8)
  br label %fixmerge440
fixmerge440:
  %t1929 = phi i64 [ %t1927, %fixfast438 ], [ %t1928, %fixslow439 ]
  %t1930 = and i64 %self, -8
  %t1931 = inttoptr i64 %t1930 to ptr
  %t1932 = getelementptr i64, ptr %t1931, i64 1
  %t1933 = load i64, ptr %t1932
  %t1934 = call i64 @rt_vector_ref(i64 %t1933, i64 %a0)
  %t1935 = load i64, ptr @"scheme.base:%ht-fold-buckets"
  %t1936 = and i64 %t1935, -8
  %t1937 = inttoptr i64 %t1936 to ptr
  %t1938 = load i64, ptr %t1937
  %t1939 = inttoptr i64 %t1938 to ptr
  %t1940 = call fastcc i64%t1939(i64 %t1935, i64 2, i64 %t1934, i64 %a1, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t1941 = musttail call fastcc i64 @"scheme.base:code_466"(i64 %self, i64 2, i64 %t1929, i64 %t1940, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t1941
else437:
  ret i64 %a1
}

define fastcc i64 @"scheme.base:code_464"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1942 = icmp eq i64 %argc, 1
  br i1 %t1942, label %argok442, label %arityerr441
arityerr441:
  call void @rt_arity_error(i64 1, i64 %argc)
  unreachable
argok442:
  %t1943 = load i64, ptr @"scheme.base:%ht-buckets"
  %t1944 = and i64 %t1943, -8
  %t1945 = inttoptr i64 %t1944 to ptr
  %t1946 = load i64, ptr %t1945
  %t1947 = inttoptr i64 %t1946 to ptr
  %t1948 = call fastcc i64%t1947(i64 %t1943, i64 1, i64 %a0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t1949 = call i64 @rt_alloc_words(i64 3)
  %t1950 = inttoptr i64 %t1949 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_466" to i64), ptr %t1950
  %t1951 = or i64 %t1949, 4
  %t1952 = getelementptr i64, ptr %t1950, i64 1
  store i64 %t1948, ptr %t1952
  %t1953 = getelementptr i64, ptr %t1950, i64 2
  store i64 %t1951, ptr %t1953
  %t1954 = and i64 %t1951, -8
  %t1955 = inttoptr i64 %t1954 to ptr
  %t1956 = load i64, ptr %t1955
  %t1957 = inttoptr i64 %t1956 to ptr
  %t1958 = musttail call fastcc i64 %t1957(i64 %t1951, i64 2, i64 0, i64 2, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t1958
}

define fastcc i64 @"scheme.base:code_472"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1963 = icmp eq i64 %argc, 1
  br i1 %t1963, label %argok444, label %arityerr443
arityerr443:
  call void @rt_arity_error(i64 1, i64 %argc)
  unreachable
argok444:
  %t1964 = call i64 @rt_car(i64 %a0)
  ret i64 %t1964
}

define fastcc i64 @"scheme.base:code_470"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1965 = icmp eq i64 %argc, 1
  br i1 %t1965, label %argok446, label %arityerr445
arityerr445:
  call void @rt_arity_error(i64 1, i64 %argc)
  unreachable
argok446:
  %t1966 = call i64 @rt_alloc_words(i64 1)
  %t1967 = inttoptr i64 %t1966 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_472" to i64), ptr %t1967
  %t1968 = or i64 %t1966, 4
  %t1969 = load i64, ptr @"scheme.base:hash-table->alist"
  %t1970 = and i64 %t1969, -8
  %t1971 = inttoptr i64 %t1970 to ptr
  %t1972 = load i64, ptr %t1971
  %t1973 = inttoptr i64 %t1972 to ptr
  %t1974 = call fastcc i64%t1973(i64 %t1969, i64 1, i64 %a0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t1975 = load i64, ptr @"scheme.base:map"
  %t1976 = and i64 %t1975, -8
  %t1977 = inttoptr i64 %t1976 to ptr
  %t1978 = load i64, ptr %t1977
  %t1979 = inttoptr i64 %t1978 to ptr
  %t1980 = musttail call fastcc i64 %t1979(i64 %t1975, i64 2, i64 %t1968, i64 %t1974, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t1980
}

define fastcc i64 @"scheme.base:code_478"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1985 = icmp eq i64 %argc, 1
  br i1 %t1985, label %argok448, label %arityerr447
arityerr447:
  call void @rt_arity_error(i64 1, i64 %argc)
  unreachable
argok448:
  %t1986 = call i64 @rt_cdr(i64 %a0)
  ret i64 %t1986
}

define fastcc i64 @"scheme.base:code_476"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1987 = icmp eq i64 %argc, 1
  br i1 %t1987, label %argok450, label %arityerr449
arityerr449:
  call void @rt_arity_error(i64 1, i64 %argc)
  unreachable
argok450:
  %t1988 = call i64 @rt_alloc_words(i64 1)
  %t1989 = inttoptr i64 %t1988 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_478" to i64), ptr %t1989
  %t1990 = or i64 %t1988, 4
  %t1991 = load i64, ptr @"scheme.base:hash-table->alist"
  %t1992 = and i64 %t1991, -8
  %t1993 = inttoptr i64 %t1992 to ptr
  %t1994 = load i64, ptr %t1993
  %t1995 = inttoptr i64 %t1994 to ptr
  %t1996 = call fastcc i64%t1995(i64 %t1991, i64 1, i64 %a0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t1997 = load i64, ptr @"scheme.base:map"
  %t1998 = and i64 %t1997, -8
  %t1999 = inttoptr i64 %t1998 to ptr
  %t2000 = load i64, ptr %t1999
  %t2001 = inttoptr i64 %t2000 to ptr
  %t2002 = musttail call fastcc i64 %t2001(i64 %t1997, i64 2, i64 %t1990, i64 %t1996, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t2002
}

define fastcc i64 @"scheme.base:code_504"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t2007 = icmp eq i64 %argc, 1
  br i1 %t2007, label %argok452, label %arityerr451
arityerr451:
  call void @rt_arity_error(i64 1, i64 %argc)
  unreachable
argok452:
  %t2008 = call i64 @rt_char_to_integer(i64 %a0)
  %t2009 = or i64 %t2008, 256
  %t2010 = and i64 %t2009, 7
  %t2011 = icmp eq i64 %t2010, 0
  br i1 %t2011, label %fixfast453, label %fixslow454
fixfast453:
  %t2012 = icmp eq i64 %t2008, 256
  %t2013 = select i1 %t2012, i64 257, i64 1
  br label %fixmerge455
fixslow454:
  %t2014 = call i64 @rt_num_eq(i64 %t2008, i64 256)
  br label %fixmerge455
fixmerge455:
  %t2015 = phi i64 [ %t2013, %fixfast453 ], [ %t2014, %fixslow454 ]
  %t2016 = icmp ne i64 %t2015, 1
  br i1 %t2016, label %then456, label %else457
then456:
  ret i64 %t2015
else457:
  %t2017 = or i64 %t2008, 72
  %t2018 = and i64 %t2017, 7
  %t2019 = icmp eq i64 %t2018, 0
  br i1 %t2019, label %fixfast458, label %fixslow459
fixfast458:
  %t2020 = icmp eq i64 %t2008, 72
  %t2021 = select i1 %t2020, i64 257, i64 1
  br label %fixmerge460
fixslow459:
  %t2022 = call i64 @rt_num_eq(i64 %t2008, i64 72)
  br label %fixmerge460
fixmerge460:
  %t2023 = phi i64 [ %t2021, %fixfast458 ], [ %t2022, %fixslow459 ]
  %t2024 = icmp ne i64 %t2023, 1
  br i1 %t2024, label %then461, label %else462
then461:
  ret i64 %t2023
else462:
  %t2025 = or i64 %t2008, 80
  %t2026 = and i64 %t2025, 7
  %t2027 = icmp eq i64 %t2026, 0
  br i1 %t2027, label %fixfast463, label %fixslow464
fixfast463:
  %t2028 = icmp eq i64 %t2008, 80
  %t2029 = select i1 %t2028, i64 257, i64 1
  br label %fixmerge465
fixslow464:
  %t2030 = call i64 @rt_num_eq(i64 %t2008, i64 80)
  br label %fixmerge465
fixmerge465:
  %t2031 = phi i64 [ %t2029, %fixfast463 ], [ %t2030, %fixslow464 ]
  %t2032 = icmp ne i64 %t2031, 1
  br i1 %t2032, label %then466, label %else467
then466:
  ret i64 %t2031
else467:
  %t2033 = or i64 %t2008, 104
  %t2034 = and i64 %t2033, 7
  %t2035 = icmp eq i64 %t2034, 0
  br i1 %t2035, label %fixfast468, label %fixslow469
fixfast468:
  %t2036 = icmp eq i64 %t2008, 104
  %t2037 = select i1 %t2036, i64 257, i64 1
  br label %fixmerge470
fixslow469:
  %t2038 = call i64 @rt_num_eq(i64 %t2008, i64 104)
  br label %fixmerge470
fixmerge470:
  %t2039 = phi i64 [ %t2037, %fixfast468 ], [ %t2038, %fixslow469 ]
  ret i64 %t2039
}

define fastcc i64 @"scheme.base:code_516"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t2044 = icmp eq i64 %argc, 1
  br i1 %t2044, label %argok472, label %arityerr471
arityerr471:
  call void @rt_arity_error(i64 1, i64 %argc)
  unreachable
argok472:
  %t2045 = call i64 @rt_char_to_integer(i64 %a0)
  %t2046 = or i64 376, %t2045
  %t2047 = and i64 %t2046, 7
  %t2048 = icmp eq i64 %t2047, 0
  br i1 %t2048, label %fixfast473, label %fixslow474
fixfast473:
  %t2049 = icmp slt i64 376, %t2045
  %t2050 = select i1 %t2049, i64 257, i64 1
  br label %fixmerge475
fixslow474:
  %t2051 = call i64 @rt_lt(i64 376, i64 %t2045)
  br label %fixmerge475
fixmerge475:
  %t2052 = phi i64 [ %t2050, %fixfast473 ], [ %t2051, %fixslow474 ]
  %t2053 = icmp ne i64 %t2052, 1
  br i1 %t2053, label %then476, label %else477
then476:
  %t2054 = or i64 %t2045, 464
  %t2055 = and i64 %t2054, 7
  %t2056 = icmp eq i64 %t2055, 0
  br i1 %t2056, label %fixfast478, label %fixslow479
fixfast478:
  %t2057 = icmp slt i64 %t2045, 464
  %t2058 = select i1 %t2057, i64 257, i64 1
  br label %fixmerge480
fixslow479:
  %t2059 = call i64 @rt_lt(i64 %t2045, i64 464)
  br label %fixmerge480
fixmerge480:
  %t2060 = phi i64 [ %t2058, %fixfast478 ], [ %t2059, %fixslow479 ]
  ret i64 %t2060
else477:
  ret i64 1
}

define fastcc i64 @"scheme.base:code_556"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t2065 = icmp eq i64 %argc, 1
  br i1 %t2065, label %argok482, label %arityerr481
arityerr481:
  call void @rt_arity_error(i64 1, i64 %argc)
  unreachable
argok482:
  %t2066 = call i64 @rt_char_to_integer(i64 %a0)
  %t2067 = load i64, ptr @"scheme.base:rd-ws?"
  %t2068 = and i64 %t2067, -8
  %t2069 = inttoptr i64 %t2068 to ptr
  %t2070 = load i64, ptr %t2069
  %t2071 = inttoptr i64 %t2070 to ptr
  %t2072 = call fastcc i64%t2071(i64 %t2067, i64 1, i64 %a0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t2073 = icmp ne i64 %t2072, 1
  br i1 %t2073, label %then483, label %else484
then483:
  ret i64 %t2072
else484:
  %t2074 = or i64 %t2066, 320
  %t2075 = and i64 %t2074, 7
  %t2076 = icmp eq i64 %t2075, 0
  br i1 %t2076, label %fixfast485, label %fixslow486
fixfast485:
  %t2077 = icmp eq i64 %t2066, 320
  %t2078 = select i1 %t2077, i64 257, i64 1
  br label %fixmerge487
fixslow486:
  %t2079 = call i64 @rt_num_eq(i64 %t2066, i64 320)
  br label %fixmerge487
fixmerge487:
  %t2080 = phi i64 [ %t2078, %fixfast485 ], [ %t2079, %fixslow486 ]
  %t2081 = icmp ne i64 %t2080, 1
  br i1 %t2081, label %then488, label %else489
then488:
  ret i64 %t2080
else489:
  %t2082 = or i64 %t2066, 328
  %t2083 = and i64 %t2082, 7
  %t2084 = icmp eq i64 %t2083, 0
  br i1 %t2084, label %fixfast490, label %fixslow491
fixfast490:
  %t2085 = icmp eq i64 %t2066, 328
  %t2086 = select i1 %t2085, i64 257, i64 1
  br label %fixmerge492
fixslow491:
  %t2087 = call i64 @rt_num_eq(i64 %t2066, i64 328)
  br label %fixmerge492
fixmerge492:
  %t2088 = phi i64 [ %t2086, %fixfast490 ], [ %t2087, %fixslow491 ]
  %t2089 = icmp ne i64 %t2088, 1
  br i1 %t2089, label %then493, label %else494
then493:
  ret i64 %t2088
else494:
  %t2090 = or i64 %t2066, 728
  %t2091 = and i64 %t2090, 7
  %t2092 = icmp eq i64 %t2091, 0
  br i1 %t2092, label %fixfast495, label %fixslow496
fixfast495:
  %t2093 = icmp eq i64 %t2066, 728
  %t2094 = select i1 %t2093, i64 257, i64 1
  br label %fixmerge497
fixslow496:
  %t2095 = call i64 @rt_num_eq(i64 %t2066, i64 728)
  br label %fixmerge497
fixmerge497:
  %t2096 = phi i64 [ %t2094, %fixfast495 ], [ %t2095, %fixslow496 ]
  %t2097 = icmp ne i64 %t2096, 1
  br i1 %t2097, label %then498, label %else499
then498:
  ret i64 %t2096
else499:
  %t2098 = or i64 %t2066, 744
  %t2099 = and i64 %t2098, 7
  %t2100 = icmp eq i64 %t2099, 0
  br i1 %t2100, label %fixfast500, label %fixslow501
fixfast500:
  %t2101 = icmp eq i64 %t2066, 744
  %t2102 = select i1 %t2101, i64 257, i64 1
  br label %fixmerge502
fixslow501:
  %t2103 = call i64 @rt_num_eq(i64 %t2066, i64 744)
  br label %fixmerge502
fixmerge502:
  %t2104 = phi i64 [ %t2102, %fixfast500 ], [ %t2103, %fixslow501 ]
  %t2105 = icmp ne i64 %t2104, 1
  br i1 %t2105, label %then503, label %else504
then503:
  ret i64 %t2104
else504:
  %t2106 = or i64 %t2066, 272
  %t2107 = and i64 %t2106, 7
  %t2108 = icmp eq i64 %t2107, 0
  br i1 %t2108, label %fixfast505, label %fixslow506
fixfast505:
  %t2109 = icmp eq i64 %t2066, 272
  %t2110 = select i1 %t2109, i64 257, i64 1
  br label %fixmerge507
fixslow506:
  %t2111 = call i64 @rt_num_eq(i64 %t2066, i64 272)
  br label %fixmerge507
fixmerge507:
  %t2112 = phi i64 [ %t2110, %fixfast505 ], [ %t2111, %fixslow506 ]
  %t2113 = icmp ne i64 %t2112, 1
  br i1 %t2113, label %then508, label %else509
then508:
  ret i64 %t2112
else509:
  %t2114 = or i64 %t2066, 472
  %t2115 = and i64 %t2114, 7
  %t2116 = icmp eq i64 %t2115, 0
  br i1 %t2116, label %fixfast510, label %fixslow511
fixfast510:
  %t2117 = icmp eq i64 %t2066, 472
  %t2118 = select i1 %t2117, i64 257, i64 1
  br label %fixmerge512
fixslow511:
  %t2119 = call i64 @rt_num_eq(i64 %t2066, i64 472)
  br label %fixmerge512
fixmerge512:
  %t2120 = phi i64 [ %t2118, %fixfast510 ], [ %t2119, %fixslow511 ]
  ret i64 %t2120
}

define fastcc i64 @"scheme.base:code_569"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t2125 = icmp eq i64 %argc, 3
  br i1 %t2125, label %argok514, label %arityerr513
arityerr513:
  call void @rt_arity_error(i64 3, i64 %argc)
  unreachable
argok514:
  %t2126 = or i64 %a2, %a1
  %t2127 = and i64 %t2126, 7
  %t2128 = icmp eq i64 %t2127, 0
  br i1 %t2128, label %fixfast515, label %fixslow516
fixfast515:
  %t2129 = icmp slt i64 %a2, %a1
  %t2130 = select i1 %t2129, i64 257, i64 1
  br label %fixmerge517
fixslow516:
  %t2131 = call i64 @rt_lt(i64 %a2, i64 %a1)
  br label %fixmerge517
fixmerge517:
  %t2132 = phi i64 [ %t2130, %fixfast515 ], [ %t2131, %fixslow516 ]
  %t2133 = icmp ne i64 %t2132, 1
  br i1 %t2133, label %then518, label %else519
then518:
  %t2134 = call i64 @rt_string_ref(i64 %a0, i64 %a2)
  %t2135 = call i64 @rt_char_to_integer(i64 %t2134)
  %t2136 = or i64 %t2135, 80
  %t2137 = and i64 %t2136, 7
  %t2138 = icmp eq i64 %t2137, 0
  br i1 %t2138, label %fixfast520, label %fixslow521
fixfast520:
  %t2139 = icmp eq i64 %t2135, 80
  %t2140 = select i1 %t2139, i64 257, i64 1
  br label %fixmerge522
fixslow521:
  %t2141 = call i64 @rt_num_eq(i64 %t2135, i64 80)
  br label %fixmerge522
fixmerge522:
  %t2142 = phi i64 [ %t2140, %fixfast520 ], [ %t2141, %fixslow521 ]
  %t2143 = icmp ne i64 %t2142, 1
  br i1 %t2143, label %then523, label %else524
then523:
  %t2144 = or i64 %a2, 8
  %t2145 = and i64 %t2144, 7
  %t2146 = icmp eq i64 %t2145, 0
  br i1 %t2146, label %fixfast525, label %fixslow526
fixfast525:
  %t2147 = add i64 %a2, 8
  br label %fixmerge527
fixslow526:
  %t2148 = call i64 @rt_add(i64 %a2, i64 8)
  br label %fixmerge527
fixmerge527:
  %t2149 = phi i64 [ %t2147, %fixfast525 ], [ %t2148, %fixslow526 ]
  ret i64 %t2149
else524:
  %t2150 = or i64 %a2, 8
  %t2151 = and i64 %t2150, 7
  %t2152 = icmp eq i64 %t2151, 0
  br i1 %t2152, label %fixfast528, label %fixslow529
fixfast528:
  %t2153 = add i64 %a2, 8
  br label %fixmerge530
fixslow529:
  %t2154 = call i64 @rt_add(i64 %a2, i64 8)
  br label %fixmerge530
fixmerge530:
  %t2155 = phi i64 [ %t2153, %fixfast528 ], [ %t2154, %fixslow529 ]
  %t2156 = load i64, ptr @"scheme.base:rd-skip-line"
  %t2157 = and i64 %t2156, -8
  %t2158 = inttoptr i64 %t2157 to ptr
  %t2159 = load i64, ptr %t2158
  %t2160 = inttoptr i64 %t2159 to ptr
  %t2161 = musttail call fastcc i64 %t2160(i64 %t2156, i64 3, i64 %a0, i64 %a1, i64 %t2155, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t2161
else519:
  ret i64 %a2
}

define fastcc i64 @"scheme.base:code_583"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t2166 = icmp eq i64 %argc, 3
  br i1 %t2166, label %argok532, label %arityerr531
arityerr531:
  call void @rt_arity_error(i64 3, i64 %argc)
  unreachable
argok532:
  %t2167 = or i64 %a2, %a1
  %t2168 = and i64 %t2167, 7
  %t2169 = icmp eq i64 %t2168, 0
  br i1 %t2169, label %fixfast533, label %fixslow534
fixfast533:
  %t2170 = icmp slt i64 %a2, %a1
  %t2171 = select i1 %t2170, i64 257, i64 1
  br label %fixmerge535
fixslow534:
  %t2172 = call i64 @rt_lt(i64 %a2, i64 %a1)
  br label %fixmerge535
fixmerge535:
  %t2173 = phi i64 [ %t2171, %fixfast533 ], [ %t2172, %fixslow534 ]
  %t2174 = icmp ne i64 %t2173, 1
  br i1 %t2174, label %then536, label %else537
then536:
  %t2175 = call i64 @rt_string_ref(i64 %a0, i64 %a2)
  %t2176 = load i64, ptr @"scheme.base:rd-ws?"
  %t2177 = and i64 %t2176, -8
  %t2178 = inttoptr i64 %t2177 to ptr
  %t2179 = load i64, ptr %t2178
  %t2180 = inttoptr i64 %t2179 to ptr
  %t2181 = call fastcc i64%t2180(i64 %t2176, i64 1, i64 %t2175, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t2182 = icmp ne i64 %t2181, 1
  br i1 %t2182, label %then538, label %else539
then538:
  %t2183 = or i64 %a2, 8
  %t2184 = and i64 %t2183, 7
  %t2185 = icmp eq i64 %t2184, 0
  br i1 %t2185, label %fixfast540, label %fixslow541
fixfast540:
  %t2186 = add i64 %a2, 8
  br label %fixmerge542
fixslow541:
  %t2187 = call i64 @rt_add(i64 %a2, i64 8)
  br label %fixmerge542
fixmerge542:
  %t2188 = phi i64 [ %t2186, %fixfast540 ], [ %t2187, %fixslow541 ]
  %t2189 = load i64, ptr @"scheme.base:rd-skip-ws"
  %t2190 = and i64 %t2189, -8
  %t2191 = inttoptr i64 %t2190 to ptr
  %t2192 = load i64, ptr %t2191
  %t2193 = inttoptr i64 %t2192 to ptr
  %t2194 = musttail call fastcc i64 %t2193(i64 %t2189, i64 3, i64 %a0, i64 %a1, i64 %t2188, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t2194
else539:
  %t2195 = call i64 @rt_char_to_integer(i64 %t2175)
  %t2196 = or i64 %t2195, 472
  %t2197 = and i64 %t2196, 7
  %t2198 = icmp eq i64 %t2197, 0
  br i1 %t2198, label %fixfast543, label %fixslow544
fixfast543:
  %t2199 = icmp eq i64 %t2195, 472
  %t2200 = select i1 %t2199, i64 257, i64 1
  br label %fixmerge545
fixslow544:
  %t2201 = call i64 @rt_num_eq(i64 %t2195, i64 472)
  br label %fixmerge545
fixmerge545:
  %t2202 = phi i64 [ %t2200, %fixfast543 ], [ %t2201, %fixslow544 ]
  %t2203 = icmp ne i64 %t2202, 1
  br i1 %t2203, label %then546, label %else547
then546:
  %t2204 = or i64 %a2, 8
  %t2205 = and i64 %t2204, 7
  %t2206 = icmp eq i64 %t2205, 0
  br i1 %t2206, label %fixfast548, label %fixslow549
fixfast548:
  %t2207 = add i64 %a2, 8
  br label %fixmerge550
fixslow549:
  %t2208 = call i64 @rt_add(i64 %a2, i64 8)
  br label %fixmerge550
fixmerge550:
  %t2209 = phi i64 [ %t2207, %fixfast548 ], [ %t2208, %fixslow549 ]
  %t2210 = load i64, ptr @"scheme.base:rd-skip-line"
  %t2211 = and i64 %t2210, -8
  %t2212 = inttoptr i64 %t2211 to ptr
  %t2213 = load i64, ptr %t2212
  %t2214 = inttoptr i64 %t2213 to ptr
  %t2215 = call fastcc i64%t2214(i64 %t2210, i64 3, i64 %a0, i64 %a1, i64 %t2209, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t2216 = load i64, ptr @"scheme.base:rd-skip-ws"
  %t2217 = and i64 %t2216, -8
  %t2218 = inttoptr i64 %t2217 to ptr
  %t2219 = load i64, ptr %t2218
  %t2220 = inttoptr i64 %t2219 to ptr
  %t2221 = musttail call fastcc i64 %t2220(i64 %t2216, i64 3, i64 %a0, i64 %a1, i64 %t2215, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t2221
else547:
  ret i64 %a2
else537:
  ret i64 %a2
}

define fastcc i64 @"scheme.base:code_592"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t2226 = icmp eq i64 %argc, 3
  br i1 %t2226, label %argok552, label %arityerr551
arityerr551:
  call void @rt_arity_error(i64 3, i64 %argc)
  unreachable
argok552:
  %t2227 = or i64 %a2, %a1
  %t2228 = and i64 %t2227, 7
  %t2229 = icmp eq i64 %t2228, 0
  br i1 %t2229, label %fixfast553, label %fixslow554
fixfast553:
  %t2230 = icmp slt i64 %a2, %a1
  %t2231 = select i1 %t2230, i64 257, i64 1
  br label %fixmerge555
fixslow554:
  %t2232 = call i64 @rt_lt(i64 %a2, i64 %a1)
  br label %fixmerge555
fixmerge555:
  %t2233 = phi i64 [ %t2231, %fixfast553 ], [ %t2232, %fixslow554 ]
  %t2234 = icmp ne i64 %t2233, 1
  br i1 %t2234, label %then556, label %else557
then556:
  %t2235 = call i64 @rt_string_ref(i64 %a0, i64 %a2)
  %t2236 = load i64, ptr @"scheme.base:rd-delim?"
  %t2237 = and i64 %t2236, -8
  %t2238 = inttoptr i64 %t2237 to ptr
  %t2239 = load i64, ptr %t2238
  %t2240 = inttoptr i64 %t2239 to ptr
  %t2241 = call fastcc i64%t2240(i64 %t2236, i64 1, i64 %t2235, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t2242 = icmp ne i64 %t2241, 1
  br i1 %t2242, label %then558, label %else559
then558:
  ret i64 %a2
else559:
  %t2243 = or i64 %a2, 8
  %t2244 = and i64 %t2243, 7
  %t2245 = icmp eq i64 %t2244, 0
  br i1 %t2245, label %fixfast560, label %fixslow561
fixfast560:
  %t2246 = add i64 %a2, 8
  br label %fixmerge562
fixslow561:
  %t2247 = call i64 @rt_add(i64 %a2, i64 8)
  br label %fixmerge562
fixmerge562:
  %t2248 = phi i64 [ %t2246, %fixfast560 ], [ %t2247, %fixslow561 ]
  %t2249 = load i64, ptr @"scheme.base:rd-token-end"
  %t2250 = and i64 %t2249, -8
  %t2251 = inttoptr i64 %t2250 to ptr
  %t2252 = load i64, ptr %t2251
  %t2253 = inttoptr i64 %t2252 to ptr
  %t2254 = musttail call fastcc i64 %t2253(i64 %t2249, i64 3, i64 %a0, i64 %a1, i64 %t2248, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t2254
else557:
  ret i64 %a2
}

define fastcc i64 @"scheme.base:code_601"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t2259 = icmp eq i64 %argc, 3
  br i1 %t2259, label %argok564, label %arityerr563
arityerr563:
  call void @rt_arity_error(i64 3, i64 %argc)
  unreachable
argok564:
  %t2260 = or i64 %a1, %a2
  %t2261 = and i64 %t2260, 7
  %t2262 = icmp eq i64 %t2261, 0
  br i1 %t2262, label %fixfast565, label %fixslow566
fixfast565:
  %t2263 = icmp slt i64 %a1, %a2
  %t2264 = select i1 %t2263, i64 257, i64 1
  br label %fixmerge567
fixslow566:
  %t2265 = call i64 @rt_lt(i64 %a1, i64 %a2)
  br label %fixmerge567
fixmerge567:
  %t2266 = phi i64 [ %t2264, %fixfast565 ], [ %t2265, %fixslow566 ]
  %t2267 = icmp ne i64 %t2266, 1
  br i1 %t2267, label %then568, label %else569
then568:
  %t2268 = call i64 @rt_string_ref(i64 %a0, i64 %a1)
  %t2269 = load i64, ptr @"scheme.base:rd-digit?"
  %t2270 = and i64 %t2269, -8
  %t2271 = inttoptr i64 %t2270 to ptr
  %t2272 = load i64, ptr %t2271
  %t2273 = inttoptr i64 %t2272 to ptr
  %t2274 = call fastcc i64%t2273(i64 %t2269, i64 1, i64 %t2268, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t2275 = icmp ne i64 %t2274, 1
  br i1 %t2275, label %then570, label %else571
then570:
  %t2276 = or i64 %a1, 8
  %t2277 = and i64 %t2276, 7
  %t2278 = icmp eq i64 %t2277, 0
  br i1 %t2278, label %fixfast572, label %fixslow573
fixfast572:
  %t2279 = add i64 %a1, 8
  br label %fixmerge574
fixslow573:
  %t2280 = call i64 @rt_add(i64 %a1, i64 8)
  br label %fixmerge574
fixmerge574:
  %t2281 = phi i64 [ %t2279, %fixfast572 ], [ %t2280, %fixslow573 ]
  %t2282 = load i64, ptr @"scheme.base:rd-all-digits?"
  %t2283 = and i64 %t2282, -8
  %t2284 = inttoptr i64 %t2283 to ptr
  %t2285 = load i64, ptr %t2284
  %t2286 = inttoptr i64 %t2285 to ptr
  %t2287 = musttail call fastcc i64 %t2286(i64 %t2282, i64 3, i64 %a0, i64 %t2281, i64 %a2, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t2287
else571:
  ret i64 1
else569:
  ret i64 257
}

define fastcc i64 @"scheme.base:code_624"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t2292 = icmp eq i64 %argc, 1
  br i1 %t2292, label %argok576, label %arityerr575
arityerr575:
  call void @rt_arity_error(i64 1, i64 %argc)
  unreachable
argok576:
  %t2293 = call i64 @rt_string_length(i64 %a0)
  %t2294 = or i64 0, %t2293
  %t2295 = and i64 %t2294, 7
  %t2296 = icmp eq i64 %t2295, 0
  br i1 %t2296, label %fixfast577, label %fixslow578
fixfast577:
  %t2297 = icmp slt i64 0, %t2293
  %t2298 = select i1 %t2297, i64 257, i64 1
  br label %fixmerge579
fixslow578:
  %t2299 = call i64 @rt_lt(i64 0, i64 %t2293)
  br label %fixmerge579
fixmerge579:
  %t2300 = phi i64 [ %t2298, %fixfast577 ], [ %t2299, %fixslow578 ]
  %t2301 = icmp ne i64 %t2300, 1
  br i1 %t2301, label %then580, label %else581
then580:
  %t2302 = call i64 @rt_string_ref(i64 %a0, i64 0)
  %t2303 = call i64 @rt_char_to_integer(i64 %t2302)
  %t2304 = call i64 @rt_string_ref(i64 %a0, i64 0)
  %t2305 = load i64, ptr @"scheme.base:rd-digit?"
  %t2306 = and i64 %t2305, -8
  %t2307 = inttoptr i64 %t2306 to ptr
  %t2308 = load i64, ptr %t2307
  %t2309 = inttoptr i64 %t2308 to ptr
  %t2310 = call fastcc i64%t2309(i64 %t2305, i64 1, i64 %t2304, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t2311 = icmp ne i64 %t2310, 1
  br i1 %t2311, label %then582, label %else583
then582:
  %t2312 = load i64, ptr @"scheme.base:rd-all-digits?"
  %t2313 = and i64 %t2312, -8
  %t2314 = inttoptr i64 %t2313 to ptr
  %t2315 = load i64, ptr %t2314
  %t2316 = inttoptr i64 %t2315 to ptr
  %t2317 = musttail call fastcc i64 %t2316(i64 %t2312, i64 3, i64 %a0, i64 0, i64 %t2293, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t2317
else583:
  %t2318 = or i64 %t2303, 360
  %t2319 = and i64 %t2318, 7
  %t2320 = icmp eq i64 %t2319, 0
  br i1 %t2320, label %fixfast584, label %fixslow585
fixfast584:
  %t2321 = icmp eq i64 %t2303, 360
  %t2322 = select i1 %t2321, i64 257, i64 1
  br label %fixmerge586
fixslow585:
  %t2323 = call i64 @rt_num_eq(i64 %t2303, i64 360)
  br label %fixmerge586
fixmerge586:
  %t2324 = phi i64 [ %t2322, %fixfast584 ], [ %t2323, %fixslow585 ]
  %t2325 = icmp ne i64 %t2324, 1
  br i1 %t2325, label %then587, label %else588
then587:
  br label %merge589
else588:
  %t2326 = or i64 %t2303, 344
  %t2327 = and i64 %t2326, 7
  %t2328 = icmp eq i64 %t2327, 0
  br i1 %t2328, label %fixfast590, label %fixslow591
fixfast590:
  %t2329 = icmp eq i64 %t2303, 344
  %t2330 = select i1 %t2329, i64 257, i64 1
  br label %fixmerge592
fixslow591:
  %t2331 = call i64 @rt_num_eq(i64 %t2303, i64 344)
  br label %fixmerge592
fixmerge592:
  %t2332 = phi i64 [ %t2330, %fixfast590 ], [ %t2331, %fixslow591 ]
  br label %merge589
merge589:
  %t2333 = phi i64 [ %t2324, %then587 ], [ %t2332, %fixmerge592 ]
  %t2334 = icmp ne i64 %t2333, 1
  br i1 %t2334, label %then593, label %else594
then593:
  %t2335 = or i64 8, %t2293
  %t2336 = and i64 %t2335, 7
  %t2337 = icmp eq i64 %t2336, 0
  br i1 %t2337, label %fixfast595, label %fixslow596
fixfast595:
  %t2338 = icmp slt i64 8, %t2293
  %t2339 = select i1 %t2338, i64 257, i64 1
  br label %fixmerge597
fixslow596:
  %t2340 = call i64 @rt_lt(i64 8, i64 %t2293)
  br label %fixmerge597
fixmerge597:
  %t2341 = phi i64 [ %t2339, %fixfast595 ], [ %t2340, %fixslow596 ]
  %t2342 = icmp ne i64 %t2341, 1
  br i1 %t2342, label %then598, label %else599
then598:
  %t2343 = load i64, ptr @"scheme.base:rd-all-digits?"
  %t2344 = and i64 %t2343, -8
  %t2345 = inttoptr i64 %t2344 to ptr
  %t2346 = load i64, ptr %t2345
  %t2347 = inttoptr i64 %t2346 to ptr
  %t2348 = musttail call fastcc i64 %t2347(i64 %t2343, i64 3, i64 %a0, i64 8, i64 %t2293, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t2348
else599:
  ret i64 1
else594:
  ret i64 1
else581:
  ret i64 1
}

define fastcc i64 @"scheme.base:code_634"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t2353 = icmp eq i64 %argc, 4
  br i1 %t2353, label %argok601, label %arityerr600
arityerr600:
  call void @rt_arity_error(i64 4, i64 %argc)
  unreachable
argok601:
  %t2354 = or i64 %a1, %a2
  %t2355 = and i64 %t2354, 7
  %t2356 = icmp eq i64 %t2355, 0
  br i1 %t2356, label %fixfast602, label %fixslow603
fixfast602:
  %t2357 = icmp slt i64 %a1, %a2
  %t2358 = select i1 %t2357, i64 257, i64 1
  br label %fixmerge604
fixslow603:
  %t2359 = call i64 @rt_lt(i64 %a1, i64 %a2)
  br label %fixmerge604
fixmerge604:
  %t2360 = phi i64 [ %t2358, %fixfast602 ], [ %t2359, %fixslow603 ]
  %t2361 = icmp ne i64 %t2360, 1
  br i1 %t2361, label %then605, label %else606
then605:
  %t2362 = or i64 %a1, 8
  %t2363 = and i64 %t2362, 7
  %t2364 = icmp eq i64 %t2363, 0
  br i1 %t2364, label %fixfast607, label %fixslow608
fixfast607:
  %t2365 = add i64 %a1, 8
  br label %fixmerge609
fixslow608:
  %t2366 = call i64 @rt_add(i64 %a1, i64 8)
  br label %fixmerge609
fixmerge609:
  %t2367 = phi i64 [ %t2365, %fixfast607 ], [ %t2366, %fixslow608 ]
  %t2368 = or i64 %a3, 80
  %t2369 = and i64 %t2368, 7
  %t2370 = icmp eq i64 %t2369, 0
  br i1 %t2370, label %fixfast610, label %fixslow611
fixfast610:
  %t2371 = ashr i64 %a3, 3
  %t2372 = mul i64 %t2371, 80
  br label %fixmerge612
fixslow611:
  %t2373 = call i64 @rt_mul(i64 %a3, i64 80)
  br label %fixmerge612
fixmerge612:
  %t2374 = phi i64 [ %t2372, %fixfast610 ], [ %t2373, %fixslow611 ]
  %t2375 = call i64 @rt_string_ref(i64 %a0, i64 %a1)
  %t2376 = call i64 @rt_char_to_integer(i64 %t2375)
  %t2377 = or i64 %t2376, 384
  %t2378 = and i64 %t2377, 7
  %t2379 = icmp eq i64 %t2378, 0
  br i1 %t2379, label %fixfast613, label %fixslow614
fixfast613:
  %t2380 = sub i64 %t2376, 384
  br label %fixmerge615
fixslow614:
  %t2381 = call i64 @rt_sub(i64 %t2376, i64 384)
  br label %fixmerge615
fixmerge615:
  %t2382 = phi i64 [ %t2380, %fixfast613 ], [ %t2381, %fixslow614 ]
  %t2383 = or i64 %t2374, %t2382
  %t2384 = and i64 %t2383, 7
  %t2385 = icmp eq i64 %t2384, 0
  br i1 %t2385, label %fixfast616, label %fixslow617
fixfast616:
  %t2386 = add i64 %t2374, %t2382
  br label %fixmerge618
fixslow617:
  %t2387 = call i64 @rt_add(i64 %t2374, i64 %t2382)
  br label %fixmerge618
fixmerge618:
  %t2388 = phi i64 [ %t2386, %fixfast616 ], [ %t2387, %fixslow617 ]
  %t2389 = load i64, ptr @"scheme.base:rd-digits"
  %t2390 = and i64 %t2389, -8
  %t2391 = inttoptr i64 %t2390 to ptr
  %t2392 = load i64, ptr %t2391
  %t2393 = inttoptr i64 %t2392 to ptr
  %t2394 = musttail call fastcc i64 %t2393(i64 %t2389, i64 4, i64 %a0, i64 %t2367, i64 %a2, i64 %t2388, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t2394
else606:
  ret i64 %a3
}

define fastcc i64 @"scheme.base:code_647"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t2399 = icmp eq i64 %argc, 1
  br i1 %t2399, label %argok620, label %arityerr619
arityerr619:
  call void @rt_arity_error(i64 1, i64 %argc)
  unreachable
argok620:
  %t2400 = call i64 @rt_string_length(i64 %a0)
  %t2401 = call i64 @rt_string_ref(i64 %a0, i64 0)
  %t2402 = call i64 @rt_char_to_integer(i64 %t2401)
  %t2403 = or i64 %t2402, 360
  %t2404 = and i64 %t2403, 7
  %t2405 = icmp eq i64 %t2404, 0
  br i1 %t2405, label %fixfast621, label %fixslow622
fixfast621:
  %t2406 = icmp eq i64 %t2402, 360
  %t2407 = select i1 %t2406, i64 257, i64 1
  br label %fixmerge623
fixslow622:
  %t2408 = call i64 @rt_num_eq(i64 %t2402, i64 360)
  br label %fixmerge623
fixmerge623:
  %t2409 = phi i64 [ %t2407, %fixfast621 ], [ %t2408, %fixslow622 ]
  %t2410 = icmp ne i64 %t2409, 1
  br i1 %t2410, label %then624, label %else625
then624:
  %t2411 = load i64, ptr @"scheme.base:rd-digits"
  %t2412 = and i64 %t2411, -8
  %t2413 = inttoptr i64 %t2412 to ptr
  %t2414 = load i64, ptr %t2413
  %t2415 = inttoptr i64 %t2414 to ptr
  %t2416 = call fastcc i64%t2415(i64 %t2411, i64 4, i64 %a0, i64 8, i64 %t2400, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t2417 = or i64 0, %t2416
  %t2418 = and i64 %t2417, 7
  %t2419 = icmp eq i64 %t2418, 0
  br i1 %t2419, label %fixfast626, label %fixslow627
fixfast626:
  %t2420 = sub i64 0, %t2416
  br label %fixmerge628
fixslow627:
  %t2421 = call i64 @rt_sub(i64 0, i64 %t2416)
  br label %fixmerge628
fixmerge628:
  %t2422 = phi i64 [ %t2420, %fixfast626 ], [ %t2421, %fixslow627 ]
  ret i64 %t2422
else625:
  %t2423 = or i64 %t2402, 344
  %t2424 = and i64 %t2423, 7
  %t2425 = icmp eq i64 %t2424, 0
  br i1 %t2425, label %fixfast629, label %fixslow630
fixfast629:
  %t2426 = icmp eq i64 %t2402, 344
  %t2427 = select i1 %t2426, i64 257, i64 1
  br label %fixmerge631
fixslow630:
  %t2428 = call i64 @rt_num_eq(i64 %t2402, i64 344)
  br label %fixmerge631
fixmerge631:
  %t2429 = phi i64 [ %t2427, %fixfast629 ], [ %t2428, %fixslow630 ]
  %t2430 = icmp ne i64 %t2429, 1
  br i1 %t2430, label %then632, label %else633
then632:
  %t2431 = load i64, ptr @"scheme.base:rd-digits"
  %t2432 = and i64 %t2431, -8
  %t2433 = inttoptr i64 %t2432 to ptr
  %t2434 = load i64, ptr %t2433
  %t2435 = inttoptr i64 %t2434 to ptr
  %t2436 = musttail call fastcc i64 %t2435(i64 %t2431, i64 4, i64 %a0, i64 8, i64 %t2400, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t2436
else633:
  %t2437 = load i64, ptr @"scheme.base:rd-digits"
  %t2438 = and i64 %t2437, -8
  %t2439 = inttoptr i64 %t2438 to ptr
  %t2440 = load i64, ptr %t2439
  %t2441 = inttoptr i64 %t2440 to ptr
  %t2442 = musttail call fastcc i64 %t2441(i64 %t2437, i64 4, i64 %a0, i64 0, i64 %t2400, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t2442
}

define fastcc i64 @"scheme.base:code_654"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t2447 = icmp eq i64 %argc, 3
  br i1 %t2447, label %argok635, label %arityerr634
arityerr634:
  call void @rt_arity_error(i64 3, i64 %argc)
  unreachable
argok635:
  %t2448 = load i64, ptr @"scheme.base:rd-token-end"
  %t2449 = and i64 %t2448, -8
  %t2450 = inttoptr i64 %t2449 to ptr
  %t2451 = load i64, ptr %t2450
  %t2452 = inttoptr i64 %t2451 to ptr
  %t2453 = call fastcc i64%t2452(i64 %t2448, i64 3, i64 %a0, i64 %a1, i64 %a2, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t2454 = call i64 @rt_substring(i64 %a0, i64 %a2, i64 %t2453)
  %t2455 = load i64, ptr @"scheme.base:rd-numeric?"
  %t2456 = and i64 %t2455, -8
  %t2457 = inttoptr i64 %t2456 to ptr
  %t2458 = load i64, ptr %t2457
  %t2459 = inttoptr i64 %t2458 to ptr
  %t2460 = call fastcc i64%t2459(i64 %t2455, i64 1, i64 %t2454, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t2461 = icmp ne i64 %t2460, 1
  br i1 %t2461, label %then636, label %else637
then636:
  %t2462 = load i64, ptr @"scheme.base:rd-parse-int"
  %t2463 = and i64 %t2462, -8
  %t2464 = inttoptr i64 %t2463 to ptr
  %t2465 = load i64, ptr %t2464
  %t2466 = inttoptr i64 %t2465 to ptr
  %t2467 = call fastcc i64%t2466(i64 %t2462, i64 1, i64 %t2454, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  br label %merge638
else637:
  %t2468 = call i64 @rt_string_to_symbol(i64 %t2454)
  br label %merge638
merge638:
  %t2469 = phi i64 [ %t2467, %then636 ], [ %t2468, %else637 ]
  %t2470 = call i64 @rt_cons(i64 %t2469, i64 %t2453)
  ret i64 %t2470
}

define fastcc i64 @"scheme.base:code_682"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t2475 = icmp eq i64 %argc, 1
  br i1 %t2475, label %argok640, label %arityerr639
arityerr639:
  call void @rt_arity_error(i64 1, i64 %argc)
  unreachable
argok640:
  %t2476 = call i64 @rt_char_to_integer(i64 %a0)
  %t2477 = or i64 376, %t2476
  %t2478 = and i64 %t2477, 7
  %t2479 = icmp eq i64 %t2478, 0
  br i1 %t2479, label %fixfast641, label %fixslow642
fixfast641:
  %t2480 = icmp slt i64 376, %t2476
  %t2481 = select i1 %t2480, i64 257, i64 1
  br label %fixmerge643
fixslow642:
  %t2482 = call i64 @rt_lt(i64 376, i64 %t2476)
  br label %fixmerge643
fixmerge643:
  %t2483 = phi i64 [ %t2481, %fixfast641 ], [ %t2482, %fixslow642 ]
  %t2484 = icmp ne i64 %t2483, 1
  br i1 %t2484, label %then644, label %else645
then644:
  %t2485 = or i64 %t2476, 464
  %t2486 = and i64 %t2485, 7
  %t2487 = icmp eq i64 %t2486, 0
  br i1 %t2487, label %fixfast647, label %fixslow648
fixfast647:
  %t2488 = icmp slt i64 %t2476, 464
  %t2489 = select i1 %t2488, i64 257, i64 1
  br label %fixmerge649
fixslow648:
  %t2490 = call i64 @rt_lt(i64 %t2476, i64 464)
  br label %fixmerge649
fixmerge649:
  %t2491 = phi i64 [ %t2489, %fixfast647 ], [ %t2490, %fixslow648 ]
  br label %merge646
else645:
  br label %merge646
merge646:
  %t2492 = phi i64 [ %t2491, %fixmerge649 ], [ 1, %else645 ]
  %t2493 = icmp ne i64 %t2492, 1
  br i1 %t2493, label %then650, label %else651
then650:
  %t2494 = or i64 %t2476, 384
  %t2495 = and i64 %t2494, 7
  %t2496 = icmp eq i64 %t2495, 0
  br i1 %t2496, label %fixfast652, label %fixslow653
fixfast652:
  %t2497 = sub i64 %t2476, 384
  br label %fixmerge654
fixslow653:
  %t2498 = call i64 @rt_sub(i64 %t2476, i64 384)
  br label %fixmerge654
fixmerge654:
  %t2499 = phi i64 [ %t2497, %fixfast652 ], [ %t2498, %fixslow653 ]
  ret i64 %t2499
else651:
  %t2500 = or i64 768, %t2476
  %t2501 = and i64 %t2500, 7
  %t2502 = icmp eq i64 %t2501, 0
  br i1 %t2502, label %fixfast655, label %fixslow656
fixfast655:
  %t2503 = icmp slt i64 768, %t2476
  %t2504 = select i1 %t2503, i64 257, i64 1
  br label %fixmerge657
fixslow656:
  %t2505 = call i64 @rt_lt(i64 768, i64 %t2476)
  br label %fixmerge657
fixmerge657:
  %t2506 = phi i64 [ %t2504, %fixfast655 ], [ %t2505, %fixslow656 ]
  %t2507 = icmp ne i64 %t2506, 1
  br i1 %t2507, label %then658, label %else659
then658:
  %t2508 = or i64 %t2476, 824
  %t2509 = and i64 %t2508, 7
  %t2510 = icmp eq i64 %t2509, 0
  br i1 %t2510, label %fixfast661, label %fixslow662
fixfast661:
  %t2511 = icmp slt i64 %t2476, 824
  %t2512 = select i1 %t2511, i64 257, i64 1
  br label %fixmerge663
fixslow662:
  %t2513 = call i64 @rt_lt(i64 %t2476, i64 824)
  br label %fixmerge663
fixmerge663:
  %t2514 = phi i64 [ %t2512, %fixfast661 ], [ %t2513, %fixslow662 ]
  br label %merge660
else659:
  br label %merge660
merge660:
  %t2515 = phi i64 [ %t2514, %fixmerge663 ], [ 1, %else659 ]
  %t2516 = icmp ne i64 %t2515, 1
  br i1 %t2516, label %then664, label %else665
then664:
  %t2517 = or i64 %t2476, 696
  %t2518 = and i64 %t2517, 7
  %t2519 = icmp eq i64 %t2518, 0
  br i1 %t2519, label %fixfast666, label %fixslow667
fixfast666:
  %t2520 = sub i64 %t2476, 696
  br label %fixmerge668
fixslow667:
  %t2521 = call i64 @rt_sub(i64 %t2476, i64 696)
  br label %fixmerge668
fixmerge668:
  %t2522 = phi i64 [ %t2520, %fixfast666 ], [ %t2521, %fixslow667 ]
  ret i64 %t2522
else665:
  %t2523 = or i64 512, %t2476
  %t2524 = and i64 %t2523, 7
  %t2525 = icmp eq i64 %t2524, 0
  br i1 %t2525, label %fixfast669, label %fixslow670
fixfast669:
  %t2526 = icmp slt i64 512, %t2476
  %t2527 = select i1 %t2526, i64 257, i64 1
  br label %fixmerge671
fixslow670:
  %t2528 = call i64 @rt_lt(i64 512, i64 %t2476)
  br label %fixmerge671
fixmerge671:
  %t2529 = phi i64 [ %t2527, %fixfast669 ], [ %t2528, %fixslow670 ]
  %t2530 = icmp ne i64 %t2529, 1
  br i1 %t2530, label %then672, label %else673
then672:
  %t2531 = or i64 %t2476, 568
  %t2532 = and i64 %t2531, 7
  %t2533 = icmp eq i64 %t2532, 0
  br i1 %t2533, label %fixfast675, label %fixslow676
fixfast675:
  %t2534 = icmp slt i64 %t2476, 568
  %t2535 = select i1 %t2534, i64 257, i64 1
  br label %fixmerge677
fixslow676:
  %t2536 = call i64 @rt_lt(i64 %t2476, i64 568)
  br label %fixmerge677
fixmerge677:
  %t2537 = phi i64 [ %t2535, %fixfast675 ], [ %t2536, %fixslow676 ]
  br label %merge674
else673:
  br label %merge674
merge674:
  %t2538 = phi i64 [ %t2537, %fixmerge677 ], [ 1, %else673 ]
  %t2539 = icmp ne i64 %t2538, 1
  br i1 %t2539, label %then678, label %else679
then678:
  %t2540 = or i64 %t2476, 440
  %t2541 = and i64 %t2540, 7
  %t2542 = icmp eq i64 %t2541, 0
  br i1 %t2542, label %fixfast680, label %fixslow681
fixfast680:
  %t2543 = sub i64 %t2476, 440
  br label %fixmerge682
fixslow681:
  %t2544 = call i64 @rt_sub(i64 %t2476, i64 440)
  br label %fixmerge682
fixmerge682:
  %t2545 = phi i64 [ %t2543, %fixfast680 ], [ %t2544, %fixslow681 ]
  ret i64 %t2545
else679:
  ret i64 0
}

define fastcc i64 @"scheme.base:code_696"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t2550 = icmp eq i64 %argc, 4
  br i1 %t2550, label %argok684, label %arityerr683
arityerr683:
  call void @rt_arity_error(i64 4, i64 %argc)
  unreachable
argok684:
  %t2551 = or i64 %a2, %a1
  %t2552 = and i64 %t2551, 7
  %t2553 = icmp eq i64 %t2552, 0
  br i1 %t2553, label %fixfast685, label %fixslow686
fixfast685:
  %t2554 = icmp slt i64 %a2, %a1
  %t2555 = select i1 %t2554, i64 257, i64 1
  br label %fixmerge687
fixslow686:
  %t2556 = call i64 @rt_lt(i64 %a2, i64 %a1)
  br label %fixmerge687
fixmerge687:
  %t2557 = phi i64 [ %t2555, %fixfast685 ], [ %t2556, %fixslow686 ]
  %t2558 = icmp ne i64 %t2557, 1
  br i1 %t2558, label %then688, label %else689
then688:
  %t2559 = call i64 @rt_string_ref(i64 %a0, i64 %a2)
  %t2560 = call i64 @rt_char_to_integer(i64 %t2559)
  %t2561 = or i64 %t2560, 472
  %t2562 = and i64 %t2561, 7
  %t2563 = icmp eq i64 %t2562, 0
  br i1 %t2563, label %fixfast690, label %fixslow691
fixfast690:
  %t2564 = icmp eq i64 %t2560, 472
  %t2565 = select i1 %t2564, i64 257, i64 1
  br label %fixmerge692
fixslow691:
  %t2566 = call i64 @rt_num_eq(i64 %t2560, i64 472)
  br label %fixmerge692
fixmerge692:
  %t2567 = phi i64 [ %t2565, %fixfast690 ], [ %t2566, %fixslow691 ]
  %t2568 = icmp ne i64 %t2567, 1
  br i1 %t2568, label %then693, label %else694
then693:
  %t2569 = or i64 %a2, 8
  %t2570 = and i64 %t2569, 7
  %t2571 = icmp eq i64 %t2570, 0
  br i1 %t2571, label %fixfast695, label %fixslow696
fixfast695:
  %t2572 = add i64 %a2, 8
  br label %fixmerge697
fixslow696:
  %t2573 = call i64 @rt_add(i64 %a2, i64 8)
  br label %fixmerge697
fixmerge697:
  %t2574 = phi i64 [ %t2572, %fixfast695 ], [ %t2573, %fixslow696 ]
  %t2575 = call i64 @rt_cons(i64 %a3, i64 %t2574)
  ret i64 %t2575
else694:
  %t2576 = or i64 %a2, 8
  %t2577 = and i64 %t2576, 7
  %t2578 = icmp eq i64 %t2577, 0
  br i1 %t2578, label %fixfast698, label %fixslow699
fixfast698:
  %t2579 = add i64 %a2, 8
  br label %fixmerge700
fixslow699:
  %t2580 = call i64 @rt_add(i64 %a2, i64 8)
  br label %fixmerge700
fixmerge700:
  %t2581 = phi i64 [ %t2579, %fixfast698 ], [ %t2580, %fixslow699 ]
  %t2582 = or i64 %a3, 128
  %t2583 = and i64 %t2582, 7
  %t2584 = icmp eq i64 %t2583, 0
  br i1 %t2584, label %fixfast701, label %fixslow702
fixfast701:
  %t2585 = ashr i64 %a3, 3
  %t2586 = mul i64 %t2585, 128
  br label %fixmerge703
fixslow702:
  %t2587 = call i64 @rt_mul(i64 %a3, i64 128)
  br label %fixmerge703
fixmerge703:
  %t2588 = phi i64 [ %t2586, %fixfast701 ], [ %t2587, %fixslow702 ]
  %t2589 = call i64 @rt_string_ref(i64 %a0, i64 %a2)
  %t2590 = load i64, ptr @"scheme.base:rd-hex-digit"
  %t2591 = and i64 %t2590, -8
  %t2592 = inttoptr i64 %t2591 to ptr
  %t2593 = load i64, ptr %t2592
  %t2594 = inttoptr i64 %t2593 to ptr
  %t2595 = call fastcc i64%t2594(i64 %t2590, i64 1, i64 %t2589, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t2596 = or i64 %t2588, %t2595
  %t2597 = and i64 %t2596, 7
  %t2598 = icmp eq i64 %t2597, 0
  br i1 %t2598, label %fixfast704, label %fixslow705
fixfast704:
  %t2599 = add i64 %t2588, %t2595
  br label %fixmerge706
fixslow705:
  %t2600 = call i64 @rt_add(i64 %t2588, i64 %t2595)
  br label %fixmerge706
fixmerge706:
  %t2601 = phi i64 [ %t2599, %fixfast704 ], [ %t2600, %fixslow705 ]
  %t2602 = load i64, ptr @"scheme.base:rd-hex"
  %t2603 = and i64 %t2602, -8
  %t2604 = inttoptr i64 %t2603 to ptr
  %t2605 = load i64, ptr %t2604
  %t2606 = inttoptr i64 %t2605 to ptr
  %t2607 = musttail call fastcc i64 %t2606(i64 %t2602, i64 4, i64 %a0, i64 %a1, i64 %t2581, i64 %t2601, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t2607
else689:
  %t2608 = call i64 @rt_cons(i64 %a3, i64 %a2)
  ret i64 %t2608
}

define fastcc i64 @"scheme.base:code_712"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t2613 = icmp eq i64 %argc, 1
  br i1 %t2613, label %argok708, label %arityerr707
arityerr707:
  call void @rt_arity_error(i64 1, i64 %argc)
  unreachable
argok708:
  %t2614 = call i64 @rt_char_to_integer(i64 %a0)
  %t2615 = or i64 %t2614, 880
  %t2616 = and i64 %t2615, 7
  %t2617 = icmp eq i64 %t2616, 0
  br i1 %t2617, label %fixfast709, label %fixslow710
fixfast709:
  %t2618 = icmp eq i64 %t2614, 880
  %t2619 = select i1 %t2618, i64 257, i64 1
  br label %fixmerge711
fixslow710:
  %t2620 = call i64 @rt_num_eq(i64 %t2614, i64 880)
  br label %fixmerge711
fixmerge711:
  %t2621 = phi i64 [ %t2619, %fixfast709 ], [ %t2620, %fixslow710 ]
  %t2622 = icmp ne i64 %t2621, 1
  br i1 %t2622, label %then712, label %else713
then712:
  %t2623 = call i64 @rt_integer_to_char(i64 80)
  ret i64 %t2623
else713:
  %t2624 = or i64 %t2614, 928
  %t2625 = and i64 %t2624, 7
  %t2626 = icmp eq i64 %t2625, 0
  br i1 %t2626, label %fixfast714, label %fixslow715
fixfast714:
  %t2627 = icmp eq i64 %t2614, 928
  %t2628 = select i1 %t2627, i64 257, i64 1
  br label %fixmerge716
fixslow715:
  %t2629 = call i64 @rt_num_eq(i64 %t2614, i64 928)
  br label %fixmerge716
fixmerge716:
  %t2630 = phi i64 [ %t2628, %fixfast714 ], [ %t2629, %fixslow715 ]
  %t2631 = icmp ne i64 %t2630, 1
  br i1 %t2631, label %then717, label %else718
then717:
  %t2632 = call i64 @rt_integer_to_char(i64 72)
  ret i64 %t2632
else718:
  %t2633 = or i64 %t2614, 912
  %t2634 = and i64 %t2633, 7
  %t2635 = icmp eq i64 %t2634, 0
  br i1 %t2635, label %fixfast719, label %fixslow720
fixfast719:
  %t2636 = icmp eq i64 %t2614, 912
  %t2637 = select i1 %t2636, i64 257, i64 1
  br label %fixmerge721
fixslow720:
  %t2638 = call i64 @rt_num_eq(i64 %t2614, i64 912)
  br label %fixmerge721
fixmerge721:
  %t2639 = phi i64 [ %t2637, %fixfast719 ], [ %t2638, %fixslow720 ]
  %t2640 = icmp ne i64 %t2639, 1
  br i1 %t2640, label %then722, label %else723
then722:
  %t2641 = call i64 @rt_integer_to_char(i64 104)
  ret i64 %t2641
else723:
  ret i64 %a0
}

define fastcc i64 @"scheme.base:code_742"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t2646 = icmp eq i64 %argc, 2
  br i1 %t2646, label %argok725, label %arityerr724
arityerr724:
  call void @rt_arity_error(i64 2, i64 %argc)
  unreachable
argok725:
  %t2647 = and i64 %self, -8
  %t2648 = inttoptr i64 %t2647 to ptr
  %t2649 = getelementptr i64, ptr %t2648, i64 1
  %t2650 = load i64, ptr %t2649
  %t2651 = or i64 %a0, %t2650
  %t2652 = and i64 %t2651, 7
  %t2653 = icmp eq i64 %t2652, 0
  br i1 %t2653, label %fixfast726, label %fixslow727
fixfast726:
  %t2654 = icmp slt i64 %a0, %t2650
  %t2655 = select i1 %t2654, i64 257, i64 1
  br label %fixmerge728
fixslow727:
  %t2656 = call i64 @rt_lt(i64 %a0, i64 %t2650)
  br label %fixmerge728
fixmerge728:
  %t2657 = phi i64 [ %t2655, %fixfast726 ], [ %t2656, %fixslow727 ]
  %t2658 = icmp ne i64 %t2657, 1
  br i1 %t2658, label %then729, label %else730
then729:
  %t2659 = and i64 %self, -8
  %t2660 = inttoptr i64 %t2659 to ptr
  %t2661 = getelementptr i64, ptr %t2660, i64 2
  %t2662 = load i64, ptr %t2661
  %t2663 = call i64 @rt_string_ref(i64 %t2662, i64 %a0)
  %t2664 = call i64 @rt_char_to_integer(i64 %t2663)
  %t2665 = or i64 %t2664, 272
  %t2666 = and i64 %t2665, 7
  %t2667 = icmp eq i64 %t2666, 0
  br i1 %t2667, label %fixfast731, label %fixslow732
fixfast731:
  %t2668 = icmp eq i64 %t2664, 272
  %t2669 = select i1 %t2668, i64 257, i64 1
  br label %fixmerge733
fixslow732:
  %t2670 = call i64 @rt_num_eq(i64 %t2664, i64 272)
  br label %fixmerge733
fixmerge733:
  %t2671 = phi i64 [ %t2669, %fixfast731 ], [ %t2670, %fixslow732 ]
  %t2672 = icmp ne i64 %t2671, 1
  br i1 %t2672, label %then734, label %else735
then734:
  %t2673 = load i64, ptr @"scheme.base:reverse"
  %t2674 = and i64 %t2673, -8
  %t2675 = inttoptr i64 %t2674 to ptr
  %t2676 = load i64, ptr %t2675
  %t2677 = inttoptr i64 %t2676 to ptr
  %t2678 = call fastcc i64%t2677(i64 %t2673, i64 1, i64 %a1, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t2679 = call i64 @rt_list_to_string(i64 %t2678)
  %t2680 = or i64 %a0, 8
  %t2681 = and i64 %t2680, 7
  %t2682 = icmp eq i64 %t2681, 0
  br i1 %t2682, label %fixfast736, label %fixslow737
fixfast736:
  %t2683 = add i64 %a0, 8
  br label %fixmerge738
fixslow737:
  %t2684 = call i64 @rt_add(i64 %a0, i64 8)
  br label %fixmerge738
fixmerge738:
  %t2685 = phi i64 [ %t2683, %fixfast736 ], [ %t2684, %fixslow737 ]
  %t2686 = call i64 @rt_cons(i64 %t2679, i64 %t2685)
  ret i64 %t2686
else735:
  %t2687 = or i64 %t2664, 736
  %t2688 = and i64 %t2687, 7
  %t2689 = icmp eq i64 %t2688, 0
  br i1 %t2689, label %fixfast739, label %fixslow740
fixfast739:
  %t2690 = icmp eq i64 %t2664, 736
  %t2691 = select i1 %t2690, i64 257, i64 1
  br label %fixmerge741
fixslow740:
  %t2692 = call i64 @rt_num_eq(i64 %t2664, i64 736)
  br label %fixmerge741
fixmerge741:
  %t2693 = phi i64 [ %t2691, %fixfast739 ], [ %t2692, %fixslow740 ]
  %t2694 = icmp ne i64 %t2693, 1
  br i1 %t2694, label %then742, label %else743
then742:
  %t2695 = and i64 %self, -8
  %t2696 = inttoptr i64 %t2695 to ptr
  %t2697 = getelementptr i64, ptr %t2696, i64 2
  %t2698 = load i64, ptr %t2697
  %t2699 = or i64 %a0, 8
  %t2700 = and i64 %t2699, 7
  %t2701 = icmp eq i64 %t2700, 0
  br i1 %t2701, label %fixfast744, label %fixslow745
fixfast744:
  %t2702 = add i64 %a0, 8
  br label %fixmerge746
fixslow745:
  %t2703 = call i64 @rt_add(i64 %a0, i64 8)
  br label %fixmerge746
fixmerge746:
  %t2704 = phi i64 [ %t2702, %fixfast744 ], [ %t2703, %fixslow745 ]
  %t2705 = call i64 @rt_string_ref(i64 %t2698, i64 %t2704)
  %t2706 = call i64 @rt_char_to_integer(i64 %t2705)
  %t2707 = or i64 %t2706, 960
  %t2708 = and i64 %t2707, 7
  %t2709 = icmp eq i64 %t2708, 0
  br i1 %t2709, label %fixfast747, label %fixslow748
fixfast747:
  %t2710 = icmp eq i64 %t2706, 960
  %t2711 = select i1 %t2710, i64 257, i64 1
  br label %fixmerge749
fixslow748:
  %t2712 = call i64 @rt_num_eq(i64 %t2706, i64 960)
  br label %fixmerge749
fixmerge749:
  %t2713 = phi i64 [ %t2711, %fixfast747 ], [ %t2712, %fixslow748 ]
  %t2714 = icmp ne i64 %t2713, 1
  br i1 %t2714, label %then750, label %else751
then750:
  %t2715 = and i64 %self, -8
  %t2716 = inttoptr i64 %t2715 to ptr
  %t2717 = getelementptr i64, ptr %t2716, i64 2
  %t2718 = load i64, ptr %t2717
  %t2719 = and i64 %self, -8
  %t2720 = inttoptr i64 %t2719 to ptr
  %t2721 = getelementptr i64, ptr %t2720, i64 1
  %t2722 = load i64, ptr %t2721
  %t2723 = or i64 %a0, 16
  %t2724 = and i64 %t2723, 7
  %t2725 = icmp eq i64 %t2724, 0
  br i1 %t2725, label %fixfast752, label %fixslow753
fixfast752:
  %t2726 = add i64 %a0, 16
  br label %fixmerge754
fixslow753:
  %t2727 = call i64 @rt_add(i64 %a0, i64 16)
  br label %fixmerge754
fixmerge754:
  %t2728 = phi i64 [ %t2726, %fixfast752 ], [ %t2727, %fixslow753 ]
  %t2729 = load i64, ptr @"scheme.base:rd-hex"
  %t2730 = and i64 %t2729, -8
  %t2731 = inttoptr i64 %t2730 to ptr
  %t2732 = load i64, ptr %t2731
  %t2733 = inttoptr i64 %t2732 to ptr
  %t2734 = call fastcc i64%t2733(i64 %t2729, i64 4, i64 %t2718, i64 %t2722, i64 %t2728, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t2735 = call i64 @rt_cdr(i64 %t2734)
  %t2736 = call i64 @rt_car(i64 %t2734)
  %t2737 = call i64 @rt_integer_to_char(i64 %t2736)
  %t2738 = call i64 @rt_cons(i64 %t2737, i64 %a1)
  %t2739 = musttail call fastcc i64 @"scheme.base:code_742"(i64 %self, i64 2, i64 %t2735, i64 %t2738, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t2739
else751:
  %t2740 = or i64 %a0, 16
  %t2741 = and i64 %t2740, 7
  %t2742 = icmp eq i64 %t2741, 0
  br i1 %t2742, label %fixfast755, label %fixslow756
fixfast755:
  %t2743 = add i64 %a0, 16
  br label %fixmerge757
fixslow756:
  %t2744 = call i64 @rt_add(i64 %a0, i64 16)
  br label %fixmerge757
fixmerge757:
  %t2745 = phi i64 [ %t2743, %fixfast755 ], [ %t2744, %fixslow756 ]
  %t2746 = load i64, ptr @"scheme.base:rd-str-esc"
  %t2747 = and i64 %t2746, -8
  %t2748 = inttoptr i64 %t2747 to ptr
  %t2749 = load i64, ptr %t2748
  %t2750 = inttoptr i64 %t2749 to ptr
  %t2751 = call fastcc i64%t2750(i64 %t2746, i64 1, i64 %t2705, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t2752 = call i64 @rt_cons(i64 %t2751, i64 %a1)
  %t2753 = musttail call fastcc i64 @"scheme.base:code_742"(i64 %self, i64 2, i64 %t2745, i64 %t2752, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t2753
else743:
  %t2754 = or i64 %a0, 8
  %t2755 = and i64 %t2754, 7
  %t2756 = icmp eq i64 %t2755, 0
  br i1 %t2756, label %fixfast758, label %fixslow759
fixfast758:
  %t2757 = add i64 %a0, 8
  br label %fixmerge760
fixslow759:
  %t2758 = call i64 @rt_add(i64 %a0, i64 8)
  br label %fixmerge760
fixmerge760:
  %t2759 = phi i64 [ %t2757, %fixfast758 ], [ %t2758, %fixslow759 ]
  %t2760 = call i64 @rt_cons(i64 %t2663, i64 %a1)
  %t2761 = musttail call fastcc i64 @"scheme.base:code_742"(i64 %self, i64 2, i64 %t2759, i64 %t2760, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t2761
else730:
  %t2762 = load i64, ptr @"scheme.base:reverse"
  %t2763 = and i64 %t2762, -8
  %t2764 = inttoptr i64 %t2763 to ptr
  %t2765 = load i64, ptr %t2764
  %t2766 = inttoptr i64 %t2765 to ptr
  %t2767 = call fastcc i64%t2766(i64 %t2762, i64 1, i64 %a1, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t2768 = call i64 @rt_list_to_string(i64 %t2767)
  %t2769 = call i64 @rt_cons(i64 %t2768, i64 %a0)
  ret i64 %t2769
}

define fastcc i64 @"scheme.base:code_740"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t2770 = icmp eq i64 %argc, 3
  br i1 %t2770, label %argok762, label %arityerr761
arityerr761:
  call void @rt_arity_error(i64 3, i64 %argc)
  unreachable
argok762:
  %t2771 = call i64 @rt_alloc_words(i64 4)
  %t2772 = inttoptr i64 %t2771 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_742" to i64), ptr %t2772
  %t2773 = or i64 %t2771, 4
  %t2774 = getelementptr i64, ptr %t2772, i64 1
  store i64 %a1, ptr %t2774
  %t2775 = getelementptr i64, ptr %t2772, i64 2
  store i64 %a0, ptr %t2775
  %t2776 = getelementptr i64, ptr %t2772, i64 3
  store i64 %t2773, ptr %t2776
  %t2777 = and i64 %t2773, -8
  %t2778 = inttoptr i64 %t2777 to ptr
  %t2779 = load i64, ptr %t2778
  %t2780 = inttoptr i64 %t2779 to ptr
  %t2781 = musttail call fastcc i64 %t2780(i64 %t2773, i64 2, i64 %a2, i64 2, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t2781
}

define fastcc i64 @"scheme.base:code_783"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t2786 = icmp eq i64 %argc, 3
  br i1 %t2786, label %argok764, label %arityerr763
arityerr763:
  call void @rt_arity_error(i64 3, i64 %argc)
  unreachable
argok764:
  %t2787 = call i64 @rt_string_ref(i64 %a0, i64 %a2)
  %t2788 = call i64 @rt_char_to_integer(i64 %t2787)
  %t2789 = or i64 %t2788, 928
  %t2790 = and i64 %t2789, 7
  %t2791 = icmp eq i64 %t2790, 0
  br i1 %t2791, label %fixfast765, label %fixslow766
fixfast765:
  %t2792 = icmp eq i64 %t2788, 928
  %t2793 = select i1 %t2792, i64 257, i64 1
  br label %fixmerge767
fixslow766:
  %t2794 = call i64 @rt_num_eq(i64 %t2788, i64 928)
  br label %fixmerge767
fixmerge767:
  %t2795 = phi i64 [ %t2793, %fixfast765 ], [ %t2794, %fixslow766 ]
  %t2796 = icmp ne i64 %t2795, 1
  br i1 %t2796, label %then768, label %else769
then768:
  %t2797 = or i64 %a2, 8
  %t2798 = and i64 %t2797, 7
  %t2799 = icmp eq i64 %t2798, 0
  br i1 %t2799, label %fixfast770, label %fixslow771
fixfast770:
  %t2800 = add i64 %a2, 8
  br label %fixmerge772
fixslow771:
  %t2801 = call i64 @rt_add(i64 %a2, i64 8)
  br label %fixmerge772
fixmerge772:
  %t2802 = phi i64 [ %t2800, %fixfast770 ], [ %t2801, %fixslow771 ]
  %t2803 = call i64 @rt_cons(i64 257, i64 %t2802)
  ret i64 %t2803
else769:
  %t2804 = or i64 %t2788, 816
  %t2805 = and i64 %t2804, 7
  %t2806 = icmp eq i64 %t2805, 0
  br i1 %t2806, label %fixfast773, label %fixslow774
fixfast773:
  %t2807 = icmp eq i64 %t2788, 816
  %t2808 = select i1 %t2807, i64 257, i64 1
  br label %fixmerge775
fixslow774:
  %t2809 = call i64 @rt_num_eq(i64 %t2788, i64 816)
  br label %fixmerge775
fixmerge775:
  %t2810 = phi i64 [ %t2808, %fixfast773 ], [ %t2809, %fixslow774 ]
  %t2811 = icmp ne i64 %t2810, 1
  br i1 %t2811, label %then776, label %else777
then776:
  %t2812 = or i64 %a2, 8
  %t2813 = and i64 %t2812, 7
  %t2814 = icmp eq i64 %t2813, 0
  br i1 %t2814, label %fixfast778, label %fixslow779
fixfast778:
  %t2815 = add i64 %a2, 8
  br label %fixmerge780
fixslow779:
  %t2816 = call i64 @rt_add(i64 %a2, i64 8)
  br label %fixmerge780
fixmerge780:
  %t2817 = phi i64 [ %t2815, %fixfast778 ], [ %t2816, %fixslow779 ]
  %t2818 = call i64 @rt_cons(i64 1, i64 %t2817)
  ret i64 %t2818
else777:
  %t2819 = or i64 %t2788, 736
  %t2820 = and i64 %t2819, 7
  %t2821 = icmp eq i64 %t2820, 0
  br i1 %t2821, label %fixfast781, label %fixslow782
fixfast781:
  %t2822 = icmp eq i64 %t2788, 736
  %t2823 = select i1 %t2822, i64 257, i64 1
  br label %fixmerge783
fixslow782:
  %t2824 = call i64 @rt_num_eq(i64 %t2788, i64 736)
  br label %fixmerge783
fixmerge783:
  %t2825 = phi i64 [ %t2823, %fixfast781 ], [ %t2824, %fixslow782 ]
  %t2826 = icmp ne i64 %t2825, 1
  br i1 %t2826, label %then784, label %else785
then784:
  %t2827 = load i64, ptr @"scheme.base:rd-char"
  %t2828 = and i64 %t2827, -8
  %t2829 = inttoptr i64 %t2828 to ptr
  %t2830 = load i64, ptr %t2829
  %t2831 = inttoptr i64 %t2830 to ptr
  %t2832 = musttail call fastcc i64 %t2831(i64 %t2827, i64 3, i64 %a0, i64 %a1, i64 %a2, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t2832
else785:
  %t2833 = or i64 %t2788, 320
  %t2834 = and i64 %t2833, 7
  %t2835 = icmp eq i64 %t2834, 0
  br i1 %t2835, label %fixfast786, label %fixslow787
fixfast786:
  %t2836 = icmp eq i64 %t2788, 320
  %t2837 = select i1 %t2836, i64 257, i64 1
  br label %fixmerge788
fixslow787:
  %t2838 = call i64 @rt_num_eq(i64 %t2788, i64 320)
  br label %fixmerge788
fixmerge788:
  %t2839 = phi i64 [ %t2837, %fixfast786 ], [ %t2838, %fixslow787 ]
  %t2840 = icmp ne i64 %t2839, 1
  br i1 %t2840, label %then789, label %else790
then789:
  %t2841 = or i64 %a2, 8
  %t2842 = and i64 %t2841, 7
  %t2843 = icmp eq i64 %t2842, 0
  br i1 %t2843, label %fixfast791, label %fixslow792
fixfast791:
  %t2844 = add i64 %a2, 8
  br label %fixmerge793
fixslow792:
  %t2845 = call i64 @rt_add(i64 %a2, i64 8)
  br label %fixmerge793
fixmerge793:
  %t2846 = phi i64 [ %t2844, %fixfast791 ], [ %t2845, %fixslow792 ]
  %t2847 = load i64, ptr @"scheme.base:rd-list"
  %t2848 = and i64 %t2847, -8
  %t2849 = inttoptr i64 %t2848 to ptr
  %t2850 = load i64, ptr %t2849
  %t2851 = inttoptr i64 %t2850 to ptr
  %t2852 = call fastcc i64%t2851(i64 %t2847, i64 4, i64 %a0, i64 %a1, i64 %t2846, i64 2, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t2853 = call i64 @rt_car(i64 %t2852)
  %t2854 = load i64, ptr @"scheme.base:list->vector"
  %t2855 = and i64 %t2854, -8
  %t2856 = inttoptr i64 %t2855 to ptr
  %t2857 = load i64, ptr %t2856
  %t2858 = inttoptr i64 %t2857 to ptr
  %t2859 = call fastcc i64%t2858(i64 %t2854, i64 1, i64 %t2853, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t2860 = call i64 @rt_cdr(i64 %t2852)
  %t2861 = call i64 @rt_cons(i64 %t2859, i64 %t2860)
  ret i64 %t2861
else790:
  %t2862 = or i64 %t2788, 936
  %t2863 = and i64 %t2862, 7
  %t2864 = icmp eq i64 %t2863, 0
  br i1 %t2864, label %fixfast794, label %fixslow795
fixfast794:
  %t2865 = icmp eq i64 %t2788, 936
  %t2866 = select i1 %t2865, i64 257, i64 1
  br label %fixmerge796
fixslow795:
  %t2867 = call i64 @rt_num_eq(i64 %t2788, i64 936)
  br label %fixmerge796
fixmerge796:
  %t2868 = phi i64 [ %t2866, %fixfast794 ], [ %t2867, %fixslow795 ]
  %t2869 = icmp ne i64 %t2868, 1
  br i1 %t2869, label %then797, label %else798
then797:
  %t2870 = or i64 %a2, 16
  %t2871 = and i64 %t2870, 7
  %t2872 = icmp eq i64 %t2871, 0
  br i1 %t2872, label %fixfast800, label %fixslow801
fixfast800:
  %t2873 = add i64 %a2, 16
  br label %fixmerge802
fixslow801:
  %t2874 = call i64 @rt_add(i64 %a2, i64 16)
  br label %fixmerge802
fixmerge802:
  %t2875 = phi i64 [ %t2873, %fixfast800 ], [ %t2874, %fixslow801 ]
  %t2876 = or i64 %t2875, %a1
  %t2877 = and i64 %t2876, 7
  %t2878 = icmp eq i64 %t2877, 0
  br i1 %t2878, label %fixfast803, label %fixslow804
fixfast803:
  %t2879 = icmp slt i64 %t2875, %a1
  %t2880 = select i1 %t2879, i64 257, i64 1
  br label %fixmerge805
fixslow804:
  %t2881 = call i64 @rt_lt(i64 %t2875, i64 %a1)
  br label %fixmerge805
fixmerge805:
  %t2882 = phi i64 [ %t2880, %fixfast803 ], [ %t2881, %fixslow804 ]
  %t2883 = icmp ne i64 %t2882, 1
  br i1 %t2883, label %then806, label %else807
then806:
  %t2884 = or i64 %a2, 8
  %t2885 = and i64 %t2884, 7
  %t2886 = icmp eq i64 %t2885, 0
  br i1 %t2886, label %fixfast809, label %fixslow810
fixfast809:
  %t2887 = add i64 %a2, 8
  br label %fixmerge811
fixslow810:
  %t2888 = call i64 @rt_add(i64 %a2, i64 8)
  br label %fixmerge811
fixmerge811:
  %t2889 = phi i64 [ %t2887, %fixfast809 ], [ %t2888, %fixslow810 ]
  %t2890 = call i64 @rt_string_ref(i64 %a0, i64 %t2889)
  %t2891 = call i64 @rt_char_to_integer(i64 %t2890)
  %t2892 = or i64 %t2891, 448
  %t2893 = and i64 %t2892, 7
  %t2894 = icmp eq i64 %t2893, 0
  br i1 %t2894, label %fixfast812, label %fixslow813
fixfast812:
  %t2895 = icmp eq i64 %t2891, 448
  %t2896 = select i1 %t2895, i64 257, i64 1
  br label %fixmerge814
fixslow813:
  %t2897 = call i64 @rt_num_eq(i64 %t2891, i64 448)
  br label %fixmerge814
fixmerge814:
  %t2898 = phi i64 [ %t2896, %fixfast812 ], [ %t2897, %fixslow813 ]
  %t2899 = icmp ne i64 %t2898, 1
  br i1 %t2899, label %then815, label %else816
then815:
  %t2900 = or i64 %a2, 16
  %t2901 = and i64 %t2900, 7
  %t2902 = icmp eq i64 %t2901, 0
  br i1 %t2902, label %fixfast818, label %fixslow819
fixfast818:
  %t2903 = add i64 %a2, 16
  br label %fixmerge820
fixslow819:
  %t2904 = call i64 @rt_add(i64 %a2, i64 16)
  br label %fixmerge820
fixmerge820:
  %t2905 = phi i64 [ %t2903, %fixfast818 ], [ %t2904, %fixslow819 ]
  %t2906 = call i64 @rt_string_ref(i64 %a0, i64 %t2905)
  %t2907 = call i64 @rt_char_to_integer(i64 %t2906)
  %t2908 = or i64 %t2907, 320
  %t2909 = and i64 %t2908, 7
  %t2910 = icmp eq i64 %t2909, 0
  br i1 %t2910, label %fixfast821, label %fixslow822
fixfast821:
  %t2911 = icmp eq i64 %t2907, 320
  %t2912 = select i1 %t2911, i64 257, i64 1
  br label %fixmerge823
fixslow822:
  %t2913 = call i64 @rt_num_eq(i64 %t2907, i64 320)
  br label %fixmerge823
fixmerge823:
  %t2914 = phi i64 [ %t2912, %fixfast821 ], [ %t2913, %fixslow822 ]
  br label %merge817
else816:
  br label %merge817
merge817:
  %t2915 = phi i64 [ %t2914, %fixmerge823 ], [ 1, %else816 ]
  br label %merge808
else807:
  br label %merge808
merge808:
  %t2916 = phi i64 [ %t2915, %merge817 ], [ 1, %else807 ]
  br label %merge799
else798:
  br label %merge799
merge799:
  %t2917 = phi i64 [ %t2916, %merge808 ], [ 1, %else798 ]
  %t2918 = icmp ne i64 %t2917, 1
  br i1 %t2918, label %then824, label %else825
then824:
  %t2919 = or i64 %a2, 24
  %t2920 = and i64 %t2919, 7
  %t2921 = icmp eq i64 %t2920, 0
  br i1 %t2921, label %fixfast826, label %fixslow827
fixfast826:
  %t2922 = add i64 %a2, 24
  br label %fixmerge828
fixslow827:
  %t2923 = call i64 @rt_add(i64 %a2, i64 24)
  br label %fixmerge828
fixmerge828:
  %t2924 = phi i64 [ %t2922, %fixfast826 ], [ %t2923, %fixslow827 ]
  %t2925 = load i64, ptr @"scheme.base:rd-list"
  %t2926 = and i64 %t2925, -8
  %t2927 = inttoptr i64 %t2926 to ptr
  %t2928 = load i64, ptr %t2927
  %t2929 = inttoptr i64 %t2928 to ptr
  %t2930 = call fastcc i64%t2929(i64 %t2925, i64 4, i64 %a0, i64 %a1, i64 %t2924, i64 2, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t2931 = call i64 @rt_car(i64 %t2930)
  %t2932 = load i64, ptr @"scheme.base:list->bytevector"
  %t2933 = and i64 %t2932, -8
  %t2934 = inttoptr i64 %t2933 to ptr
  %t2935 = load i64, ptr %t2934
  %t2936 = inttoptr i64 %t2935 to ptr
  %t2937 = call fastcc i64%t2936(i64 %t2932, i64 1, i64 %t2931, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t2938 = call i64 @rt_cdr(i64 %t2930)
  %t2939 = call i64 @rt_cons(i64 %t2937, i64 %t2938)
  ret i64 %t2939
else825:
  %t2940 = load i64, ptr @"scheme.base:rd-token-end"
  %t2941 = and i64 %t2940, -8
  %t2942 = inttoptr i64 %t2941 to ptr
  %t2943 = load i64, ptr %t2942
  %t2944 = inttoptr i64 %t2943 to ptr
  %t2945 = call fastcc i64%t2944(i64 %t2940, i64 3, i64 %a0, i64 %a1, i64 %a2, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t2946 = call i64 @rt_substring(i64 %a0, i64 %a2, i64 %t2945)
  %t2947 = call i64 @rt_string_to_symbol(i64 %t2946)
  %t2948 = call i64 @rt_cons(i64 %t2947, i64 %t2945)
  ret i64 %t2948
}

define fastcc i64 @"scheme.base:code_786"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t2953 = icmp eq i64 %argc, 1
  br i1 %t2953, label %argok830, label %arityerr829
arityerr829:
  call void @rt_arity_error(i64 1, i64 %argc)
  unreachable
argok830:
  %t2954 = call i64 @rt_make_string(ptr @.str.lit.4, i64 5)
  %t2955 = call i64 @rt_string_eq(i64 %a0, i64 %t2954)
  %t2956 = icmp ne i64 %t2955, 1
  br i1 %t2956, label %then831, label %else832
then831:
  %t2957 = call i64 @rt_integer_to_char(i64 256)
  ret i64 %t2957
else832:
  %t2958 = call i64 @rt_make_string(ptr @.str.lit.5, i64 7)
  %t2959 = call i64 @rt_string_eq(i64 %a0, i64 %t2958)
  %t2960 = icmp ne i64 %t2959, 1
  br i1 %t2960, label %then833, label %else834
then833:
  %t2961 = call i64 @rt_integer_to_char(i64 80)
  ret i64 %t2961
else834:
  %t2962 = call i64 @rt_make_string(ptr @.str.lit.6, i64 3)
  %t2963 = call i64 @rt_string_eq(i64 %a0, i64 %t2962)
  %t2964 = icmp ne i64 %t2963, 1
  br i1 %t2964, label %then835, label %else836
then835:
  %t2965 = call i64 @rt_integer_to_char(i64 72)
  ret i64 %t2965
else836:
  %t2966 = call i64 @rt_make_string(ptr @.str.lit.7, i64 6)
  %t2967 = call i64 @rt_string_eq(i64 %a0, i64 %t2966)
  %t2968 = icmp ne i64 %t2967, 1
  br i1 %t2968, label %then837, label %else838
then837:
  %t2969 = call i64 @rt_integer_to_char(i64 104)
  ret i64 %t2969
else838:
  %t2970 = call i64 @rt_make_string(ptr @.str.lit.8, i64 3)
  %t2971 = call i64 @rt_string_eq(i64 %a0, i64 %t2970)
  %t2972 = icmp ne i64 %t2971, 1
  br i1 %t2972, label %then839, label %else840
then839:
  %t2973 = call i64 @rt_integer_to_char(i64 0)
  ret i64 %t2973
else840:
  %t2974 = call i64 @rt_make_string(ptr @.str.lit.9, i64 4)
  %t2975 = call i64 @rt_string_eq(i64 %a0, i64 %t2974)
  %t2976 = icmp ne i64 %t2975, 1
  br i1 %t2976, label %then841, label %else842
then841:
  %t2977 = call i64 @rt_integer_to_char(i64 0)
  ret i64 %t2977
else842:
  %t2978 = call i64 @rt_make_string(ptr @.str.lit.10, i64 6)
  %t2979 = call i64 @rt_string_eq(i64 %a0, i64 %t2978)
  %t2980 = icmp ne i64 %t2979, 1
  br i1 %t2980, label %then843, label %else844
then843:
  %t2981 = call i64 @rt_integer_to_char(i64 1016)
  ret i64 %t2981
else844:
  %t2982 = call i64 @rt_make_string(ptr @.str.lit.11, i64 7)
  %t2983 = call i64 @rt_string_eq(i64 %a0, i64 %t2982)
  %t2984 = icmp ne i64 %t2983, 1
  br i1 %t2984, label %then845, label %else846
then845:
  %t2985 = call i64 @rt_integer_to_char(i64 216)
  ret i64 %t2985
else846:
  %t2986 = call i64 @rt_make_string(ptr @.str.lit.12, i64 3)
  %t2987 = call i64 @rt_string_eq(i64 %a0, i64 %t2986)
  %t2988 = icmp ne i64 %t2987, 1
  br i1 %t2988, label %then847, label %else848
then847:
  %t2989 = call i64 @rt_integer_to_char(i64 216)
  ret i64 %t2989
else848:
  %t2990 = call i64 @rt_string_ref(i64 %a0, i64 0)
  ret i64 %t2990
}

define fastcc i64 @"scheme.base:code_798"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t2995 = icmp eq i64 %argc, 3
  br i1 %t2995, label %argok850, label %arityerr849
arityerr849:
  call void @rt_arity_error(i64 3, i64 %argc)
  unreachable
argok850:
  %t2996 = or i64 %a2, 8
  %t2997 = and i64 %t2996, 7
  %t2998 = icmp eq i64 %t2997, 0
  br i1 %t2998, label %fixfast851, label %fixslow852
fixfast851:
  %t2999 = add i64 %a2, 8
  br label %fixmerge853
fixslow852:
  %t3000 = call i64 @rt_add(i64 %a2, i64 8)
  br label %fixmerge853
fixmerge853:
  %t3001 = phi i64 [ %t2999, %fixfast851 ], [ %t3000, %fixslow852 ]
  %t3002 = or i64 %t3001, 8
  %t3003 = and i64 %t3002, 7
  %t3004 = icmp eq i64 %t3003, 0
  br i1 %t3004, label %fixfast854, label %fixslow855
fixfast854:
  %t3005 = add i64 %t3001, 8
  br label %fixmerge856
fixslow855:
  %t3006 = call i64 @rt_add(i64 %t3001, i64 8)
  br label %fixmerge856
fixmerge856:
  %t3007 = phi i64 [ %t3005, %fixfast854 ], [ %t3006, %fixslow855 ]
  %t3008 = load i64, ptr @"scheme.base:rd-token-end"
  %t3009 = and i64 %t3008, -8
  %t3010 = inttoptr i64 %t3009 to ptr
  %t3011 = load i64, ptr %t3010
  %t3012 = inttoptr i64 %t3011 to ptr
  %t3013 = call fastcc i64%t3012(i64 %t3008, i64 3, i64 %a0, i64 %a1, i64 %t3007, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t3014 = call i64 @rt_substring(i64 %a0, i64 %t3001, i64 %t3013)
  %t3015 = call i64 @rt_string_length(i64 %t3014)
  %t3016 = or i64 %t3015, 8
  %t3017 = and i64 %t3016, 7
  %t3018 = icmp eq i64 %t3017, 0
  br i1 %t3018, label %fixfast857, label %fixslow858
fixfast857:
  %t3019 = icmp eq i64 %t3015, 8
  %t3020 = select i1 %t3019, i64 257, i64 1
  br label %fixmerge859
fixslow858:
  %t3021 = call i64 @rt_num_eq(i64 %t3015, i64 8)
  br label %fixmerge859
fixmerge859:
  %t3022 = phi i64 [ %t3020, %fixfast857 ], [ %t3021, %fixslow858 ]
  %t3023 = icmp ne i64 %t3022, 1
  br i1 %t3023, label %then860, label %else861
then860:
  %t3024 = call i64 @rt_string_ref(i64 %a0, i64 %t3001)
  %t3025 = call i64 @rt_cons(i64 %t3024, i64 %t3013)
  ret i64 %t3025
else861:
  %t3026 = load i64, ptr @"scheme.base:rd-char-name"
  %t3027 = and i64 %t3026, -8
  %t3028 = inttoptr i64 %t3027 to ptr
  %t3029 = load i64, ptr %t3028
  %t3030 = inttoptr i64 %t3029 to ptr
  %t3031 = call fastcc i64%t3030(i64 %t3026, i64 1, i64 %t3014, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t3032 = call i64 @rt_cons(i64 %t3031, i64 %t3013)
  ret i64 %t3032
}

define fastcc i64 @"scheme.base:code_805"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t3037 = icmp eq i64 %argc, 3
  br i1 %t3037, label %argok863, label %arityerr862
arityerr862:
  call void @rt_arity_error(i64 3, i64 %argc)
  unreachable
argok863:
  %t3038 = load i64, ptr @"scheme.base:rd-skip-ws"
  %t3039 = and i64 %t3038, -8
  %t3040 = inttoptr i64 %t3039 to ptr
  %t3041 = load i64, ptr %t3040
  %t3042 = inttoptr i64 %t3041 to ptr
  %t3043 = call fastcc i64%t3042(i64 %t3038, i64 3, i64 %a0, i64 %a1, i64 %a2, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t3044 = load i64, ptr @"scheme.base:rd-datum"
  %t3045 = and i64 %t3044, -8
  %t3046 = inttoptr i64 %t3045 to ptr
  %t3047 = load i64, ptr %t3046
  %t3048 = inttoptr i64 %t3047 to ptr
  %t3049 = call fastcc i64%t3048(i64 %t3044, i64 3, i64 %a0, i64 %a1, i64 %t3043, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t3050 = call i64 @rt_intern(ptr @.str.sym.13)
  %t3051 = call i64 @rt_car(i64 %t3049)
  %t3052 = load i64, ptr @"scheme.base:list"
  %t3053 = and i64 %t3052, -8
  %t3054 = inttoptr i64 %t3053 to ptr
  %t3055 = load i64, ptr %t3054
  %t3056 = inttoptr i64 %t3055 to ptr
  %t3057 = call fastcc i64%t3056(i64 %t3052, i64 2, i64 %t3050, i64 %t3051, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t3058 = call i64 @rt_cdr(i64 %t3049)
  %t3059 = call i64 @rt_cons(i64 %t3057, i64 %t3058)
  ret i64 %t3059
}

define fastcc i64 @"scheme.base:code_812"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t3064 = icmp eq i64 %argc, 3
  br i1 %t3064, label %argok865, label %arityerr864
arityerr864:
  call void @rt_arity_error(i64 3, i64 %argc)
  unreachable
argok865:
  %t3065 = load i64, ptr @"scheme.base:rd-skip-ws"
  %t3066 = and i64 %t3065, -8
  %t3067 = inttoptr i64 %t3066 to ptr
  %t3068 = load i64, ptr %t3067
  %t3069 = inttoptr i64 %t3068 to ptr
  %t3070 = call fastcc i64%t3069(i64 %t3065, i64 3, i64 %a0, i64 %a1, i64 %a2, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t3071 = load i64, ptr @"scheme.base:rd-datum"
  %t3072 = and i64 %t3071, -8
  %t3073 = inttoptr i64 %t3072 to ptr
  %t3074 = load i64, ptr %t3073
  %t3075 = inttoptr i64 %t3074 to ptr
  %t3076 = call fastcc i64%t3075(i64 %t3071, i64 3, i64 %a0, i64 %a1, i64 %t3070, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t3077 = call i64 @rt_intern(ptr @.str.sym.14)
  %t3078 = call i64 @rt_car(i64 %t3076)
  %t3079 = load i64, ptr @"scheme.base:list"
  %t3080 = and i64 %t3079, -8
  %t3081 = inttoptr i64 %t3080 to ptr
  %t3082 = load i64, ptr %t3081
  %t3083 = inttoptr i64 %t3082 to ptr
  %t3084 = call fastcc i64%t3083(i64 %t3079, i64 2, i64 %t3077, i64 %t3078, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t3085 = call i64 @rt_cdr(i64 %t3076)
  %t3086 = call i64 @rt_cons(i64 %t3084, i64 %t3085)
  ret i64 %t3086
}

define fastcc i64 @"scheme.base:code_829"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t3091 = icmp eq i64 %argc, 3
  br i1 %t3091, label %argok867, label %arityerr866
arityerr866:
  call void @rt_arity_error(i64 3, i64 %argc)
  unreachable
argok867:
  %t3092 = or i64 %a2, %a1
  %t3093 = and i64 %t3092, 7
  %t3094 = icmp eq i64 %t3093, 0
  br i1 %t3094, label %fixfast868, label %fixslow869
fixfast868:
  %t3095 = icmp slt i64 %a2, %a1
  %t3096 = select i1 %t3095, i64 257, i64 1
  br label %fixmerge870
fixslow869:
  %t3097 = call i64 @rt_lt(i64 %a2, i64 %a1)
  br label %fixmerge870
fixmerge870:
  %t3098 = phi i64 [ %t3096, %fixfast868 ], [ %t3097, %fixslow869 ]
  %t3099 = icmp ne i64 %t3098, 1
  br i1 %t3099, label %then871, label %else872
then871:
  %t3100 = call i64 @rt_string_ref(i64 %a0, i64 %a2)
  %t3101 = call i64 @rt_char_to_integer(i64 %t3100)
  %t3102 = or i64 %t3101, 512
  %t3103 = and i64 %t3102, 7
  %t3104 = icmp eq i64 %t3103, 0
  br i1 %t3104, label %fixfast874, label %fixslow875
fixfast874:
  %t3105 = icmp eq i64 %t3101, 512
  %t3106 = select i1 %t3105, i64 257, i64 1
  br label %fixmerge876
fixslow875:
  %t3107 = call i64 @rt_num_eq(i64 %t3101, i64 512)
  br label %fixmerge876
fixmerge876:
  %t3108 = phi i64 [ %t3106, %fixfast874 ], [ %t3107, %fixslow875 ]
  br label %merge873
else872:
  br label %merge873
merge873:
  %t3109 = phi i64 [ %t3108, %fixmerge876 ], [ 1, %else872 ]
  %t3110 = icmp ne i64 %t3109, 1
  br i1 %t3110, label %then877, label %else878
then877:
  %t3111 = or i64 %a2, 8
  %t3112 = and i64 %t3111, 7
  %t3113 = icmp eq i64 %t3112, 0
  br i1 %t3113, label %fixfast879, label %fixslow880
fixfast879:
  %t3114 = add i64 %a2, 8
  br label %fixmerge881
fixslow880:
  %t3115 = call i64 @rt_add(i64 %a2, i64 8)
  br label %fixmerge881
fixmerge881:
  %t3116 = phi i64 [ %t3114, %fixfast879 ], [ %t3115, %fixslow880 ]
  %t3117 = load i64, ptr @"scheme.base:rd-skip-ws"
  %t3118 = and i64 %t3117, -8
  %t3119 = inttoptr i64 %t3118 to ptr
  %t3120 = load i64, ptr %t3119
  %t3121 = inttoptr i64 %t3120 to ptr
  %t3122 = call fastcc i64%t3121(i64 %t3117, i64 3, i64 %a0, i64 %a1, i64 %t3116, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t3123 = load i64, ptr @"scheme.base:rd-datum"
  %t3124 = and i64 %t3123, -8
  %t3125 = inttoptr i64 %t3124 to ptr
  %t3126 = load i64, ptr %t3125
  %t3127 = inttoptr i64 %t3126 to ptr
  %t3128 = call fastcc i64%t3127(i64 %t3123, i64 3, i64 %a0, i64 %a1, i64 %t3122, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t3129 = call i64 @rt_intern(ptr @.str.sym.15)
  %t3130 = call i64 @rt_car(i64 %t3128)
  %t3131 = load i64, ptr @"scheme.base:list"
  %t3132 = and i64 %t3131, -8
  %t3133 = inttoptr i64 %t3132 to ptr
  %t3134 = load i64, ptr %t3133
  %t3135 = inttoptr i64 %t3134 to ptr
  %t3136 = call fastcc i64%t3135(i64 %t3131, i64 2, i64 %t3129, i64 %t3130, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t3137 = call i64 @rt_cdr(i64 %t3128)
  %t3138 = call i64 @rt_cons(i64 %t3136, i64 %t3137)
  ret i64 %t3138
else878:
  %t3139 = load i64, ptr @"scheme.base:rd-skip-ws"
  %t3140 = and i64 %t3139, -8
  %t3141 = inttoptr i64 %t3140 to ptr
  %t3142 = load i64, ptr %t3141
  %t3143 = inttoptr i64 %t3142 to ptr
  %t3144 = call fastcc i64%t3143(i64 %t3139, i64 3, i64 %a0, i64 %a1, i64 %a2, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t3145 = load i64, ptr @"scheme.base:rd-datum"
  %t3146 = and i64 %t3145, -8
  %t3147 = inttoptr i64 %t3146 to ptr
  %t3148 = load i64, ptr %t3147
  %t3149 = inttoptr i64 %t3148 to ptr
  %t3150 = call fastcc i64%t3149(i64 %t3145, i64 3, i64 %a0, i64 %a1, i64 %t3144, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t3151 = call i64 @rt_intern(ptr @.str.sym.16)
  %t3152 = call i64 @rt_car(i64 %t3150)
  %t3153 = load i64, ptr @"scheme.base:list"
  %t3154 = and i64 %t3153, -8
  %t3155 = inttoptr i64 %t3154 to ptr
  %t3156 = load i64, ptr %t3155
  %t3157 = inttoptr i64 %t3156 to ptr
  %t3158 = call fastcc i64%t3157(i64 %t3153, i64 2, i64 %t3151, i64 %t3152, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t3159 = call i64 @rt_cdr(i64 %t3150)
  %t3160 = call i64 @rt_cons(i64 %t3158, i64 %t3159)
  ret i64 %t3160
}

define fastcc i64 @"scheme.base:code_842"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t3165 = icmp eq i64 %argc, 3
  br i1 %t3165, label %argok883, label %arityerr882
arityerr882:
  call void @rt_arity_error(i64 3, i64 %argc)
  unreachable
argok883:
  %t3166 = call i64 @rt_string_ref(i64 %a0, i64 %a2)
  %t3167 = call i64 @rt_char_to_integer(i64 %t3166)
  %t3168 = or i64 %t3167, 368
  %t3169 = and i64 %t3168, 7
  %t3170 = icmp eq i64 %t3169, 0
  br i1 %t3170, label %fixfast884, label %fixslow885
fixfast884:
  %t3171 = icmp eq i64 %t3167, 368
  %t3172 = select i1 %t3171, i64 257, i64 1
  br label %fixmerge886
fixslow885:
  %t3173 = call i64 @rt_num_eq(i64 %t3167, i64 368)
  br label %fixmerge886
fixmerge886:
  %t3174 = phi i64 [ %t3172, %fixfast884 ], [ %t3173, %fixslow885 ]
  %t3175 = icmp ne i64 %t3174, 1
  br i1 %t3175, label %then887, label %else888
then887:
  %t3176 = or i64 %a2, 8
  %t3177 = and i64 %t3176, 7
  %t3178 = icmp eq i64 %t3177, 0
  br i1 %t3178, label %fixfast889, label %fixslow890
fixfast889:
  %t3179 = add i64 %a2, 8
  br label %fixmerge891
fixslow890:
  %t3180 = call i64 @rt_add(i64 %a2, i64 8)
  br label %fixmerge891
fixmerge891:
  %t3181 = phi i64 [ %t3179, %fixfast889 ], [ %t3180, %fixslow890 ]
  %t3182 = load i64, ptr @"scheme.base:rd-token-end"
  %t3183 = and i64 %t3182, -8
  %t3184 = inttoptr i64 %t3183 to ptr
  %t3185 = load i64, ptr %t3184
  %t3186 = inttoptr i64 %t3185 to ptr
  %t3187 = call fastcc i64%t3186(i64 %t3182, i64 3, i64 %a0, i64 %a1, i64 %t3181, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t3188 = or i64 %a2, 8
  %t3189 = and i64 %t3188, 7
  %t3190 = icmp eq i64 %t3189, 0
  br i1 %t3190, label %fixfast892, label %fixslow893
fixfast892:
  %t3191 = add i64 %a2, 8
  br label %fixmerge894
fixslow893:
  %t3192 = call i64 @rt_add(i64 %a2, i64 8)
  br label %fixmerge894
fixmerge894:
  %t3193 = phi i64 [ %t3191, %fixfast892 ], [ %t3192, %fixslow893 ]
  %t3194 = or i64 %t3187, %t3193
  %t3195 = and i64 %t3194, 7
  %t3196 = icmp eq i64 %t3195, 0
  br i1 %t3196, label %fixfast895, label %fixslow896
fixfast895:
  %t3197 = icmp eq i64 %t3187, %t3193
  %t3198 = select i1 %t3197, i64 257, i64 1
  br label %fixmerge897
fixslow896:
  %t3199 = call i64 @rt_num_eq(i64 %t3187, i64 %t3193)
  br label %fixmerge897
fixmerge897:
  %t3200 = phi i64 [ %t3198, %fixfast895 ], [ %t3199, %fixslow896 ]
  ret i64 %t3200
else888:
  ret i64 1
}

define fastcc i64 @"scheme.base:code_846"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t3205 = icmp eq i64 %argc, 2
  br i1 %t3205, label %argok899, label %arityerr898
arityerr898:
  call void @rt_arity_error(i64 2, i64 %argc)
  unreachable
argok899:
  %t3206 = call i64 @rt_null_p(i64 %a0)
  %t3207 = icmp ne i64 %t3206, 1
  br i1 %t3207, label %then900, label %else901
then900:
  ret i64 %a1
else901:
  %t3208 = call i64 @rt_cdr(i64 %a0)
  %t3209 = call i64 @rt_car(i64 %a0)
  %t3210 = call i64 @rt_cons(i64 %t3209, i64 %a1)
  %t3211 = load i64, ptr @"scheme.base:rd-append-reverse"
  %t3212 = and i64 %t3211, -8
  %t3213 = inttoptr i64 %t3212 to ptr
  %t3214 = load i64, ptr %t3213
  %t3215 = inttoptr i64 %t3214 to ptr
  %t3216 = musttail call fastcc i64 %t3215(i64 %t3211, i64 2, i64 %t3208, i64 %t3210, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t3216
}

define fastcc i64 @"scheme.base:code_871"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t3221 = icmp eq i64 %argc, 4
  br i1 %t3221, label %argok903, label %arityerr902
arityerr902:
  call void @rt_arity_error(i64 4, i64 %argc)
  unreachable
argok903:
  %t3222 = load i64, ptr @"scheme.base:rd-skip-ws"
  %t3223 = and i64 %t3222, -8
  %t3224 = inttoptr i64 %t3223 to ptr
  %t3225 = load i64, ptr %t3224
  %t3226 = inttoptr i64 %t3225 to ptr
  %t3227 = call fastcc i64%t3226(i64 %t3222, i64 3, i64 %a0, i64 %a1, i64 %a2, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t3228 = or i64 %t3227, %a1
  %t3229 = and i64 %t3228, 7
  %t3230 = icmp eq i64 %t3229, 0
  br i1 %t3230, label %fixfast904, label %fixslow905
fixfast904:
  %t3231 = icmp slt i64 %t3227, %a1
  %t3232 = select i1 %t3231, i64 257, i64 1
  br label %fixmerge906
fixslow905:
  %t3233 = call i64 @rt_lt(i64 %t3227, i64 %a1)
  br label %fixmerge906
fixmerge906:
  %t3234 = phi i64 [ %t3232, %fixfast904 ], [ %t3233, %fixslow905 ]
  %t3235 = icmp ne i64 %t3234, 1
  br i1 %t3235, label %then907, label %else908
then907:
  %t3236 = call i64 @rt_string_ref(i64 %a0, i64 %t3227)
  %t3237 = call i64 @rt_char_to_integer(i64 %t3236)
  %t3238 = or i64 %t3237, 328
  %t3239 = and i64 %t3238, 7
  %t3240 = icmp eq i64 %t3239, 0
  br i1 %t3240, label %fixfast909, label %fixslow910
fixfast909:
  %t3241 = icmp eq i64 %t3237, 328
  %t3242 = select i1 %t3241, i64 257, i64 1
  br label %fixmerge911
fixslow910:
  %t3243 = call i64 @rt_num_eq(i64 %t3237, i64 328)
  br label %fixmerge911
fixmerge911:
  %t3244 = phi i64 [ %t3242, %fixfast909 ], [ %t3243, %fixslow910 ]
  %t3245 = icmp ne i64 %t3244, 1
  br i1 %t3245, label %then912, label %else913
then912:
  br label %merge914
else913:
  %t3246 = or i64 %t3237, 744
  %t3247 = and i64 %t3246, 7
  %t3248 = icmp eq i64 %t3247, 0
  br i1 %t3248, label %fixfast915, label %fixslow916
fixfast915:
  %t3249 = icmp eq i64 %t3237, 744
  %t3250 = select i1 %t3249, i64 257, i64 1
  br label %fixmerge917
fixslow916:
  %t3251 = call i64 @rt_num_eq(i64 %t3237, i64 744)
  br label %fixmerge917
fixmerge917:
  %t3252 = phi i64 [ %t3250, %fixfast915 ], [ %t3251, %fixslow916 ]
  br label %merge914
merge914:
  %t3253 = phi i64 [ %t3244, %then912 ], [ %t3252, %fixmerge917 ]
  %t3254 = icmp ne i64 %t3253, 1
  br i1 %t3254, label %then918, label %else919
then918:
  %t3255 = load i64, ptr @"scheme.base:reverse"
  %t3256 = and i64 %t3255, -8
  %t3257 = inttoptr i64 %t3256 to ptr
  %t3258 = load i64, ptr %t3257
  %t3259 = inttoptr i64 %t3258 to ptr
  %t3260 = call fastcc i64%t3259(i64 %t3255, i64 1, i64 %a3, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t3261 = or i64 %t3227, 8
  %t3262 = and i64 %t3261, 7
  %t3263 = icmp eq i64 %t3262, 0
  br i1 %t3263, label %fixfast920, label %fixslow921
fixfast920:
  %t3264 = add i64 %t3227, 8
  br label %fixmerge922
fixslow921:
  %t3265 = call i64 @rt_add(i64 %t3227, i64 8)
  br label %fixmerge922
fixmerge922:
  %t3266 = phi i64 [ %t3264, %fixfast920 ], [ %t3265, %fixslow921 ]
  %t3267 = call i64 @rt_cons(i64 %t3260, i64 %t3266)
  ret i64 %t3267
else919:
  %t3268 = load i64, ptr @"scheme.base:rd-dot?"
  %t3269 = and i64 %t3268, -8
  %t3270 = inttoptr i64 %t3269 to ptr
  %t3271 = load i64, ptr %t3270
  %t3272 = inttoptr i64 %t3271 to ptr
  %t3273 = call fastcc i64%t3272(i64 %t3268, i64 3, i64 %a0, i64 %a1, i64 %t3227, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t3274 = icmp ne i64 %t3273, 1
  br i1 %t3274, label %then923, label %else924
then923:
  %t3275 = or i64 %t3227, 8
  %t3276 = and i64 %t3275, 7
  %t3277 = icmp eq i64 %t3276, 0
  br i1 %t3277, label %fixfast925, label %fixslow926
fixfast925:
  %t3278 = add i64 %t3227, 8
  br label %fixmerge927
fixslow926:
  %t3279 = call i64 @rt_add(i64 %t3227, i64 8)
  br label %fixmerge927
fixmerge927:
  %t3280 = phi i64 [ %t3278, %fixfast925 ], [ %t3279, %fixslow926 ]
  %t3281 = load i64, ptr @"scheme.base:rd-skip-ws"
  %t3282 = and i64 %t3281, -8
  %t3283 = inttoptr i64 %t3282 to ptr
  %t3284 = load i64, ptr %t3283
  %t3285 = inttoptr i64 %t3284 to ptr
  %t3286 = call fastcc i64%t3285(i64 %t3281, i64 3, i64 %a0, i64 %a1, i64 %t3280, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t3287 = load i64, ptr @"scheme.base:rd-datum"
  %t3288 = and i64 %t3287, -8
  %t3289 = inttoptr i64 %t3288 to ptr
  %t3290 = load i64, ptr %t3289
  %t3291 = inttoptr i64 %t3290 to ptr
  %t3292 = call fastcc i64%t3291(i64 %t3287, i64 3, i64 %a0, i64 %a1, i64 %t3286, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t3293 = call i64 @rt_cdr(i64 %t3292)
  %t3294 = load i64, ptr @"scheme.base:rd-skip-ws"
  %t3295 = and i64 %t3294, -8
  %t3296 = inttoptr i64 %t3295 to ptr
  %t3297 = load i64, ptr %t3296
  %t3298 = inttoptr i64 %t3297 to ptr
  %t3299 = call fastcc i64%t3298(i64 %t3294, i64 3, i64 %a0, i64 %a1, i64 %t3293, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t3300 = call i64 @rt_car(i64 %t3292)
  %t3301 = load i64, ptr @"scheme.base:rd-append-reverse"
  %t3302 = and i64 %t3301, -8
  %t3303 = inttoptr i64 %t3302 to ptr
  %t3304 = load i64, ptr %t3303
  %t3305 = inttoptr i64 %t3304 to ptr
  %t3306 = call fastcc i64%t3305(i64 %t3301, i64 2, i64 %a3, i64 %t3300, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t3307 = or i64 %t3299, 8
  %t3308 = and i64 %t3307, 7
  %t3309 = icmp eq i64 %t3308, 0
  br i1 %t3309, label %fixfast928, label %fixslow929
fixfast928:
  %t3310 = add i64 %t3299, 8
  br label %fixmerge930
fixslow929:
  %t3311 = call i64 @rt_add(i64 %t3299, i64 8)
  br label %fixmerge930
fixmerge930:
  %t3312 = phi i64 [ %t3310, %fixfast928 ], [ %t3311, %fixslow929 ]
  %t3313 = call i64 @rt_cons(i64 %t3306, i64 %t3312)
  ret i64 %t3313
else924:
  %t3314 = load i64, ptr @"scheme.base:rd-datum"
  %t3315 = and i64 %t3314, -8
  %t3316 = inttoptr i64 %t3315 to ptr
  %t3317 = load i64, ptr %t3316
  %t3318 = inttoptr i64 %t3317 to ptr
  %t3319 = call fastcc i64%t3318(i64 %t3314, i64 3, i64 %a0, i64 %a1, i64 %t3227, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t3320 = call i64 @rt_cdr(i64 %t3319)
  %t3321 = call i64 @rt_car(i64 %t3319)
  %t3322 = call i64 @rt_cons(i64 %t3321, i64 %a3)
  %t3323 = load i64, ptr @"scheme.base:rd-list"
  %t3324 = and i64 %t3323, -8
  %t3325 = inttoptr i64 %t3324 to ptr
  %t3326 = load i64, ptr %t3325
  %t3327 = inttoptr i64 %t3326 to ptr
  %t3328 = musttail call fastcc i64 %t3327(i64 %t3323, i64 4, i64 %a0, i64 %a1, i64 %t3320, i64 %t3322, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t3328
else908:
  %t3329 = load i64, ptr @"scheme.base:reverse"
  %t3330 = and i64 %t3329, -8
  %t3331 = inttoptr i64 %t3330 to ptr
  %t3332 = load i64, ptr %t3331
  %t3333 = inttoptr i64 %t3332 to ptr
  %t3334 = call fastcc i64%t3333(i64 %t3329, i64 1, i64 %a3, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t3335 = call i64 @rt_cons(i64 %t3334, i64 %t3227)
  ret i64 %t3335
}

define fastcc i64 @"scheme.base:code_905"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t3340 = icmp eq i64 %argc, 3
  br i1 %t3340, label %argok932, label %arityerr931
arityerr931:
  call void @rt_arity_error(i64 3, i64 %argc)
  unreachable
argok932:
  %t3341 = call i64 @rt_string_ref(i64 %a0, i64 %a2)
  %t3342 = call i64 @rt_char_to_integer(i64 %t3341)
  %t3343 = or i64 %t3342, 320
  %t3344 = and i64 %t3343, 7
  %t3345 = icmp eq i64 %t3344, 0
  br i1 %t3345, label %fixfast933, label %fixslow934
fixfast933:
  %t3346 = icmp eq i64 %t3342, 320
  %t3347 = select i1 %t3346, i64 257, i64 1
  br label %fixmerge935
fixslow934:
  %t3348 = call i64 @rt_num_eq(i64 %t3342, i64 320)
  br label %fixmerge935
fixmerge935:
  %t3349 = phi i64 [ %t3347, %fixfast933 ], [ %t3348, %fixslow934 ]
  %t3350 = icmp ne i64 %t3349, 1
  br i1 %t3350, label %then936, label %else937
then936:
  %t3351 = or i64 %a2, 8
  %t3352 = and i64 %t3351, 7
  %t3353 = icmp eq i64 %t3352, 0
  br i1 %t3353, label %fixfast938, label %fixslow939
fixfast938:
  %t3354 = add i64 %a2, 8
  br label %fixmerge940
fixslow939:
  %t3355 = call i64 @rt_add(i64 %a2, i64 8)
  br label %fixmerge940
fixmerge940:
  %t3356 = phi i64 [ %t3354, %fixfast938 ], [ %t3355, %fixslow939 ]
  %t3357 = load i64, ptr @"scheme.base:rd-list"
  %t3358 = and i64 %t3357, -8
  %t3359 = inttoptr i64 %t3358 to ptr
  %t3360 = load i64, ptr %t3359
  %t3361 = inttoptr i64 %t3360 to ptr
  %t3362 = musttail call fastcc i64 %t3361(i64 %t3357, i64 4, i64 %a0, i64 %a1, i64 %t3356, i64 2, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t3362
else937:
  %t3363 = or i64 %t3342, 728
  %t3364 = and i64 %t3363, 7
  %t3365 = icmp eq i64 %t3364, 0
  br i1 %t3365, label %fixfast941, label %fixslow942
fixfast941:
  %t3366 = icmp eq i64 %t3342, 728
  %t3367 = select i1 %t3366, i64 257, i64 1
  br label %fixmerge943
fixslow942:
  %t3368 = call i64 @rt_num_eq(i64 %t3342, i64 728)
  br label %fixmerge943
fixmerge943:
  %t3369 = phi i64 [ %t3367, %fixfast941 ], [ %t3368, %fixslow942 ]
  %t3370 = icmp ne i64 %t3369, 1
  br i1 %t3370, label %then944, label %else945
then944:
  %t3371 = or i64 %a2, 8
  %t3372 = and i64 %t3371, 7
  %t3373 = icmp eq i64 %t3372, 0
  br i1 %t3373, label %fixfast946, label %fixslow947
fixfast946:
  %t3374 = add i64 %a2, 8
  br label %fixmerge948
fixslow947:
  %t3375 = call i64 @rt_add(i64 %a2, i64 8)
  br label %fixmerge948
fixmerge948:
  %t3376 = phi i64 [ %t3374, %fixfast946 ], [ %t3375, %fixslow947 ]
  %t3377 = load i64, ptr @"scheme.base:rd-list"
  %t3378 = and i64 %t3377, -8
  %t3379 = inttoptr i64 %t3378 to ptr
  %t3380 = load i64, ptr %t3379
  %t3381 = inttoptr i64 %t3380 to ptr
  %t3382 = musttail call fastcc i64 %t3381(i64 %t3377, i64 4, i64 %a0, i64 %a1, i64 %t3376, i64 2, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t3382
else945:
  %t3383 = or i64 %t3342, 312
  %t3384 = and i64 %t3383, 7
  %t3385 = icmp eq i64 %t3384, 0
  br i1 %t3385, label %fixfast949, label %fixslow950
fixfast949:
  %t3386 = icmp eq i64 %t3342, 312
  %t3387 = select i1 %t3386, i64 257, i64 1
  br label %fixmerge951
fixslow950:
  %t3388 = call i64 @rt_num_eq(i64 %t3342, i64 312)
  br label %fixmerge951
fixmerge951:
  %t3389 = phi i64 [ %t3387, %fixfast949 ], [ %t3388, %fixslow950 ]
  %t3390 = icmp ne i64 %t3389, 1
  br i1 %t3390, label %then952, label %else953
then952:
  %t3391 = or i64 %a2, 8
  %t3392 = and i64 %t3391, 7
  %t3393 = icmp eq i64 %t3392, 0
  br i1 %t3393, label %fixfast954, label %fixslow955
fixfast954:
  %t3394 = add i64 %a2, 8
  br label %fixmerge956
fixslow955:
  %t3395 = call i64 @rt_add(i64 %a2, i64 8)
  br label %fixmerge956
fixmerge956:
  %t3396 = phi i64 [ %t3394, %fixfast954 ], [ %t3395, %fixslow955 ]
  %t3397 = load i64, ptr @"scheme.base:rd-quote"
  %t3398 = and i64 %t3397, -8
  %t3399 = inttoptr i64 %t3398 to ptr
  %t3400 = load i64, ptr %t3399
  %t3401 = inttoptr i64 %t3400 to ptr
  %t3402 = musttail call fastcc i64 %t3401(i64 %t3397, i64 3, i64 %a0, i64 %a1, i64 %t3396, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t3402
else953:
  %t3403 = or i64 %t3342, 768
  %t3404 = and i64 %t3403, 7
  %t3405 = icmp eq i64 %t3404, 0
  br i1 %t3405, label %fixfast957, label %fixslow958
fixfast957:
  %t3406 = icmp eq i64 %t3342, 768
  %t3407 = select i1 %t3406, i64 257, i64 1
  br label %fixmerge959
fixslow958:
  %t3408 = call i64 @rt_num_eq(i64 %t3342, i64 768)
  br label %fixmerge959
fixmerge959:
  %t3409 = phi i64 [ %t3407, %fixfast957 ], [ %t3408, %fixslow958 ]
  %t3410 = icmp ne i64 %t3409, 1
  br i1 %t3410, label %then960, label %else961
then960:
  %t3411 = or i64 %a2, 8
  %t3412 = and i64 %t3411, 7
  %t3413 = icmp eq i64 %t3412, 0
  br i1 %t3413, label %fixfast962, label %fixslow963
fixfast962:
  %t3414 = add i64 %a2, 8
  br label %fixmerge964
fixslow963:
  %t3415 = call i64 @rt_add(i64 %a2, i64 8)
  br label %fixmerge964
fixmerge964:
  %t3416 = phi i64 [ %t3414, %fixfast962 ], [ %t3415, %fixslow963 ]
  %t3417 = load i64, ptr @"scheme.base:rd-quasi"
  %t3418 = and i64 %t3417, -8
  %t3419 = inttoptr i64 %t3418 to ptr
  %t3420 = load i64, ptr %t3419
  %t3421 = inttoptr i64 %t3420 to ptr
  %t3422 = musttail call fastcc i64 %t3421(i64 %t3417, i64 3, i64 %a0, i64 %a1, i64 %t3416, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t3422
else961:
  %t3423 = or i64 %t3342, 352
  %t3424 = and i64 %t3423, 7
  %t3425 = icmp eq i64 %t3424, 0
  br i1 %t3425, label %fixfast965, label %fixslow966
fixfast965:
  %t3426 = icmp eq i64 %t3342, 352
  %t3427 = select i1 %t3426, i64 257, i64 1
  br label %fixmerge967
fixslow966:
  %t3428 = call i64 @rt_num_eq(i64 %t3342, i64 352)
  br label %fixmerge967
fixmerge967:
  %t3429 = phi i64 [ %t3427, %fixfast965 ], [ %t3428, %fixslow966 ]
  %t3430 = icmp ne i64 %t3429, 1
  br i1 %t3430, label %then968, label %else969
then968:
  %t3431 = or i64 %a2, 8
  %t3432 = and i64 %t3431, 7
  %t3433 = icmp eq i64 %t3432, 0
  br i1 %t3433, label %fixfast970, label %fixslow971
fixfast970:
  %t3434 = add i64 %a2, 8
  br label %fixmerge972
fixslow971:
  %t3435 = call i64 @rt_add(i64 %a2, i64 8)
  br label %fixmerge972
fixmerge972:
  %t3436 = phi i64 [ %t3434, %fixfast970 ], [ %t3435, %fixslow971 ]
  %t3437 = load i64, ptr @"scheme.base:rd-unquote"
  %t3438 = and i64 %t3437, -8
  %t3439 = inttoptr i64 %t3438 to ptr
  %t3440 = load i64, ptr %t3439
  %t3441 = inttoptr i64 %t3440 to ptr
  %t3442 = musttail call fastcc i64 %t3441(i64 %t3437, i64 3, i64 %a0, i64 %a1, i64 %t3436, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t3442
else969:
  %t3443 = or i64 %t3342, 272
  %t3444 = and i64 %t3443, 7
  %t3445 = icmp eq i64 %t3444, 0
  br i1 %t3445, label %fixfast973, label %fixslow974
fixfast973:
  %t3446 = icmp eq i64 %t3342, 272
  %t3447 = select i1 %t3446, i64 257, i64 1
  br label %fixmerge975
fixslow974:
  %t3448 = call i64 @rt_num_eq(i64 %t3342, i64 272)
  br label %fixmerge975
fixmerge975:
  %t3449 = phi i64 [ %t3447, %fixfast973 ], [ %t3448, %fixslow974 ]
  %t3450 = icmp ne i64 %t3449, 1
  br i1 %t3450, label %then976, label %else977
then976:
  %t3451 = or i64 %a2, 8
  %t3452 = and i64 %t3451, 7
  %t3453 = icmp eq i64 %t3452, 0
  br i1 %t3453, label %fixfast978, label %fixslow979
fixfast978:
  %t3454 = add i64 %a2, 8
  br label %fixmerge980
fixslow979:
  %t3455 = call i64 @rt_add(i64 %a2, i64 8)
  br label %fixmerge980
fixmerge980:
  %t3456 = phi i64 [ %t3454, %fixfast978 ], [ %t3455, %fixslow979 ]
  %t3457 = load i64, ptr @"scheme.base:rd-string"
  %t3458 = and i64 %t3457, -8
  %t3459 = inttoptr i64 %t3458 to ptr
  %t3460 = load i64, ptr %t3459
  %t3461 = inttoptr i64 %t3460 to ptr
  %t3462 = musttail call fastcc i64 %t3461(i64 %t3457, i64 3, i64 %a0, i64 %a1, i64 %t3456, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t3462
else977:
  %t3463 = or i64 %t3342, 280
  %t3464 = and i64 %t3463, 7
  %t3465 = icmp eq i64 %t3464, 0
  br i1 %t3465, label %fixfast981, label %fixslow982
fixfast981:
  %t3466 = icmp eq i64 %t3342, 280
  %t3467 = select i1 %t3466, i64 257, i64 1
  br label %fixmerge983
fixslow982:
  %t3468 = call i64 @rt_num_eq(i64 %t3342, i64 280)
  br label %fixmerge983
fixmerge983:
  %t3469 = phi i64 [ %t3467, %fixfast981 ], [ %t3468, %fixslow982 ]
  %t3470 = icmp ne i64 %t3469, 1
  br i1 %t3470, label %then984, label %else985
then984:
  %t3471 = or i64 %a2, 8
  %t3472 = and i64 %t3471, 7
  %t3473 = icmp eq i64 %t3472, 0
  br i1 %t3473, label %fixfast986, label %fixslow987
fixfast986:
  %t3474 = add i64 %a2, 8
  br label %fixmerge988
fixslow987:
  %t3475 = call i64 @rt_add(i64 %a2, i64 8)
  br label %fixmerge988
fixmerge988:
  %t3476 = phi i64 [ %t3474, %fixfast986 ], [ %t3475, %fixslow987 ]
  %t3477 = load i64, ptr @"scheme.base:rd-hash"
  %t3478 = and i64 %t3477, -8
  %t3479 = inttoptr i64 %t3478 to ptr
  %t3480 = load i64, ptr %t3479
  %t3481 = inttoptr i64 %t3480 to ptr
  %t3482 = musttail call fastcc i64 %t3481(i64 %t3477, i64 3, i64 %a0, i64 %a1, i64 %t3476, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t3482
else985:
  %t3483 = load i64, ptr @"scheme.base:rd-atom"
  %t3484 = and i64 %t3483, -8
  %t3485 = inttoptr i64 %t3484 to ptr
  %t3486 = load i64, ptr %t3485
  %t3487 = inttoptr i64 %t3486 to ptr
  %t3488 = musttail call fastcc i64 %t3487(i64 %t3483, i64 3, i64 %a0, i64 %a1, i64 %a2, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t3488
}

define fastcc i64 @"scheme.base:code_909"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t3493 = icmp eq i64 %argc, 1
  br i1 %t3493, label %argok990, label %arityerr989
arityerr989:
  call void @rt_arity_error(i64 1, i64 %argc)
  unreachable
argok990:
  %t3494 = call i64 @rt_string_length(i64 %a0)
  %t3495 = load i64, ptr @"scheme.base:rd-skip-ws"
  %t3496 = and i64 %t3495, -8
  %t3497 = inttoptr i64 %t3496 to ptr
  %t3498 = load i64, ptr %t3497
  %t3499 = inttoptr i64 %t3498 to ptr
  %t3500 = call fastcc i64%t3499(i64 %t3495, i64 3, i64 %a0, i64 %t3494, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t3501 = load i64, ptr @"scheme.base:rd-datum"
  %t3502 = and i64 %t3501, -8
  %t3503 = inttoptr i64 %t3502 to ptr
  %t3504 = load i64, ptr %t3503
  %t3505 = inttoptr i64 %t3504 to ptr
  %t3506 = call fastcc i64%t3505(i64 %t3501, i64 3, i64 %a0, i64 %t3494, i64 %t3500, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t3507 = call i64 @rt_car(i64 %t3506)
  ret i64 %t3507
}

define fastcc i64 @"scheme.base:code_923"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t3512 = icmp eq i64 %argc, 2
  br i1 %t3512, label %argok992, label %arityerr991
arityerr991:
  call void @rt_arity_error(i64 2, i64 %argc)
  unreachable
argok992:
  %t3513 = and i64 %self, -8
  %t3514 = inttoptr i64 %t3513 to ptr
  %t3515 = getelementptr i64, ptr %t3514, i64 1
  %t3516 = load i64, ptr %t3515
  %t3517 = or i64 %a0, %t3516
  %t3518 = and i64 %t3517, 7
  %t3519 = icmp eq i64 %t3518, 0
  br i1 %t3519, label %fixfast993, label %fixslow994
fixfast993:
  %t3520 = icmp slt i64 %a0, %t3516
  %t3521 = select i1 %t3520, i64 257, i64 1
  br label %fixmerge995
fixslow994:
  %t3522 = call i64 @rt_lt(i64 %a0, i64 %t3516)
  br label %fixmerge995
fixmerge995:
  %t3523 = phi i64 [ %t3521, %fixfast993 ], [ %t3522, %fixslow994 ]
  %t3524 = icmp ne i64 %t3523, 1
  br i1 %t3524, label %then996, label %else997
then996:
  %t3525 = and i64 %self, -8
  %t3526 = inttoptr i64 %t3525 to ptr
  %t3527 = getelementptr i64, ptr %t3526, i64 2
  %t3528 = load i64, ptr %t3527
  %t3529 = and i64 %self, -8
  %t3530 = inttoptr i64 %t3529 to ptr
  %t3531 = getelementptr i64, ptr %t3530, i64 1
  %t3532 = load i64, ptr %t3531
  %t3533 = load i64, ptr @"scheme.base:rd-datum"
  %t3534 = and i64 %t3533, -8
  %t3535 = inttoptr i64 %t3534 to ptr
  %t3536 = load i64, ptr %t3535
  %t3537 = inttoptr i64 %t3536 to ptr
  %t3538 = call fastcc i64%t3537(i64 %t3533, i64 3, i64 %t3528, i64 %t3532, i64 %a0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t3539 = and i64 %self, -8
  %t3540 = inttoptr i64 %t3539 to ptr
  %t3541 = getelementptr i64, ptr %t3540, i64 2
  %t3542 = load i64, ptr %t3541
  %t3543 = and i64 %self, -8
  %t3544 = inttoptr i64 %t3543 to ptr
  %t3545 = getelementptr i64, ptr %t3544, i64 1
  %t3546 = load i64, ptr %t3545
  %t3547 = call i64 @rt_cdr(i64 %t3538)
  %t3548 = load i64, ptr @"scheme.base:rd-skip-ws"
  %t3549 = and i64 %t3548, -8
  %t3550 = inttoptr i64 %t3549 to ptr
  %t3551 = load i64, ptr %t3550
  %t3552 = inttoptr i64 %t3551 to ptr
  %t3553 = call fastcc i64%t3552(i64 %t3548, i64 3, i64 %t3542, i64 %t3546, i64 %t3547, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t3554 = call i64 @rt_car(i64 %t3538)
  %t3555 = call i64 @rt_cons(i64 %t3554, i64 %a1)
  %t3556 = musttail call fastcc i64 @"scheme.base:code_923"(i64 %self, i64 2, i64 %t3553, i64 %t3555, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t3556
else997:
  %t3557 = load i64, ptr @"scheme.base:reverse"
  %t3558 = and i64 %t3557, -8
  %t3559 = inttoptr i64 %t3558 to ptr
  %t3560 = load i64, ptr %t3559
  %t3561 = inttoptr i64 %t3560 to ptr
  %t3562 = musttail call fastcc i64 %t3561(i64 %t3557, i64 1, i64 %a1, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t3562
}

define fastcc i64 @"scheme.base:code_921"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t3563 = icmp eq i64 %argc, 1
  br i1 %t3563, label %argok999, label %arityerr998
arityerr998:
  call void @rt_arity_error(i64 1, i64 %argc)
  unreachable
argok999:
  %t3564 = call i64 @rt_string_length(i64 %a0)
  %t3565 = call i64 @rt_alloc_words(i64 4)
  %t3566 = inttoptr i64 %t3565 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_923" to i64), ptr %t3566
  %t3567 = or i64 %t3565, 4
  %t3568 = getelementptr i64, ptr %t3566, i64 1
  store i64 %t3564, ptr %t3568
  %t3569 = getelementptr i64, ptr %t3566, i64 2
  store i64 %a0, ptr %t3569
  %t3570 = getelementptr i64, ptr %t3566, i64 3
  store i64 %t3567, ptr %t3570
  %t3571 = load i64, ptr @"scheme.base:rd-skip-ws"
  %t3572 = and i64 %t3571, -8
  %t3573 = inttoptr i64 %t3572 to ptr
  %t3574 = load i64, ptr %t3573
  %t3575 = inttoptr i64 %t3574 to ptr
  %t3576 = call fastcc i64%t3575(i64 %t3571, i64 3, i64 %a0, i64 %t3564, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t3577 = and i64 %t3567, -8
  %t3578 = inttoptr i64 %t3577 to ptr
  %t3579 = load i64, ptr %t3578
  %t3580 = inttoptr i64 %t3579 to ptr
  %t3581 = musttail call fastcc i64 %t3580(i64 %t3567, i64 2, i64 %t3576, i64 2, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t3581
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
  %t1266 = call i64 @rt_alloc_words(i64 1)
  %t1267 = inttoptr i64 %t1266 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_316" to i64), ptr %t1267
  %t1268 = or i64 %t1266, 4
  %t1269 = call i64 @rt_root(i64 %t1268)
  store i64 %t1269, ptr @"scheme.base:number->string"
  ret i64 %t1269
}

define i64 @"scheme.base:__init_56"() {
entry:
  %t1292 = call i64 @rt_alloc_words(i64 1)
  %t1293 = inttoptr i64 %t1292 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_320" to i64), ptr %t1293
  %t1294 = or i64 %t1292, 4
  %t1295 = call i64 @rt_root(i64 %t1294)
  store i64 %t1295, ptr @"scheme.base:error"
  ret i64 %t1295
}

define i64 @"scheme.base:__init_57"() {
entry:
  %t1298 = call i64 @rt_alloc_words(i64 1)
  %t1299 = inttoptr i64 %t1298 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_323" to i64), ptr %t1299
  %t1300 = or i64 %t1298, 4
  %t1301 = call i64 @rt_root(i64 %t1300)
  store i64 %t1301, ptr @"scheme.base:raise"
  ret i64 %t1301
}

define i64 @"scheme.base:__init_58"() {
entry:
  %t1304 = call i64 @rt_alloc_words(i64 1)
  %t1305 = inttoptr i64 %t1304 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_326" to i64), ptr %t1305
  %t1306 = or i64 %t1304, 4
  %t1307 = call i64 @rt_root(i64 %t1306)
  store i64 %t1307, ptr @"scheme.base:error-object?"
  ret i64 %t1307
}

define i64 @"scheme.base:__init_59"() {
entry:
  %t1310 = call i64 @rt_alloc_words(i64 1)
  %t1311 = inttoptr i64 %t1310 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_329" to i64), ptr %t1311
  %t1312 = or i64 %t1310, 4
  %t1313 = call i64 @rt_root(i64 %t1312)
  store i64 %t1313, ptr @"scheme.base:error-object-message"
  ret i64 %t1313
}

define i64 @"scheme.base:__init_60"() {
entry:
  %t1316 = call i64 @rt_alloc_words(i64 1)
  %t1317 = inttoptr i64 %t1316 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_332" to i64), ptr %t1317
  %t1318 = or i64 %t1316, 4
  %t1319 = call i64 @rt_root(i64 %t1318)
  store i64 %t1319, ptr @"scheme.base:error-object-irritants"
  ret i64 %t1319
}

define i64 @"scheme.base:__init_61"() {
entry:
  %t1359 = call i64 @rt_alloc_words(i64 1)
  %t1360 = inttoptr i64 %t1359 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_339" to i64), ptr %t1360
  %t1361 = or i64 %t1359, 4
  %t1362 = call i64 @rt_root(i64 %t1361)
  store i64 %t1362, ptr @"scheme.base:list->vector"
  ret i64 %t1362
}

define i64 @"scheme.base:__init_62"() {
entry:
  %t1381 = call i64 @rt_alloc_words(i64 1)
  %t1382 = inttoptr i64 %t1381 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_344" to i64), ptr %t1382
  %t1383 = or i64 %t1381, 4
  %t1384 = call i64 @rt_root(i64 %t1383)
  store i64 %t1384, ptr @"scheme.base:vector"
  ret i64 %t1384
}

define i64 @"scheme.base:__init_63"() {
entry:
  %t1424 = call i64 @rt_alloc_words(i64 1)
  %t1425 = inttoptr i64 %t1424 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_351" to i64), ptr %t1425
  %t1426 = or i64 %t1424, 4
  %t1427 = call i64 @rt_root(i64 %t1426)
  store i64 %t1427, ptr @"scheme.base:list->bytevector"
  ret i64 %t1427
}

define i64 @"scheme.base:__init_64"() {
entry:
  %t1446 = call i64 @rt_alloc_words(i64 1)
  %t1447 = inttoptr i64 %t1446 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_356" to i64), ptr %t1447
  %t1448 = or i64 %t1446, 4
  %t1449 = call i64 @rt_root(i64 %t1448)
  store i64 %t1449, ptr @"scheme.base:bytevector"
  ret i64 %t1449
}

define i64 @"scheme.base:__init_65"() {
entry:
  %t1450 = call i64 @rt_root(i64 64)
  store i64 %t1450, ptr @"scheme.base:%ht-initial-buckets"
  ret i64 %t1450
}

define i64 @"scheme.base:__init_66"() {
entry:
  %t1451 = call i64 @rt_root(i64 24)
  store i64 %t1451, ptr @"scheme.base:%ht-load-factor"
  ret i64 %t1451
}

define i64 @"scheme.base:__init_67"() {
entry:
  %t1462 = call i64 @rt_alloc_words(i64 1)
  %t1463 = inttoptr i64 %t1462 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_358" to i64), ptr %t1463
  %t1464 = or i64 %t1462, 4
  %t1465 = call i64 @rt_root(i64 %t1464)
  store i64 %t1465, ptr @"scheme.base:make-hash-table"
  ret i64 %t1465
}

define i64 @"scheme.base:__init_68"() {
entry:
  %t1468 = call i64 @rt_alloc_words(i64 1)
  %t1469 = inttoptr i64 %t1468 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_361" to i64), ptr %t1469
  %t1470 = or i64 %t1468, 4
  %t1471 = call i64 @rt_root(i64 %t1470)
  store i64 %t1471, ptr @"scheme.base:hash-table?"
  ret i64 %t1471
}

define i64 @"scheme.base:__init_69"() {
entry:
  %t1475 = call i64 @rt_alloc_words(i64 1)
  %t1476 = inttoptr i64 %t1475 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_364" to i64), ptr %t1476
  %t1477 = or i64 %t1475, 4
  %t1478 = call i64 @rt_root(i64 %t1477)
  store i64 %t1478, ptr @"scheme.base:%ht-count"
  ret i64 %t1478
}

define i64 @"scheme.base:__init_70"() {
entry:
  %t1482 = call i64 @rt_alloc_words(i64 1)
  %t1483 = inttoptr i64 %t1482 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_367" to i64), ptr %t1483
  %t1484 = or i64 %t1482, 4
  %t1485 = call i64 @rt_root(i64 %t1484)
  store i64 %t1485, ptr @"scheme.base:%ht-buckets"
  ret i64 %t1485
}

define i64 @"scheme.base:__init_71"() {
entry:
  %t1489 = call i64 @rt_alloc_words(i64 1)
  %t1490 = inttoptr i64 %t1489 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_371" to i64), ptr %t1490
  %t1491 = or i64 %t1489, 4
  %t1492 = call i64 @rt_root(i64 %t1491)
  store i64 %t1492, ptr @"scheme.base:%ht-set-count!"
  ret i64 %t1492
}

define i64 @"scheme.base:__init_72"() {
entry:
  %t1496 = call i64 @rt_alloc_words(i64 1)
  %t1497 = inttoptr i64 %t1496 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_375" to i64), ptr %t1497
  %t1498 = or i64 %t1496, 4
  %t1499 = call i64 @rt_root(i64 %t1498)
  store i64 %t1499, ptr @"scheme.base:%ht-set-buckets!"
  ret i64 %t1499
}

define i64 @"scheme.base:__init_73"() {
entry:
  %t1503 = call i64 @rt_alloc_words(i64 1)
  %t1504 = inttoptr i64 %t1503 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_379" to i64), ptr %t1504
  %t1505 = or i64 %t1503, 4
  %t1506 = call i64 @rt_root(i64 %t1505)
  store i64 %t1506, ptr @"scheme.base:%ht-index"
  ret i64 %t1506
}

define i64 @"scheme.base:__init_74"() {
entry:
  %t1522 = call i64 @rt_alloc_words(i64 1)
  %t1523 = inttoptr i64 %t1522 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_383" to i64), ptr %t1523
  %t1524 = or i64 %t1522, 4
  %t1525 = call i64 @rt_root(i64 %t1524)
  store i64 %t1525, ptr @"scheme.base:%ht-assoc"
  ret i64 %t1525
}

define i64 @"scheme.base:__init_75"() {
entry:
  %t1543 = call i64 @rt_alloc_words(i64 1)
  %t1544 = inttoptr i64 %t1543 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_387" to i64), ptr %t1544
  %t1545 = or i64 %t1543, 4
  %t1546 = call i64 @rt_root(i64 %t1545)
  store i64 %t1546, ptr @"scheme.base:%ht-remove"
  ret i64 %t1546
}

define i64 @"scheme.base:__init_76"() {
entry:
  %t1570 = call i64 @rt_alloc_words(i64 1)
  %t1571 = inttoptr i64 %t1570 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_394" to i64), ptr %t1571
  %t1572 = or i64 %t1570, 4
  %t1573 = call i64 @rt_root(i64 %t1572)
  store i64 %t1573, ptr @"scheme.base:hash-table-ref/default"
  ret i64 %t1573
}

define i64 @"scheme.base:__init_77"() {
entry:
  %t1596 = call i64 @rt_alloc_words(i64 1)
  %t1597 = inttoptr i64 %t1596 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_399" to i64), ptr %t1597
  %t1598 = or i64 %t1596, 4
  %t1599 = call i64 @rt_root(i64 %t1598)
  store i64 %t1599, ptr @"scheme.base:hash-table-contains?"
  ret i64 %t1599
}

define i64 @"scheme.base:__init_78"() {
entry:
  %t1630 = call i64 @rt_alloc_words(i64 1)
  %t1631 = inttoptr i64 %t1630 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_405" to i64), ptr %t1631
  %t1632 = or i64 %t1630, 4
  %t1633 = call i64 @rt_root(i64 %t1632)
  store i64 %t1633, ptr @"scheme.base:hash-table-ref"
  ret i64 %t1633
}

define i64 @"scheme.base:__init_79"() {
entry:
  %t1713 = call i64 @rt_alloc_words(i64 1)
  %t1714 = inttoptr i64 %t1713 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_419" to i64), ptr %t1714
  %t1715 = or i64 %t1713, 4
  %t1716 = call i64 @rt_root(i64 %t1715)
  store i64 %t1716, ptr @"scheme.base:hash-table-set!"
  ret i64 %t1716
}

define i64 @"scheme.base:__init_80"() {
entry:
  %t1764 = call i64 @rt_alloc_words(i64 1)
  %t1765 = inttoptr i64 %t1764 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_426" to i64), ptr %t1765
  %t1766 = or i64 %t1764, 4
  %t1767 = call i64 @rt_root(i64 %t1766)
  store i64 %t1767, ptr @"scheme.base:hash-table-delete!"
  ret i64 %t1767
}

define i64 @"scheme.base:__init_81"() {
entry:
  %t1875 = call i64 @rt_alloc_words(i64 1)
  %t1876 = inttoptr i64 %t1875 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_442" to i64), ptr %t1876
  %t1877 = or i64 %t1875, 4
  %t1878 = call i64 @rt_root(i64 %t1877)
  store i64 %t1878, ptr @"scheme.base:%ht-grow!"
  ret i64 %t1878
}

define i64 @"scheme.base:__init_82"() {
entry:
  %t1886 = call i64 @rt_alloc_words(i64 1)
  %t1887 = inttoptr i64 %t1886 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_449" to i64), ptr %t1887
  %t1888 = or i64 %t1886, 4
  %t1889 = call i64 @rt_root(i64 %t1888)
  store i64 %t1889, ptr @"scheme.base:hash-table-size"
  ret i64 %t1889
}

define i64 @"scheme.base:__init_83"() {
entry:
  %t1906 = call i64 @rt_alloc_words(i64 1)
  %t1907 = inttoptr i64 %t1906 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_453" to i64), ptr %t1907
  %t1908 = or i64 %t1906, 4
  %t1909 = call i64 @rt_root(i64 %t1908)
  store i64 %t1909, ptr @"scheme.base:%ht-fold-buckets"
  ret i64 %t1909
}

define i64 @"scheme.base:__init_84"() {
entry:
  %t1959 = call i64 @rt_alloc_words(i64 1)
  %t1960 = inttoptr i64 %t1959 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_464" to i64), ptr %t1960
  %t1961 = or i64 %t1959, 4
  %t1962 = call i64 @rt_root(i64 %t1961)
  store i64 %t1962, ptr @"scheme.base:hash-table->alist"
  ret i64 %t1962
}

define i64 @"scheme.base:__init_85"() {
entry:
  %t1981 = call i64 @rt_alloc_words(i64 1)
  %t1982 = inttoptr i64 %t1981 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_470" to i64), ptr %t1982
  %t1983 = or i64 %t1981, 4
  %t1984 = call i64 @rt_root(i64 %t1983)
  store i64 %t1984, ptr @"scheme.base:hash-table-keys"
  ret i64 %t1984
}

define i64 @"scheme.base:__init_86"() {
entry:
  %t2003 = call i64 @rt_alloc_words(i64 1)
  %t2004 = inttoptr i64 %t2003 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_476" to i64), ptr %t2004
  %t2005 = or i64 %t2003, 4
  %t2006 = call i64 @rt_root(i64 %t2005)
  store i64 %t2006, ptr @"scheme.base:hash-table-values"
  ret i64 %t2006
}

define i64 @"scheme.base:__init_87"() {
entry:
  %t2040 = call i64 @rt_alloc_words(i64 1)
  %t2041 = inttoptr i64 %t2040 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_504" to i64), ptr %t2041
  %t2042 = or i64 %t2040, 4
  %t2043 = call i64 @rt_root(i64 %t2042)
  store i64 %t2043, ptr @"scheme.base:rd-ws?"
  ret i64 %t2043
}

define i64 @"scheme.base:__init_88"() {
entry:
  %t2061 = call i64 @rt_alloc_words(i64 1)
  %t2062 = inttoptr i64 %t2061 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_516" to i64), ptr %t2062
  %t2063 = or i64 %t2061, 4
  %t2064 = call i64 @rt_root(i64 %t2063)
  store i64 %t2064, ptr @"scheme.base:rd-digit?"
  ret i64 %t2064
}

define i64 @"scheme.base:__init_89"() {
entry:
  %t2121 = call i64 @rt_alloc_words(i64 1)
  %t2122 = inttoptr i64 %t2121 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_556" to i64), ptr %t2122
  %t2123 = or i64 %t2121, 4
  %t2124 = call i64 @rt_root(i64 %t2123)
  store i64 %t2124, ptr @"scheme.base:rd-delim?"
  ret i64 %t2124
}

define i64 @"scheme.base:__init_90"() {
entry:
  %t2162 = call i64 @rt_alloc_words(i64 1)
  %t2163 = inttoptr i64 %t2162 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_569" to i64), ptr %t2163
  %t2164 = or i64 %t2162, 4
  %t2165 = call i64 @rt_root(i64 %t2164)
  store i64 %t2165, ptr @"scheme.base:rd-skip-line"
  ret i64 %t2165
}

define i64 @"scheme.base:__init_91"() {
entry:
  %t2222 = call i64 @rt_alloc_words(i64 1)
  %t2223 = inttoptr i64 %t2222 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_583" to i64), ptr %t2223
  %t2224 = or i64 %t2222, 4
  %t2225 = call i64 @rt_root(i64 %t2224)
  store i64 %t2225, ptr @"scheme.base:rd-skip-ws"
  ret i64 %t2225
}

define i64 @"scheme.base:__init_92"() {
entry:
  %t2255 = call i64 @rt_alloc_words(i64 1)
  %t2256 = inttoptr i64 %t2255 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_592" to i64), ptr %t2256
  %t2257 = or i64 %t2255, 4
  %t2258 = call i64 @rt_root(i64 %t2257)
  store i64 %t2258, ptr @"scheme.base:rd-token-end"
  ret i64 %t2258
}

define i64 @"scheme.base:__init_93"() {
entry:
  %t2288 = call i64 @rt_alloc_words(i64 1)
  %t2289 = inttoptr i64 %t2288 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_601" to i64), ptr %t2289
  %t2290 = or i64 %t2288, 4
  %t2291 = call i64 @rt_root(i64 %t2290)
  store i64 %t2291, ptr @"scheme.base:rd-all-digits?"
  ret i64 %t2291
}

define i64 @"scheme.base:__init_94"() {
entry:
  %t2349 = call i64 @rt_alloc_words(i64 1)
  %t2350 = inttoptr i64 %t2349 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_624" to i64), ptr %t2350
  %t2351 = or i64 %t2349, 4
  %t2352 = call i64 @rt_root(i64 %t2351)
  store i64 %t2352, ptr @"scheme.base:rd-numeric?"
  ret i64 %t2352
}

define i64 @"scheme.base:__init_95"() {
entry:
  %t2395 = call i64 @rt_alloc_words(i64 1)
  %t2396 = inttoptr i64 %t2395 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_634" to i64), ptr %t2396
  %t2397 = or i64 %t2395, 4
  %t2398 = call i64 @rt_root(i64 %t2397)
  store i64 %t2398, ptr @"scheme.base:rd-digits"
  ret i64 %t2398
}

define i64 @"scheme.base:__init_96"() {
entry:
  %t2443 = call i64 @rt_alloc_words(i64 1)
  %t2444 = inttoptr i64 %t2443 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_647" to i64), ptr %t2444
  %t2445 = or i64 %t2443, 4
  %t2446 = call i64 @rt_root(i64 %t2445)
  store i64 %t2446, ptr @"scheme.base:rd-parse-int"
  ret i64 %t2446
}

define i64 @"scheme.base:__init_97"() {
entry:
  %t2471 = call i64 @rt_alloc_words(i64 1)
  %t2472 = inttoptr i64 %t2471 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_654" to i64), ptr %t2472
  %t2473 = or i64 %t2471, 4
  %t2474 = call i64 @rt_root(i64 %t2473)
  store i64 %t2474, ptr @"scheme.base:rd-atom"
  ret i64 %t2474
}

define i64 @"scheme.base:__init_98"() {
entry:
  %t2546 = call i64 @rt_alloc_words(i64 1)
  %t2547 = inttoptr i64 %t2546 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_682" to i64), ptr %t2547
  %t2548 = or i64 %t2546, 4
  %t2549 = call i64 @rt_root(i64 %t2548)
  store i64 %t2549, ptr @"scheme.base:rd-hex-digit"
  ret i64 %t2549
}

define i64 @"scheme.base:__init_99"() {
entry:
  %t2609 = call i64 @rt_alloc_words(i64 1)
  %t2610 = inttoptr i64 %t2609 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_696" to i64), ptr %t2610
  %t2611 = or i64 %t2609, 4
  %t2612 = call i64 @rt_root(i64 %t2611)
  store i64 %t2612, ptr @"scheme.base:rd-hex"
  ret i64 %t2612
}

define i64 @"scheme.base:__init_100"() {
entry:
  %t2642 = call i64 @rt_alloc_words(i64 1)
  %t2643 = inttoptr i64 %t2642 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_712" to i64), ptr %t2643
  %t2644 = or i64 %t2642, 4
  %t2645 = call i64 @rt_root(i64 %t2644)
  store i64 %t2645, ptr @"scheme.base:rd-str-esc"
  ret i64 %t2645
}

define i64 @"scheme.base:__init_101"() {
entry:
  %t2782 = call i64 @rt_alloc_words(i64 1)
  %t2783 = inttoptr i64 %t2782 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_740" to i64), ptr %t2783
  %t2784 = or i64 %t2782, 4
  %t2785 = call i64 @rt_root(i64 %t2784)
  store i64 %t2785, ptr @"scheme.base:rd-string"
  ret i64 %t2785
}

define i64 @"scheme.base:__init_102"() {
entry:
  %t2949 = call i64 @rt_alloc_words(i64 1)
  %t2950 = inttoptr i64 %t2949 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_783" to i64), ptr %t2950
  %t2951 = or i64 %t2949, 4
  %t2952 = call i64 @rt_root(i64 %t2951)
  store i64 %t2952, ptr @"scheme.base:rd-hash"
  ret i64 %t2952
}

define i64 @"scheme.base:__init_103"() {
entry:
  %t2991 = call i64 @rt_alloc_words(i64 1)
  %t2992 = inttoptr i64 %t2991 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_786" to i64), ptr %t2992
  %t2993 = or i64 %t2991, 4
  %t2994 = call i64 @rt_root(i64 %t2993)
  store i64 %t2994, ptr @"scheme.base:rd-char-name"
  ret i64 %t2994
}

define i64 @"scheme.base:__init_104"() {
entry:
  %t3033 = call i64 @rt_alloc_words(i64 1)
  %t3034 = inttoptr i64 %t3033 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_798" to i64), ptr %t3034
  %t3035 = or i64 %t3033, 4
  %t3036 = call i64 @rt_root(i64 %t3035)
  store i64 %t3036, ptr @"scheme.base:rd-char"
  ret i64 %t3036
}

define i64 @"scheme.base:__init_105"() {
entry:
  %t3060 = call i64 @rt_alloc_words(i64 1)
  %t3061 = inttoptr i64 %t3060 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_805" to i64), ptr %t3061
  %t3062 = or i64 %t3060, 4
  %t3063 = call i64 @rt_root(i64 %t3062)
  store i64 %t3063, ptr @"scheme.base:rd-quote"
  ret i64 %t3063
}

define i64 @"scheme.base:__init_106"() {
entry:
  %t3087 = call i64 @rt_alloc_words(i64 1)
  %t3088 = inttoptr i64 %t3087 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_812" to i64), ptr %t3088
  %t3089 = or i64 %t3087, 4
  %t3090 = call i64 @rt_root(i64 %t3089)
  store i64 %t3090, ptr @"scheme.base:rd-quasi"
  ret i64 %t3090
}

define i64 @"scheme.base:__init_107"() {
entry:
  %t3161 = call i64 @rt_alloc_words(i64 1)
  %t3162 = inttoptr i64 %t3161 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_829" to i64), ptr %t3162
  %t3163 = or i64 %t3161, 4
  %t3164 = call i64 @rt_root(i64 %t3163)
  store i64 %t3164, ptr @"scheme.base:rd-unquote"
  ret i64 %t3164
}

define i64 @"scheme.base:__init_108"() {
entry:
  %t3201 = call i64 @rt_alloc_words(i64 1)
  %t3202 = inttoptr i64 %t3201 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_842" to i64), ptr %t3202
  %t3203 = or i64 %t3201, 4
  %t3204 = call i64 @rt_root(i64 %t3203)
  store i64 %t3204, ptr @"scheme.base:rd-dot?"
  ret i64 %t3204
}

define i64 @"scheme.base:__init_109"() {
entry:
  %t3217 = call i64 @rt_alloc_words(i64 1)
  %t3218 = inttoptr i64 %t3217 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_846" to i64), ptr %t3218
  %t3219 = or i64 %t3217, 4
  %t3220 = call i64 @rt_root(i64 %t3219)
  store i64 %t3220, ptr @"scheme.base:rd-append-reverse"
  ret i64 %t3220
}

define i64 @"scheme.base:__init_110"() {
entry:
  %t3336 = call i64 @rt_alloc_words(i64 1)
  %t3337 = inttoptr i64 %t3336 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_871" to i64), ptr %t3337
  %t3338 = or i64 %t3336, 4
  %t3339 = call i64 @rt_root(i64 %t3338)
  store i64 %t3339, ptr @"scheme.base:rd-list"
  ret i64 %t3339
}

define i64 @"scheme.base:__init_111"() {
entry:
  %t3489 = call i64 @rt_alloc_words(i64 1)
  %t3490 = inttoptr i64 %t3489 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_905" to i64), ptr %t3490
  %t3491 = or i64 %t3489, 4
  %t3492 = call i64 @rt_root(i64 %t3491)
  store i64 %t3492, ptr @"scheme.base:rd-datum"
  ret i64 %t3492
}

define i64 @"scheme.base:__init_112"() {
entry:
  %t3508 = call i64 @rt_alloc_words(i64 1)
  %t3509 = inttoptr i64 %t3508 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_909" to i64), ptr %t3509
  %t3510 = or i64 %t3508, 4
  %t3511 = call i64 @rt_root(i64 %t3510)
  store i64 %t3511, ptr @"scheme.base:read-from-string"
  ret i64 %t3511
}

define i64 @"scheme.base:__init_113"() {
entry:
  %t3582 = call i64 @rt_alloc_words(i64 1)
  %t3583 = inttoptr i64 %t3582 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_921" to i64), ptr %t3583
  %t3584 = or i64 %t3582, 4
  %t3585 = call i64 @rt_root(i64 %t3584)
  store i64 %t3585, ptr @"scheme.base:read-all-from-string"
  ret i64 %t3585
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

