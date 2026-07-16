;;; core.ss -- the pure compiler core: source forms (or text) -> LLVM IR text.
;;;
;;; This is the self-hosting target: text in -> IR text out.  It performs NO
;;; file, subprocess, or external-port I/O.  Everything effectful -- reading the
;;; source file, reading the prelude, supplying the host target-triple header,
;;; writing the .ll, and invoking the C toolchain / JIT -- lives in the driver
;;; (compile.ss).  Keeping that surface out of the core means self-hosting never
;;; has to bring the filesystem or subprocess API into the language.
;;;
;;; FLAT SOURCE (change: self-hosting-completion): this file is concatenation-
;;; ready.  The passes are NOT `(include ...)`d here -- they are separate flat
;;; files concatenated ahead of this one by the ordered-`cat` assembly (see the
;;; Makefile `regen` recipe / `src/README.md`).  The reader is the in-language
;;; `read-all-from-string` (defined in the prelude), so the core needs no ports.
;;; The Chez-hosted driver/tests include the same flat files (no separate library
;;; tree), so there is one live source.

;; --- reader (self-hostable; no ports) ------------------------------------
;; `read-all-from-string` is provided by the prelude (which is prepended to every
;; program the compiler compiles, including the compiler's own source).
(define (read-forms-from-string str) (read-all-from-string str))

;; --- prelude assembly (pure list ops over already-read forms) ------------

;; name defined by a top-level (define ...) form, or #f for a non-define form
(define (define-name f)
  (and (pair? f) (eq? (car f) 'define)
       (let ([sig (cadr f)]) (if (pair? sig) (car sig) sig))))

;; prepend prelude forms to the user's, dropping any prelude define whose name
;; the user also defines (user-wins shadowing, so the prelude never clobbers).
(define (with-prelude prelude-forms user-forms)
  (let ([user-names (filter (lambda (x) x) (map define-name user-forms))])
    (append
      (filter (lambda (f)
                (let ([n (define-name f)])
                  (not (and n (memq n user-names)))))
              prelude-forms)
      user-forms)))

;; names bound at the top level (prelude + program), used both as the hygiene
;; "known bindings" set and, with the fixed keyword/primitive sets, to decide
;; which template identifiers a macro is allowed to introduce.
(define (compute-known macro-env runtime-forms)
  (union* (list *core-keywords* *prims* *extra-op-keywords*
                (map car macro-env)
                (filter (lambda (x) x) (map define-name runtime-forms)))))

;; --- the pipeline: forms -> IR text (no target header) -------------------
;; `dump` is an injected side-channel: the driver passes an effectful stderr
;; dumper under --dump; every other caller passes `no-dump` so the core stays
;; pure.  The core never touches a port itself.
(define (no-dump stage form) (if #f #f))

(define (compile-forms forms dump)
  (reset-counter!)
  (let* ([me+rf (collect-define-syntax forms)]
         [macro-env (car me+rf)] [runtime-forms (cadr me+rf)])
    (let* ([known (compute-known macro-env runtime-forms)]
           [top   (collect-toplevel runtime-forms)]
           [expd  (expand top macro-env known)]
           [core  (rename-program (parse-program expd))]
           [a     (recognize-let core)]
           [b     (convert-assignments a)]
           [c     (convert-closures b)]
           [d     (lower-program c program-unit)])
      (dump "collect-toplevel" top) (dump "expand" expd)
      (dump "parse+rename" core) (dump "recognize-let" a)
      (dump "convert-assignments" b) (dump "convert-closures" c) (dump "lower" d)
      (emit-program d))))

;; a source whose only top-level form is a (define-library ...) is a library unit
;; (change: module-artifacts-vertical-slice); it compiles to a unit module, not a
;; program, through the SAME embedded --emit path programs use -- so a unit's bytes
;; are identical whether emitted for the AOT door or loaded into the REPL door.
(define (single-define-library forms)
  (and (pair? forms) (null? (cdr forms)) (define-library-form? (car forms))
       (car forms)))
;; The lone-define-library filter path (scheme-run --emit / compile-source-string)
;; has no manifest, so it resolves no imports: import-free libraries only (a library
;; with imports is built through build-modular-program / the REPL preload, which
;; supply its dependencies' export tables).  import-tables is '() here.
(define (compile-library-form form dump)
  (let ([dl (parse-define-library form)])
    (car (compile-library (car dl) (cadr dl) (caddr dl) (cadddr dl) '() dump))))

;; convenience: source text -> IR text (no prelude, no header).  This is the
;; core's self-hosting-facing contract; the driver adds prelude/header/toolchain.
(define (compile-source-string str)
  (let ([forms (read-forms-from-string str)])
    (cond
      [(single-define-library forms) => (lambda (lib) (compile-library-form lib no-dump))]
      [else (compile-forms forms no-dump)])))

;; source text + prelude text -> IR text (no header).  The prelude-aware sibling
;; of compile-source-string: it applies the same user-wins shadowing the batch
;; driver does (with-prelude), but takes the prelude as *text* rather than
;; reading a file, so it stays free of filesystem/subprocess I/O.  Used by the
;; embedded compiler (change: path-a-embedding), whose entry bakes the prelude
;; source in as a string constant and passes the user program on stdin.  A lone
;; define-library is compiled as a unit (prelude-free in Stage 1).
(define (compile-source-with-prelude prelude-str user-str)
  (let ([forms (read-forms-from-string user-str)])
    (cond
      [(single-define-library forms) => (lambda (lib) (compile-library-form lib no-dump))]
      [else
       (compile-forms
         (with-prelude (read-forms-from-string prelude-str) forms)
         no-dump)])))

;; --- prelude re-homed as (scheme base) for the embedded runner (change:
;; embedded-runner-rehome) ---------------------------------------------------
;; The Chez-free runner (scheme-run / scheme-compile) re-homes the prelude the way
;; the Chez driver does, but with no manifest and no filesystem: it builds the
;; (scheme base) library from the BAKED-IN prelude source, compiles it to a unit,
;; and compiles the user program auto-importing it.  A program and a library each
;; emit a fixed @__apply0 and string globals from a reset counter, which would
;; collide in a single LLVM module, so the two modules are returned SEPARATELY,
;; joined by a boundary marker the host splits on -- mirroring the driver's
;; separate-unit linking, so the emitted program module is byte-identical to the
;; driver's prog.ll.

;; A line that cannot occur in emitted core IR (the core emits no `;` comments),
;; so the host splits the two modules unambiguously.
(define *emit-unit-boundary* "; ==EMIT-UNIT-BOUNDARY==\n")

;; Build the (scheme base) define-library form from the prelude's forms: every
;; top-level (define NAME ...) is exported; ALL prelude forms (procedures + the
;; derived-form macros) stay in the body, so the library self-compiles and its
;; macros are lifted into the unit's compile-time macro-env.  Mirrors
;; tools/gen-scheme-base.ss exactly, but in the portable core -- the baked-in
;; prelude source is the single source of truth, so no lib/scheme/base.sld read.
;; Built with cons/list (not quasiquote) to stay in the plainest self-hostable
;; subset.
(define (scheme-base-library-form prelude-forms)
  (cons 'define-library
        (cons '(scheme base)
              (cons (cons 'export (filter (lambda (x) x) (map define-name prelude-forms)))
                    (list (cons 'begin prelude-forms))))))

;; the prelude's derived-form macros (its compile-time half), merged into a user
;; program's macro-env at expand time -- the same set the Chez driver merges.
(define (prelude-macro-forms prelude-forms)
  (filter (lambda (f) (and (pair? f) (eq? (car f) 'define-syntax))) prelude-forms))

;; source text + prelude text -> two IR modules (no header) joined by the boundary
;; marker: the (scheme base) library IR, the marker, then the program IR (which
;; references scheme.base:* as external globals).  The re-homed sibling of
;; compile-source-with-prelude: instead of prepending the prelude's definitions it
;; compiles (scheme base) from the baked-in prelude source and compiles the program
;; importing it via compile-program-with-imports -- the SAME core path the Chez
;; driver drives, so the program module is byte-identical to the driver's.  A lone
;; define-library is still compiled as one unit (a library does not auto-import the
;; prelude), returning a single module with no marker.
(define (compile-source-rehomed prelude-str user-str)
  (let ([user-forms (read-forms-from-string user-str)])
    (cond
      [(single-define-library user-forms) => (lambda (lib) (compile-library-form lib no-dump))]
      [else
       (let* ([prelude-forms (read-forms-from-string prelude-str)]
              [dl         (parse-define-library (scheme-base-library-form prelude-forms))]
              [base-res   (compile-library (car dl) (cadr dl) (caddr dl) (cadddr dl) '() no-dump)]
              [base-ir    (car base-res)]
              [base-table (cadr base-res)]
              [prog-ir    (compile-program-with-imports
                            (prelude-macro-forms prelude-forms)
                            user-forms (list base-table)
                            (list '(scheme base)) no-dump)])
         (string-append base-ir *emit-unit-boundary* prog-ir))])))

;; shared back half of the pipeline for one core-IL expression.  The REPL feeds
;; forms through this incrementally (against a persistent env); batch compilation
;; runs the same passes over a whole program in `compile-forms`.
(define (repl-lcode il)
  (lower-program (convert-closures (convert-assignments (recognize-let il))) program-unit))

;; ============================================================================
;; Module artifacts: define-library / import / export (change:
;; module-artifacts-vertical-slice).  The pure core turns forms + an in-memory
;; import environment into IR text + an export table; the driver/host owns all
;; file/manifest/link effects.
;; ============================================================================

(define (define-library-form? f) (and (pair? f) (eq? (car f) 'define-library)))
(define (import-form? f) (and (pair? f) (eq? (car f) 'import)))

;; An export spec is either a bare name `n` or a rename `(rename internal external)`
;; (change: module-generalize).  Normalize each to a pair (external . internal): the
;; external name is what importers see (the export-table key); the internal name is
;; what the library defines and what the emitted symbol is based on.  A bare name is
;; (n . n).  The symbol is ALWAYS the internal name, so rename is pure table
;; indirection with no new emission logic.
(define (normalize-export spec)
  (if (pair? spec)                          ; (rename internal external)
      (cons (caddr spec) (cadr spec))       ; (external . internal)
      (cons spec spec)))                    ; bare: external == internal

;; (define-library (name ...) decl ...) -> (list name imports exports body-forms).
;; decls: (export spec ...) | (import (L) ...) | (begin form ...) | a bare form.
;; Each export is normalized to an (external . internal) pair (see normalize-export).
(define (parse-define-library form)
  (let ([name (cadr form)])
    (let loop ([ds (cddr form)] [imps '()] [exps '()] [body '()])
      (if (null? ds)
          (list name (reverse imps) (reverse exps) (reverse body))
          (let ([d (car ds)])
            (cond
              [(and (pair? d) (eq? (car d) 'export))
               (loop (cdr ds) imps (append (reverse (map normalize-export (cdr d))) exps) body)]
              [(and (pair? d) (eq? (car d) 'import))
               (loop (cdr ds) (append (reverse (cdr d)) imps) exps body)]
              [(and (pair? d) (eq? (car d) 'begin))
               (loop (cdr ds) imps exps (append (reverse (cdr d)) body))]
              [else (loop (cdr ds) imps exps (cons d body))]))))))

;; Split a program's top-level forms into (list imported-libs runtime-forms);
;; each imported-lib is a library name like (mylib).
(define (collect-imports forms)
  (let loop ([fs forms] [imps '()] [rt '()])
    (cond
      [(null? fs) (list (reverse imps) (reverse rt))]
      [(import-form? (car fs)) (loop (cdr fs) (append (reverse (cdr (car fs))) imps) rt)]
      [else (loop (cdr fs) imps (cons (car fs) rt))])))

;; expand one top-level form (define init, or a bare expression) against macro-env
(define (expand-unit-form f macro-env known)
  (if (and (pair? f) (eq? (car f) 'define))
      (let ([nd (normalize-define f)])
        `(define ,(car nd) ,(expand (cadr nd) macro-env known)))
      (expand f macro-env known)))

;; lower one core-IL expression for a unit named `unit` (code labels get @"L:..").
(define (unit-lcode il unit)
  (lower-program (convert-closures (convert-assignments (recognize-let il))) unit))

;; An import environment is an alist external-name -> mangled-symbol, built from a
;; list of imported libraries' export tables (each `(name ((ext . mangled) ...))`,
;; as returned by compile-library).  The mangled string is interned to a symbol so
;; resolution can emit it as a (global-ref sym); because that symbol is already
;; unit-qualified (`b:add1`), emit does not re-mangle it and it becomes an external
;; global.  Shared by compile-library (transitive lib->lib imports) and
;; compile-program-with-imports (change: module-generalize).
(define (import-tables->env-alist import-tables)
  (map (lambda (p) (cons (car p) (string->symbol (cdr p))))
       (apply append (map cadr import-tables))))

;; Compile a library's declarations into (list ir-text export-table).
;;   name          : library name (list of symbol parts)
;;   exports       : (external . internal) pairs (see normalize-export)
;;   body-forms    : the library's top-level defines (a mutually-recursive group)
;;   import-tables : the export tables of the libraries THIS library imports (its
;;                   direct dependencies); '() for an import-free library.
;; export-table : (list name ((external-name . mangled-string) ...)).
;; A library may import other libraries (change: module-generalize): its body
;; resolves those imports' exports as external globals, exactly as a program does.
;; Libraries do not share the prelude (that is Stage 3), so the body uses
;; primitives / core forms / imported bindings only.
(define (compile-library name imports exports body-forms import-tables dump)
  (reset-counter!)
  (let* ([me+rf (collect-define-syntax body-forms)]
         [macro-env (car me+rf)]
         [runtime (cadr me+rf)]
         [import-env-alist (import-tables->env-alist import-tables)]
         ;; imported external names are "known" too (see compile-program-with-imports),
         ;; so a macro introducing one is not hygiene-renamed away.
         [known (union (compute-known macro-env runtime) (map car import-env-alist))]
         [defs  (filter define-form? runtime)]
         [defined-names (map (lambda (p) (car (normalize-define p))) defs)]
         [env   (make-repl-env)])
    ;; validate each export's INTERNAL name is defined at the library's top level.
    (for-each
      (lambda (e)
        (unless (memq (cdr e) defined-names)
          (error 'compile-library "export of a name the library does not define" (cdr e))))
      exports)
    ;; seed the import environment FIRST, so the unit's own defines (registered
    ;; next, consed on top) shadow an imported name of the same spelling.
    (vector-set! env 0 import-env-alist)
    ;; phase 1: register every top-level define (plain names) for mutual reference
    (for-each (lambda (f) (unit-register-define! env f)) defs)
    ;; phase 2: lower each define body as one mutually-recursive group (register? #f).
    ;; Use fold-left (left-to-right in BOTH hosts), not map: the gensym counter is
    ;; mutated per form, and Chez's map vs the prelude's map apply in different
    ;; orders -- which would diverge the AOT-door and REPL-door units.  fold-left
    ;; keeps a library's emitted bytes identical across doors (dev->ship fidelity).
    (let ([progs (reverse
                   (fold-left
                     (lambda (acc f)
                       (cons (unit-lcode (repl-lower-form* env (expand-unit-form f macro-env known) #f) name)
                             acc))
                     (quote ()) defs))]
          ;; export table keys on the EXTERNAL name; the symbol is the INTERNAL name
          ;; mangled to this unit (rename is pure indirection).
          [export-table (map (lambda (e) (cons (car e) (mangle name (cdr e)))) exports)])
      (list (emit-library-batch progs name) (list name export-table)))))

;; Compile a program that imports libraries.  import-tables is a list of the
;; program's DIRECT imports' export tables (as returned by compile-library); the
;; program resolves imported free identifiers to the exporter's external globals.
;; init-libs is the WHOLE transitive import closure in dependency (topological)
;; order (change: module-generalize) -- the units whose one-shot __init the
;; program's @scheme_entry runs, deepest dependency first, before the body.  When
;; init-libs is #f the program's direct imports are used (single-stage callers).
;; Returns IR text.
(define (compile-program-with-imports prelude-forms user-forms import-tables init-libs dump)
  (let* ([imp+rt (collect-imports user-forms)]
         [imported-libs (car imp+rt)]
         [runtime-user (cadr imp+rt)]
         [import-env-alist (import-tables->env-alist import-tables)] ; (ext . mangled-sym)
         [forms (with-prelude prelude-forms runtime-user)])
    (reset-counter!)
    (let* ([me+rf (collect-define-syntax forms)]
           [macro-env (car me+rf)] [runtime (cadr me+rf)]
           ;; Imported external names are "known" bindings too, so a derived-form
           ;; macro (e.g. `case`) may introduce a reference to one (e.g. `memv`)
           ;; without hygiene renaming it away (change: module-prelude-scheme-base).
           [known (union (compute-known macro-env runtime) (map car import-env-alist))]
           [top   (collect-toplevel runtime)]
           [expd  (expand top macro-env known)]
           [core0 (rename-program (parse-program expd))]
           [core  (if (null? import-env-alist)
                      core0
                      (resolve-globals core0 (vector import-env-alist 0)))]
           [a (recognize-let core)]
           [b (convert-assignments a)]
           [c (convert-closures b)]
           [d (lower-program c program-unit)])
      (dump "collect-toplevel" top) (dump "expand" expd)
      (dump "parse+rename+imports" core) (dump "lower" d)
      (emit-program-with-imports d (or init-libs imported-libs) (map cdr import-env-alist)))))
