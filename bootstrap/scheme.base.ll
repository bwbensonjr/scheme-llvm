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

define fastcc i64 @"scheme.base:code_353"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1286 = icmp eq i64 %argc, 2
  br i1 %t1286, label %argok258, label %arityerr257
arityerr257:
  call void @rt_arity_error(i64 2, i64 %argc)
  unreachable
argok258:
  %t1287 = call i64 @rt_null_p(i64 %a0)
  %t1288 = icmp ne i64 %t1287, 1
  br i1 %t1288, label %then259, label %else260
then259:
  %t1289 = and i64 %self, -8
  %t1290 = inttoptr i64 %t1289 to ptr
  %t1291 = getelementptr i64, ptr %t1290, i64 1
  %t1292 = load i64, ptr %t1291
  ret i64 %t1292
else260:
  %t1293 = and i64 %self, -8
  %t1294 = inttoptr i64 %t1293 to ptr
  %t1295 = getelementptr i64, ptr %t1294, i64 1
  %t1296 = load i64, ptr %t1295
  %t1297 = call i64 @rt_car(i64 %a0)
  %t1298 = call i64 @rt_bytevector_u8_set(i64 %t1296, i64 %a1, i64 %t1297)
  %t1299 = call i64 @rt_cdr(i64 %a0)
  %t1300 = call i64 @rt_add(i64 %a1, i64 8)
  %t1301 = and i64 %self, -8
  %t1302 = inttoptr i64 %t1301 to ptr
  %t1303 = getelementptr i64, ptr %t1302, i64 2
  %t1304 = load i64, ptr %t1303
  %t1305 = and i64 %t1304, -8
  %t1306 = inttoptr i64 %t1305 to ptr
  %t1307 = load i64, ptr %t1306
  %t1308 = inttoptr i64 %t1307 to ptr
  %t1309 = musttail call fastcc i64 %t1308(i64 %t1304, i64 2, i64 %t1299, i64 %t1300, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t1309
}

define fastcc i64 @"scheme.base:code_351"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1310 = icmp eq i64 %argc, 1
  br i1 %t1310, label %argok262, label %arityerr261
arityerr261:
  call void @rt_arity_error(i64 1, i64 %argc)
  unreachable
argok262:
  %t1311 = load i64, ptr @"scheme.base:length"
  %t1312 = and i64 %t1311, -8
  %t1313 = inttoptr i64 %t1312 to ptr
  %t1314 = load i64, ptr %t1313
  %t1315 = inttoptr i64 %t1314 to ptr
  %t1316 = call fastcc i64%t1315(i64 %t1311, i64 1, i64 %a0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t1317 = call i64 @rt_make_bytevector(i64 %t1316, i64 0)
  %t1318 = call i64 @rt_alloc_words(i64 3)
  %t1319 = inttoptr i64 %t1318 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_353" to i64), ptr %t1319
  %t1320 = or i64 %t1318, 4
  %t1321 = getelementptr i64, ptr %t1319, i64 1
  store i64 %t1317, ptr %t1321
  %t1322 = getelementptr i64, ptr %t1319, i64 2
  store i64 %t1320, ptr %t1322
  %t1323 = and i64 %t1320, -8
  %t1324 = inttoptr i64 %t1323 to ptr
  %t1325 = load i64, ptr %t1324
  %t1326 = inttoptr i64 %t1325 to ptr
  %t1327 = musttail call fastcc i64 %t1326(i64 %t1320, i64 2, i64 %a0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t1327
}

define fastcc i64 @"scheme.base:code_356"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1332 = icmp sge i64 %argc, 0
  br i1 %t1332, label %argok264, label %arityerr263
arityerr263:
  call void @rt_arity_error(i64 0, i64 %argc)
  unreachable
argok264:
  %t1333 = call i64 @rt_alloc_words(i64 8)
  %t1334 = inttoptr i64 %t1333 to ptr
  %t1335 = getelementptr i64, ptr %t1334, i64 0
  store i64 %a0, ptr %t1335
  %t1336 = getelementptr i64, ptr %t1334, i64 1
  store i64 %a1, ptr %t1336
  %t1337 = getelementptr i64, ptr %t1334, i64 2
  store i64 %a2, ptr %t1337
  %t1338 = getelementptr i64, ptr %t1334, i64 3
  store i64 %a3, ptr %t1338
  %t1339 = getelementptr i64, ptr %t1334, i64 4
  store i64 %a4, ptr %t1339
  %t1340 = getelementptr i64, ptr %t1334, i64 5
  store i64 %a5, ptr %t1340
  %t1341 = getelementptr i64, ptr %t1334, i64 6
  store i64 %a6, ptr %t1341
  %t1342 = getelementptr i64, ptr %t1334, i64 7
  store i64 %a7, ptr %t1342
  %t1343 = call i64 @rt_build_rest(i64 %argc, i64 0, i64 8, ptr %t1334, ptr %overflow)
  %t1344 = load i64, ptr @"scheme.base:list->bytevector"
  %t1345 = and i64 %t1344, -8
  %t1346 = inttoptr i64 %t1345 to ptr
  %t1347 = load i64, ptr %t1346
  %t1348 = inttoptr i64 %t1347 to ptr
  %t1349 = musttail call fastcc i64 %t1348(i64 %t1344, i64 1, i64 %t1343, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t1349
}

define fastcc i64 @"scheme.base:code_358"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1356 = icmp eq i64 %argc, 0
  br i1 %t1356, label %argok266, label %arityerr265
arityerr265:
  call void @rt_arity_error(i64 0, i64 %argc)
  unreachable
argok266:
  %t1357 = load i64, ptr @"scheme.base:%ht-initial-buckets"
  %t1358 = call i64 @rt_make_vector(i64 %t1357, i64 2)
  %t1359 = load i64, ptr @"scheme.base:vector"
  %t1360 = and i64 %t1359, -8
  %t1361 = inttoptr i64 %t1360 to ptr
  %t1362 = load i64, ptr %t1361
  %t1363 = inttoptr i64 %t1362 to ptr
  %t1364 = call fastcc i64%t1363(i64 %t1359, i64 3, i64 0, i64 %t1358, i64 1, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t1365 = call i64 @rt_make_hash_table(i64 %t1364)
  ret i64 %t1365
}

define fastcc i64 @"scheme.base:code_361"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1370 = icmp eq i64 %argc, 1
  br i1 %t1370, label %argok268, label %arityerr267
arityerr267:
  call void @rt_arity_error(i64 1, i64 %argc)
  unreachable
argok268:
  %t1371 = call i64 @rt_hash_table_p(i64 %a0)
  ret i64 %t1371
}

define fastcc i64 @"scheme.base:code_364"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1376 = icmp eq i64 %argc, 1
  br i1 %t1376, label %argok270, label %arityerr269
arityerr269:
  call void @rt_arity_error(i64 1, i64 %argc)
  unreachable
argok270:
  %t1377 = call i64 @rt_hash_table_spine(i64 %a0)
  %t1378 = call i64 @rt_vector_ref(i64 %t1377, i64 0)
  ret i64 %t1378
}

define fastcc i64 @"scheme.base:code_367"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1383 = icmp eq i64 %argc, 1
  br i1 %t1383, label %argok272, label %arityerr271
arityerr271:
  call void @rt_arity_error(i64 1, i64 %argc)
  unreachable
argok272:
  %t1384 = call i64 @rt_hash_table_spine(i64 %a0)
  %t1385 = call i64 @rt_vector_ref(i64 %t1384, i64 8)
  ret i64 %t1385
}

define fastcc i64 @"scheme.base:code_371"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1390 = icmp eq i64 %argc, 2
  br i1 %t1390, label %argok274, label %arityerr273
arityerr273:
  call void @rt_arity_error(i64 2, i64 %argc)
  unreachable
argok274:
  %t1391 = call i64 @rt_hash_table_spine(i64 %a0)
  %t1392 = call i64 @rt_vector_set(i64 %t1391, i64 0, i64 %a1)
  ret i64 %t1392
}

define fastcc i64 @"scheme.base:code_375"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1397 = icmp eq i64 %argc, 2
  br i1 %t1397, label %argok276, label %arityerr275
arityerr275:
  call void @rt_arity_error(i64 2, i64 %argc)
  unreachable
argok276:
  %t1398 = call i64 @rt_hash_table_spine(i64 %a0)
  %t1399 = call i64 @rt_vector_set(i64 %t1398, i64 8, i64 %a1)
  ret i64 %t1399
}

define fastcc i64 @"scheme.base:code_379"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1404 = icmp eq i64 %argc, 2
  br i1 %t1404, label %argok278, label %arityerr277
arityerr277:
  call void @rt_arity_error(i64 2, i64 %argc)
  unreachable
argok278:
  %t1405 = call i64 @rt_hash(i64 %a0)
  %t1406 = call i64 @rt_remainder(i64 %t1405, i64 %a1)
  ret i64 %t1406
}

define fastcc i64 @"scheme.base:code_383"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1411 = icmp eq i64 %argc, 2
  br i1 %t1411, label %argok280, label %arityerr279
arityerr279:
  call void @rt_arity_error(i64 2, i64 %argc)
  unreachable
argok280:
  %t1412 = call i64 @rt_null_p(i64 %a1)
  %t1413 = icmp ne i64 %t1412, 1
  br i1 %t1413, label %then281, label %else282
then281:
  ret i64 1
else282:
  %t1414 = call i64 @rt_car(i64 %a1)
  %t1415 = call i64 @rt_car(i64 %t1414)
  %t1416 = call i64 @rt_equal(i64 %a0, i64 %t1415)
  %t1417 = icmp ne i64 %t1416, 1
  br i1 %t1417, label %then283, label %else284
then283:
  %t1418 = call i64 @rt_car(i64 %a1)
  ret i64 %t1418
else284:
  %t1419 = call i64 @rt_cdr(i64 %a1)
  %t1420 = load i64, ptr @"scheme.base:%ht-assoc"
  %t1421 = and i64 %t1420, -8
  %t1422 = inttoptr i64 %t1421 to ptr
  %t1423 = load i64, ptr %t1422
  %t1424 = inttoptr i64 %t1423 to ptr
  %t1425 = musttail call fastcc i64 %t1424(i64 %t1420, i64 2, i64 %a0, i64 %t1419, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t1425
}

define fastcc i64 @"scheme.base:code_387"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1430 = icmp eq i64 %argc, 2
  br i1 %t1430, label %argok286, label %arityerr285
arityerr285:
  call void @rt_arity_error(i64 2, i64 %argc)
  unreachable
argok286:
  %t1431 = call i64 @rt_null_p(i64 %a1)
  %t1432 = icmp ne i64 %t1431, 1
  br i1 %t1432, label %then287, label %else288
then287:
  ret i64 2
else288:
  %t1433 = call i64 @rt_car(i64 %a1)
  %t1434 = call i64 @rt_car(i64 %t1433)
  %t1435 = call i64 @rt_equal(i64 %a0, i64 %t1434)
  %t1436 = icmp ne i64 %t1435, 1
  br i1 %t1436, label %then289, label %else290
then289:
  %t1437 = call i64 @rt_cdr(i64 %a1)
  ret i64 %t1437
else290:
  %t1438 = call i64 @rt_car(i64 %a1)
  %t1439 = call i64 @rt_cdr(i64 %a1)
  %t1440 = load i64, ptr @"scheme.base:%ht-remove"
  %t1441 = and i64 %t1440, -8
  %t1442 = inttoptr i64 %t1441 to ptr
  %t1443 = load i64, ptr %t1442
  %t1444 = inttoptr i64 %t1443 to ptr
  %t1445 = call fastcc i64%t1444(i64 %t1440, i64 2, i64 %a0, i64 %t1439, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t1446 = call i64 @rt_cons(i64 %t1438, i64 %t1445)
  ret i64 %t1446
}

define fastcc i64 @"scheme.base:code_394"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1451 = icmp eq i64 %argc, 3
  br i1 %t1451, label %argok292, label %arityerr291
arityerr291:
  call void @rt_arity_error(i64 3, i64 %argc)
  unreachable
argok292:
  %t1452 = load i64, ptr @"scheme.base:%ht-buckets"
  %t1453 = and i64 %t1452, -8
  %t1454 = inttoptr i64 %t1453 to ptr
  %t1455 = load i64, ptr %t1454
  %t1456 = inttoptr i64 %t1455 to ptr
  %t1457 = call fastcc i64%t1456(i64 %t1452, i64 1, i64 %a0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t1458 = call i64 @rt_vector_length(i64 %t1457)
  %t1459 = load i64, ptr @"scheme.base:%ht-index"
  %t1460 = and i64 %t1459, -8
  %t1461 = inttoptr i64 %t1460 to ptr
  %t1462 = load i64, ptr %t1461
  %t1463 = inttoptr i64 %t1462 to ptr
  %t1464 = call fastcc i64%t1463(i64 %t1459, i64 2, i64 %a1, i64 %t1458, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t1465 = call i64 @rt_vector_ref(i64 %t1457, i64 %t1464)
  %t1466 = load i64, ptr @"scheme.base:%ht-assoc"
  %t1467 = and i64 %t1466, -8
  %t1468 = inttoptr i64 %t1467 to ptr
  %t1469 = load i64, ptr %t1468
  %t1470 = inttoptr i64 %t1469 to ptr
  %t1471 = call fastcc i64%t1470(i64 %t1466, i64 2, i64 %a1, i64 %t1465, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t1472 = icmp ne i64 %t1471, 1
  br i1 %t1472, label %then293, label %else294
then293:
  %t1473 = call i64 @rt_cdr(i64 %t1471)
  ret i64 %t1473
else294:
  ret i64 %a2
}

define fastcc i64 @"scheme.base:code_399"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1478 = icmp eq i64 %argc, 2
  br i1 %t1478, label %argok296, label %arityerr295
arityerr295:
  call void @rt_arity_error(i64 2, i64 %argc)
  unreachable
argok296:
  %t1479 = load i64, ptr @"scheme.base:%ht-buckets"
  %t1480 = and i64 %t1479, -8
  %t1481 = inttoptr i64 %t1480 to ptr
  %t1482 = load i64, ptr %t1481
  %t1483 = inttoptr i64 %t1482 to ptr
  %t1484 = call fastcc i64%t1483(i64 %t1479, i64 1, i64 %a0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t1485 = call i64 @rt_vector_length(i64 %t1484)
  %t1486 = load i64, ptr @"scheme.base:%ht-index"
  %t1487 = and i64 %t1486, -8
  %t1488 = inttoptr i64 %t1487 to ptr
  %t1489 = load i64, ptr %t1488
  %t1490 = inttoptr i64 %t1489 to ptr
  %t1491 = call fastcc i64%t1490(i64 %t1486, i64 2, i64 %a1, i64 %t1485, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t1492 = call i64 @rt_vector_ref(i64 %t1484, i64 %t1491)
  %t1493 = load i64, ptr @"scheme.base:%ht-assoc"
  %t1494 = and i64 %t1493, -8
  %t1495 = inttoptr i64 %t1494 to ptr
  %t1496 = load i64, ptr %t1495
  %t1497 = inttoptr i64 %t1496 to ptr
  %t1498 = call fastcc i64%t1497(i64 %t1493, i64 2, i64 %a1, i64 %t1492, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t1499 = icmp ne i64 %t1498, 1
  br i1 %t1499, label %then297, label %else298
then297:
  ret i64 257
else298:
  ret i64 1
}

define fastcc i64 @"scheme.base:code_405"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1504 = icmp eq i64 %argc, 2
  br i1 %t1504, label %argok300, label %arityerr299
arityerr299:
  call void @rt_arity_error(i64 2, i64 %argc)
  unreachable
argok300:
  %t1505 = load i64, ptr @"scheme.base:%ht-buckets"
  %t1506 = and i64 %t1505, -8
  %t1507 = inttoptr i64 %t1506 to ptr
  %t1508 = load i64, ptr %t1507
  %t1509 = inttoptr i64 %t1508 to ptr
  %t1510 = call fastcc i64%t1509(i64 %t1505, i64 1, i64 %a0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t1511 = call i64 @rt_vector_length(i64 %t1510)
  %t1512 = load i64, ptr @"scheme.base:%ht-index"
  %t1513 = and i64 %t1512, -8
  %t1514 = inttoptr i64 %t1513 to ptr
  %t1515 = load i64, ptr %t1514
  %t1516 = inttoptr i64 %t1515 to ptr
  %t1517 = call fastcc i64%t1516(i64 %t1512, i64 2, i64 %a1, i64 %t1511, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t1518 = call i64 @rt_vector_ref(i64 %t1510, i64 %t1517)
  %t1519 = load i64, ptr @"scheme.base:%ht-assoc"
  %t1520 = and i64 %t1519, -8
  %t1521 = inttoptr i64 %t1520 to ptr
  %t1522 = load i64, ptr %t1521
  %t1523 = inttoptr i64 %t1522 to ptr
  %t1524 = call fastcc i64%t1523(i64 %t1519, i64 2, i64 %a1, i64 %t1518, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t1525 = icmp ne i64 %t1524, 1
  br i1 %t1525, label %then301, label %else302
then301:
  %t1526 = call i64 @rt_cdr(i64 %t1524)
  ret i64 %t1526
else302:
  %t1527 = call i64 @rt_make_string(ptr @.str.lit.3, i64 29)
  %t1528 = load i64, ptr @"scheme.base:error"
  %t1529 = and i64 %t1528, -8
  %t1530 = inttoptr i64 %t1529 to ptr
  %t1531 = load i64, ptr %t1530
  %t1532 = inttoptr i64 %t1531 to ptr
  %t1533 = musttail call fastcc i64 %t1532(i64 %t1528, i64 2, i64 %t1527, i64 %a1, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t1533
}

define fastcc i64 @"scheme.base:code_419"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1538 = icmp eq i64 %argc, 3
  br i1 %t1538, label %argok304, label %arityerr303
arityerr303:
  call void @rt_arity_error(i64 3, i64 %argc)
  unreachable
argok304:
  %t1539 = load i64, ptr @"scheme.base:%ht-buckets"
  %t1540 = and i64 %t1539, -8
  %t1541 = inttoptr i64 %t1540 to ptr
  %t1542 = load i64, ptr %t1541
  %t1543 = inttoptr i64 %t1542 to ptr
  %t1544 = call fastcc i64%t1543(i64 %t1539, i64 1, i64 %a0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t1545 = call i64 @rt_vector_length(i64 %t1544)
  %t1546 = load i64, ptr @"scheme.base:%ht-index"
  %t1547 = and i64 %t1546, -8
  %t1548 = inttoptr i64 %t1547 to ptr
  %t1549 = load i64, ptr %t1548
  %t1550 = inttoptr i64 %t1549 to ptr
  %t1551 = call fastcc i64%t1550(i64 %t1546, i64 2, i64 %a1, i64 %t1545, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t1552 = call i64 @rt_vector_ref(i64 %t1544, i64 %t1551)
  %t1553 = load i64, ptr @"scheme.base:%ht-assoc"
  %t1554 = and i64 %t1553, -8
  %t1555 = inttoptr i64 %t1554 to ptr
  %t1556 = load i64, ptr %t1555
  %t1557 = inttoptr i64 %t1556 to ptr
  %t1558 = call fastcc i64%t1557(i64 %t1553, i64 2, i64 %a1, i64 %t1552, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t1559 = call i64 @rt_cons(i64 %a1, i64 %a2)
  %t1560 = icmp ne i64 %t1558, 1
  br i1 %t1560, label %then305, label %else306
then305:
  %t1561 = load i64, ptr @"scheme.base:%ht-remove"
  %t1562 = and i64 %t1561, -8
  %t1563 = inttoptr i64 %t1562 to ptr
  %t1564 = load i64, ptr %t1563
  %t1565 = inttoptr i64 %t1564 to ptr
  %t1566 = call fastcc i64%t1565(i64 %t1561, i64 2, i64 %a1, i64 %t1552, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  br label %merge307
else306:
  br label %merge307
merge307:
  %t1567 = phi i64 [ %t1566, %then305 ], [ %t1552, %else306 ]
  %t1568 = call i64 @rt_cons(i64 %t1559, i64 %t1567)
  %t1569 = call i64 @rt_vector_set(i64 %t1544, i64 %t1551, i64 %t1568)
  %t1570 = icmp ne i64 %t1558, 1
  br i1 %t1570, label %then308, label %else309
then308:
  ret i64 1
else309:
  %t1571 = load i64, ptr @"scheme.base:%ht-count"
  %t1572 = and i64 %t1571, -8
  %t1573 = inttoptr i64 %t1572 to ptr
  %t1574 = load i64, ptr %t1573
  %t1575 = inttoptr i64 %t1574 to ptr
  %t1576 = call fastcc i64%t1575(i64 %t1571, i64 1, i64 %a0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t1577 = call i64 @rt_add(i64 %t1576, i64 8)
  %t1578 = load i64, ptr @"scheme.base:%ht-set-count!"
  %t1579 = and i64 %t1578, -8
  %t1580 = inttoptr i64 %t1579 to ptr
  %t1581 = load i64, ptr %t1580
  %t1582 = inttoptr i64 %t1581 to ptr
  %t1583 = call fastcc i64%t1582(i64 %t1578, i64 2, i64 %a0, i64 %t1577, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t1584 = load i64, ptr @"scheme.base:%ht-count"
  %t1585 = and i64 %t1584, -8
  %t1586 = inttoptr i64 %t1585 to ptr
  %t1587 = load i64, ptr %t1586
  %t1588 = inttoptr i64 %t1587 to ptr
  %t1589 = call fastcc i64%t1588(i64 %t1584, i64 1, i64 %a0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t1590 = load i64, ptr @"scheme.base:%ht-load-factor"
  %t1591 = call i64 @rt_mul(i64 %t1590, i64 %t1545)
  %t1592 = call i64 @rt_lt(i64 %t1591, i64 %t1589)
  %t1593 = icmp ne i64 %t1592, 1
  br i1 %t1593, label %then310, label %else311
then310:
  %t1594 = load i64, ptr @"scheme.base:%ht-grow!"
  %t1595 = and i64 %t1594, -8
  %t1596 = inttoptr i64 %t1595 to ptr
  %t1597 = load i64, ptr %t1596
  %t1598 = inttoptr i64 %t1597 to ptr
  %t1599 = musttail call fastcc i64 %t1598(i64 %t1594, i64 1, i64 %a0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t1599
else311:
  ret i64 1
}

define fastcc i64 @"scheme.base:code_426"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1604 = icmp eq i64 %argc, 2
  br i1 %t1604, label %argok313, label %arityerr312
arityerr312:
  call void @rt_arity_error(i64 2, i64 %argc)
  unreachable
argok313:
  %t1605 = load i64, ptr @"scheme.base:%ht-buckets"
  %t1606 = and i64 %t1605, -8
  %t1607 = inttoptr i64 %t1606 to ptr
  %t1608 = load i64, ptr %t1607
  %t1609 = inttoptr i64 %t1608 to ptr
  %t1610 = call fastcc i64%t1609(i64 %t1605, i64 1, i64 %a0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t1611 = call i64 @rt_vector_length(i64 %t1610)
  %t1612 = load i64, ptr @"scheme.base:%ht-index"
  %t1613 = and i64 %t1612, -8
  %t1614 = inttoptr i64 %t1613 to ptr
  %t1615 = load i64, ptr %t1614
  %t1616 = inttoptr i64 %t1615 to ptr
  %t1617 = call fastcc i64%t1616(i64 %t1612, i64 2, i64 %a1, i64 %t1611, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t1618 = call i64 @rt_vector_ref(i64 %t1610, i64 %t1617)
  %t1619 = load i64, ptr @"scheme.base:%ht-assoc"
  %t1620 = and i64 %t1619, -8
  %t1621 = inttoptr i64 %t1620 to ptr
  %t1622 = load i64, ptr %t1621
  %t1623 = inttoptr i64 %t1622 to ptr
  %t1624 = call fastcc i64%t1623(i64 %t1619, i64 2, i64 %a1, i64 %t1618, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t1625 = icmp ne i64 %t1624, 1
  br i1 %t1625, label %then314, label %else315
then314:
  %t1626 = load i64, ptr @"scheme.base:%ht-remove"
  %t1627 = and i64 %t1626, -8
  %t1628 = inttoptr i64 %t1627 to ptr
  %t1629 = load i64, ptr %t1628
  %t1630 = inttoptr i64 %t1629 to ptr
  %t1631 = call fastcc i64%t1630(i64 %t1626, i64 2, i64 %a1, i64 %t1618, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t1632 = call i64 @rt_vector_set(i64 %t1610, i64 %t1617, i64 %t1631)
  %t1633 = load i64, ptr @"scheme.base:%ht-count"
  %t1634 = and i64 %t1633, -8
  %t1635 = inttoptr i64 %t1634 to ptr
  %t1636 = load i64, ptr %t1635
  %t1637 = inttoptr i64 %t1636 to ptr
  %t1638 = call fastcc i64%t1637(i64 %t1633, i64 1, i64 %a0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t1639 = call i64 @rt_sub(i64 %t1638, i64 8)
  %t1640 = load i64, ptr @"scheme.base:%ht-set-count!"
  %t1641 = and i64 %t1640, -8
  %t1642 = inttoptr i64 %t1641 to ptr
  %t1643 = load i64, ptr %t1642
  %t1644 = inttoptr i64 %t1643 to ptr
  %t1645 = musttail call fastcc i64 %t1644(i64 %t1640, i64 2, i64 %a0, i64 %t1639, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t1645
else315:
  ret i64 1
}

define fastcc i64 @"scheme.base:code_446"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1650 = icmp eq i64 %argc, 1
  br i1 %t1650, label %argok317, label %arityerr316
arityerr316:
  call void @rt_arity_error(i64 1, i64 %argc)
  unreachable
argok317:
  %t1651 = call i64 @rt_null_p(i64 %a0)
  %t1652 = icmp ne i64 %t1651, 1
  br i1 %t1652, label %then318, label %else319
then318:
  ret i64 1
else319:
  %t1653 = call i64 @rt_car(i64 %a0)
  %t1654 = call i64 @rt_car(i64 %t1653)
  %t1655 = and i64 %self, -8
  %t1656 = inttoptr i64 %t1655 to ptr
  %t1657 = getelementptr i64, ptr %t1656, i64 1
  %t1658 = load i64, ptr %t1657
  %t1659 = load i64, ptr @"scheme.base:%ht-index"
  %t1660 = and i64 %t1659, -8
  %t1661 = inttoptr i64 %t1660 to ptr
  %t1662 = load i64, ptr %t1661
  %t1663 = inttoptr i64 %t1662 to ptr
  %t1664 = call fastcc i64%t1663(i64 %t1659, i64 2, i64 %t1654, i64 %t1658, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t1665 = and i64 %self, -8
  %t1666 = inttoptr i64 %t1665 to ptr
  %t1667 = getelementptr i64, ptr %t1666, i64 2
  %t1668 = load i64, ptr %t1667
  %t1669 = and i64 %self, -8
  %t1670 = inttoptr i64 %t1669 to ptr
  %t1671 = getelementptr i64, ptr %t1670, i64 2
  %t1672 = load i64, ptr %t1671
  %t1673 = call i64 @rt_vector_ref(i64 %t1672, i64 %t1664)
  %t1674 = call i64 @rt_cons(i64 %t1653, i64 %t1673)
  %t1675 = call i64 @rt_vector_set(i64 %t1668, i64 %t1664, i64 %t1674)
  %t1676 = call i64 @rt_cdr(i64 %a0)
  %t1677 = and i64 %self, -8
  %t1678 = inttoptr i64 %t1677 to ptr
  %t1679 = getelementptr i64, ptr %t1678, i64 3
  %t1680 = load i64, ptr %t1679
  %t1681 = and i64 %t1680, -8
  %t1682 = inttoptr i64 %t1681 to ptr
  %t1683 = load i64, ptr %t1682
  %t1684 = inttoptr i64 %t1683 to ptr
  %t1685 = musttail call fastcc i64 %t1684(i64 %t1680, i64 1, i64 %t1676, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t1685
}

define fastcc i64 @"scheme.base:code_444"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1686 = icmp eq i64 %argc, 1
  br i1 %t1686, label %argok321, label %arityerr320
arityerr320:
  call void @rt_arity_error(i64 1, i64 %argc)
  unreachable
argok321:
  %t1687 = and i64 %self, -8
  %t1688 = inttoptr i64 %t1687 to ptr
  %t1689 = getelementptr i64, ptr %t1688, i64 1
  %t1690 = load i64, ptr %t1689
  %t1691 = call i64 @rt_vector_length(i64 %t1690)
  %t1692 = call i64 @rt_lt(i64 %a0, i64 %t1691)
  %t1693 = icmp ne i64 %t1692, 1
  br i1 %t1693, label %then322, label %else323
then322:
  %t1694 = call i64 @rt_alloc_words(i64 4)
  %t1695 = inttoptr i64 %t1694 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_446" to i64), ptr %t1695
  %t1696 = or i64 %t1694, 4
  %t1697 = and i64 %self, -8
  %t1698 = inttoptr i64 %t1697 to ptr
  %t1699 = getelementptr i64, ptr %t1698, i64 2
  %t1700 = load i64, ptr %t1699
  %t1701 = getelementptr i64, ptr %t1695, i64 1
  store i64 %t1700, ptr %t1701
  %t1702 = and i64 %self, -8
  %t1703 = inttoptr i64 %t1702 to ptr
  %t1704 = getelementptr i64, ptr %t1703, i64 3
  %t1705 = load i64, ptr %t1704
  %t1706 = getelementptr i64, ptr %t1695, i64 2
  store i64 %t1705, ptr %t1706
  %t1707 = getelementptr i64, ptr %t1695, i64 3
  store i64 %t1696, ptr %t1707
  %t1708 = and i64 %self, -8
  %t1709 = inttoptr i64 %t1708 to ptr
  %t1710 = getelementptr i64, ptr %t1709, i64 1
  %t1711 = load i64, ptr %t1710
  %t1712 = call i64 @rt_vector_ref(i64 %t1711, i64 %a0)
  %t1713 = and i64 %t1696, -8
  %t1714 = inttoptr i64 %t1713 to ptr
  %t1715 = load i64, ptr %t1714
  %t1716 = inttoptr i64 %t1715 to ptr
  %t1717 = call fastcc i64%t1716(i64 %t1696, i64 1, i64 %t1712, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t1718 = call i64 @rt_add(i64 %a0, i64 8)
  %t1719 = and i64 %self, -8
  %t1720 = inttoptr i64 %t1719 to ptr
  %t1721 = getelementptr i64, ptr %t1720, i64 4
  %t1722 = load i64, ptr %t1721
  %t1723 = and i64 %t1722, -8
  %t1724 = inttoptr i64 %t1723 to ptr
  %t1725 = load i64, ptr %t1724
  %t1726 = inttoptr i64 %t1725 to ptr
  %t1727 = musttail call fastcc i64 %t1726(i64 %t1722, i64 1, i64 %t1718, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t1727
else323:
  ret i64 1
}

define fastcc i64 @"scheme.base:code_442"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1728 = icmp eq i64 %argc, 1
  br i1 %t1728, label %argok325, label %arityerr324
arityerr324:
  call void @rt_arity_error(i64 1, i64 %argc)
  unreachable
argok325:
  %t1729 = load i64, ptr @"scheme.base:%ht-buckets"
  %t1730 = and i64 %t1729, -8
  %t1731 = inttoptr i64 %t1730 to ptr
  %t1732 = load i64, ptr %t1731
  %t1733 = inttoptr i64 %t1732 to ptr
  %t1734 = call fastcc i64%t1733(i64 %t1729, i64 1, i64 %a0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t1735 = call i64 @rt_vector_length(i64 %t1734)
  %t1736 = call i64 @rt_mul(i64 16, i64 %t1735)
  %t1737 = call i64 @rt_make_vector(i64 %t1736, i64 2)
  %t1738 = call i64 @rt_alloc_words(i64 5)
  %t1739 = inttoptr i64 %t1738 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_444" to i64), ptr %t1739
  %t1740 = or i64 %t1738, 4
  %t1741 = getelementptr i64, ptr %t1739, i64 1
  store i64 %t1734, ptr %t1741
  %t1742 = getelementptr i64, ptr %t1739, i64 2
  store i64 %t1736, ptr %t1742
  %t1743 = getelementptr i64, ptr %t1739, i64 3
  store i64 %t1737, ptr %t1743
  %t1744 = getelementptr i64, ptr %t1739, i64 4
  store i64 %t1740, ptr %t1744
  %t1745 = and i64 %t1740, -8
  %t1746 = inttoptr i64 %t1745 to ptr
  %t1747 = load i64, ptr %t1746
  %t1748 = inttoptr i64 %t1747 to ptr
  %t1749 = call fastcc i64%t1748(i64 %t1740, i64 1, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t1750 = load i64, ptr @"scheme.base:%ht-set-buckets!"
  %t1751 = and i64 %t1750, -8
  %t1752 = inttoptr i64 %t1751 to ptr
  %t1753 = load i64, ptr %t1752
  %t1754 = inttoptr i64 %t1753 to ptr
  %t1755 = musttail call fastcc i64 %t1754(i64 %t1750, i64 2, i64 %a0, i64 %t1737, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t1755
}

define fastcc i64 @"scheme.base:code_449"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1760 = icmp eq i64 %argc, 1
  br i1 %t1760, label %argok327, label %arityerr326
arityerr326:
  call void @rt_arity_error(i64 1, i64 %argc)
  unreachable
argok327:
  %t1761 = load i64, ptr @"scheme.base:%ht-count"
  %t1762 = and i64 %t1761, -8
  %t1763 = inttoptr i64 %t1762 to ptr
  %t1764 = load i64, ptr %t1763
  %t1765 = inttoptr i64 %t1764 to ptr
  %t1766 = musttail call fastcc i64 %t1765(i64 %t1761, i64 1, i64 %a0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t1766
}

define fastcc i64 @"scheme.base:code_453"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1771 = icmp eq i64 %argc, 2
  br i1 %t1771, label %argok329, label %arityerr328
arityerr328:
  call void @rt_arity_error(i64 2, i64 %argc)
  unreachable
argok329:
  %t1772 = call i64 @rt_null_p(i64 %a0)
  %t1773 = icmp ne i64 %t1772, 1
  br i1 %t1773, label %then330, label %else331
then330:
  ret i64 %a1
else331:
  %t1774 = call i64 @rt_car(i64 %a0)
  %t1775 = call i64 @rt_car(i64 %t1774)
  %t1776 = call i64 @rt_car(i64 %a0)
  %t1777 = call i64 @rt_cdr(i64 %t1776)
  %t1778 = call i64 @rt_cons(i64 %t1775, i64 %t1777)
  %t1779 = call i64 @rt_cdr(i64 %a0)
  %t1780 = load i64, ptr @"scheme.base:%ht-fold-buckets"
  %t1781 = and i64 %t1780, -8
  %t1782 = inttoptr i64 %t1781 to ptr
  %t1783 = load i64, ptr %t1782
  %t1784 = inttoptr i64 %t1783 to ptr
  %t1785 = call fastcc i64%t1784(i64 %t1780, i64 2, i64 %t1779, i64 %a1, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t1786 = call i64 @rt_cons(i64 %t1778, i64 %t1785)
  ret i64 %t1786
}

define fastcc i64 @"scheme.base:code_466"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1791 = icmp eq i64 %argc, 2
  br i1 %t1791, label %argok333, label %arityerr332
arityerr332:
  call void @rt_arity_error(i64 2, i64 %argc)
  unreachable
argok333:
  %t1792 = and i64 %self, -8
  %t1793 = inttoptr i64 %t1792 to ptr
  %t1794 = getelementptr i64, ptr %t1793, i64 1
  %t1795 = load i64, ptr %t1794
  %t1796 = call i64 @rt_vector_length(i64 %t1795)
  %t1797 = call i64 @rt_lt(i64 %a0, i64 %t1796)
  %t1798 = icmp ne i64 %t1797, 1
  br i1 %t1798, label %then334, label %else335
then334:
  %t1799 = call i64 @rt_add(i64 %a0, i64 8)
  %t1800 = and i64 %self, -8
  %t1801 = inttoptr i64 %t1800 to ptr
  %t1802 = getelementptr i64, ptr %t1801, i64 1
  %t1803 = load i64, ptr %t1802
  %t1804 = call i64 @rt_vector_ref(i64 %t1803, i64 %a0)
  %t1805 = load i64, ptr @"scheme.base:%ht-fold-buckets"
  %t1806 = and i64 %t1805, -8
  %t1807 = inttoptr i64 %t1806 to ptr
  %t1808 = load i64, ptr %t1807
  %t1809 = inttoptr i64 %t1808 to ptr
  %t1810 = call fastcc i64%t1809(i64 %t1805, i64 2, i64 %t1804, i64 %a1, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t1811 = and i64 %self, -8
  %t1812 = inttoptr i64 %t1811 to ptr
  %t1813 = getelementptr i64, ptr %t1812, i64 2
  %t1814 = load i64, ptr %t1813
  %t1815 = and i64 %t1814, -8
  %t1816 = inttoptr i64 %t1815 to ptr
  %t1817 = load i64, ptr %t1816
  %t1818 = inttoptr i64 %t1817 to ptr
  %t1819 = musttail call fastcc i64 %t1818(i64 %t1814, i64 2, i64 %t1799, i64 %t1810, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t1819
else335:
  ret i64 %a1
}

define fastcc i64 @"scheme.base:code_464"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1820 = icmp eq i64 %argc, 1
  br i1 %t1820, label %argok337, label %arityerr336
arityerr336:
  call void @rt_arity_error(i64 1, i64 %argc)
  unreachable
argok337:
  %t1821 = load i64, ptr @"scheme.base:%ht-buckets"
  %t1822 = and i64 %t1821, -8
  %t1823 = inttoptr i64 %t1822 to ptr
  %t1824 = load i64, ptr %t1823
  %t1825 = inttoptr i64 %t1824 to ptr
  %t1826 = call fastcc i64%t1825(i64 %t1821, i64 1, i64 %a0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t1827 = call i64 @rt_alloc_words(i64 3)
  %t1828 = inttoptr i64 %t1827 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_466" to i64), ptr %t1828
  %t1829 = or i64 %t1827, 4
  %t1830 = getelementptr i64, ptr %t1828, i64 1
  store i64 %t1826, ptr %t1830
  %t1831 = getelementptr i64, ptr %t1828, i64 2
  store i64 %t1829, ptr %t1831
  %t1832 = and i64 %t1829, -8
  %t1833 = inttoptr i64 %t1832 to ptr
  %t1834 = load i64, ptr %t1833
  %t1835 = inttoptr i64 %t1834 to ptr
  %t1836 = musttail call fastcc i64 %t1835(i64 %t1829, i64 2, i64 0, i64 2, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t1836
}

define fastcc i64 @"scheme.base:code_472"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1841 = icmp eq i64 %argc, 1
  br i1 %t1841, label %argok339, label %arityerr338
arityerr338:
  call void @rt_arity_error(i64 1, i64 %argc)
  unreachable
argok339:
  %t1842 = call i64 @rt_car(i64 %a0)
  ret i64 %t1842
}

define fastcc i64 @"scheme.base:code_470"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1843 = icmp eq i64 %argc, 1
  br i1 %t1843, label %argok341, label %arityerr340
arityerr340:
  call void @rt_arity_error(i64 1, i64 %argc)
  unreachable
argok341:
  %t1844 = call i64 @rt_alloc_words(i64 1)
  %t1845 = inttoptr i64 %t1844 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_472" to i64), ptr %t1845
  %t1846 = or i64 %t1844, 4
  %t1847 = load i64, ptr @"scheme.base:hash-table->alist"
  %t1848 = and i64 %t1847, -8
  %t1849 = inttoptr i64 %t1848 to ptr
  %t1850 = load i64, ptr %t1849
  %t1851 = inttoptr i64 %t1850 to ptr
  %t1852 = call fastcc i64%t1851(i64 %t1847, i64 1, i64 %a0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t1853 = load i64, ptr @"scheme.base:map"
  %t1854 = and i64 %t1853, -8
  %t1855 = inttoptr i64 %t1854 to ptr
  %t1856 = load i64, ptr %t1855
  %t1857 = inttoptr i64 %t1856 to ptr
  %t1858 = musttail call fastcc i64 %t1857(i64 %t1853, i64 2, i64 %t1846, i64 %t1852, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t1858
}

define fastcc i64 @"scheme.base:code_478"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1863 = icmp eq i64 %argc, 1
  br i1 %t1863, label %argok343, label %arityerr342
arityerr342:
  call void @rt_arity_error(i64 1, i64 %argc)
  unreachable
argok343:
  %t1864 = call i64 @rt_cdr(i64 %a0)
  ret i64 %t1864
}

define fastcc i64 @"scheme.base:code_476"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1865 = icmp eq i64 %argc, 1
  br i1 %t1865, label %argok345, label %arityerr344
arityerr344:
  call void @rt_arity_error(i64 1, i64 %argc)
  unreachable
argok345:
  %t1866 = call i64 @rt_alloc_words(i64 1)
  %t1867 = inttoptr i64 %t1866 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_478" to i64), ptr %t1867
  %t1868 = or i64 %t1866, 4
  %t1869 = load i64, ptr @"scheme.base:hash-table->alist"
  %t1870 = and i64 %t1869, -8
  %t1871 = inttoptr i64 %t1870 to ptr
  %t1872 = load i64, ptr %t1871
  %t1873 = inttoptr i64 %t1872 to ptr
  %t1874 = call fastcc i64%t1873(i64 %t1869, i64 1, i64 %a0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t1875 = load i64, ptr @"scheme.base:map"
  %t1876 = and i64 %t1875, -8
  %t1877 = inttoptr i64 %t1876 to ptr
  %t1878 = load i64, ptr %t1877
  %t1879 = inttoptr i64 %t1878 to ptr
  %t1880 = musttail call fastcc i64 %t1879(i64 %t1875, i64 2, i64 %t1868, i64 %t1874, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t1880
}

define fastcc i64 @"scheme.base:code_504"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1885 = icmp eq i64 %argc, 1
  br i1 %t1885, label %argok347, label %arityerr346
arityerr346:
  call void @rt_arity_error(i64 1, i64 %argc)
  unreachable
argok347:
  %t1886 = call i64 @rt_char_to_integer(i64 %a0)
  %t1887 = call i64 @rt_num_eq(i64 %t1886, i64 256)
  %t1888 = icmp ne i64 %t1887, 1
  br i1 %t1888, label %then348, label %else349
then348:
  ret i64 %t1887
else349:
  %t1889 = call i64 @rt_num_eq(i64 %t1886, i64 72)
  %t1890 = icmp ne i64 %t1889, 1
  br i1 %t1890, label %then350, label %else351
then350:
  ret i64 %t1889
else351:
  %t1891 = call i64 @rt_num_eq(i64 %t1886, i64 80)
  %t1892 = icmp ne i64 %t1891, 1
  br i1 %t1892, label %then352, label %else353
then352:
  ret i64 %t1891
else353:
  %t1893 = call i64 @rt_num_eq(i64 %t1886, i64 104)
  ret i64 %t1893
}

define fastcc i64 @"scheme.base:code_516"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1898 = icmp eq i64 %argc, 1
  br i1 %t1898, label %argok355, label %arityerr354
arityerr354:
  call void @rt_arity_error(i64 1, i64 %argc)
  unreachable
argok355:
  %t1899 = call i64 @rt_char_to_integer(i64 %a0)
  %t1900 = call i64 @rt_lt(i64 376, i64 %t1899)
  %t1901 = icmp ne i64 %t1900, 1
  br i1 %t1901, label %then356, label %else357
then356:
  %t1902 = call i64 @rt_lt(i64 %t1899, i64 464)
  ret i64 %t1902
else357:
  ret i64 1
}

define fastcc i64 @"scheme.base:code_556"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1907 = icmp eq i64 %argc, 1
  br i1 %t1907, label %argok359, label %arityerr358
arityerr358:
  call void @rt_arity_error(i64 1, i64 %argc)
  unreachable
argok359:
  %t1908 = call i64 @rt_char_to_integer(i64 %a0)
  %t1909 = load i64, ptr @"scheme.base:rd-ws?"
  %t1910 = and i64 %t1909, -8
  %t1911 = inttoptr i64 %t1910 to ptr
  %t1912 = load i64, ptr %t1911
  %t1913 = inttoptr i64 %t1912 to ptr
  %t1914 = call fastcc i64%t1913(i64 %t1909, i64 1, i64 %a0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t1915 = icmp ne i64 %t1914, 1
  br i1 %t1915, label %then360, label %else361
then360:
  ret i64 %t1914
else361:
  %t1916 = call i64 @rt_num_eq(i64 %t1908, i64 320)
  %t1917 = icmp ne i64 %t1916, 1
  br i1 %t1917, label %then362, label %else363
then362:
  ret i64 %t1916
else363:
  %t1918 = call i64 @rt_num_eq(i64 %t1908, i64 328)
  %t1919 = icmp ne i64 %t1918, 1
  br i1 %t1919, label %then364, label %else365
then364:
  ret i64 %t1918
else365:
  %t1920 = call i64 @rt_num_eq(i64 %t1908, i64 728)
  %t1921 = icmp ne i64 %t1920, 1
  br i1 %t1921, label %then366, label %else367
then366:
  ret i64 %t1920
else367:
  %t1922 = call i64 @rt_num_eq(i64 %t1908, i64 744)
  %t1923 = icmp ne i64 %t1922, 1
  br i1 %t1923, label %then368, label %else369
then368:
  ret i64 %t1922
else369:
  %t1924 = call i64 @rt_num_eq(i64 %t1908, i64 272)
  %t1925 = icmp ne i64 %t1924, 1
  br i1 %t1925, label %then370, label %else371
then370:
  ret i64 %t1924
else371:
  %t1926 = call i64 @rt_num_eq(i64 %t1908, i64 472)
  ret i64 %t1926
}

define fastcc i64 @"scheme.base:code_569"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1931 = icmp eq i64 %argc, 3
  br i1 %t1931, label %argok373, label %arityerr372
arityerr372:
  call void @rt_arity_error(i64 3, i64 %argc)
  unreachable
argok373:
  %t1932 = call i64 @rt_lt(i64 %a2, i64 %a1)
  %t1933 = icmp ne i64 %t1932, 1
  br i1 %t1933, label %then374, label %else375
then374:
  %t1934 = call i64 @rt_string_ref(i64 %a0, i64 %a2)
  %t1935 = call i64 @rt_char_to_integer(i64 %t1934)
  %t1936 = call i64 @rt_num_eq(i64 %t1935, i64 80)
  %t1937 = icmp ne i64 %t1936, 1
  br i1 %t1937, label %then376, label %else377
then376:
  %t1938 = call i64 @rt_add(i64 %a2, i64 8)
  ret i64 %t1938
else377:
  %t1939 = call i64 @rt_add(i64 %a2, i64 8)
  %t1940 = load i64, ptr @"scheme.base:rd-skip-line"
  %t1941 = and i64 %t1940, -8
  %t1942 = inttoptr i64 %t1941 to ptr
  %t1943 = load i64, ptr %t1942
  %t1944 = inttoptr i64 %t1943 to ptr
  %t1945 = musttail call fastcc i64 %t1944(i64 %t1940, i64 3, i64 %a0, i64 %a1, i64 %t1939, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t1945
else375:
  ret i64 %a2
}

define fastcc i64 @"scheme.base:code_583"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1950 = icmp eq i64 %argc, 3
  br i1 %t1950, label %argok379, label %arityerr378
arityerr378:
  call void @rt_arity_error(i64 3, i64 %argc)
  unreachable
argok379:
  %t1951 = call i64 @rt_lt(i64 %a2, i64 %a1)
  %t1952 = icmp ne i64 %t1951, 1
  br i1 %t1952, label %then380, label %else381
then380:
  %t1953 = call i64 @rt_string_ref(i64 %a0, i64 %a2)
  %t1954 = load i64, ptr @"scheme.base:rd-ws?"
  %t1955 = and i64 %t1954, -8
  %t1956 = inttoptr i64 %t1955 to ptr
  %t1957 = load i64, ptr %t1956
  %t1958 = inttoptr i64 %t1957 to ptr
  %t1959 = call fastcc i64%t1958(i64 %t1954, i64 1, i64 %t1953, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t1960 = icmp ne i64 %t1959, 1
  br i1 %t1960, label %then382, label %else383
then382:
  %t1961 = call i64 @rt_add(i64 %a2, i64 8)
  %t1962 = load i64, ptr @"scheme.base:rd-skip-ws"
  %t1963 = and i64 %t1962, -8
  %t1964 = inttoptr i64 %t1963 to ptr
  %t1965 = load i64, ptr %t1964
  %t1966 = inttoptr i64 %t1965 to ptr
  %t1967 = musttail call fastcc i64 %t1966(i64 %t1962, i64 3, i64 %a0, i64 %a1, i64 %t1961, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t1967
else383:
  %t1968 = call i64 @rt_char_to_integer(i64 %t1953)
  %t1969 = call i64 @rt_num_eq(i64 %t1968, i64 472)
  %t1970 = icmp ne i64 %t1969, 1
  br i1 %t1970, label %then384, label %else385
then384:
  %t1971 = call i64 @rt_add(i64 %a2, i64 8)
  %t1972 = load i64, ptr @"scheme.base:rd-skip-line"
  %t1973 = and i64 %t1972, -8
  %t1974 = inttoptr i64 %t1973 to ptr
  %t1975 = load i64, ptr %t1974
  %t1976 = inttoptr i64 %t1975 to ptr
  %t1977 = call fastcc i64%t1976(i64 %t1972, i64 3, i64 %a0, i64 %a1, i64 %t1971, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t1978 = load i64, ptr @"scheme.base:rd-skip-ws"
  %t1979 = and i64 %t1978, -8
  %t1980 = inttoptr i64 %t1979 to ptr
  %t1981 = load i64, ptr %t1980
  %t1982 = inttoptr i64 %t1981 to ptr
  %t1983 = musttail call fastcc i64 %t1982(i64 %t1978, i64 3, i64 %a0, i64 %a1, i64 %t1977, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t1983
else385:
  ret i64 %a2
else381:
  ret i64 %a2
}

define fastcc i64 @"scheme.base:code_592"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t1988 = icmp eq i64 %argc, 3
  br i1 %t1988, label %argok387, label %arityerr386
arityerr386:
  call void @rt_arity_error(i64 3, i64 %argc)
  unreachable
argok387:
  %t1989 = call i64 @rt_lt(i64 %a2, i64 %a1)
  %t1990 = icmp ne i64 %t1989, 1
  br i1 %t1990, label %then388, label %else389
then388:
  %t1991 = call i64 @rt_string_ref(i64 %a0, i64 %a2)
  %t1992 = load i64, ptr @"scheme.base:rd-delim?"
  %t1993 = and i64 %t1992, -8
  %t1994 = inttoptr i64 %t1993 to ptr
  %t1995 = load i64, ptr %t1994
  %t1996 = inttoptr i64 %t1995 to ptr
  %t1997 = call fastcc i64%t1996(i64 %t1992, i64 1, i64 %t1991, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t1998 = icmp ne i64 %t1997, 1
  br i1 %t1998, label %then390, label %else391
then390:
  ret i64 %a2
else391:
  %t1999 = call i64 @rt_add(i64 %a2, i64 8)
  %t2000 = load i64, ptr @"scheme.base:rd-token-end"
  %t2001 = and i64 %t2000, -8
  %t2002 = inttoptr i64 %t2001 to ptr
  %t2003 = load i64, ptr %t2002
  %t2004 = inttoptr i64 %t2003 to ptr
  %t2005 = musttail call fastcc i64 %t2004(i64 %t2000, i64 3, i64 %a0, i64 %a1, i64 %t1999, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t2005
else389:
  ret i64 %a2
}

define fastcc i64 @"scheme.base:code_601"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t2010 = icmp eq i64 %argc, 3
  br i1 %t2010, label %argok393, label %arityerr392
arityerr392:
  call void @rt_arity_error(i64 3, i64 %argc)
  unreachable
argok393:
  %t2011 = call i64 @rt_lt(i64 %a1, i64 %a2)
  %t2012 = icmp ne i64 %t2011, 1
  br i1 %t2012, label %then394, label %else395
then394:
  %t2013 = call i64 @rt_string_ref(i64 %a0, i64 %a1)
  %t2014 = load i64, ptr @"scheme.base:rd-digit?"
  %t2015 = and i64 %t2014, -8
  %t2016 = inttoptr i64 %t2015 to ptr
  %t2017 = load i64, ptr %t2016
  %t2018 = inttoptr i64 %t2017 to ptr
  %t2019 = call fastcc i64%t2018(i64 %t2014, i64 1, i64 %t2013, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t2020 = icmp ne i64 %t2019, 1
  br i1 %t2020, label %then396, label %else397
then396:
  %t2021 = call i64 @rt_add(i64 %a1, i64 8)
  %t2022 = load i64, ptr @"scheme.base:rd-all-digits?"
  %t2023 = and i64 %t2022, -8
  %t2024 = inttoptr i64 %t2023 to ptr
  %t2025 = load i64, ptr %t2024
  %t2026 = inttoptr i64 %t2025 to ptr
  %t2027 = musttail call fastcc i64 %t2026(i64 %t2022, i64 3, i64 %a0, i64 %t2021, i64 %a2, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t2027
else397:
  ret i64 1
else395:
  ret i64 257
}

define fastcc i64 @"scheme.base:code_624"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t2032 = icmp eq i64 %argc, 1
  br i1 %t2032, label %argok399, label %arityerr398
arityerr398:
  call void @rt_arity_error(i64 1, i64 %argc)
  unreachable
argok399:
  %t2033 = call i64 @rt_string_length(i64 %a0)
  %t2034 = call i64 @rt_lt(i64 0, i64 %t2033)
  %t2035 = icmp ne i64 %t2034, 1
  br i1 %t2035, label %then400, label %else401
then400:
  %t2036 = call i64 @rt_string_ref(i64 %a0, i64 0)
  %t2037 = call i64 @rt_char_to_integer(i64 %t2036)
  %t2038 = call i64 @rt_string_ref(i64 %a0, i64 0)
  %t2039 = load i64, ptr @"scheme.base:rd-digit?"
  %t2040 = and i64 %t2039, -8
  %t2041 = inttoptr i64 %t2040 to ptr
  %t2042 = load i64, ptr %t2041
  %t2043 = inttoptr i64 %t2042 to ptr
  %t2044 = call fastcc i64%t2043(i64 %t2039, i64 1, i64 %t2038, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t2045 = icmp ne i64 %t2044, 1
  br i1 %t2045, label %then402, label %else403
then402:
  %t2046 = load i64, ptr @"scheme.base:rd-all-digits?"
  %t2047 = and i64 %t2046, -8
  %t2048 = inttoptr i64 %t2047 to ptr
  %t2049 = load i64, ptr %t2048
  %t2050 = inttoptr i64 %t2049 to ptr
  %t2051 = musttail call fastcc i64 %t2050(i64 %t2046, i64 3, i64 %a0, i64 0, i64 %t2033, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t2051
else403:
  %t2052 = call i64 @rt_num_eq(i64 %t2037, i64 360)
  %t2053 = icmp ne i64 %t2052, 1
  br i1 %t2053, label %then404, label %else405
then404:
  br label %merge406
else405:
  %t2054 = call i64 @rt_num_eq(i64 %t2037, i64 344)
  br label %merge406
merge406:
  %t2055 = phi i64 [ %t2052, %then404 ], [ %t2054, %else405 ]
  %t2056 = icmp ne i64 %t2055, 1
  br i1 %t2056, label %then407, label %else408
then407:
  %t2057 = call i64 @rt_lt(i64 8, i64 %t2033)
  %t2058 = icmp ne i64 %t2057, 1
  br i1 %t2058, label %then409, label %else410
then409:
  %t2059 = load i64, ptr @"scheme.base:rd-all-digits?"
  %t2060 = and i64 %t2059, -8
  %t2061 = inttoptr i64 %t2060 to ptr
  %t2062 = load i64, ptr %t2061
  %t2063 = inttoptr i64 %t2062 to ptr
  %t2064 = musttail call fastcc i64 %t2063(i64 %t2059, i64 3, i64 %a0, i64 8, i64 %t2033, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t2064
else410:
  ret i64 1
else408:
  ret i64 1
else401:
  ret i64 1
}

define fastcc i64 @"scheme.base:code_634"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t2069 = icmp eq i64 %argc, 4
  br i1 %t2069, label %argok412, label %arityerr411
arityerr411:
  call void @rt_arity_error(i64 4, i64 %argc)
  unreachable
argok412:
  %t2070 = call i64 @rt_lt(i64 %a1, i64 %a2)
  %t2071 = icmp ne i64 %t2070, 1
  br i1 %t2071, label %then413, label %else414
then413:
  %t2072 = call i64 @rt_add(i64 %a1, i64 8)
  %t2073 = call i64 @rt_mul(i64 %a3, i64 80)
  %t2074 = call i64 @rt_string_ref(i64 %a0, i64 %a1)
  %t2075 = call i64 @rt_char_to_integer(i64 %t2074)
  %t2076 = call i64 @rt_sub(i64 %t2075, i64 384)
  %t2077 = call i64 @rt_add(i64 %t2073, i64 %t2076)
  %t2078 = load i64, ptr @"scheme.base:rd-digits"
  %t2079 = and i64 %t2078, -8
  %t2080 = inttoptr i64 %t2079 to ptr
  %t2081 = load i64, ptr %t2080
  %t2082 = inttoptr i64 %t2081 to ptr
  %t2083 = musttail call fastcc i64 %t2082(i64 %t2078, i64 4, i64 %a0, i64 %t2072, i64 %a2, i64 %t2077, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t2083
else414:
  ret i64 %a3
}

define fastcc i64 @"scheme.base:code_647"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t2088 = icmp eq i64 %argc, 1
  br i1 %t2088, label %argok416, label %arityerr415
arityerr415:
  call void @rt_arity_error(i64 1, i64 %argc)
  unreachable
argok416:
  %t2089 = call i64 @rt_string_length(i64 %a0)
  %t2090 = call i64 @rt_string_ref(i64 %a0, i64 0)
  %t2091 = call i64 @rt_char_to_integer(i64 %t2090)
  %t2092 = call i64 @rt_num_eq(i64 %t2091, i64 360)
  %t2093 = icmp ne i64 %t2092, 1
  br i1 %t2093, label %then417, label %else418
then417:
  %t2094 = load i64, ptr @"scheme.base:rd-digits"
  %t2095 = and i64 %t2094, -8
  %t2096 = inttoptr i64 %t2095 to ptr
  %t2097 = load i64, ptr %t2096
  %t2098 = inttoptr i64 %t2097 to ptr
  %t2099 = call fastcc i64%t2098(i64 %t2094, i64 4, i64 %a0, i64 8, i64 %t2089, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t2100 = call i64 @rt_sub(i64 0, i64 %t2099)
  ret i64 %t2100
else418:
  %t2101 = call i64 @rt_num_eq(i64 %t2091, i64 344)
  %t2102 = icmp ne i64 %t2101, 1
  br i1 %t2102, label %then419, label %else420
then419:
  %t2103 = load i64, ptr @"scheme.base:rd-digits"
  %t2104 = and i64 %t2103, -8
  %t2105 = inttoptr i64 %t2104 to ptr
  %t2106 = load i64, ptr %t2105
  %t2107 = inttoptr i64 %t2106 to ptr
  %t2108 = musttail call fastcc i64 %t2107(i64 %t2103, i64 4, i64 %a0, i64 8, i64 %t2089, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t2108
else420:
  %t2109 = load i64, ptr @"scheme.base:rd-digits"
  %t2110 = and i64 %t2109, -8
  %t2111 = inttoptr i64 %t2110 to ptr
  %t2112 = load i64, ptr %t2111
  %t2113 = inttoptr i64 %t2112 to ptr
  %t2114 = musttail call fastcc i64 %t2113(i64 %t2109, i64 4, i64 %a0, i64 0, i64 %t2089, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t2114
}

define fastcc i64 @"scheme.base:code_654"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t2119 = icmp eq i64 %argc, 3
  br i1 %t2119, label %argok422, label %arityerr421
arityerr421:
  call void @rt_arity_error(i64 3, i64 %argc)
  unreachable
argok422:
  %t2120 = load i64, ptr @"scheme.base:rd-token-end"
  %t2121 = and i64 %t2120, -8
  %t2122 = inttoptr i64 %t2121 to ptr
  %t2123 = load i64, ptr %t2122
  %t2124 = inttoptr i64 %t2123 to ptr
  %t2125 = call fastcc i64%t2124(i64 %t2120, i64 3, i64 %a0, i64 %a1, i64 %a2, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t2126 = call i64 @rt_substring(i64 %a0, i64 %a2, i64 %t2125)
  %t2127 = load i64, ptr @"scheme.base:rd-numeric?"
  %t2128 = and i64 %t2127, -8
  %t2129 = inttoptr i64 %t2128 to ptr
  %t2130 = load i64, ptr %t2129
  %t2131 = inttoptr i64 %t2130 to ptr
  %t2132 = call fastcc i64%t2131(i64 %t2127, i64 1, i64 %t2126, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t2133 = icmp ne i64 %t2132, 1
  br i1 %t2133, label %then423, label %else424
then423:
  %t2134 = load i64, ptr @"scheme.base:rd-parse-int"
  %t2135 = and i64 %t2134, -8
  %t2136 = inttoptr i64 %t2135 to ptr
  %t2137 = load i64, ptr %t2136
  %t2138 = inttoptr i64 %t2137 to ptr
  %t2139 = call fastcc i64%t2138(i64 %t2134, i64 1, i64 %t2126, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  br label %merge425
else424:
  %t2140 = call i64 @rt_string_to_symbol(i64 %t2126)
  br label %merge425
merge425:
  %t2141 = phi i64 [ %t2139, %then423 ], [ %t2140, %else424 ]
  %t2142 = call i64 @rt_cons(i64 %t2141, i64 %t2125)
  ret i64 %t2142
}

define fastcc i64 @"scheme.base:code_682"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t2147 = icmp eq i64 %argc, 1
  br i1 %t2147, label %argok427, label %arityerr426
arityerr426:
  call void @rt_arity_error(i64 1, i64 %argc)
  unreachable
argok427:
  %t2148 = call i64 @rt_char_to_integer(i64 %a0)
  %t2149 = call i64 @rt_lt(i64 376, i64 %t2148)
  %t2150 = icmp ne i64 %t2149, 1
  br i1 %t2150, label %then428, label %else429
then428:
  %t2151 = call i64 @rt_lt(i64 %t2148, i64 464)
  br label %merge430
else429:
  br label %merge430
merge430:
  %t2152 = phi i64 [ %t2151, %then428 ], [ 1, %else429 ]
  %t2153 = icmp ne i64 %t2152, 1
  br i1 %t2153, label %then431, label %else432
then431:
  %t2154 = call i64 @rt_sub(i64 %t2148, i64 384)
  ret i64 %t2154
else432:
  %t2155 = call i64 @rt_lt(i64 768, i64 %t2148)
  %t2156 = icmp ne i64 %t2155, 1
  br i1 %t2156, label %then433, label %else434
then433:
  %t2157 = call i64 @rt_lt(i64 %t2148, i64 824)
  br label %merge435
else434:
  br label %merge435
merge435:
  %t2158 = phi i64 [ %t2157, %then433 ], [ 1, %else434 ]
  %t2159 = icmp ne i64 %t2158, 1
  br i1 %t2159, label %then436, label %else437
then436:
  %t2160 = call i64 @rt_sub(i64 %t2148, i64 696)
  ret i64 %t2160
else437:
  %t2161 = call i64 @rt_lt(i64 512, i64 %t2148)
  %t2162 = icmp ne i64 %t2161, 1
  br i1 %t2162, label %then438, label %else439
then438:
  %t2163 = call i64 @rt_lt(i64 %t2148, i64 568)
  br label %merge440
else439:
  br label %merge440
merge440:
  %t2164 = phi i64 [ %t2163, %then438 ], [ 1, %else439 ]
  %t2165 = icmp ne i64 %t2164, 1
  br i1 %t2165, label %then441, label %else442
then441:
  %t2166 = call i64 @rt_sub(i64 %t2148, i64 440)
  ret i64 %t2166
else442:
  ret i64 0
}

define fastcc i64 @"scheme.base:code_696"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t2171 = icmp eq i64 %argc, 4
  br i1 %t2171, label %argok444, label %arityerr443
arityerr443:
  call void @rt_arity_error(i64 4, i64 %argc)
  unreachable
argok444:
  %t2172 = call i64 @rt_lt(i64 %a2, i64 %a1)
  %t2173 = icmp ne i64 %t2172, 1
  br i1 %t2173, label %then445, label %else446
then445:
  %t2174 = call i64 @rt_string_ref(i64 %a0, i64 %a2)
  %t2175 = call i64 @rt_char_to_integer(i64 %t2174)
  %t2176 = call i64 @rt_num_eq(i64 %t2175, i64 472)
  %t2177 = icmp ne i64 %t2176, 1
  br i1 %t2177, label %then447, label %else448
then447:
  %t2178 = call i64 @rt_add(i64 %a2, i64 8)
  %t2179 = call i64 @rt_cons(i64 %a3, i64 %t2178)
  ret i64 %t2179
else448:
  %t2180 = call i64 @rt_add(i64 %a2, i64 8)
  %t2181 = call i64 @rt_mul(i64 %a3, i64 128)
  %t2182 = call i64 @rt_string_ref(i64 %a0, i64 %a2)
  %t2183 = load i64, ptr @"scheme.base:rd-hex-digit"
  %t2184 = and i64 %t2183, -8
  %t2185 = inttoptr i64 %t2184 to ptr
  %t2186 = load i64, ptr %t2185
  %t2187 = inttoptr i64 %t2186 to ptr
  %t2188 = call fastcc i64%t2187(i64 %t2183, i64 1, i64 %t2182, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t2189 = call i64 @rt_add(i64 %t2181, i64 %t2188)
  %t2190 = load i64, ptr @"scheme.base:rd-hex"
  %t2191 = and i64 %t2190, -8
  %t2192 = inttoptr i64 %t2191 to ptr
  %t2193 = load i64, ptr %t2192
  %t2194 = inttoptr i64 %t2193 to ptr
  %t2195 = musttail call fastcc i64 %t2194(i64 %t2190, i64 4, i64 %a0, i64 %a1, i64 %t2180, i64 %t2189, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t2195
else446:
  %t2196 = call i64 @rt_cons(i64 %a3, i64 %a2)
  ret i64 %t2196
}

define fastcc i64 @"scheme.base:code_712"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t2201 = icmp eq i64 %argc, 1
  br i1 %t2201, label %argok450, label %arityerr449
arityerr449:
  call void @rt_arity_error(i64 1, i64 %argc)
  unreachable
argok450:
  %t2202 = call i64 @rt_char_to_integer(i64 %a0)
  %t2203 = call i64 @rt_num_eq(i64 %t2202, i64 880)
  %t2204 = icmp ne i64 %t2203, 1
  br i1 %t2204, label %then451, label %else452
then451:
  %t2205 = call i64 @rt_integer_to_char(i64 80)
  ret i64 %t2205
else452:
  %t2206 = call i64 @rt_num_eq(i64 %t2202, i64 928)
  %t2207 = icmp ne i64 %t2206, 1
  br i1 %t2207, label %then453, label %else454
then453:
  %t2208 = call i64 @rt_integer_to_char(i64 72)
  ret i64 %t2208
else454:
  %t2209 = call i64 @rt_num_eq(i64 %t2202, i64 912)
  %t2210 = icmp ne i64 %t2209, 1
  br i1 %t2210, label %then455, label %else456
then455:
  %t2211 = call i64 @rt_integer_to_char(i64 104)
  ret i64 %t2211
else456:
  ret i64 %a0
}

define fastcc i64 @"scheme.base:code_742"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t2216 = icmp eq i64 %argc, 2
  br i1 %t2216, label %argok458, label %arityerr457
arityerr457:
  call void @rt_arity_error(i64 2, i64 %argc)
  unreachable
argok458:
  %t2217 = and i64 %self, -8
  %t2218 = inttoptr i64 %t2217 to ptr
  %t2219 = getelementptr i64, ptr %t2218, i64 1
  %t2220 = load i64, ptr %t2219
  %t2221 = call i64 @rt_lt(i64 %a0, i64 %t2220)
  %t2222 = icmp ne i64 %t2221, 1
  br i1 %t2222, label %then459, label %else460
then459:
  %t2223 = and i64 %self, -8
  %t2224 = inttoptr i64 %t2223 to ptr
  %t2225 = getelementptr i64, ptr %t2224, i64 2
  %t2226 = load i64, ptr %t2225
  %t2227 = call i64 @rt_string_ref(i64 %t2226, i64 %a0)
  %t2228 = call i64 @rt_char_to_integer(i64 %t2227)
  %t2229 = call i64 @rt_num_eq(i64 %t2228, i64 272)
  %t2230 = icmp ne i64 %t2229, 1
  br i1 %t2230, label %then461, label %else462
then461:
  %t2231 = load i64, ptr @"scheme.base:reverse"
  %t2232 = and i64 %t2231, -8
  %t2233 = inttoptr i64 %t2232 to ptr
  %t2234 = load i64, ptr %t2233
  %t2235 = inttoptr i64 %t2234 to ptr
  %t2236 = call fastcc i64%t2235(i64 %t2231, i64 1, i64 %a1, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t2237 = call i64 @rt_list_to_string(i64 %t2236)
  %t2238 = call i64 @rt_add(i64 %a0, i64 8)
  %t2239 = call i64 @rt_cons(i64 %t2237, i64 %t2238)
  ret i64 %t2239
else462:
  %t2240 = call i64 @rt_num_eq(i64 %t2228, i64 736)
  %t2241 = icmp ne i64 %t2240, 1
  br i1 %t2241, label %then463, label %else464
then463:
  %t2242 = and i64 %self, -8
  %t2243 = inttoptr i64 %t2242 to ptr
  %t2244 = getelementptr i64, ptr %t2243, i64 2
  %t2245 = load i64, ptr %t2244
  %t2246 = call i64 @rt_add(i64 %a0, i64 8)
  %t2247 = call i64 @rt_string_ref(i64 %t2245, i64 %t2246)
  %t2248 = call i64 @rt_char_to_integer(i64 %t2247)
  %t2249 = call i64 @rt_num_eq(i64 %t2248, i64 960)
  %t2250 = icmp ne i64 %t2249, 1
  br i1 %t2250, label %then465, label %else466
then465:
  %t2251 = and i64 %self, -8
  %t2252 = inttoptr i64 %t2251 to ptr
  %t2253 = getelementptr i64, ptr %t2252, i64 2
  %t2254 = load i64, ptr %t2253
  %t2255 = and i64 %self, -8
  %t2256 = inttoptr i64 %t2255 to ptr
  %t2257 = getelementptr i64, ptr %t2256, i64 1
  %t2258 = load i64, ptr %t2257
  %t2259 = call i64 @rt_add(i64 %a0, i64 16)
  %t2260 = load i64, ptr @"scheme.base:rd-hex"
  %t2261 = and i64 %t2260, -8
  %t2262 = inttoptr i64 %t2261 to ptr
  %t2263 = load i64, ptr %t2262
  %t2264 = inttoptr i64 %t2263 to ptr
  %t2265 = call fastcc i64%t2264(i64 %t2260, i64 4, i64 %t2254, i64 %t2258, i64 %t2259, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t2266 = call i64 @rt_cdr(i64 %t2265)
  %t2267 = call i64 @rt_car(i64 %t2265)
  %t2268 = call i64 @rt_integer_to_char(i64 %t2267)
  %t2269 = call i64 @rt_cons(i64 %t2268, i64 %a1)
  %t2270 = and i64 %self, -8
  %t2271 = inttoptr i64 %t2270 to ptr
  %t2272 = getelementptr i64, ptr %t2271, i64 3
  %t2273 = load i64, ptr %t2272
  %t2274 = and i64 %t2273, -8
  %t2275 = inttoptr i64 %t2274 to ptr
  %t2276 = load i64, ptr %t2275
  %t2277 = inttoptr i64 %t2276 to ptr
  %t2278 = musttail call fastcc i64 %t2277(i64 %t2273, i64 2, i64 %t2266, i64 %t2269, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t2278
else466:
  %t2279 = call i64 @rt_add(i64 %a0, i64 16)
  %t2280 = load i64, ptr @"scheme.base:rd-str-esc"
  %t2281 = and i64 %t2280, -8
  %t2282 = inttoptr i64 %t2281 to ptr
  %t2283 = load i64, ptr %t2282
  %t2284 = inttoptr i64 %t2283 to ptr
  %t2285 = call fastcc i64%t2284(i64 %t2280, i64 1, i64 %t2247, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t2286 = call i64 @rt_cons(i64 %t2285, i64 %a1)
  %t2287 = and i64 %self, -8
  %t2288 = inttoptr i64 %t2287 to ptr
  %t2289 = getelementptr i64, ptr %t2288, i64 3
  %t2290 = load i64, ptr %t2289
  %t2291 = and i64 %t2290, -8
  %t2292 = inttoptr i64 %t2291 to ptr
  %t2293 = load i64, ptr %t2292
  %t2294 = inttoptr i64 %t2293 to ptr
  %t2295 = musttail call fastcc i64 %t2294(i64 %t2290, i64 2, i64 %t2279, i64 %t2286, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t2295
else464:
  %t2296 = call i64 @rt_add(i64 %a0, i64 8)
  %t2297 = call i64 @rt_cons(i64 %t2227, i64 %a1)
  %t2298 = and i64 %self, -8
  %t2299 = inttoptr i64 %t2298 to ptr
  %t2300 = getelementptr i64, ptr %t2299, i64 3
  %t2301 = load i64, ptr %t2300
  %t2302 = and i64 %t2301, -8
  %t2303 = inttoptr i64 %t2302 to ptr
  %t2304 = load i64, ptr %t2303
  %t2305 = inttoptr i64 %t2304 to ptr
  %t2306 = musttail call fastcc i64 %t2305(i64 %t2301, i64 2, i64 %t2296, i64 %t2297, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t2306
else460:
  %t2307 = load i64, ptr @"scheme.base:reverse"
  %t2308 = and i64 %t2307, -8
  %t2309 = inttoptr i64 %t2308 to ptr
  %t2310 = load i64, ptr %t2309
  %t2311 = inttoptr i64 %t2310 to ptr
  %t2312 = call fastcc i64%t2311(i64 %t2307, i64 1, i64 %a1, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t2313 = call i64 @rt_list_to_string(i64 %t2312)
  %t2314 = call i64 @rt_cons(i64 %t2313, i64 %a0)
  ret i64 %t2314
}

define fastcc i64 @"scheme.base:code_740"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t2315 = icmp eq i64 %argc, 3
  br i1 %t2315, label %argok468, label %arityerr467
arityerr467:
  call void @rt_arity_error(i64 3, i64 %argc)
  unreachable
argok468:
  %t2316 = call i64 @rt_alloc_words(i64 4)
  %t2317 = inttoptr i64 %t2316 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_742" to i64), ptr %t2317
  %t2318 = or i64 %t2316, 4
  %t2319 = getelementptr i64, ptr %t2317, i64 1
  store i64 %a1, ptr %t2319
  %t2320 = getelementptr i64, ptr %t2317, i64 2
  store i64 %a0, ptr %t2320
  %t2321 = getelementptr i64, ptr %t2317, i64 3
  store i64 %t2318, ptr %t2321
  %t2322 = and i64 %t2318, -8
  %t2323 = inttoptr i64 %t2322 to ptr
  %t2324 = load i64, ptr %t2323
  %t2325 = inttoptr i64 %t2324 to ptr
  %t2326 = musttail call fastcc i64 %t2325(i64 %t2318, i64 2, i64 %a2, i64 2, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t2326
}

define fastcc i64 @"scheme.base:code_783"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t2331 = icmp eq i64 %argc, 3
  br i1 %t2331, label %argok470, label %arityerr469
arityerr469:
  call void @rt_arity_error(i64 3, i64 %argc)
  unreachable
argok470:
  %t2332 = call i64 @rt_string_ref(i64 %a0, i64 %a2)
  %t2333 = call i64 @rt_char_to_integer(i64 %t2332)
  %t2334 = call i64 @rt_num_eq(i64 %t2333, i64 928)
  %t2335 = icmp ne i64 %t2334, 1
  br i1 %t2335, label %then471, label %else472
then471:
  %t2336 = call i64 @rt_add(i64 %a2, i64 8)
  %t2337 = call i64 @rt_cons(i64 257, i64 %t2336)
  ret i64 %t2337
else472:
  %t2338 = call i64 @rt_num_eq(i64 %t2333, i64 816)
  %t2339 = icmp ne i64 %t2338, 1
  br i1 %t2339, label %then473, label %else474
then473:
  %t2340 = call i64 @rt_add(i64 %a2, i64 8)
  %t2341 = call i64 @rt_cons(i64 1, i64 %t2340)
  ret i64 %t2341
else474:
  %t2342 = call i64 @rt_num_eq(i64 %t2333, i64 736)
  %t2343 = icmp ne i64 %t2342, 1
  br i1 %t2343, label %then475, label %else476
then475:
  %t2344 = load i64, ptr @"scheme.base:rd-char"
  %t2345 = and i64 %t2344, -8
  %t2346 = inttoptr i64 %t2345 to ptr
  %t2347 = load i64, ptr %t2346
  %t2348 = inttoptr i64 %t2347 to ptr
  %t2349 = musttail call fastcc i64 %t2348(i64 %t2344, i64 3, i64 %a0, i64 %a1, i64 %a2, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t2349
else476:
  %t2350 = call i64 @rt_num_eq(i64 %t2333, i64 320)
  %t2351 = icmp ne i64 %t2350, 1
  br i1 %t2351, label %then477, label %else478
then477:
  %t2352 = call i64 @rt_add(i64 %a2, i64 8)
  %t2353 = load i64, ptr @"scheme.base:rd-list"
  %t2354 = and i64 %t2353, -8
  %t2355 = inttoptr i64 %t2354 to ptr
  %t2356 = load i64, ptr %t2355
  %t2357 = inttoptr i64 %t2356 to ptr
  %t2358 = call fastcc i64%t2357(i64 %t2353, i64 4, i64 %a0, i64 %a1, i64 %t2352, i64 2, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t2359 = call i64 @rt_car(i64 %t2358)
  %t2360 = load i64, ptr @"scheme.base:list->vector"
  %t2361 = and i64 %t2360, -8
  %t2362 = inttoptr i64 %t2361 to ptr
  %t2363 = load i64, ptr %t2362
  %t2364 = inttoptr i64 %t2363 to ptr
  %t2365 = call fastcc i64%t2364(i64 %t2360, i64 1, i64 %t2359, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t2366 = call i64 @rt_cdr(i64 %t2358)
  %t2367 = call i64 @rt_cons(i64 %t2365, i64 %t2366)
  ret i64 %t2367
else478:
  %t2368 = call i64 @rt_num_eq(i64 %t2333, i64 936)
  %t2369 = icmp ne i64 %t2368, 1
  br i1 %t2369, label %then479, label %else480
then479:
  %t2370 = call i64 @rt_add(i64 %a2, i64 16)
  %t2371 = call i64 @rt_lt(i64 %t2370, i64 %a1)
  %t2372 = icmp ne i64 %t2371, 1
  br i1 %t2372, label %then482, label %else483
then482:
  %t2373 = call i64 @rt_add(i64 %a2, i64 8)
  %t2374 = call i64 @rt_string_ref(i64 %a0, i64 %t2373)
  %t2375 = call i64 @rt_char_to_integer(i64 %t2374)
  %t2376 = call i64 @rt_num_eq(i64 %t2375, i64 448)
  %t2377 = icmp ne i64 %t2376, 1
  br i1 %t2377, label %then485, label %else486
then485:
  %t2378 = call i64 @rt_add(i64 %a2, i64 16)
  %t2379 = call i64 @rt_string_ref(i64 %a0, i64 %t2378)
  %t2380 = call i64 @rt_char_to_integer(i64 %t2379)
  %t2381 = call i64 @rt_num_eq(i64 %t2380, i64 320)
  br label %merge487
else486:
  br label %merge487
merge487:
  %t2382 = phi i64 [ %t2381, %then485 ], [ 1, %else486 ]
  br label %merge484
else483:
  br label %merge484
merge484:
  %t2383 = phi i64 [ %t2382, %merge487 ], [ 1, %else483 ]
  br label %merge481
else480:
  br label %merge481
merge481:
  %t2384 = phi i64 [ %t2383, %merge484 ], [ 1, %else480 ]
  %t2385 = icmp ne i64 %t2384, 1
  br i1 %t2385, label %then488, label %else489
then488:
  %t2386 = call i64 @rt_add(i64 %a2, i64 24)
  %t2387 = load i64, ptr @"scheme.base:rd-list"
  %t2388 = and i64 %t2387, -8
  %t2389 = inttoptr i64 %t2388 to ptr
  %t2390 = load i64, ptr %t2389
  %t2391 = inttoptr i64 %t2390 to ptr
  %t2392 = call fastcc i64%t2391(i64 %t2387, i64 4, i64 %a0, i64 %a1, i64 %t2386, i64 2, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t2393 = call i64 @rt_car(i64 %t2392)
  %t2394 = load i64, ptr @"scheme.base:list->bytevector"
  %t2395 = and i64 %t2394, -8
  %t2396 = inttoptr i64 %t2395 to ptr
  %t2397 = load i64, ptr %t2396
  %t2398 = inttoptr i64 %t2397 to ptr
  %t2399 = call fastcc i64%t2398(i64 %t2394, i64 1, i64 %t2393, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t2400 = call i64 @rt_cdr(i64 %t2392)
  %t2401 = call i64 @rt_cons(i64 %t2399, i64 %t2400)
  ret i64 %t2401
else489:
  %t2402 = load i64, ptr @"scheme.base:rd-token-end"
  %t2403 = and i64 %t2402, -8
  %t2404 = inttoptr i64 %t2403 to ptr
  %t2405 = load i64, ptr %t2404
  %t2406 = inttoptr i64 %t2405 to ptr
  %t2407 = call fastcc i64%t2406(i64 %t2402, i64 3, i64 %a0, i64 %a1, i64 %a2, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t2408 = call i64 @rt_substring(i64 %a0, i64 %a2, i64 %t2407)
  %t2409 = call i64 @rt_string_to_symbol(i64 %t2408)
  %t2410 = call i64 @rt_cons(i64 %t2409, i64 %t2407)
  ret i64 %t2410
}

define fastcc i64 @"scheme.base:code_786"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t2415 = icmp eq i64 %argc, 1
  br i1 %t2415, label %argok491, label %arityerr490
arityerr490:
  call void @rt_arity_error(i64 1, i64 %argc)
  unreachable
argok491:
  %t2416 = call i64 @rt_make_string(ptr @.str.lit.4, i64 5)
  %t2417 = call i64 @rt_string_eq(i64 %a0, i64 %t2416)
  %t2418 = icmp ne i64 %t2417, 1
  br i1 %t2418, label %then492, label %else493
then492:
  %t2419 = call i64 @rt_integer_to_char(i64 256)
  ret i64 %t2419
else493:
  %t2420 = call i64 @rt_make_string(ptr @.str.lit.5, i64 7)
  %t2421 = call i64 @rt_string_eq(i64 %a0, i64 %t2420)
  %t2422 = icmp ne i64 %t2421, 1
  br i1 %t2422, label %then494, label %else495
then494:
  %t2423 = call i64 @rt_integer_to_char(i64 80)
  ret i64 %t2423
else495:
  %t2424 = call i64 @rt_make_string(ptr @.str.lit.6, i64 3)
  %t2425 = call i64 @rt_string_eq(i64 %a0, i64 %t2424)
  %t2426 = icmp ne i64 %t2425, 1
  br i1 %t2426, label %then496, label %else497
then496:
  %t2427 = call i64 @rt_integer_to_char(i64 72)
  ret i64 %t2427
else497:
  %t2428 = call i64 @rt_make_string(ptr @.str.lit.7, i64 6)
  %t2429 = call i64 @rt_string_eq(i64 %a0, i64 %t2428)
  %t2430 = icmp ne i64 %t2429, 1
  br i1 %t2430, label %then498, label %else499
then498:
  %t2431 = call i64 @rt_integer_to_char(i64 104)
  ret i64 %t2431
else499:
  %t2432 = call i64 @rt_make_string(ptr @.str.lit.8, i64 3)
  %t2433 = call i64 @rt_string_eq(i64 %a0, i64 %t2432)
  %t2434 = icmp ne i64 %t2433, 1
  br i1 %t2434, label %then500, label %else501
then500:
  %t2435 = call i64 @rt_integer_to_char(i64 0)
  ret i64 %t2435
else501:
  %t2436 = call i64 @rt_make_string(ptr @.str.lit.9, i64 4)
  %t2437 = call i64 @rt_string_eq(i64 %a0, i64 %t2436)
  %t2438 = icmp ne i64 %t2437, 1
  br i1 %t2438, label %then502, label %else503
then502:
  %t2439 = call i64 @rt_integer_to_char(i64 0)
  ret i64 %t2439
else503:
  %t2440 = call i64 @rt_make_string(ptr @.str.lit.10, i64 6)
  %t2441 = call i64 @rt_string_eq(i64 %a0, i64 %t2440)
  %t2442 = icmp ne i64 %t2441, 1
  br i1 %t2442, label %then504, label %else505
then504:
  %t2443 = call i64 @rt_integer_to_char(i64 1016)
  ret i64 %t2443
else505:
  %t2444 = call i64 @rt_make_string(ptr @.str.lit.11, i64 7)
  %t2445 = call i64 @rt_string_eq(i64 %a0, i64 %t2444)
  %t2446 = icmp ne i64 %t2445, 1
  br i1 %t2446, label %then506, label %else507
then506:
  %t2447 = call i64 @rt_integer_to_char(i64 216)
  ret i64 %t2447
else507:
  %t2448 = call i64 @rt_make_string(ptr @.str.lit.12, i64 3)
  %t2449 = call i64 @rt_string_eq(i64 %a0, i64 %t2448)
  %t2450 = icmp ne i64 %t2449, 1
  br i1 %t2450, label %then508, label %else509
then508:
  %t2451 = call i64 @rt_integer_to_char(i64 216)
  ret i64 %t2451
else509:
  %t2452 = call i64 @rt_string_ref(i64 %a0, i64 0)
  ret i64 %t2452
}

define fastcc i64 @"scheme.base:code_798"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t2457 = icmp eq i64 %argc, 3
  br i1 %t2457, label %argok511, label %arityerr510
arityerr510:
  call void @rt_arity_error(i64 3, i64 %argc)
  unreachable
argok511:
  %t2458 = call i64 @rt_add(i64 %a2, i64 8)
  %t2459 = call i64 @rt_add(i64 %t2458, i64 8)
  %t2460 = load i64, ptr @"scheme.base:rd-token-end"
  %t2461 = and i64 %t2460, -8
  %t2462 = inttoptr i64 %t2461 to ptr
  %t2463 = load i64, ptr %t2462
  %t2464 = inttoptr i64 %t2463 to ptr
  %t2465 = call fastcc i64%t2464(i64 %t2460, i64 3, i64 %a0, i64 %a1, i64 %t2459, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t2466 = call i64 @rt_substring(i64 %a0, i64 %t2458, i64 %t2465)
  %t2467 = call i64 @rt_string_length(i64 %t2466)
  %t2468 = call i64 @rt_num_eq(i64 %t2467, i64 8)
  %t2469 = icmp ne i64 %t2468, 1
  br i1 %t2469, label %then512, label %else513
then512:
  %t2470 = call i64 @rt_string_ref(i64 %a0, i64 %t2458)
  %t2471 = call i64 @rt_cons(i64 %t2470, i64 %t2465)
  ret i64 %t2471
else513:
  %t2472 = load i64, ptr @"scheme.base:rd-char-name"
  %t2473 = and i64 %t2472, -8
  %t2474 = inttoptr i64 %t2473 to ptr
  %t2475 = load i64, ptr %t2474
  %t2476 = inttoptr i64 %t2475 to ptr
  %t2477 = call fastcc i64%t2476(i64 %t2472, i64 1, i64 %t2466, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t2478 = call i64 @rt_cons(i64 %t2477, i64 %t2465)
  ret i64 %t2478
}

define fastcc i64 @"scheme.base:code_805"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t2483 = icmp eq i64 %argc, 3
  br i1 %t2483, label %argok515, label %arityerr514
arityerr514:
  call void @rt_arity_error(i64 3, i64 %argc)
  unreachable
argok515:
  %t2484 = load i64, ptr @"scheme.base:rd-skip-ws"
  %t2485 = and i64 %t2484, -8
  %t2486 = inttoptr i64 %t2485 to ptr
  %t2487 = load i64, ptr %t2486
  %t2488 = inttoptr i64 %t2487 to ptr
  %t2489 = call fastcc i64%t2488(i64 %t2484, i64 3, i64 %a0, i64 %a1, i64 %a2, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t2490 = load i64, ptr @"scheme.base:rd-datum"
  %t2491 = and i64 %t2490, -8
  %t2492 = inttoptr i64 %t2491 to ptr
  %t2493 = load i64, ptr %t2492
  %t2494 = inttoptr i64 %t2493 to ptr
  %t2495 = call fastcc i64%t2494(i64 %t2490, i64 3, i64 %a0, i64 %a1, i64 %t2489, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t2496 = call i64 @rt_intern(ptr @.str.sym.13)
  %t2497 = call i64 @rt_car(i64 %t2495)
  %t2498 = load i64, ptr @"scheme.base:list"
  %t2499 = and i64 %t2498, -8
  %t2500 = inttoptr i64 %t2499 to ptr
  %t2501 = load i64, ptr %t2500
  %t2502 = inttoptr i64 %t2501 to ptr
  %t2503 = call fastcc i64%t2502(i64 %t2498, i64 2, i64 %t2496, i64 %t2497, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t2504 = call i64 @rt_cdr(i64 %t2495)
  %t2505 = call i64 @rt_cons(i64 %t2503, i64 %t2504)
  ret i64 %t2505
}

define fastcc i64 @"scheme.base:code_812"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t2510 = icmp eq i64 %argc, 3
  br i1 %t2510, label %argok517, label %arityerr516
arityerr516:
  call void @rt_arity_error(i64 3, i64 %argc)
  unreachable
argok517:
  %t2511 = load i64, ptr @"scheme.base:rd-skip-ws"
  %t2512 = and i64 %t2511, -8
  %t2513 = inttoptr i64 %t2512 to ptr
  %t2514 = load i64, ptr %t2513
  %t2515 = inttoptr i64 %t2514 to ptr
  %t2516 = call fastcc i64%t2515(i64 %t2511, i64 3, i64 %a0, i64 %a1, i64 %a2, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t2517 = load i64, ptr @"scheme.base:rd-datum"
  %t2518 = and i64 %t2517, -8
  %t2519 = inttoptr i64 %t2518 to ptr
  %t2520 = load i64, ptr %t2519
  %t2521 = inttoptr i64 %t2520 to ptr
  %t2522 = call fastcc i64%t2521(i64 %t2517, i64 3, i64 %a0, i64 %a1, i64 %t2516, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t2523 = call i64 @rt_intern(ptr @.str.sym.14)
  %t2524 = call i64 @rt_car(i64 %t2522)
  %t2525 = load i64, ptr @"scheme.base:list"
  %t2526 = and i64 %t2525, -8
  %t2527 = inttoptr i64 %t2526 to ptr
  %t2528 = load i64, ptr %t2527
  %t2529 = inttoptr i64 %t2528 to ptr
  %t2530 = call fastcc i64%t2529(i64 %t2525, i64 2, i64 %t2523, i64 %t2524, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t2531 = call i64 @rt_cdr(i64 %t2522)
  %t2532 = call i64 @rt_cons(i64 %t2530, i64 %t2531)
  ret i64 %t2532
}

define fastcc i64 @"scheme.base:code_829"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t2537 = icmp eq i64 %argc, 3
  br i1 %t2537, label %argok519, label %arityerr518
arityerr518:
  call void @rt_arity_error(i64 3, i64 %argc)
  unreachable
argok519:
  %t2538 = call i64 @rt_lt(i64 %a2, i64 %a1)
  %t2539 = icmp ne i64 %t2538, 1
  br i1 %t2539, label %then520, label %else521
then520:
  %t2540 = call i64 @rt_string_ref(i64 %a0, i64 %a2)
  %t2541 = call i64 @rt_char_to_integer(i64 %t2540)
  %t2542 = call i64 @rt_num_eq(i64 %t2541, i64 512)
  br label %merge522
else521:
  br label %merge522
merge522:
  %t2543 = phi i64 [ %t2542, %then520 ], [ 1, %else521 ]
  %t2544 = icmp ne i64 %t2543, 1
  br i1 %t2544, label %then523, label %else524
then523:
  %t2545 = call i64 @rt_add(i64 %a2, i64 8)
  %t2546 = load i64, ptr @"scheme.base:rd-skip-ws"
  %t2547 = and i64 %t2546, -8
  %t2548 = inttoptr i64 %t2547 to ptr
  %t2549 = load i64, ptr %t2548
  %t2550 = inttoptr i64 %t2549 to ptr
  %t2551 = call fastcc i64%t2550(i64 %t2546, i64 3, i64 %a0, i64 %a1, i64 %t2545, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t2552 = load i64, ptr @"scheme.base:rd-datum"
  %t2553 = and i64 %t2552, -8
  %t2554 = inttoptr i64 %t2553 to ptr
  %t2555 = load i64, ptr %t2554
  %t2556 = inttoptr i64 %t2555 to ptr
  %t2557 = call fastcc i64%t2556(i64 %t2552, i64 3, i64 %a0, i64 %a1, i64 %t2551, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t2558 = call i64 @rt_intern(ptr @.str.sym.15)
  %t2559 = call i64 @rt_car(i64 %t2557)
  %t2560 = load i64, ptr @"scheme.base:list"
  %t2561 = and i64 %t2560, -8
  %t2562 = inttoptr i64 %t2561 to ptr
  %t2563 = load i64, ptr %t2562
  %t2564 = inttoptr i64 %t2563 to ptr
  %t2565 = call fastcc i64%t2564(i64 %t2560, i64 2, i64 %t2558, i64 %t2559, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t2566 = call i64 @rt_cdr(i64 %t2557)
  %t2567 = call i64 @rt_cons(i64 %t2565, i64 %t2566)
  ret i64 %t2567
else524:
  %t2568 = load i64, ptr @"scheme.base:rd-skip-ws"
  %t2569 = and i64 %t2568, -8
  %t2570 = inttoptr i64 %t2569 to ptr
  %t2571 = load i64, ptr %t2570
  %t2572 = inttoptr i64 %t2571 to ptr
  %t2573 = call fastcc i64%t2572(i64 %t2568, i64 3, i64 %a0, i64 %a1, i64 %a2, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t2574 = load i64, ptr @"scheme.base:rd-datum"
  %t2575 = and i64 %t2574, -8
  %t2576 = inttoptr i64 %t2575 to ptr
  %t2577 = load i64, ptr %t2576
  %t2578 = inttoptr i64 %t2577 to ptr
  %t2579 = call fastcc i64%t2578(i64 %t2574, i64 3, i64 %a0, i64 %a1, i64 %t2573, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t2580 = call i64 @rt_intern(ptr @.str.sym.16)
  %t2581 = call i64 @rt_car(i64 %t2579)
  %t2582 = load i64, ptr @"scheme.base:list"
  %t2583 = and i64 %t2582, -8
  %t2584 = inttoptr i64 %t2583 to ptr
  %t2585 = load i64, ptr %t2584
  %t2586 = inttoptr i64 %t2585 to ptr
  %t2587 = call fastcc i64%t2586(i64 %t2582, i64 2, i64 %t2580, i64 %t2581, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t2588 = call i64 @rt_cdr(i64 %t2579)
  %t2589 = call i64 @rt_cons(i64 %t2587, i64 %t2588)
  ret i64 %t2589
}

define fastcc i64 @"scheme.base:code_842"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t2594 = icmp eq i64 %argc, 3
  br i1 %t2594, label %argok526, label %arityerr525
arityerr525:
  call void @rt_arity_error(i64 3, i64 %argc)
  unreachable
argok526:
  %t2595 = call i64 @rt_string_ref(i64 %a0, i64 %a2)
  %t2596 = call i64 @rt_char_to_integer(i64 %t2595)
  %t2597 = call i64 @rt_num_eq(i64 %t2596, i64 368)
  %t2598 = icmp ne i64 %t2597, 1
  br i1 %t2598, label %then527, label %else528
then527:
  %t2599 = call i64 @rt_add(i64 %a2, i64 8)
  %t2600 = load i64, ptr @"scheme.base:rd-token-end"
  %t2601 = and i64 %t2600, -8
  %t2602 = inttoptr i64 %t2601 to ptr
  %t2603 = load i64, ptr %t2602
  %t2604 = inttoptr i64 %t2603 to ptr
  %t2605 = call fastcc i64%t2604(i64 %t2600, i64 3, i64 %a0, i64 %a1, i64 %t2599, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t2606 = call i64 @rt_add(i64 %a2, i64 8)
  %t2607 = call i64 @rt_num_eq(i64 %t2605, i64 %t2606)
  ret i64 %t2607
else528:
  ret i64 1
}

define fastcc i64 @"scheme.base:code_846"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t2612 = icmp eq i64 %argc, 2
  br i1 %t2612, label %argok530, label %arityerr529
arityerr529:
  call void @rt_arity_error(i64 2, i64 %argc)
  unreachable
argok530:
  %t2613 = call i64 @rt_null_p(i64 %a0)
  %t2614 = icmp ne i64 %t2613, 1
  br i1 %t2614, label %then531, label %else532
then531:
  ret i64 %a1
else532:
  %t2615 = call i64 @rt_cdr(i64 %a0)
  %t2616 = call i64 @rt_car(i64 %a0)
  %t2617 = call i64 @rt_cons(i64 %t2616, i64 %a1)
  %t2618 = load i64, ptr @"scheme.base:rd-append-reverse"
  %t2619 = and i64 %t2618, -8
  %t2620 = inttoptr i64 %t2619 to ptr
  %t2621 = load i64, ptr %t2620
  %t2622 = inttoptr i64 %t2621 to ptr
  %t2623 = musttail call fastcc i64 %t2622(i64 %t2618, i64 2, i64 %t2615, i64 %t2617, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t2623
}

define fastcc i64 @"scheme.base:code_871"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t2628 = icmp eq i64 %argc, 4
  br i1 %t2628, label %argok534, label %arityerr533
arityerr533:
  call void @rt_arity_error(i64 4, i64 %argc)
  unreachable
argok534:
  %t2629 = load i64, ptr @"scheme.base:rd-skip-ws"
  %t2630 = and i64 %t2629, -8
  %t2631 = inttoptr i64 %t2630 to ptr
  %t2632 = load i64, ptr %t2631
  %t2633 = inttoptr i64 %t2632 to ptr
  %t2634 = call fastcc i64%t2633(i64 %t2629, i64 3, i64 %a0, i64 %a1, i64 %a2, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t2635 = call i64 @rt_lt(i64 %t2634, i64 %a1)
  %t2636 = icmp ne i64 %t2635, 1
  br i1 %t2636, label %then535, label %else536
then535:
  %t2637 = call i64 @rt_string_ref(i64 %a0, i64 %t2634)
  %t2638 = call i64 @rt_char_to_integer(i64 %t2637)
  %t2639 = call i64 @rt_num_eq(i64 %t2638, i64 328)
  %t2640 = icmp ne i64 %t2639, 1
  br i1 %t2640, label %then537, label %else538
then537:
  br label %merge539
else538:
  %t2641 = call i64 @rt_num_eq(i64 %t2638, i64 744)
  br label %merge539
merge539:
  %t2642 = phi i64 [ %t2639, %then537 ], [ %t2641, %else538 ]
  %t2643 = icmp ne i64 %t2642, 1
  br i1 %t2643, label %then540, label %else541
then540:
  %t2644 = load i64, ptr @"scheme.base:reverse"
  %t2645 = and i64 %t2644, -8
  %t2646 = inttoptr i64 %t2645 to ptr
  %t2647 = load i64, ptr %t2646
  %t2648 = inttoptr i64 %t2647 to ptr
  %t2649 = call fastcc i64%t2648(i64 %t2644, i64 1, i64 %a3, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t2650 = call i64 @rt_add(i64 %t2634, i64 8)
  %t2651 = call i64 @rt_cons(i64 %t2649, i64 %t2650)
  ret i64 %t2651
else541:
  %t2652 = load i64, ptr @"scheme.base:rd-dot?"
  %t2653 = and i64 %t2652, -8
  %t2654 = inttoptr i64 %t2653 to ptr
  %t2655 = load i64, ptr %t2654
  %t2656 = inttoptr i64 %t2655 to ptr
  %t2657 = call fastcc i64%t2656(i64 %t2652, i64 3, i64 %a0, i64 %a1, i64 %t2634, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t2658 = icmp ne i64 %t2657, 1
  br i1 %t2658, label %then542, label %else543
then542:
  %t2659 = call i64 @rt_add(i64 %t2634, i64 8)
  %t2660 = load i64, ptr @"scheme.base:rd-skip-ws"
  %t2661 = and i64 %t2660, -8
  %t2662 = inttoptr i64 %t2661 to ptr
  %t2663 = load i64, ptr %t2662
  %t2664 = inttoptr i64 %t2663 to ptr
  %t2665 = call fastcc i64%t2664(i64 %t2660, i64 3, i64 %a0, i64 %a1, i64 %t2659, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t2666 = load i64, ptr @"scheme.base:rd-datum"
  %t2667 = and i64 %t2666, -8
  %t2668 = inttoptr i64 %t2667 to ptr
  %t2669 = load i64, ptr %t2668
  %t2670 = inttoptr i64 %t2669 to ptr
  %t2671 = call fastcc i64%t2670(i64 %t2666, i64 3, i64 %a0, i64 %a1, i64 %t2665, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t2672 = call i64 @rt_cdr(i64 %t2671)
  %t2673 = load i64, ptr @"scheme.base:rd-skip-ws"
  %t2674 = and i64 %t2673, -8
  %t2675 = inttoptr i64 %t2674 to ptr
  %t2676 = load i64, ptr %t2675
  %t2677 = inttoptr i64 %t2676 to ptr
  %t2678 = call fastcc i64%t2677(i64 %t2673, i64 3, i64 %a0, i64 %a1, i64 %t2672, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t2679 = call i64 @rt_car(i64 %t2671)
  %t2680 = load i64, ptr @"scheme.base:rd-append-reverse"
  %t2681 = and i64 %t2680, -8
  %t2682 = inttoptr i64 %t2681 to ptr
  %t2683 = load i64, ptr %t2682
  %t2684 = inttoptr i64 %t2683 to ptr
  %t2685 = call fastcc i64%t2684(i64 %t2680, i64 2, i64 %a3, i64 %t2679, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t2686 = call i64 @rt_add(i64 %t2678, i64 8)
  %t2687 = call i64 @rt_cons(i64 %t2685, i64 %t2686)
  ret i64 %t2687
else543:
  %t2688 = load i64, ptr @"scheme.base:rd-datum"
  %t2689 = and i64 %t2688, -8
  %t2690 = inttoptr i64 %t2689 to ptr
  %t2691 = load i64, ptr %t2690
  %t2692 = inttoptr i64 %t2691 to ptr
  %t2693 = call fastcc i64%t2692(i64 %t2688, i64 3, i64 %a0, i64 %a1, i64 %t2634, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t2694 = call i64 @rt_cdr(i64 %t2693)
  %t2695 = call i64 @rt_car(i64 %t2693)
  %t2696 = call i64 @rt_cons(i64 %t2695, i64 %a3)
  %t2697 = load i64, ptr @"scheme.base:rd-list"
  %t2698 = and i64 %t2697, -8
  %t2699 = inttoptr i64 %t2698 to ptr
  %t2700 = load i64, ptr %t2699
  %t2701 = inttoptr i64 %t2700 to ptr
  %t2702 = musttail call fastcc i64 %t2701(i64 %t2697, i64 4, i64 %a0, i64 %a1, i64 %t2694, i64 %t2696, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t2702
else536:
  %t2703 = load i64, ptr @"scheme.base:reverse"
  %t2704 = and i64 %t2703, -8
  %t2705 = inttoptr i64 %t2704 to ptr
  %t2706 = load i64, ptr %t2705
  %t2707 = inttoptr i64 %t2706 to ptr
  %t2708 = call fastcc i64%t2707(i64 %t2703, i64 1, i64 %a3, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t2709 = call i64 @rt_cons(i64 %t2708, i64 %t2634)
  ret i64 %t2709
}

define fastcc i64 @"scheme.base:code_905"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t2714 = icmp eq i64 %argc, 3
  br i1 %t2714, label %argok545, label %arityerr544
arityerr544:
  call void @rt_arity_error(i64 3, i64 %argc)
  unreachable
argok545:
  %t2715 = call i64 @rt_string_ref(i64 %a0, i64 %a2)
  %t2716 = call i64 @rt_char_to_integer(i64 %t2715)
  %t2717 = call i64 @rt_num_eq(i64 %t2716, i64 320)
  %t2718 = icmp ne i64 %t2717, 1
  br i1 %t2718, label %then546, label %else547
then546:
  %t2719 = call i64 @rt_add(i64 %a2, i64 8)
  %t2720 = load i64, ptr @"scheme.base:rd-list"
  %t2721 = and i64 %t2720, -8
  %t2722 = inttoptr i64 %t2721 to ptr
  %t2723 = load i64, ptr %t2722
  %t2724 = inttoptr i64 %t2723 to ptr
  %t2725 = musttail call fastcc i64 %t2724(i64 %t2720, i64 4, i64 %a0, i64 %a1, i64 %t2719, i64 2, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t2725
else547:
  %t2726 = call i64 @rt_num_eq(i64 %t2716, i64 728)
  %t2727 = icmp ne i64 %t2726, 1
  br i1 %t2727, label %then548, label %else549
then548:
  %t2728 = call i64 @rt_add(i64 %a2, i64 8)
  %t2729 = load i64, ptr @"scheme.base:rd-list"
  %t2730 = and i64 %t2729, -8
  %t2731 = inttoptr i64 %t2730 to ptr
  %t2732 = load i64, ptr %t2731
  %t2733 = inttoptr i64 %t2732 to ptr
  %t2734 = musttail call fastcc i64 %t2733(i64 %t2729, i64 4, i64 %a0, i64 %a1, i64 %t2728, i64 2, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t2734
else549:
  %t2735 = call i64 @rt_num_eq(i64 %t2716, i64 312)
  %t2736 = icmp ne i64 %t2735, 1
  br i1 %t2736, label %then550, label %else551
then550:
  %t2737 = call i64 @rt_add(i64 %a2, i64 8)
  %t2738 = load i64, ptr @"scheme.base:rd-quote"
  %t2739 = and i64 %t2738, -8
  %t2740 = inttoptr i64 %t2739 to ptr
  %t2741 = load i64, ptr %t2740
  %t2742 = inttoptr i64 %t2741 to ptr
  %t2743 = musttail call fastcc i64 %t2742(i64 %t2738, i64 3, i64 %a0, i64 %a1, i64 %t2737, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t2743
else551:
  %t2744 = call i64 @rt_num_eq(i64 %t2716, i64 768)
  %t2745 = icmp ne i64 %t2744, 1
  br i1 %t2745, label %then552, label %else553
then552:
  %t2746 = call i64 @rt_add(i64 %a2, i64 8)
  %t2747 = load i64, ptr @"scheme.base:rd-quasi"
  %t2748 = and i64 %t2747, -8
  %t2749 = inttoptr i64 %t2748 to ptr
  %t2750 = load i64, ptr %t2749
  %t2751 = inttoptr i64 %t2750 to ptr
  %t2752 = musttail call fastcc i64 %t2751(i64 %t2747, i64 3, i64 %a0, i64 %a1, i64 %t2746, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t2752
else553:
  %t2753 = call i64 @rt_num_eq(i64 %t2716, i64 352)
  %t2754 = icmp ne i64 %t2753, 1
  br i1 %t2754, label %then554, label %else555
then554:
  %t2755 = call i64 @rt_add(i64 %a2, i64 8)
  %t2756 = load i64, ptr @"scheme.base:rd-unquote"
  %t2757 = and i64 %t2756, -8
  %t2758 = inttoptr i64 %t2757 to ptr
  %t2759 = load i64, ptr %t2758
  %t2760 = inttoptr i64 %t2759 to ptr
  %t2761 = musttail call fastcc i64 %t2760(i64 %t2756, i64 3, i64 %a0, i64 %a1, i64 %t2755, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t2761
else555:
  %t2762 = call i64 @rt_num_eq(i64 %t2716, i64 272)
  %t2763 = icmp ne i64 %t2762, 1
  br i1 %t2763, label %then556, label %else557
then556:
  %t2764 = call i64 @rt_add(i64 %a2, i64 8)
  %t2765 = load i64, ptr @"scheme.base:rd-string"
  %t2766 = and i64 %t2765, -8
  %t2767 = inttoptr i64 %t2766 to ptr
  %t2768 = load i64, ptr %t2767
  %t2769 = inttoptr i64 %t2768 to ptr
  %t2770 = musttail call fastcc i64 %t2769(i64 %t2765, i64 3, i64 %a0, i64 %a1, i64 %t2764, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t2770
else557:
  %t2771 = call i64 @rt_num_eq(i64 %t2716, i64 280)
  %t2772 = icmp ne i64 %t2771, 1
  br i1 %t2772, label %then558, label %else559
then558:
  %t2773 = call i64 @rt_add(i64 %a2, i64 8)
  %t2774 = load i64, ptr @"scheme.base:rd-hash"
  %t2775 = and i64 %t2774, -8
  %t2776 = inttoptr i64 %t2775 to ptr
  %t2777 = load i64, ptr %t2776
  %t2778 = inttoptr i64 %t2777 to ptr
  %t2779 = musttail call fastcc i64 %t2778(i64 %t2774, i64 3, i64 %a0, i64 %a1, i64 %t2773, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t2779
else559:
  %t2780 = load i64, ptr @"scheme.base:rd-atom"
  %t2781 = and i64 %t2780, -8
  %t2782 = inttoptr i64 %t2781 to ptr
  %t2783 = load i64, ptr %t2782
  %t2784 = inttoptr i64 %t2783 to ptr
  %t2785 = musttail call fastcc i64 %t2784(i64 %t2780, i64 3, i64 %a0, i64 %a1, i64 %a2, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t2785
}

define fastcc i64 @"scheme.base:code_909"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t2790 = icmp eq i64 %argc, 1
  br i1 %t2790, label %argok561, label %arityerr560
arityerr560:
  call void @rt_arity_error(i64 1, i64 %argc)
  unreachable
argok561:
  %t2791 = call i64 @rt_string_length(i64 %a0)
  %t2792 = load i64, ptr @"scheme.base:rd-skip-ws"
  %t2793 = and i64 %t2792, -8
  %t2794 = inttoptr i64 %t2793 to ptr
  %t2795 = load i64, ptr %t2794
  %t2796 = inttoptr i64 %t2795 to ptr
  %t2797 = call fastcc i64%t2796(i64 %t2792, i64 3, i64 %a0, i64 %t2791, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t2798 = load i64, ptr @"scheme.base:rd-datum"
  %t2799 = and i64 %t2798, -8
  %t2800 = inttoptr i64 %t2799 to ptr
  %t2801 = load i64, ptr %t2800
  %t2802 = inttoptr i64 %t2801 to ptr
  %t2803 = call fastcc i64%t2802(i64 %t2798, i64 3, i64 %a0, i64 %t2791, i64 %t2797, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t2804 = call i64 @rt_car(i64 %t2803)
  ret i64 %t2804
}

define fastcc i64 @"scheme.base:code_923"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t2809 = icmp eq i64 %argc, 2
  br i1 %t2809, label %argok563, label %arityerr562
arityerr562:
  call void @rt_arity_error(i64 2, i64 %argc)
  unreachable
argok563:
  %t2810 = and i64 %self, -8
  %t2811 = inttoptr i64 %t2810 to ptr
  %t2812 = getelementptr i64, ptr %t2811, i64 1
  %t2813 = load i64, ptr %t2812
  %t2814 = call i64 @rt_lt(i64 %a0, i64 %t2813)
  %t2815 = icmp ne i64 %t2814, 1
  br i1 %t2815, label %then564, label %else565
then564:
  %t2816 = and i64 %self, -8
  %t2817 = inttoptr i64 %t2816 to ptr
  %t2818 = getelementptr i64, ptr %t2817, i64 2
  %t2819 = load i64, ptr %t2818
  %t2820 = and i64 %self, -8
  %t2821 = inttoptr i64 %t2820 to ptr
  %t2822 = getelementptr i64, ptr %t2821, i64 1
  %t2823 = load i64, ptr %t2822
  %t2824 = load i64, ptr @"scheme.base:rd-datum"
  %t2825 = and i64 %t2824, -8
  %t2826 = inttoptr i64 %t2825 to ptr
  %t2827 = load i64, ptr %t2826
  %t2828 = inttoptr i64 %t2827 to ptr
  %t2829 = call fastcc i64%t2828(i64 %t2824, i64 3, i64 %t2819, i64 %t2823, i64 %a0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t2830 = and i64 %self, -8
  %t2831 = inttoptr i64 %t2830 to ptr
  %t2832 = getelementptr i64, ptr %t2831, i64 2
  %t2833 = load i64, ptr %t2832
  %t2834 = and i64 %self, -8
  %t2835 = inttoptr i64 %t2834 to ptr
  %t2836 = getelementptr i64, ptr %t2835, i64 1
  %t2837 = load i64, ptr %t2836
  %t2838 = call i64 @rt_cdr(i64 %t2829)
  %t2839 = load i64, ptr @"scheme.base:rd-skip-ws"
  %t2840 = and i64 %t2839, -8
  %t2841 = inttoptr i64 %t2840 to ptr
  %t2842 = load i64, ptr %t2841
  %t2843 = inttoptr i64 %t2842 to ptr
  %t2844 = call fastcc i64%t2843(i64 %t2839, i64 3, i64 %t2833, i64 %t2837, i64 %t2838, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t2845 = call i64 @rt_car(i64 %t2829)
  %t2846 = call i64 @rt_cons(i64 %t2845, i64 %a1)
  %t2847 = and i64 %self, -8
  %t2848 = inttoptr i64 %t2847 to ptr
  %t2849 = getelementptr i64, ptr %t2848, i64 3
  %t2850 = load i64, ptr %t2849
  %t2851 = and i64 %t2850, -8
  %t2852 = inttoptr i64 %t2851 to ptr
  %t2853 = load i64, ptr %t2852
  %t2854 = inttoptr i64 %t2853 to ptr
  %t2855 = musttail call fastcc i64 %t2854(i64 %t2850, i64 2, i64 %t2844, i64 %t2846, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t2855
else565:
  %t2856 = load i64, ptr @"scheme.base:reverse"
  %t2857 = and i64 %t2856, -8
  %t2858 = inttoptr i64 %t2857 to ptr
  %t2859 = load i64, ptr %t2858
  %t2860 = inttoptr i64 %t2859 to ptr
  %t2861 = musttail call fastcc i64 %t2860(i64 %t2856, i64 1, i64 %a1, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t2861
}

define fastcc i64 @"scheme.base:code_921"(i64 %self, i64 %argc, i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ptr %overflow) {
entry:
  %t2862 = icmp eq i64 %argc, 1
  br i1 %t2862, label %argok567, label %arityerr566
arityerr566:
  call void @rt_arity_error(i64 1, i64 %argc)
  unreachable
argok567:
  %t2863 = call i64 @rt_string_length(i64 %a0)
  %t2864 = call i64 @rt_alloc_words(i64 4)
  %t2865 = inttoptr i64 %t2864 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_923" to i64), ptr %t2865
  %t2866 = or i64 %t2864, 4
  %t2867 = getelementptr i64, ptr %t2865, i64 1
  store i64 %t2863, ptr %t2867
  %t2868 = getelementptr i64, ptr %t2865, i64 2
  store i64 %a0, ptr %t2868
  %t2869 = getelementptr i64, ptr %t2865, i64 3
  store i64 %t2866, ptr %t2869
  %t2870 = load i64, ptr @"scheme.base:rd-skip-ws"
  %t2871 = and i64 %t2870, -8
  %t2872 = inttoptr i64 %t2871 to ptr
  %t2873 = load i64, ptr %t2872
  %t2874 = inttoptr i64 %t2873 to ptr
  %t2875 = call fastcc i64%t2874(i64 %t2870, i64 3, i64 %a0, i64 %t2863, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  %t2876 = and i64 %t2866, -8
  %t2877 = inttoptr i64 %t2876 to ptr
  %t2878 = load i64, ptr %t2877
  %t2879 = inttoptr i64 %t2878 to ptr
  %t2880 = musttail call fastcc i64 %t2879(i64 %t2866, i64 2, i64 %t2875, i64 2, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, ptr null)
  ret i64 %t2880
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
  %t1328 = call i64 @rt_alloc_words(i64 1)
  %t1329 = inttoptr i64 %t1328 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_351" to i64), ptr %t1329
  %t1330 = or i64 %t1328, 4
  %t1331 = call i64 @rt_root(i64 %t1330)
  store i64 %t1331, ptr @"scheme.base:list->bytevector"
  ret i64 %t1331
}

define i64 @"scheme.base:__init_64"() {
entry:
  %t1350 = call i64 @rt_alloc_words(i64 1)
  %t1351 = inttoptr i64 %t1350 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_356" to i64), ptr %t1351
  %t1352 = or i64 %t1350, 4
  %t1353 = call i64 @rt_root(i64 %t1352)
  store i64 %t1353, ptr @"scheme.base:bytevector"
  ret i64 %t1353
}

define i64 @"scheme.base:__init_65"() {
entry:
  %t1354 = call i64 @rt_root(i64 64)
  store i64 %t1354, ptr @"scheme.base:%ht-initial-buckets"
  ret i64 %t1354
}

define i64 @"scheme.base:__init_66"() {
entry:
  %t1355 = call i64 @rt_root(i64 24)
  store i64 %t1355, ptr @"scheme.base:%ht-load-factor"
  ret i64 %t1355
}

define i64 @"scheme.base:__init_67"() {
entry:
  %t1366 = call i64 @rt_alloc_words(i64 1)
  %t1367 = inttoptr i64 %t1366 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_358" to i64), ptr %t1367
  %t1368 = or i64 %t1366, 4
  %t1369 = call i64 @rt_root(i64 %t1368)
  store i64 %t1369, ptr @"scheme.base:make-hash-table"
  ret i64 %t1369
}

define i64 @"scheme.base:__init_68"() {
entry:
  %t1372 = call i64 @rt_alloc_words(i64 1)
  %t1373 = inttoptr i64 %t1372 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_361" to i64), ptr %t1373
  %t1374 = or i64 %t1372, 4
  %t1375 = call i64 @rt_root(i64 %t1374)
  store i64 %t1375, ptr @"scheme.base:hash-table?"
  ret i64 %t1375
}

define i64 @"scheme.base:__init_69"() {
entry:
  %t1379 = call i64 @rt_alloc_words(i64 1)
  %t1380 = inttoptr i64 %t1379 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_364" to i64), ptr %t1380
  %t1381 = or i64 %t1379, 4
  %t1382 = call i64 @rt_root(i64 %t1381)
  store i64 %t1382, ptr @"scheme.base:%ht-count"
  ret i64 %t1382
}

define i64 @"scheme.base:__init_70"() {
entry:
  %t1386 = call i64 @rt_alloc_words(i64 1)
  %t1387 = inttoptr i64 %t1386 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_367" to i64), ptr %t1387
  %t1388 = or i64 %t1386, 4
  %t1389 = call i64 @rt_root(i64 %t1388)
  store i64 %t1389, ptr @"scheme.base:%ht-buckets"
  ret i64 %t1389
}

define i64 @"scheme.base:__init_71"() {
entry:
  %t1393 = call i64 @rt_alloc_words(i64 1)
  %t1394 = inttoptr i64 %t1393 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_371" to i64), ptr %t1394
  %t1395 = or i64 %t1393, 4
  %t1396 = call i64 @rt_root(i64 %t1395)
  store i64 %t1396, ptr @"scheme.base:%ht-set-count!"
  ret i64 %t1396
}

define i64 @"scheme.base:__init_72"() {
entry:
  %t1400 = call i64 @rt_alloc_words(i64 1)
  %t1401 = inttoptr i64 %t1400 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_375" to i64), ptr %t1401
  %t1402 = or i64 %t1400, 4
  %t1403 = call i64 @rt_root(i64 %t1402)
  store i64 %t1403, ptr @"scheme.base:%ht-set-buckets!"
  ret i64 %t1403
}

define i64 @"scheme.base:__init_73"() {
entry:
  %t1407 = call i64 @rt_alloc_words(i64 1)
  %t1408 = inttoptr i64 %t1407 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_379" to i64), ptr %t1408
  %t1409 = or i64 %t1407, 4
  %t1410 = call i64 @rt_root(i64 %t1409)
  store i64 %t1410, ptr @"scheme.base:%ht-index"
  ret i64 %t1410
}

define i64 @"scheme.base:__init_74"() {
entry:
  %t1426 = call i64 @rt_alloc_words(i64 1)
  %t1427 = inttoptr i64 %t1426 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_383" to i64), ptr %t1427
  %t1428 = or i64 %t1426, 4
  %t1429 = call i64 @rt_root(i64 %t1428)
  store i64 %t1429, ptr @"scheme.base:%ht-assoc"
  ret i64 %t1429
}

define i64 @"scheme.base:__init_75"() {
entry:
  %t1447 = call i64 @rt_alloc_words(i64 1)
  %t1448 = inttoptr i64 %t1447 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_387" to i64), ptr %t1448
  %t1449 = or i64 %t1447, 4
  %t1450 = call i64 @rt_root(i64 %t1449)
  store i64 %t1450, ptr @"scheme.base:%ht-remove"
  ret i64 %t1450
}

define i64 @"scheme.base:__init_76"() {
entry:
  %t1474 = call i64 @rt_alloc_words(i64 1)
  %t1475 = inttoptr i64 %t1474 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_394" to i64), ptr %t1475
  %t1476 = or i64 %t1474, 4
  %t1477 = call i64 @rt_root(i64 %t1476)
  store i64 %t1477, ptr @"scheme.base:hash-table-ref/default"
  ret i64 %t1477
}

define i64 @"scheme.base:__init_77"() {
entry:
  %t1500 = call i64 @rt_alloc_words(i64 1)
  %t1501 = inttoptr i64 %t1500 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_399" to i64), ptr %t1501
  %t1502 = or i64 %t1500, 4
  %t1503 = call i64 @rt_root(i64 %t1502)
  store i64 %t1503, ptr @"scheme.base:hash-table-contains?"
  ret i64 %t1503
}

define i64 @"scheme.base:__init_78"() {
entry:
  %t1534 = call i64 @rt_alloc_words(i64 1)
  %t1535 = inttoptr i64 %t1534 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_405" to i64), ptr %t1535
  %t1536 = or i64 %t1534, 4
  %t1537 = call i64 @rt_root(i64 %t1536)
  store i64 %t1537, ptr @"scheme.base:hash-table-ref"
  ret i64 %t1537
}

define i64 @"scheme.base:__init_79"() {
entry:
  %t1600 = call i64 @rt_alloc_words(i64 1)
  %t1601 = inttoptr i64 %t1600 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_419" to i64), ptr %t1601
  %t1602 = or i64 %t1600, 4
  %t1603 = call i64 @rt_root(i64 %t1602)
  store i64 %t1603, ptr @"scheme.base:hash-table-set!"
  ret i64 %t1603
}

define i64 @"scheme.base:__init_80"() {
entry:
  %t1646 = call i64 @rt_alloc_words(i64 1)
  %t1647 = inttoptr i64 %t1646 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_426" to i64), ptr %t1647
  %t1648 = or i64 %t1646, 4
  %t1649 = call i64 @rt_root(i64 %t1648)
  store i64 %t1649, ptr @"scheme.base:hash-table-delete!"
  ret i64 %t1649
}

define i64 @"scheme.base:__init_81"() {
entry:
  %t1756 = call i64 @rt_alloc_words(i64 1)
  %t1757 = inttoptr i64 %t1756 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_442" to i64), ptr %t1757
  %t1758 = or i64 %t1756, 4
  %t1759 = call i64 @rt_root(i64 %t1758)
  store i64 %t1759, ptr @"scheme.base:%ht-grow!"
  ret i64 %t1759
}

define i64 @"scheme.base:__init_82"() {
entry:
  %t1767 = call i64 @rt_alloc_words(i64 1)
  %t1768 = inttoptr i64 %t1767 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_449" to i64), ptr %t1768
  %t1769 = or i64 %t1767, 4
  %t1770 = call i64 @rt_root(i64 %t1769)
  store i64 %t1770, ptr @"scheme.base:hash-table-size"
  ret i64 %t1770
}

define i64 @"scheme.base:__init_83"() {
entry:
  %t1787 = call i64 @rt_alloc_words(i64 1)
  %t1788 = inttoptr i64 %t1787 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_453" to i64), ptr %t1788
  %t1789 = or i64 %t1787, 4
  %t1790 = call i64 @rt_root(i64 %t1789)
  store i64 %t1790, ptr @"scheme.base:%ht-fold-buckets"
  ret i64 %t1790
}

define i64 @"scheme.base:__init_84"() {
entry:
  %t1837 = call i64 @rt_alloc_words(i64 1)
  %t1838 = inttoptr i64 %t1837 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_464" to i64), ptr %t1838
  %t1839 = or i64 %t1837, 4
  %t1840 = call i64 @rt_root(i64 %t1839)
  store i64 %t1840, ptr @"scheme.base:hash-table->alist"
  ret i64 %t1840
}

define i64 @"scheme.base:__init_85"() {
entry:
  %t1859 = call i64 @rt_alloc_words(i64 1)
  %t1860 = inttoptr i64 %t1859 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_470" to i64), ptr %t1860
  %t1861 = or i64 %t1859, 4
  %t1862 = call i64 @rt_root(i64 %t1861)
  store i64 %t1862, ptr @"scheme.base:hash-table-keys"
  ret i64 %t1862
}

define i64 @"scheme.base:__init_86"() {
entry:
  %t1881 = call i64 @rt_alloc_words(i64 1)
  %t1882 = inttoptr i64 %t1881 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_476" to i64), ptr %t1882
  %t1883 = or i64 %t1881, 4
  %t1884 = call i64 @rt_root(i64 %t1883)
  store i64 %t1884, ptr @"scheme.base:hash-table-values"
  ret i64 %t1884
}

define i64 @"scheme.base:__init_87"() {
entry:
  %t1894 = call i64 @rt_alloc_words(i64 1)
  %t1895 = inttoptr i64 %t1894 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_504" to i64), ptr %t1895
  %t1896 = or i64 %t1894, 4
  %t1897 = call i64 @rt_root(i64 %t1896)
  store i64 %t1897, ptr @"scheme.base:rd-ws?"
  ret i64 %t1897
}

define i64 @"scheme.base:__init_88"() {
entry:
  %t1903 = call i64 @rt_alloc_words(i64 1)
  %t1904 = inttoptr i64 %t1903 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_516" to i64), ptr %t1904
  %t1905 = or i64 %t1903, 4
  %t1906 = call i64 @rt_root(i64 %t1905)
  store i64 %t1906, ptr @"scheme.base:rd-digit?"
  ret i64 %t1906
}

define i64 @"scheme.base:__init_89"() {
entry:
  %t1927 = call i64 @rt_alloc_words(i64 1)
  %t1928 = inttoptr i64 %t1927 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_556" to i64), ptr %t1928
  %t1929 = or i64 %t1927, 4
  %t1930 = call i64 @rt_root(i64 %t1929)
  store i64 %t1930, ptr @"scheme.base:rd-delim?"
  ret i64 %t1930
}

define i64 @"scheme.base:__init_90"() {
entry:
  %t1946 = call i64 @rt_alloc_words(i64 1)
  %t1947 = inttoptr i64 %t1946 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_569" to i64), ptr %t1947
  %t1948 = or i64 %t1946, 4
  %t1949 = call i64 @rt_root(i64 %t1948)
  store i64 %t1949, ptr @"scheme.base:rd-skip-line"
  ret i64 %t1949
}

define i64 @"scheme.base:__init_91"() {
entry:
  %t1984 = call i64 @rt_alloc_words(i64 1)
  %t1985 = inttoptr i64 %t1984 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_583" to i64), ptr %t1985
  %t1986 = or i64 %t1984, 4
  %t1987 = call i64 @rt_root(i64 %t1986)
  store i64 %t1987, ptr @"scheme.base:rd-skip-ws"
  ret i64 %t1987
}

define i64 @"scheme.base:__init_92"() {
entry:
  %t2006 = call i64 @rt_alloc_words(i64 1)
  %t2007 = inttoptr i64 %t2006 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_592" to i64), ptr %t2007
  %t2008 = or i64 %t2006, 4
  %t2009 = call i64 @rt_root(i64 %t2008)
  store i64 %t2009, ptr @"scheme.base:rd-token-end"
  ret i64 %t2009
}

define i64 @"scheme.base:__init_93"() {
entry:
  %t2028 = call i64 @rt_alloc_words(i64 1)
  %t2029 = inttoptr i64 %t2028 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_601" to i64), ptr %t2029
  %t2030 = or i64 %t2028, 4
  %t2031 = call i64 @rt_root(i64 %t2030)
  store i64 %t2031, ptr @"scheme.base:rd-all-digits?"
  ret i64 %t2031
}

define i64 @"scheme.base:__init_94"() {
entry:
  %t2065 = call i64 @rt_alloc_words(i64 1)
  %t2066 = inttoptr i64 %t2065 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_624" to i64), ptr %t2066
  %t2067 = or i64 %t2065, 4
  %t2068 = call i64 @rt_root(i64 %t2067)
  store i64 %t2068, ptr @"scheme.base:rd-numeric?"
  ret i64 %t2068
}

define i64 @"scheme.base:__init_95"() {
entry:
  %t2084 = call i64 @rt_alloc_words(i64 1)
  %t2085 = inttoptr i64 %t2084 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_634" to i64), ptr %t2085
  %t2086 = or i64 %t2084, 4
  %t2087 = call i64 @rt_root(i64 %t2086)
  store i64 %t2087, ptr @"scheme.base:rd-digits"
  ret i64 %t2087
}

define i64 @"scheme.base:__init_96"() {
entry:
  %t2115 = call i64 @rt_alloc_words(i64 1)
  %t2116 = inttoptr i64 %t2115 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_647" to i64), ptr %t2116
  %t2117 = or i64 %t2115, 4
  %t2118 = call i64 @rt_root(i64 %t2117)
  store i64 %t2118, ptr @"scheme.base:rd-parse-int"
  ret i64 %t2118
}

define i64 @"scheme.base:__init_97"() {
entry:
  %t2143 = call i64 @rt_alloc_words(i64 1)
  %t2144 = inttoptr i64 %t2143 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_654" to i64), ptr %t2144
  %t2145 = or i64 %t2143, 4
  %t2146 = call i64 @rt_root(i64 %t2145)
  store i64 %t2146, ptr @"scheme.base:rd-atom"
  ret i64 %t2146
}

define i64 @"scheme.base:__init_98"() {
entry:
  %t2167 = call i64 @rt_alloc_words(i64 1)
  %t2168 = inttoptr i64 %t2167 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_682" to i64), ptr %t2168
  %t2169 = or i64 %t2167, 4
  %t2170 = call i64 @rt_root(i64 %t2169)
  store i64 %t2170, ptr @"scheme.base:rd-hex-digit"
  ret i64 %t2170
}

define i64 @"scheme.base:__init_99"() {
entry:
  %t2197 = call i64 @rt_alloc_words(i64 1)
  %t2198 = inttoptr i64 %t2197 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_696" to i64), ptr %t2198
  %t2199 = or i64 %t2197, 4
  %t2200 = call i64 @rt_root(i64 %t2199)
  store i64 %t2200, ptr @"scheme.base:rd-hex"
  ret i64 %t2200
}

define i64 @"scheme.base:__init_100"() {
entry:
  %t2212 = call i64 @rt_alloc_words(i64 1)
  %t2213 = inttoptr i64 %t2212 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_712" to i64), ptr %t2213
  %t2214 = or i64 %t2212, 4
  %t2215 = call i64 @rt_root(i64 %t2214)
  store i64 %t2215, ptr @"scheme.base:rd-str-esc"
  ret i64 %t2215
}

define i64 @"scheme.base:__init_101"() {
entry:
  %t2327 = call i64 @rt_alloc_words(i64 1)
  %t2328 = inttoptr i64 %t2327 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_740" to i64), ptr %t2328
  %t2329 = or i64 %t2327, 4
  %t2330 = call i64 @rt_root(i64 %t2329)
  store i64 %t2330, ptr @"scheme.base:rd-string"
  ret i64 %t2330
}

define i64 @"scheme.base:__init_102"() {
entry:
  %t2411 = call i64 @rt_alloc_words(i64 1)
  %t2412 = inttoptr i64 %t2411 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_783" to i64), ptr %t2412
  %t2413 = or i64 %t2411, 4
  %t2414 = call i64 @rt_root(i64 %t2413)
  store i64 %t2414, ptr @"scheme.base:rd-hash"
  ret i64 %t2414
}

define i64 @"scheme.base:__init_103"() {
entry:
  %t2453 = call i64 @rt_alloc_words(i64 1)
  %t2454 = inttoptr i64 %t2453 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_786" to i64), ptr %t2454
  %t2455 = or i64 %t2453, 4
  %t2456 = call i64 @rt_root(i64 %t2455)
  store i64 %t2456, ptr @"scheme.base:rd-char-name"
  ret i64 %t2456
}

define i64 @"scheme.base:__init_104"() {
entry:
  %t2479 = call i64 @rt_alloc_words(i64 1)
  %t2480 = inttoptr i64 %t2479 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_798" to i64), ptr %t2480
  %t2481 = or i64 %t2479, 4
  %t2482 = call i64 @rt_root(i64 %t2481)
  store i64 %t2482, ptr @"scheme.base:rd-char"
  ret i64 %t2482
}

define i64 @"scheme.base:__init_105"() {
entry:
  %t2506 = call i64 @rt_alloc_words(i64 1)
  %t2507 = inttoptr i64 %t2506 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_805" to i64), ptr %t2507
  %t2508 = or i64 %t2506, 4
  %t2509 = call i64 @rt_root(i64 %t2508)
  store i64 %t2509, ptr @"scheme.base:rd-quote"
  ret i64 %t2509
}

define i64 @"scheme.base:__init_106"() {
entry:
  %t2533 = call i64 @rt_alloc_words(i64 1)
  %t2534 = inttoptr i64 %t2533 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_812" to i64), ptr %t2534
  %t2535 = or i64 %t2533, 4
  %t2536 = call i64 @rt_root(i64 %t2535)
  store i64 %t2536, ptr @"scheme.base:rd-quasi"
  ret i64 %t2536
}

define i64 @"scheme.base:__init_107"() {
entry:
  %t2590 = call i64 @rt_alloc_words(i64 1)
  %t2591 = inttoptr i64 %t2590 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_829" to i64), ptr %t2591
  %t2592 = or i64 %t2590, 4
  %t2593 = call i64 @rt_root(i64 %t2592)
  store i64 %t2593, ptr @"scheme.base:rd-unquote"
  ret i64 %t2593
}

define i64 @"scheme.base:__init_108"() {
entry:
  %t2608 = call i64 @rt_alloc_words(i64 1)
  %t2609 = inttoptr i64 %t2608 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_842" to i64), ptr %t2609
  %t2610 = or i64 %t2608, 4
  %t2611 = call i64 @rt_root(i64 %t2610)
  store i64 %t2611, ptr @"scheme.base:rd-dot?"
  ret i64 %t2611
}

define i64 @"scheme.base:__init_109"() {
entry:
  %t2624 = call i64 @rt_alloc_words(i64 1)
  %t2625 = inttoptr i64 %t2624 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_846" to i64), ptr %t2625
  %t2626 = or i64 %t2624, 4
  %t2627 = call i64 @rt_root(i64 %t2626)
  store i64 %t2627, ptr @"scheme.base:rd-append-reverse"
  ret i64 %t2627
}

define i64 @"scheme.base:__init_110"() {
entry:
  %t2710 = call i64 @rt_alloc_words(i64 1)
  %t2711 = inttoptr i64 %t2710 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_871" to i64), ptr %t2711
  %t2712 = or i64 %t2710, 4
  %t2713 = call i64 @rt_root(i64 %t2712)
  store i64 %t2713, ptr @"scheme.base:rd-list"
  ret i64 %t2713
}

define i64 @"scheme.base:__init_111"() {
entry:
  %t2786 = call i64 @rt_alloc_words(i64 1)
  %t2787 = inttoptr i64 %t2786 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_905" to i64), ptr %t2787
  %t2788 = or i64 %t2786, 4
  %t2789 = call i64 @rt_root(i64 %t2788)
  store i64 %t2789, ptr @"scheme.base:rd-datum"
  ret i64 %t2789
}

define i64 @"scheme.base:__init_112"() {
entry:
  %t2805 = call i64 @rt_alloc_words(i64 1)
  %t2806 = inttoptr i64 %t2805 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_909" to i64), ptr %t2806
  %t2807 = or i64 %t2805, 4
  %t2808 = call i64 @rt_root(i64 %t2807)
  store i64 %t2808, ptr @"scheme.base:read-from-string"
  ret i64 %t2808
}

define i64 @"scheme.base:__init_113"() {
entry:
  %t2881 = call i64 @rt_alloc_words(i64 1)
  %t2882 = inttoptr i64 %t2881 to ptr
  store i64 ptrtoint (ptr @"scheme.base:code_921" to i64), ptr %t2882
  %t2883 = or i64 %t2881, 4
  %t2884 = call i64 @rt_root(i64 %t2883)
  store i64 %t2884, ptr @"scheme.base:read-all-from-string"
  ret i64 %t2884
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

