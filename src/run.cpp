// run.cpp -- in-process compile-and-run for a whole Scheme program, now with
// user-library resolution via the manifest (change: run-door-user-libraries).
//
// One process, no Chez and no clang/lli.  This host links the MODE-DISPATCHED
// embedded compiler (bootstrap/embed-repl.ll -- the same one the REPL host drives)
// and hands it operations through the runtime's REPL channel (rt_repl_set), reusing
// the REPL door's proven Chez-free manifest/library machinery.  The run door is the
// third module door, at parity with the AOT and REPL doors:
//
//   mode 1  init-session (seed session state; merge prelude macros)
//   mode 8  register the baked-in (scheme base) -> its unit IR + init symbol
//   mode 5  manifest text -> newline-separated user-library source paths
//   mode 4  library source text -> (ok . (unit-ir . init-symbol)) | (deferred . name)
//   mode 7  whole program text -> (ok . (program-ir . "scheme_entry")) | (error . msg)
//
// Unlike the REPL host, the run host adds each unit module to the JIT WITHOUT running
// its __init: the program module's @scheme_entry runs every unit's one-shot __init in
// topological order before the body -- exactly as a fresh AOT executable does, so the
// program module is byte-identical to the AOT door's prog.ll (dev->ship fidelity).
//
// Usage:  build/scheme-run < program.scm
//         build/scheme-run --manifest FILE < program.scm      (user libraries)
//         build/scheme-run --emit < program.scm > program.ll  (Chez-free AOT front half)
//
// With --emit the runner does NOT JIT: it writes every emitted module (the baked
// (scheme base), each imported unit, then the program), joined by the boundary marker,
// to stdout.  bin/scheme-compile splits that on the marker and links all units with the
// runtime -- a fully Chez-free source->native path.  The IR is the SAME bytes the JIT
// path runs, so what you emit is what you'd run in-process.

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
  intptr_t rt_car(intptr_t v);
  intptr_t rt_cdr(intptr_t v);
  intptr_t rt_symbol_to_string(intptr_t v);
  intptr_t rt_string_len(intptr_t v);
  const char *rt_string_bytes(intptr_t v);

  void rt_write(intptr_t v);                 // runtime value printer
  extern jmp_buf *rt_trap;                    // runtime trap escape hook
  extern char rt_trap_msg[];                  // last trap's message
  void rt_guard_reset(void);                  // clear guard frames after a trap
}

typedef intptr_t (*entry_t)(void);

static std::unique_ptr<LLJIT> JIT;

// The boundary marker the compiler joins separate modules with (src/core.ss
// *emit-unit-boundary*); --emit re-uses it to delimit the units it writes.
static const std::string kBoundary = "; ==EMIT-UNIT-BOUNDARY==\n";

// Copy a scheme string value's bytes into a std::string.
static std::string scm_str(intptr_t v) {
  return std::string(rt_string_bytes(v), (size_t)rt_string_len(v));
}
// The name of a (status . payload) result's status symbol.
static std::string status_of(intptr_t r) {
  return scm_str(rt_symbol_to_string(rt_car(r)));
}

static std::string read_file(const std::string &path) {
  std::ifstream f(path, std::ios::binary);
  std::ostringstream ss;
  ss << f.rdbuf();
  return ss.str();
}

// Parse IR text and add it to the JIT.  On failure, print a message and return false.
static bool add_ir(const std::string &ir, const char *name) {
  auto ctx = std::make_unique<LLVMContext>();
  SMDiagnostic err;
  auto buf = MemoryBuffer::getMemBuffer(ir, name);
  std::unique_ptr<Module> mod = parseIR(buf->getMemBufferRef(), err, *ctx);
  if (!mod) {
    std::string msg;
    raw_string_ostream os(msg);
    err.print(name, os);
    std::cerr << "scheme-run: parse error: " << os.str() << "\n";
    return false;
  }
  mod->setDataLayout(JIT->getDataLayout());
  if (Error e = JIT->addIRModule(ThreadSafeModule(std::move(mod), std::move(ctx)))) {
    std::cerr << "scheme-run: add error: " << toString(std::move(e)) << "\n";
    return false;
  }
  return true;
}

// Preload every user library named in the manifest into `modules` (change:
// run-door-user-libraries).  Mirrors the REPL host's preload_libraries -- the SAME
// compiler modes 5 (manifest text -> paths) and 4 (source -> unit IR) -- but it only
// COLLECTS each unit's IR; it does NOT run __init (the program's @scheme_entry does).
// The compiler owns all resolution; this is just the file I/O + fixpoint orchestration.
// A library resolves against already-loaded units, so we iterate to a fixpoint: each
// pass loads whatever units now have their imports satisfied, giving topological order
// regardless of manifest order.  A pass with no progress and units still deferred means
// an import cycle or an import missing from the manifest.  Returns false on a hard error.
static bool preload_user_libraries(const std::string &manifest, std::vector<std::string> &modules) {
  std::ifstream probe(manifest);
  if (!probe.good()) return true;            // no manifest: no user libraries

  std::string mtext = read_file(manifest);
  // Mode 9: manifest paths EXCLUDING (scheme base) -- the run door bakes it in (mode 8)
  // or omits it (--no-prelude), so it must never be loaded from the manifest.
  rt_repl_set(9, mtext.data(), (intptr_t)mtext.size());
  std::string paths = scm_str(scheme_entry());

  std::vector<std::string> pending;
  std::istringstream lines(paths);
  std::string path;
  while (std::getline(lines, path))
    if (!path.empty()) pending.push_back(path);

  while (!pending.empty()) {
    std::vector<std::string> deferred;
    bool progress = false;
    for (const std::string &p : pending) {
      std::string src = read_file(p);
      rt_repl_set(4, src.data(), (intptr_t)src.size());
      intptr_t r = scheme_entry();
      std::string st = status_of(r);
      if (st == "deferred") { deferred.push_back(p); continue; }
      if (st == "already") { progress = true; continue; }  // e.g. baked (scheme base): no module
      if (st != "ok") {
        std::cerr << "scheme-run: loading library " << p << ": " << scm_str(rt_cdr(r)) << "\n";
        return false;
      }
      modules.push_back(scm_str(rt_car(rt_cdr(r))));   // collect IR; do NOT run __init
      progress = true;
    }
    if (!progress) {                         // every remaining unit is stuck
      for (const std::string &p : deferred)
        std::cerr << "scheme-run: library " << p
                  << ": unresolved or cyclic import (dependency missing from manifest?)\n";
      return false;
    }
    pending.swap(deferred);
  }
  return true;
}

int main(int argc, char **argv) {
  bool emit = false;
  bool no_prelude = false;
  bool resolve = false;                        // --resolve-program: print a program entry, no run
  std::string resolve_name;                    // "" => select the sole program entry
  std::string manifest;
  for (int i = 1; i < argc; i++) {
    std::string a(argv[i]);
    if (a == "--emit") emit = true;
    else if (a == "--no-prelude") no_prelude = true;
    else if (a == "--manifest" && i + 1 < argc) manifest = argv[++i];
    else if (a == "--resolve-program") {
      resolve = true;
      if (i + 1 < argc && argv[i + 1][0] != '-') resolve_name = argv[++i];
    }
  }
  // Manifest resolution: --manifest flag wins, then EMIT_MANIFEST, then the default.
  if (manifest.empty()) {
    const char *mp = std::getenv("EMIT_MANIFEST");
    manifest = mp ? std::string(mp) : std::string("emit-libs.scm");
  }

  // --resolve-program NAME: resolve a manifest (program NAME (source S) [(output O)])
  //   entry to its source + output and print them (source line, then output line;
  //   the output line is empty when the entry has no (output ...)).  Chez-free: the
  //   embedded compiler owns the manifest grammar (mode 10); this host selects one
  //   program by name and does the file I/O.  It never reads stdin, JITs, or runs
  //   anything -- the `emit build` wrapper hands the printed source to bin/scheme-compile.
  if (resolve) {
    GC_INIT();
    rt_repl_set(0, "", 0);                      // init-session (no prelude needed)
    scheme_entry();
    std::ifstream probe(manifest);
    std::string mtext = probe.good() ? read_file(manifest) : std::string();
    rt_repl_set(10, mtext.data(), (intptr_t)mtext.size());
    std::string triples = scm_str(scheme_entry());
    // Parse the mode-10 output: consecutive (name, source, output) line triples.
    std::vector<std::vector<std::string>> progs;
    std::istringstream ls(triples);
    std::string n, s, o;
    while (std::getline(ls, n) && std::getline(ls, s) && std::getline(ls, o))
      progs.push_back({n, s, o});
    if (progs.empty()) {
      std::cerr << "emit: no program entry in manifest " << manifest << "\n";
      return 1;
    }
    const std::vector<std::string> *pick = nullptr;
    if (!resolve_name.empty()) {
      for (const auto &p : progs)
        if (p[0] == resolve_name) { pick = &p; break; }
      if (!pick) {
        std::cerr << "emit: no program entry named " << resolve_name
                  << " in " << manifest << "\n";
        return 1;
      }
    } else if (progs.size() == 1) {
      pick = &progs[0];
    } else {
      std::cerr << "emit: multiple program entries; name one of:";
      for (const auto &p : progs) std::cerr << " " << p[0];
      std::cerr << "\n";
      return 1;
    }
    std::cout << (*pick)[1] << "\n" << (*pick)[2] << "\n";
    return 0;
  }

  // Forward --no-prelude to the embedded compiler (read via %no-prelude?): it skips
  // baking/implying (scheme base).  Must be set before any scheme_entry() call.
  if (no_prelude) setenv("EMIT_NO_PRELUDE", "1", 1);

  // Read the whole program source from stdin (the dispatched entry no longer reads
  // stdin itself; the host owns I/O and hands the program in via mode 7).
  std::string prog_src;
  {
    std::ostringstream ss;
    ss << std::cin.rdbuf();
    prog_src = ss.str();
  }

  GC_INIT();                                 // once, before the compiler allocates

  // 1) Compile in-process.  Seed the session, register the baked (scheme base), preload
  //    any user libraries, then compile the program -- collecting every module's IR.
  rt_repl_set(no_prelude ? 0 : 1, "", 0);    // init-session
  scheme_entry();

  std::vector<std::string> modules;          // unit modules, in the order emitted

  if (!no_prelude) {
    rt_repl_set(8, "", 0);                    // register baked (scheme base)
    intptr_t r = scheme_entry();
    if (status_of(r) != "ok") {
      std::cerr << "scheme-run: (scheme base): " << scm_str(rt_cdr(r)) << "\n";
      return 1;
    }
    modules.push_back(scm_str(rt_car(rt_cdr(r))));
  }

  if (!preload_user_libraries(manifest, modules)) return 1;

  rt_repl_set(7, prog_src.data(), (intptr_t)prog_src.size());   // compile program
  intptr_t pr = scheme_entry();
  std::string pst = status_of(pr);
  if (pst != "ok" && pst != "library") {
    std::cerr << "scheme-run: " << scm_str(rt_cdr(pr)) << "\n";
    return 1;
  }
  std::string prog_ir = scm_str(rt_car(rt_cdr(pr)));
  // A lone define-library compiles to a single unit with no baked (scheme base) and
  // no program entry: drop the base/units set up for the program case and emit/JIT
  // only this module (matches the batch runner; used by `scheme-run --emit < lib.sld`).
  if (pst == "library") modules.clear();

  // --emit: write every module (units then program), joined by the boundary marker, to
  //    stdout and stop -- no JIT.  bin/scheme-compile splits on the marker and links all
  //    units with the runtime.  The IR here is byte-for-byte what the JIT path runs.
  if (emit) {
    for (const std::string &m : modules) {
      std::fwrite(m.data(), 1, m.size(), stdout);
      std::fwrite(kBoundary.data(), 1, kBoundary.size(), stdout);
    }
    std::fwrite(prog_ir.data(), 1, prog_ir.size(), stdout);
    std::fflush(stdout);
    return 0;
  }

  // 2) Stand up the JIT and resolve rt_* / GC symbols from this process (the runtime is
  //    linked in; -rdynamic exports the symbols the IR references).
  InitializeNativeTarget();
  InitializeNativeTargetAsmPrinter();
  InitializeNativeTargetAsmParser();

  auto jitOr = LLJITBuilder().create();
  if (!jitOr) {
    std::cerr << "scheme-run: fatal: failed to create LLJIT: " << toString(jitOr.takeError()) << "\n";
    return 1;
  }
  JIT = std::move(*jitOr);

  auto gen = DynamicLibrarySearchGenerator::GetForCurrentProcess(
      JIT->getDataLayout().getGlobalPrefix());
  if (!gen) {
    std::cerr << "scheme-run: fatal: generator error: " << toString(gen.takeError()) << "\n";
    return 1;
  }
  JIT->getMainJITDylib().addGenerator(std::move(*gen));

  // 3) Add every unit module (baked (scheme base) + preloaded user units), then the
  //    program.  Add order is irrelevant -- symbols resolve lazily and the program's
  //    @scheme_entry drives __init in topological order.  The program's own scheme_entry
  //    (a JITDylib definition) shadows the linked-in compiler's (a process fallback), so
  //    the lookup below resolves the program.
  for (size_t i = 0; i < modules.size(); i++)
    if (!add_ir(modules[i], "<unit>")) return 1;
  if (!add_ir(prog_ir, "<program>")) return 1;

  Expected<ExecutorAddr> sym = JIT->lookup("scheme_entry");
  if (!sym) {
    std::cerr << "scheme-run: lookup error: " << toString(sym.takeError()) << "\n";
    return 1;
  }
  entry_t fn = sym->toPtr<entry_t>();

  // 4) Run the program.  A runtime trap longjmps back here (as in the REPL host) so we
  //    report it rather than crashing; conservative GC needs no unwinding.
  jmp_buf jb;
  rt_trap = &jb;
  if (setjmp(jb) == 0) {
    intptr_t r = fn();
    rt_write(r);
    std::printf("\n");
    std::fflush(stdout);
  } else {
    rt_guard_reset();   // a trap may have bypassed rt_run_guarded's frame pop
    std::cerr << "scheme-run: trap: " << rt_trap_msg << "\n";
    rt_trap = nullptr;
    return 1;
  }
  rt_trap = nullptr;
  return 0;
}
