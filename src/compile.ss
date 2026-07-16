;;; compile.ss -- driver for the core-lambda-slice compiler.
;;;
;;; Usage (run from the repo root):
;;;   chez --libdirs src --script src/compile.ss SRC.scm [-o OUT] [--dump]
;;;
;;; Reads the top-level forms from SRC.scm (a sequence of `define`s and
;;; expressions), runs the pipeline (dumping the IL after each stage to stderr
;;; with --dump), emits OUT.ll, and links it with the C runtime + libgc into the
;;; executable OUT.

(import (chezscheme))

;; The Chez-hosted driver includes the SAME flat source the Chez-free `cat`
;; assembly concatenates (change: self-hosting-completion) -- there is no separate
;; `(library ...)` tree to maintain.  `match`/`util` are flat files (no library
;; wrapper), the passes are flat, and `core.ss` no longer `(include ...)`s them,
;; so the driver concatenates them here in the same order the `regen` recipe does.
;; This file remains the driver: it owns every effect -- file reads/writes, the
;; host target header, and the toolchain/JIT -- and delegates forms->IR to core.
(include "src/match.scm")
(include "src/util.scm")
(include "src/parse.ss")
(include "src/passes/expand.ss")
(include "src/passes/recognize-let.ss")
(include "src/passes/convert-assignments.ss")
(include "src/passes/convert-closures.ss")
(include "src/passes/lower.ss")
(include "src/emit.ss")
(include "src/core.ss")

;; Port-based reader (Chez I/O; the driver owns effects).  `core.ss` no longer
;; defines this -- the self-hostable core has no ports -- so the driver supplies
;; the port reader it needs to slurp source files and stdin.
(define (read-forms port)   ; -> ordered list of all top-level forms in PORT
  (let loop ([forms '()])
    (let ([e (read port)])
      (if (eof-object? e) (reverse forms) (loop (cons e forms))))))

;; The self-hostable core reads source via the in-language `read-all-from-string`
;; (provided by the prelude to a running program).  Under Chez the driver supplies
;; it over a string port, so `core.ss`'s `read-forms-from-string` works here too.
(define (read-all-from-string str) (read-forms (open-input-string str)))

(define runtime-c "src/runtime/runtime.c")

;; --- toolchain discovery (change: allow-llvm-install-flexibility) ----------
;; The Chez driver cannot source tools/llvm-env.sh, so discovery stays single-sourced by
;; SHELLING OUT to that same layer (`tools/llvm-env.sh --print-env`) and reading the
;; resolved values -- a bare `chez --script src/compile.ss ...` from the repo root thus
;; picks up any LLVM the shared layer can find.  An explicit env override still wins; if
;; the layer is unavailable, a legacy Homebrew keg is the last-resort fallback.
(define (getenv-ne name)               ; getenv, but empty string counts as unset
  (let ([v (getenv name)]) (and v (> (string-length v) 0) v)))
(define (shell-line cmd)               ; run CMD, return its first stdout line, or #f
  (let* ([pipes (process cmd)] [from (car pipes)] [to (cadr pipes)])
    (close-port to)
    (let ([ln (get-line from)]) (close-port from)
      (and (not (eof-object? ln)) (> (string-length ln) 0) ln))))
(define (ensure-slash s)               ; a bin dir path the `tool` helper can suffix
  (if (and (> (string-length s) 0) (char=? (string-ref s (- (string-length s) 1)) #\/))
      s (string-append s "/")))
(define (string-suffix? suf s)
  (let ([sl (string-length s)] [ul (string-length suf)])
    (and (>= sl ul) (string=? (substring s (- sl ul) sl) suf))))
(define (macos?) (string-suffix? "osx" (symbol->string (machine-type))))

;; Read `NAME=VALUE` lines from `tools/llvm-env.sh --print-env` into an alist ('() if the
;; layer is absent or errors); this is the single shared discovery implementation.
(define *llvm-env*
  (guard (e [#t '()])
    (if (file-exists? "tools/llvm-env.sh")
        (let* ([pipes (process "tools/llvm-env.sh --print-env 2>/dev/null")]
               [from (car pipes)] [to (cadr pipes)])
          (close-port to)
          (let loop ([acc '()])
            (let ([ln (get-line from)])
              (if (eof-object? ln)
                  (begin (close-port from) (reverse acc))
                  (let ([i (let scan ([k 0])
                             (cond [(>= k (string-length ln)) #f]
                                   [(char=? (string-ref ln k) #\=) k]
                                   [else (scan (+ k 1))]))])
                    (loop (if i
                              (cons (cons (substring ln 0 i)
                                          (substring ln (+ i 1) (string-length ln)))
                                    acc)
                              acc)))))))
        '())))
(define (from-layer name) (cond [(assoc name *llvm-env*) => cdr] [else #f]))

(define gc-inc  (or (getenv-ne "EMIT_GC_INC")  (from-layer "EMIT_GC_INC")  "/opt/homebrew/include"))
(define gc-lib  (or (getenv-ne "EMIT_GC_LIB")  (from-layer "EMIT_GC_LIB")  "/opt/homebrew/lib"))
;; LLVM tool dir for the jit/bitcode backends (kept with a trailing slash for `tool`).
(define llvm-bin
  (ensure-slash (or (getenv-ne "EMIT_LLVM_BIN") (from-layer "EMIT_LLVM_BIN")
                    "/opt/homebrew/opt/llvm@22/bin")))
;; libgc shared object for `lli -load=`: .dylib on macOS, .so elsewhere (fixes the JIT
;; backend off macOS, where the old hardcoded libgc.dylib does not exist).
(define gc-dylib
  (or (getenv-ne "EMIT_GC_DYLIB") (from-layer "EMIT_GC_DYLIB")
      (string-append gc-lib "/libgc." (if (macos?) "dylib" "so"))))
;; AOT C compiler (D6): explicit CC wins, then the shared layer's resolved CC (a system
;; clang when present, else the discovered LLVM clang); the in-Scheme branch is the
;; last-resort fallback when the layer is unavailable.
(define aot-cc
  (or (getenv-ne "CC") (from-layer "CC")
      (if (getenv-ne "EMIT_LLVM_BIN")
          (string-append llvm-bin "clang")
          (if (shell-line "command -v clang 2>/dev/null") "clang"
              (string-append llvm-bin "clang")))))

;; Module header: the `target datalayout`/`target triple` lines for the host.
;; Without them clang fills in its own effective triple when it loads our IR and
;; warns (-Woverride-module).  We ask the system clang what it would emit for an
;; empty translation unit -- the canonical, portable way to learn the host's
;; exact triple (which -print-target-triple does not report on macOS).
(define (host-target-header)
  (let* ([pipes (process (string-append aot-cc " -S -emit-llvm -x c -o - - 2>/dev/null"))]
         [from (car pipes)]
         [to   (cadr pipes)])
    (put-string to "int __scheme_llvm_probe;\n")
    (close-port to)
    (let loop ([acc '()])
      (let ([ln (get-line from)])
        (cond
          [(eof-object? ln)
           (close-port from)
           (apply string-append (reverse acc))]
          [(and (>= (string-length ln) 7) (string=? (substring ln 0 7) "target "))
           (loop (cons (string-append ln "\n") acc))]
          [else (loop acc)])))))

(define (read-program path)   ; -> ordered list of all top-level forms (file I/O)
  (let* ([p (open-input-file path)]
         [forms (read-forms p)])
    (close-port p)
    forms))

(define (dump stage form)
  (fprintf (current-error-port) ";; ==== after ~a ====\n" stage)
  (pretty-print form (current-error-port))
  (newline (current-error-port)))

;; --- output verbosity (see docs/OUTPUT.md) --------------------------------
;; One control, three levels, read from EMIT_VERBOSITY (unset = default) and
;; overridable by -q/-v.  All narration goes to stderr; stdout stays data-only
;; (the --emit-ir filter never narrates).  0 = quiet, 1 = default, 2 = verbose.
(define driver-verbosity
  (let ([v (getenv "EMIT_VERBOSITY")])
    (cond
      [(not v) 1]
      [(or (string=? v "quiet") (string=? v "q") (string=? v "0")) 0]
      [(or (string=? v "verbose") (string=? v "v") (string=? v "2")) 2]
      [else 1])))

;; concise status line to stderr, suppressed at quiet.  fprintf-style.
(define (note fmt . args)
  (when (>= driver-verbosity 1)
    (apply fprintf (current-error-port) fmt args)))

;; verbose-only per-pass stage announcement (concise; no full form dump).  Shares
;; core.ss's injected `dump` side-channel, so the pure core stays port-free.
(define (announce-stage stage form)
  (when (>= driver-verbosity 2)
    (fprintf (current-error-port) "  stage ~a\n" stage)))

;; --- prelude (standard library prepended to every program) ---------------
;; The prelude is a *file*, so reading it is the driver's job; the pure core's
;; `with-prelude` merges the already-read forms (user-wins shadowing).
(define prelude-path "src/prelude.scm")

;; Read source (+ prelude) and assemble the ordered form list the core compiles.
(define (program-forms src prelude?)
  (let ([user-forms (read-program src)])
    (if prelude?
        (with-prelude (read-program prelude-path) user-forms)
        user-forms)))

;; --- optional self-hosted forms->IR via a compiled `schemec` (path C, D4) --
;; When enabled (env SCHEMEC=<path> or --via-schemec), the forms->IR step shells
;; out to the compiled `schemec` (a text->IR filter) instead of running the core
;; in-process.  The driver still owns everything else: it merges the prelude
;; (with-prelude), then serializes the already-merged forms to text on schemec's
;; stdin and reads the emitted core IR from its stdout.  `schemec` prepends no
;; prelude and no target header -- those stay the driver's job.  The in-process
;; path is retained (it builds schemec, and is the default/fallback).
(define default-schemec "build/schemec")
(define (schemec-binary) (or (getenv "SCHEMEC") default-schemec))

;; forms (already prelude-merged) -> IR text, via the schemec co-process.  Write
;; every form then close stdin; schemec reads to EOF, compiles, writes IR to
;; stdout.  It reads all input before emitting, so write-then-read cannot
;; deadlock on the pipe.
(define (forms->ir-via-schemec forms)
  ;; Chez `process` merges the child's stderr into the stdout pipe, which would
  ;; corrupt the captured IR; send schemec's stderr to /dev/null (a compile error
  ;; there surfaces as empty IR and a downstream clang failure).
  (let* ([pipes (process (string-append (schemec-binary) " 2>/dev/null"))]
         [from (car pipes)] [to (cadr pipes)])
    (for-each (lambda (f) (write f to) (newline to)) forms)
    (close-port to)
    (let ([ir (get-string-all from)])
      (close-port from)
      ir)))

;; Driver: assemble forms, run forms->IR (in-process core, or schemec when
;; via?), prepend the host target header, and write the .ll.  The header (a
;; clang subprocess) is an effect and stays here so the core stays host-agnostic.
(define (compile-file src ll dumpf prelude? via?)
  (let* ([forms (program-forms src prelude?)]
         [ir    (if via?
                    (forms->ir-via-schemec forms)
                    (compile-forms forms dumpf))]
         [text  (string-append (host-target-header) ir)])
    (let ([out (open-output-file ll 'replace)]) (display text out) (close-port out))))

;; --- backends -----------------------------------------------------------
;; One emitted OUT.ll drives three exits.  AOT uses `aot-cc` (a system clang when present,
;; else the discovered LLVM clang; see the toolchain-discovery block above).  The JIT and
;; bitcode exits use the discovered LLVM tools (`llvm-bin`, from EMIT_LLVM_BIN or
;; `llvm-config --bindir`) -- no fixed keg path.
(define (tool t) (string-append llvm-bin t))
(define (sh who cmd)
  (unless (zero? (system cmd)) (error 'compile (string-append who " failed") cmd)))

(define (require-llvm-tools)
  (for-each
    (lambda (t)
      (unless (file-exists? (tool t))
        (error 'compile
               (string-append "required LLVM tool not found: " (tool t)
                              "  (install LLVM -- apt: 'llvm', brew: 'llvm' -- "
                              "or set EMIT_LLVM_BIN to your LLVM bin directory)"))))
    '("lli" "llvm-as" "llvm-link" "clang")))

;; AOT (default): textual IR -> native exe via the system clang.  Unchanged.
(define (link ll exe)
  (sh "clang" (string-append aot-cc " -I" gc-inc " -L" gc-lib " " runtime-c " " ll " -lgc -o " exe)))

;; Bitcode: assemble OUT.ll -> OUT.bc (the inspectable/opt-able artifact),
;; then codegen the .bc + runtime to a native exe (LLVM 22 clang).
(define (emit-bitcode ll bc)
  (sh "llvm-as" (string-append (tool "llvm-as") " " ll " -o " bc)))
(define (build-bitcode-exe bc exe)
  (sh "clang(bc)"
      (string-append (tool "clang") " -I" gc-inc " -L" gc-lib " " runtime-c " " bc " -lgc -o " exe)))

;; JIT: assemble the program, compile the runtime to bitcode, llvm-link them
;; (so the C main + rt_* join the module), and run in-process via lli with
;; libgc loaded.  lli executes the linked module's main.
(define (run-jit ll base)
  (let ([pbc (string-append base ".bc")]
        [rbc (string-append base ".rt.bc")]
        [cbc (string-append base ".combined.bc")])
    (sh "llvm-as"    (string-append (tool "llvm-as") " " ll " -o " pbc))
    (sh "clang-emit" (string-append (tool "clang") " -I" gc-inc " -emit-llvm -c " runtime-c " -o " rbc))
    (sh "llvm-link"  (string-append (tool "llvm-link") " " pbc " " rbc " -o " cbc))
    (sh "lli"        (string-append (tool "lli") " -load=" gc-dylib " " cbc))))

(define (strip-ext s)
  (let ([i (let loop ([i (- (string-length s) 1)])
             (cond [(< i 0) #f] [(char=? (string-ref s i) #\.) i] [else (loop (- i 1))]))])
    (if i (substring s 0 i) s)))

;; --- interactive REPL: launch the embedded-compiler host ----------------
;; The REPL is now Chez-free (change: repl-embedded-incremental): the whole
;; incremental loop -- read a complete form, compile it against the persistent
;; session state, JIT and run it, print the value -- lives in build/repl-host,
;; which A-links the EMBEDDED compiler and does its own compilation in-process.
;; This driver only ensures the host is up to date and then hands the terminal
;; over to it (the host inherits this process's stdin/stdout/stderr, so prompts,
;; values, and diagnostics flow straight through).  There is no Chez per-form
;; compilation, no frame protocol, and no persistent Chez state any more.
(define repl-host-path "build/repl-host")

;; Rebuild the host whenever the runtime/host sources, the embedded compiler (and
;; the core sources behind it), or the recipe changed -- not merely when the
;; binary is missing: the host links a runtime + compiler snapshot and the JIT
;; resolves rt_* / prelude globals from the host process, so a stale binary
;; silently lacks anything added since it was built (changes:
;; fix-stale-repl-host-rebuild, repl-embedded-incremental).  `make` no-ops when
;; the host is already up to date.
(define (ensure-host)
  (unless (zero? (system "make build/repl-host 1>&2"))
    (error 'repl "failed to build the REPL host")))

;; Launch the host, inheriting our stdio, and exit with its status.  --no-prelude
;; is passed through so the host seeds the session without the standard library.
(define (run-repl prelude?)
  (ensure-host)
  (exit (system (string-append repl-host-path (if prelude? "" " --no-prelude")))))

;; --- core filter mode: stdin source text -> stdout IR text ---------------
;; The self-hosting-facing shape of the core (design D2): read all of stdin as
;; source, run the pure pipeline, and write IR to stdout.  The target header and
;; toolchain are intentionally left to the driver/host, so a future self-hosted
;; core runs as a plain text filter without any filesystem/subprocess surface.
(define (emit-ir-filter prelude?)
  (let* ([user-forms (read-forms (current-input-port))]
         [forms (if prelude?
                    (with-prelude (read-program prelude-path) user-forms)
                    user-forms)]
         [ir (compile-forms forms no-dump)])
    (display ir (current-output-port))
    (flush-output-port (current-output-port))))

;; --- import-aware AOT build (change: module-artifacts-vertical-slice) ------
;; A program with top-level (import (L)) forms is built by resolving each L
;; through a manifest to its source, compiling the library to a unit .ll (+ a
;; readable .exports table), compiling the program against the imports' export
;; tables, and linking runtime + every unit .ll + the program into one exe.
;; Reading the manifest/sources and writing/linking artifacts are driver effects;
;; the pure core provides compile-library / compile-program-with-imports.
(define *manifest-path* (or (getenv "EMIT_MANIFEST") "emit-libs.scm"))

;; manifest file (one s-expression) -> list of (name source-path artifact-dir).
(define (read-manifest path)
  (unless (file-exists? path)
    (error 'build (string-append "library manifest not found: " path)))
  (map (lambda (entry)                     ; (library NAME (source S) [(artifacts A)])
         (let ([name (cadr entry)] [clauses (cddr entry)])
           (list name
                 (cond [(assq 'source clauses) => cadr]
                       [else (error 'build "manifest entry missing (source ...)" name)])
                 (cond [(assq 'artifacts clauses) => cadr] [else "build/lib"]))))
       (car (read-program path))))

(define (manifest-lookup manifest name)
  (or (assoc name manifest)
      (error 'build "library not found in manifest" name)))

(define (lib-basename name)                ; (foo bar) -> "foo.bar"
  (let loop ([parts (cdr name)] [acc (symbol->string (car name))])
    (if (null? parts) acc
        (loop (cdr parts) (string-append acc "." (symbol->string (car parts)))))))

(define (program-imports src) (car (collect-imports (read-program src))))

(define (write-text path text)
  (let ([o (open-output-file path 'replace)]) (display text o) (close-port o)))

;; --- prelude as (scheme base) (change: module-prelude-scheme-base, Stage 3) ---
;; The prelude's RUNTIME half is the library (scheme base) (auto-imported); its
;; COMPILE-TIME half is the derived-form macros, obtained by filtering the prelude
;; source for define-syntax and merged into a user program's macro-env (no separate
;; baked constant -- the prelude source is the single source of truth).
(define scheme-base-lib '(scheme base))
(define (prelude-macro-forms)
  (filter (lambda (f) (and (pair? f) (eq? (car f) 'define-syntax)))
          (read-program prelude-path)))
;; a program's imports plus an implicit (scheme base) when the prelude is enabled
;; (deduped, so an explicit (import (scheme base)) is not doubled).
(define (with-scheme-base imports prelude?)
  (if (and prelude? (not (member scheme-base-lib imports)))
      (append imports (list scheme-base-lib))
      imports))

;; --- library dependency graph (change: module-generalize) ------------------
;; A library may import other libraries, so the build resolves the TRANSITIVE
;; closure of a program's imports, orders it topologically (dependencies before
;; dependents), and rejects cycles -- all in the driver; the pure core only ever
;; sees one unit's forms plus its dependencies' export tables as data.

;; Parse a library name's source (via the manifest) into (name imports exports body).
(define (read-define-library manifest name)
  (parse-define-library (car (read-program (cadr (manifest-lookup manifest name))))))

;; Topologically sort the transitive closure of `roots` (a list of library names).
;; Returns (values order dl-cache): `order` lists every library in the closure with
;; dependencies before dependents; `dl-cache` is an alist name -> parsed
;; define-library so callers avoid re-reading sources.  A back-edge (a name already
;; on the current DFS path) is an import cycle -> compile-time error.
(define (toposort-libs roots manifest)
  (let ([order '()] [visited '()] [cache '()])
    (define (get-dl name)
      (cond [(assoc name cache) => cdr]
            [else (let ([dl (read-define-library manifest name)])
                    (set! cache (cons (cons name dl) cache)) dl)]))
    (define (visit name path)
      (cond
        [(member name visited) (if #f #f)]                    ; already finished (diamond)
        [(member name path)
         (error 'build "import cycle among libraries" (reverse (cons name path)))]
        [else
         (for-each (lambda (dep) (visit dep (cons name path))) (cadr (get-dl name)))
         (set! visited (cons name visited))
         (set! order (cons name order))]))                    ; finished after its deps
    (for-each (lambda (r) (visit r '())) roots)
    (values (reverse order) cache)))

;; --- compiler-identity stamp (change: artifact-compiler-stamp) -------------
;; Artifact freshness must depend on the COMPILER, not just the library source:
;; a compiler/emitter change with unchanged source would otherwise reuse stale
;; IR (the classic Make footgun -- the toolchain is not a listed prerequisite).
;; We stamp each unit with a version marker + a content hash of the compiler
;; sources that determine emitted IR, matching Rust (.rlib SVH), GHC (.hi
;; version), Go, and Bazel.  In this driver path the compiler runs as interpreted
;; source, so those files are on disk at run time -- hashing them IS the running
;; compiler's identity.

;; Version marker for the stamp FORMAT (D1): bump by hand to force a global
;; invalidation deliberately (e.g. if the stamp scheme itself changes).
(define compiler-stamp-version 1)

;; Exactly the (include ...) block at the top of this file PLUS this file itself,
;; in a fixed order -- the sources that turn library source -> IR in this path.
;; KEEP IN SYNC with the include block near line 20 (change: artifact-compiler-stamp).
(define compiler-source-files
  '("src/match.scm"
    "src/util.scm"
    "src/parse.ss"
    "src/passes/expand.ss"
    "src/passes/recognize-let.ss"
    "src/passes/convert-assignments.ss"
    "src/passes/convert-closures.ss"
    "src/passes/lower.ss"
    "src/emit.ss"
    "src/core.ss"
    "src/compile.ss"))

;; A file's raw bytes as a bytevector (binary; content-based, immune to touch /
;; checkout / clock skew -- the mtime fragility that just bit us on sources).
(define (file-bytes path)
  (let* ([p (open-file-input-port path)]
         [bv (get-bytevector-all p)])
    (close-port p)
    (if (eof-object? bv) (bytevector) bv)))

;; Dependency-free 64-bit FNV-1a folded into `acc` (D2).  Non-cryptographic: it
;; guards against accidental staleness, not adversarial collisions, and adds no
;; dependency ("no new dependencies").
(define fnv64-prime 1099511628211)
(define fnv64-mask (- (expt 2 64) 1))
(define (fnv1a-bytes acc bv)
  (let ([n (bytevector-length bv)])
    (let loop ([i 0] [h acc])
      (if (= i n)
          h
          (loop (+ i 1)
                (bitwise-and (* (bitwise-xor h (bytevector-u8-ref bv i))
                                fnv64-prime)
                             fnv64-mask))))))

;; The compiler-identity stamp (D1): (emit-artifact-stamp VERSION HEX-DIGEST),
;; the digest hashing the compiler sources (fixed order) then the host target
;; header -- both determine the emitted IR (the header is prepended to every
;; .ll).  Computed ONCE per build (D4) and compared to each unit's recorded stamp.
(define fnv64-offset-basis 14695981039346656037)
(define (compiler-stamp header)
  (let* ([h (fold-left (lambda (acc f) (fnv1a-bytes acc (file-bytes f)))
                       fnv64-offset-basis
                       compiler-source-files)]
         [h (fnv1a-bytes h (string->utf8 header))])
    (list 'emit-artifact-stamp compiler-stamp-version (number->string h 16))))

;; Read back a unit's recorded stamp datum, or #f if the sidecar is absent/empty
;; (a torn write fails safe toward rebuild -- D3).
(define (read-stamp stampf)
  (and (file-exists? stampf)
       (let ([forms (read-program stampf)])
         (and (pair? forms) (car forms)))))

;; A library's artifacts are FRESH when both exist, neither is older than the
;; source, AND the recorded compiler stamp equals the current one (change:
;; module-generalize + artifact-compiler-stamp).  file-modification-time returns
;; a time-utc object; compare with time<=? (src not newer than the artifact).
(define (artifacts-fresh? src ll expf stampf stamp)
  (and (file-exists? ll) (file-exists? expf)
       (let ([st (file-modification-time src)])
         (and (time<=? st (file-modification-time ll))
              (time<=? st (file-modification-time expf))))
       (equal? (read-stamp stampf) stamp)))

;; Why an artifact is being rebuilt, for narration (docs/OUTPUT.md): absent,
;; its source changed, or the compiler that produced it differs (stamp mismatch).
;; Compute this BEFORE the rebuild rewrites the artifacts.
(define (rebuild-reason src ll expf stampf stamp)
  (cond
    [(not (and (file-exists? ll) (file-exists? expf))) "missing"]
    [(let ([st (file-modification-time src)])
       (not (and (time<=? st (file-modification-time ll))
                 (time<=? st (file-modification-time expf)))))
     "source changed"]
    [(not (equal? (read-stamp stampf) stamp)) "compiler changed"]
    [else "stale"]))

;; Compile+link a program that imports libraries.  `exe` is the output path.
;; Resolves the transitive import closure, builds/reuses each unit in topological
;; order (its import env drawn from its already-built dependencies' export tables),
;; compiles the program against its DIRECT imports, and links runtime + every unit
;; in the closure + the program.  The program's @scheme_entry runs the whole
;; closure's __init in dependency order (change: module-generalize).
;; Build the modular artifact SET without linking (change: driver-backend-rehome):
;; resolve the transitive import closure (incl. the auto-imported (scheme base)
;; when the prelude is enabled), build/reuse each unit .ll (with the host header),
;; compile the program .ll against its direct imports, and RETURN the ordered unit
;; .ll list (topological/link order) plus the program .ll.  The three backends
;; (aot/jit/bitcode) each consume this same set, so re-home + import resolution is
;; one path, not per-backend.
(define (build-modular-artifacts src out prelude?)
  (let* ([user-forms     (read-program src)]
         ;; Stage 3: the prelude's procedures come from the auto-imported (scheme
         ;; base) library, not a prepend; only its derived-form macros are merged
         ;; as prelude-forms (compile-time).  --no-prelude adds neither.
         [direct-imports (with-scheme-base (car (collect-imports user-forms)) prelude?)]
         [manifest       (read-manifest *manifest-path*)]
         [prelude-forms  (if prelude? (prelude-macro-forms) '())]
         [header         (host-target-header)]
         ;; compiler identity, computed ONCE per build (D4) and compared to each
         ;; unit's recorded .stamp in artifacts-fresh? (change: artifact-compiler-stamp).
         [stamp          (compiler-stamp header)])
    (let-values ([(order dl-cache) (toposort-libs direct-imports manifest)])
      ;; build/reuse each unit in topo order, accumulating (name . export-table)
      ;; and the .ll paths for linking.
      (let loop ([libs order] [tables '()] [lls '()])
        (if (null? libs)
            ;; every unit ready: compile the program against its DIRECT imports'
            ;; tables, ordering the whole closure's inits by topo order.
            (let* ([direct-tables (map (lambda (n) (cdr (assoc n tables))) direct-imports)]
                   [prog-ll   (string-append out ".ll")]      ; beside the exe, not the source
                   [prog-ir   (compile-program-with-imports
                                prelude-forms user-forms direct-tables order no-dump)]
                   [prog-text (string-append header prog-ir)])
              (write-text prog-ll prog-text)
              (note "compile ~a -> ~a  [~a bytes]\n" src prog-ll (string-length prog-text))
              (values (reverse lls) prog-ll))           ; unit .ll's in link order + program .ll
            ;; build or reuse one library
            (let* ([name    (car libs)]
                   [entry   (manifest-lookup manifest name)]
                   [art-dir (caddr entry)]
                   [dl      (cdr (assoc name dl-cache))]
                   [base    (lib-basename name)]
                   [ll      (string-append art-dir "/" base ".ll")]
                   [expf    (string-append art-dir "/" base ".exports")]
                   [stampf  (string-append art-dir "/" base ".stamp")])
              (if (artifacts-fresh? (cadr entry) ll expf stampf stamp)
                  ;; reuse: read the export table back from the artifact
                  (let ([table (car (read-program expf))])
                    (note "reuse ~s -> ~a  [fresh]\n" name ll)
                    (loop (cdr libs) (cons (cons name table) tables) (cons ll lls)))
                  ;; rebuild: import env comes from this lib's already-built deps.
                  ;; Capture the reason BEFORE writing (the writes make it fresh again).
                  (let* ([reason  (rebuild-reason (cadr entry) ll expf stampf stamp)]
                         [imp-tables (map (lambda (n) (cdr (assoc n tables))) (cadr dl))]
                         [res     (compile-library (car dl) (cadr dl) (caddr dl) (cadddr dl)
                                                   imp-tables no-dump)]
                         [ll-text (string-append header (car res))])
                    (sh "mkdir" (string-append "mkdir -p " art-dir))
                    (write-text ll ll-text)
                    (let ([o (open-output-file expf 'replace)])
                      (write (cadr res) o) (newline o) (close-port o))
                    ;; write the .stamp LAST so a torn write fails safe toward
                    ;; rebuild (D3); `write` (not display) so the digest string
                    ;; round-trips as a string, not a symbol.
                    (let ([o (open-output-file stampf 'replace)])
                      (write stamp o) (newline o) (close-port o))
                    (note "compile ~s -> ~a  [~a bytes, recompile: ~a]\n"
                          name ll (string-length ll-text) reason)
                    (loop (cdr libs) (cons (cons name (cadr res)) tables) (cons ll lls))))))))))

;; --- modular-set backend consumers (change: driver-backend-rehome) ---------
;; Each takes the unit .ll's (link order) + the program .ll and drives one exit.
(define (lls->string lls) (apply string-append (map (lambda (l) (string-append l " ")) lls)))

;; AOT: clang links runtime + every unit + program -> native exe.
(define (link-modular-aot unit-lls prog-ll exe)
  (sh "clang"
      (string-append aot-cc " -Wno-override-module -I" gc-inc " -L" gc-lib " " runtime-c " "
                     (lls->string unit-lls) prog-ll " -lgc -o " exe))
  (note "link ~a + ~a unit(s) -> ~a  [aot, modules]\n" prog-ll (length unit-lls) exe))

;; assemble each .ll in the set to a sibling .bc; return the .bc paths in order.
(define (assemble-set lls)
  (map (lambda (ll)
         (let ([bc (string-append ll ".bc")])
           (sh "llvm-as" (string-append (tool "llvm-as") " " ll " -o " bc))
           bc))
       lls))

;; JIT: assemble the whole set + the runtime to bitcode, llvm-link them into one
;; module (so the units' scheme.base:* globals, the program, and rt_* / C main all
;; join), and run in-process via lli with libgc loaded.
(define (run-jit-modular unit-lls prog-ll base)
  (let* ([rbc (string-append base ".rt.bc")]
         [cbc (string-append base ".combined.bc")]
         [bcs (assemble-set (append unit-lls (list prog-ll)))])
    (sh "clang-emit" (string-append (tool "clang") " -I" gc-inc " -emit-llvm -c " runtime-c " -o " rbc))
    (sh "llvm-link"  (string-append (tool "llvm-link") " " (lls->string bcs) rbc " -o " cbc))
    (sh "lli"        (string-append (tool "lli") " -load=" gc-dylib " " cbc))))

;; Bitcode: llvm-link the whole set into one program .bc (the inspectable/opt-able
;; artifact), then codegen that .bc + runtime to a native exe.
(define (build-bitcode-modular unit-lls prog-ll exe base)
  (let* ([bc  (string-append base ".bc")]
         [bcs (assemble-set (append unit-lls (list prog-ll)))])
    (sh "llvm-link" (string-append (tool "llvm-link") " " (lls->string bcs) "-o " bc))
    (sh "clang(bc)"
        (string-append (tool "clang") " -Wno-override-module -I" gc-inc " -L" gc-lib " "
                       runtime-c " " bc " -lgc -o " exe))
    (note "link ~a + ~a unit(s) -> ~a -> ~a  [bitcode, modules]\n" prog-ll (length unit-lls) bc exe)))

;; --- argument handling ---
;; `via?` (env SCHEMEC=<path> or --via-schemec) routes the batch forms->IR step
;; through the compiled `schemec` (path C, D4) instead of the in-process core.
(define (main args)
  (let loop ([args args] [src #f] [out #f] [dump? #f] [backend "aot"] [prelude? #t]
             [repl? #f] [emit-ir? #f] [via? (and (getenv "SCHEMEC") #t)])
    (cond
      [(null? args)
       (cond
         [repl? (run-repl prelude?)]
         [emit-ir? (emit-ir-filter prelude?)]
         [else
          (unless src (error 'compile "usage: compile.ss SRC.scm [-o OUT] [--dump] [-q|-v] [--backend aot|jit|bitcode] [--no-prelude] [--via-schemec]\n   or: compile.ss --repl [--no-prelude]\n   or: compile.ss --emit-ir [--no-prelude] < SRC.scm  (IR text on stdout)\n   (-q/-v or env EMIT_VERBOSITY=quiet|verbose control status output; see docs/OUTPUT.md)\n   (--via-schemec / env SCHEMEC=<path>: run forms->IR through the compiled schemec)"))
          (let* ([out (or out (strip-ext src))] [ll (string-append out ".ll")]
                 ;; --dump = full per-pass form trace; -v = concise stage names; else silent
                 [dumpf (cond [dump? dump] [(>= driver-verbosity 2) announce-stage] [else no-dump])])
            (cond
              ;; Module-aware path for ALL backends (change: driver-backend-rehome):
              ;; a program that imports libraries -- or, with the prelude enabled, any
              ;; program (it auto-imports (scheme base), Stage 3) -- resolves its
              ;; libraries once into the modular artifact set, which aot/jit/bitcode
              ;; each consume.  This is what re-homes jit/bitcode (no prelude prepend,
              ;; and they now handle imports) (changes: module-artifacts-vertical-slice,
              ;; module-prelude-scheme-base, driver-backend-rehome).
              [(or prelude? (pair? (program-imports src)))
               (let-values ([(unit-lls prog-ll) (build-modular-artifacts src out prelude?)])
                 (case (string->symbol backend)
                   [(aot) (link-modular-aot unit-lls prog-ll out)]
                   [(bitcode) (require-llvm-tools) (build-bitcode-modular unit-lls prog-ll out out)]
                   [(jit) (require-llvm-tools) (run-jit-modular unit-lls prog-ll out)]
                   [else (error 'compile "unknown backend (want aot|jit|bitcode)" backend)]))]
              [else
            ;; --no-prelude + no imports: a single self-contained module (no (scheme
            ;; base)), driven to any backend as before.
            (compile-file src ll dumpf prelude? via?)
            (case (string->symbol backend)
              [(aot)
               (link ll out)
               (note "link ~a -> ~a~a  [aot]\n" ll out (if via? "  (via schemec)" ""))]
              [(bitcode)
               (require-llvm-tools)
               (let ([bc (string-append out ".bc")])
                 (emit-bitcode ll bc)
                 (build-bitcode-exe bc out)
                 (note "link ~a -> ~a -> ~a  [bitcode]\n" ll bc out))]
              [(jit)
               (require-llvm-tools)
               (run-jit ll out)]
              [else (error 'compile "unknown backend (want aot|jit|bitcode)" backend)])]))])]
      [(string=? (car args) "--manifest") (set! *manifest-path* (cadr args)) (loop (cddr args) src out dump? backend prelude? repl? emit-ir? via?)]
      [(string=? (car args) "-o") (loop (cddr args) src (cadr args) dump? backend prelude? repl? emit-ir? via?)]
      [(string=? (car args) "-q") (set! driver-verbosity 0) (loop (cdr args) src out dump? backend prelude? repl? emit-ir? via?)]
      [(string=? (car args) "-v") (set! driver-verbosity 2) (loop (cdr args) src out dump? backend prelude? repl? emit-ir? via?)]
      [(string=? (car args) "--dump") (loop (cdr args) src out #t backend prelude? repl? emit-ir? via?)]
      [(string=? (car args) "--backend") (loop (cddr args) src out dump? (cadr args) prelude? repl? emit-ir? via?)]
      [(string=? (car args) "--no-prelude") (loop (cdr args) src out dump? backend #f repl? emit-ir? via?)]
      [(string=? (car args) "--repl") (loop (cdr args) src out dump? backend prelude? #t emit-ir? via?)]
      [(string=? (car args) "--emit-ir") (loop (cdr args) src out dump? backend prelude? repl? #t via?)]
      [(string=? (car args) "--via-schemec") (loop (cdr args) src out dump? backend prelude? repl? emit-ir? #t)]
      [else (loop (cdr args) (car args) out dump? backend prelude? repl? emit-ir? via?)])))

(main (command-line-arguments))
