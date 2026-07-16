// host.cpp -- persistent ORC/LLJIT host for the interactive Scheme REPL, driving
// the EMBEDDED compiler in-process (change: repl-embedded-incremental).
//
// One long-lived process, no Chez and no per-form subprocess.  The embedded
// compiler is A-linked into this host (bootstrap/embed-repl.ll): its ccc
// `scheme_entry` is a dispatcher the host calls once per operation, handing the
// operation selector + per-form source text in through the runtime's REPL channel
// (rt_repl_set) and reading the result value back across the FFI.  Operations:
//   mode 0/1  init-session (no prelude / with the baked-in prelude) -> prelude IR
//   mode 2    form-complete? -> a fixnum: consumed>=0 | -1 incomplete | -2 malformed
//   mode 3    compile-one-form -> (status . payload):
//               ok     -> (ir-text . entry-name)   host JITs + runs entry-name
//               error  -> message                  host reports on stderr
//               syntax -> registered-name          host notes on stderr
// The compiler keeps all incremental state (env/macro-env/known/n) across calls in
// the runtime; this host only JITs the IR the compiler emits and runs the entry
// thunk it names (the entry-name handshake), exactly as the old frame protocol did
// minus the Chez co-process.
//
// The host owns the outer loop (it owns the JIT): read stdin, ask the compiler
// whether the buffer holds a complete form yet, and when it does, hand that form's
// text to the compiler, JIT the returned module, and run its entry thunk.
// Values (and runtime traps, as "!trap: ...") print to stdout; the prompt, the
// banner, and compile-error diagnostics go to stderr.

#include "llvm/ExecutionEngine/Orc/LLJIT.h"
#include "llvm/ExecutionEngine/Orc/ExecutionUtils.h"
#include "llvm/IRReader/IRReader.h"
#include "llvm/IR/Module.h"
#include "llvm/IR/LLVMContext.h"
#include "llvm/Support/SourceMgr.h"
#include "llvm/Support/TargetSelect.h"
#include "llvm/Support/Error.h"

#include <cstdint>
#include <csetjmp>
#include <cstdio>
#include <cstdlib>
#include <fstream>
#include <sstream>
#include <iostream>
#include <string>
#include <vector>
#include <memory>

#include <gc/gc.h>

using namespace llvm;
using namespace llvm::orc;

extern "C" {
  // The embedded compiler's dispatched entry (defined by the linked-in
  // bootstrap/embed-repl.ll).  Called via this link-time symbol -- always the
  // compiler, never a JIT'd module of the same name.
  intptr_t scheme_entry(void);

  // Runtime REPL channel + value accessors (src/runtime/runtime.c).
  void rt_repl_set(intptr_t mode, const char *bytes, intptr_t len);
  intptr_t rt_fixnum_value(intptr_t v);
  intptr_t rt_car(intptr_t v);
  intptr_t rt_cdr(intptr_t v);
  intptr_t rt_symbol_to_string(intptr_t v);
  intptr_t rt_string_len(intptr_t v);
  const char *rt_string_bytes(intptr_t v);

  void rt_write(intptr_t v);            // runtime value printer
  extern jmp_buf *rt_trap;              // runtime trap escape hook
  extern char rt_trap_msg[];            // last trap's message
  void rt_guard_reset(void);            // clear guard frames after a trap
}

typedef intptr_t (*thunk_t)(void);

static std::unique_ptr<LLJIT> JIT;

// Copy a scheme string value's bytes into a std::string.
static std::string scm_str(intptr_t v) {
  return std::string(rt_string_bytes(v), (size_t)rt_string_len(v));
}
// The name of a (status . payload) result's status symbol.
static std::string status_of(intptr_t r) {
  return scm_str(rt_symbol_to_string(rt_car(r)));
}

// Parse IR text and add it to the JIT.  On failure, put a message in `err`.
static bool add_ir(const std::string &ir, std::string &err) {
  auto ctx = std::make_unique<LLVMContext>();
  SMDiagnostic diag;
  auto buf = MemoryBuffer::getMemBuffer(ir, "<repl>");
  std::unique_ptr<Module> mod = parseIR(buf->getMemBufferRef(), diag, *ctx);
  if (!mod) {
    raw_string_ostream os(err);
    diag.print("<repl>", os);
    return false;
  }
  mod->setDataLayout(JIT->getDataLayout());
  if (Error e = JIT->addIRModule(ThreadSafeModule(std::move(mod), std::move(ctx)))) {
    err = toString(std::move(e));
    return false;
  }
  return true;
}

// Look up an entry thunk by name, run it under trap isolation, and print the
// value (stdout) or "!trap: <msg>" (stdout).  A runtime trap longjmps back here
// instead of exiting, so the session survives; conservative GC needs no unwinding
// of the JIT'd frames.
static void run_thunk(const std::string &name) {
  Expected<ExecutorAddr> sym = JIT->lookup(name);
  if (!sym) {
    std::cout << "!lookup error: " << toString(sym.takeError()) << "\n" << std::flush;
    return;
  }
  thunk_t fn = sym->toPtr<thunk_t>();
  jmp_buf jb;
  rt_trap = &jb;
  if (setjmp(jb) == 0) {
    intptr_t r = fn();
    rt_write(r);
    std::printf("\n");
    std::fflush(stdout);
  } else {
    rt_guard_reset();
    std::cout << "!trap: " << rt_trap_msg << "\n" << std::flush;
  }
  rt_trap = nullptr;
}

// Run a named entry thunk once for effect (no value print), under trap
// isolation.  Used for the one-shot library @"L:__init" populators.
static bool run_init(const std::string &name) {
  Expected<ExecutorAddr> sym = JIT->lookup(name);
  if (!sym) {
    std::cerr << "error: library init lookup: " << toString(sym.takeError()) << "\n";
    return false;
  }
  thunk_t fn = sym->toPtr<thunk_t>();
  jmp_buf jb;
  rt_trap = &jb;
  bool ok = true;
  if (setjmp(jb) == 0) { fn(); }
  else { rt_guard_reset(); std::cerr << "error: library init trap: " << rt_trap_msg << "\n"; ok = false; }
  rt_trap = nullptr;
  return ok;
}

static std::string read_file(const std::string &path) {
  std::ifstream f(path, std::ios::binary);
  std::ostringstream ss;
  ss << f.rdbuf();
  return ss.str();
}

// Preload every library named in the manifest into the shared JITDylib (change:
// module-artifacts-vertical-slice; transitive imports: module-generalize).  The
// compiler owns manifest parsing: mode 5 turns the manifest text into a
// newline-separated list of source paths; for each we read the file (host I/O) and
// hand it to mode 4, which compiles the unit and returns (ok . (ir . init-symbol)),
// or (deferred . name) if a direct import is not loaded yet.  Because a library
// resolves against the already-loaded units, dependencies must load before their
// dependents; we therefore iterate to a FIXPOINT -- each pass loads whatever units
// now have their imports satisfied -- so the load order is topological regardless
// of manifest order.  A pass that makes no progress with libraries still deferred
// means an import cycle or an import of a library missing from the manifest.
static void preload_libraries() {
  const char *mp = std::getenv("EMIT_MANIFEST");
  std::string manifest = mp ? std::string(mp) : std::string("emit-libs.scm");
  std::ifstream probe(manifest);
  if (!probe.good()) return;                 // no manifest: no libraries this session
  std::string mtext = read_file(manifest);

  rt_repl_set(5, mtext.data(), (intptr_t)mtext.size());
  std::string paths = scm_str(scheme_entry());

  std::vector<std::string> pending;
  std::istringstream lines(paths);
  std::string path;
  while (std::getline(lines, path))
    if (!path.empty()) pending.push_back(path);

  // Fixpoint: repeatedly try the still-pending libraries; keep the deferred ones
  // for the next pass.  Stop when all load or a full pass makes no progress.
  while (!pending.empty()) {
    std::vector<std::string> deferred;
    bool progress = false;
    for (const std::string &p : pending) {
      std::string src = read_file(p);
      rt_repl_set(4, src.data(), (intptr_t)src.size());
      intptr_t r = scheme_entry();
      std::string st = status_of(r);
      if (st == "deferred") { deferred.push_back(p); continue; }
      if (st != "ok") {
        std::cerr << "error: loading library " << p << ": " << scm_str(rt_cdr(r)) << "\n";
        progress = true;                     // drop it; do not retry a hard error
        continue;
      }
      intptr_t payload = rt_cdr(r);          // (ir . init-symbol)
      std::string ir = scm_str(rt_car(payload));
      std::string init = scm_str(rt_cdr(payload));
      std::string err;
      if (!add_ir(ir, err)) { std::cerr << "error: library add " << p << ": " << err << "\n"; }
      else run_init(init);
      progress = true;
    }
    if (!progress) {                         // every remaining unit is stuck
      for (const std::string &p : deferred)
        std::cerr << "error: library " << p
                  << ": unresolved or cyclic import (dependency missing from manifest?)\n";
      break;
    }
    pending.swap(deferred);
  }
}

// Compile one complete form's text via the embedded compiler and act on the
// (status . payload) it returns.
static void process_form(const std::string &form) {
  rt_repl_set(3, form.data(), (intptr_t)form.size());
  intptr_t r = scheme_entry();
  std::string st = status_of(r);
  if (st == "ok") {
    intptr_t payload = rt_cdr(r);           // (ir-text . entry-name)
    std::string ir = scm_str(rt_car(payload));
    std::string name = scm_str(rt_cdr(payload));
    std::string err;
    if (!add_ir(ir, err)) { std::cerr << "error: " << err << "\n"; return; }
    run_thunk(name);                        // entry-name handshake: run what the compiler chose
  } else if (st == "syntax") {
    std::cerr << ";; syntax " << scm_str(rt_cdr(r)) << "\n";
  } else if (st == "import") {              // (import (L)): exports merged; no module
    // nothing to JIT -- the unit was preloaded; the session scope now sees it.
  } else {                                  // "error": compile-time; session continues
    std::cerr << "error: " << scm_str(rt_cdr(r)) << "\n";
  }
}

int main(int argc, char **argv) {
  bool prelude = true;
  for (int i = 1; i < argc; i++)
    if (std::string(argv[i]) == "--no-prelude") prelude = false;

  GC_INIT();                                // once for the whole session
  InitializeNativeTarget();
  InitializeNativeTargetAsmPrinter();
  InitializeNativeTargetAsmParser();

  auto jitOr = LLJITBuilder().create();
  if (!jitOr) {
    std::cerr << "fatal: failed to create LLJIT: " << toString(jitOr.takeError()) << "\n";
    return 1;
  }
  JIT = std::move(*jitOr);

  // Resolve rt_* / GC symbols (and prelude globals' external refs) from this
  // process; the runtime + embedded compiler are linked in and -rdynamic-exported.
  auto gen = DynamicLibrarySearchGenerator::GetForCurrentProcess(
      JIT->getDataLayout().getGlobalPrefix());
  if (!gen) {
    std::cerr << "fatal: generator error: " << toString(gen.takeError()) << "\n";
    return 1;
  }
  JIT->getMainJITDylib().addGenerator(std::move(*gen));

  // Initialize the session.  init-session returns the prelude as ONE batch module
  // whose entry thunk is @__repl_prelude (a name distinct from the linked
  // compiler's @scheme_entry, so JIT->lookup resolves THIS module and not the
  // compiler); add it and run that thunk once to populate the prelude's global
  // slots, against which later forms resolve.  --no-prelude returns "" and skips.
  rt_repl_set(prelude ? 1 : 0, "", 0);
  std::string prelude_ir = scm_str(scheme_entry());
  if (!prelude_ir.empty()) {
    std::string err;
    if (!add_ir(prelude_ir, err)) {
      std::cerr << "fatal: prelude add: " << err << "\n";
      return 1;
    }
    Expected<ExecutorAddr> sym = JIT->lookup("__repl_prelude");
    if (!sym) {
      std::cerr << "fatal: prelude entry: " << toString(sym.takeError()) << "\n";
      return 1;
    }
    thunk_t fn = sym->toPtr<thunk_t>();
    jmp_buf jb;
    rt_trap = &jb;
    if (setjmp(jb) == 0) {
      fn();
    } else {
      rt_guard_reset();
      std::cerr << "fatal: prelude trap: " << rt_trap_msg << "\n";
      return 1;
    }
    rt_trap = nullptr;
  }

  // Preload manifest libraries so interactive (import (L)) forms can resolve them.
  preload_libraries();

  std::cerr << "Emit REPL (embedded compiler, ORC/LLJIT).  ^D to exit.\n";

  // Accumulate stdin and drive the compiler.  After each line, ask the compiler
  // (form-complete?) whether the buffer starts with a complete form; when it does,
  // slice that form off, compile+run it, and keep draining any further complete
  // forms already in the buffer before reading more input.
  std::string buf, line;
  std::cerr << "scheme> " << std::flush;
  while (std::getline(std::cin, line)) {
    buf += line;
    buf += "\n";
    for (;;) {
      rt_repl_set(2, buf.data(), (intptr_t)buf.size());
      intptr_t code = rt_fixnum_value(scheme_entry());
      if (code == -1) break;                // incomplete: read more input
      if (code == -2) {                     // malformed: report and drop the buffer
        std::cerr << "error: malformed input\n";
        buf.clear();
        break;
      }
      std::string form = buf.substr(0, (size_t)code);
      buf.erase(0, (size_t)code);
      process_form(form);
      if (buf.find_first_not_of(" \t\r\n") == std::string::npos) { buf.clear(); break; }
    }
    std::cerr << "scheme> " << std::flush;
  }
  std::cerr << "\n";
  return 0;
}
