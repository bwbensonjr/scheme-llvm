// host.cpp -- persistent ORC/LLJIT host for the interactive Scheme REPL
// (change: interactive-repl, Group 4).
//
// One long-lived process: GC is initialized once, and a single LLJIT instance
// keeps the GC heap, symbol-intern table, and rt_* runtime alive for the whole
// session.  Each entered form arrives as its own LLVM IR module; the host adds
// it to the running JIT, looks up its @__repl_N thunk, and calls it.  Globals
// defined by earlier modules resolve for later modules within the shared
// JITDylib, so values (pairs, closures, strings, symbols) persist across forms.
//
// stdin protocol (one frame per form), spoken by the Chez REPL driver:
//   "<entry-symbol> <byte-count>\n"  followed by exactly <byte-count> bytes of IR
// For each frame the host prints exactly one line to stdout: the printed value,
// or "!<message>" on a compile/JIT error or a runtime trap.  EOF ends the loop.

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
#include <iostream>
#include <sstream>
#include <string>
#include <memory>

#include <gc/gc.h>

using namespace llvm;
using namespace llvm::orc;

extern "C" {
  void rt_write(intptr_t v);   // runtime value printer (linked into this host)
  extern jmp_buf *rt_trap;     // runtime trap escape hook (see runtime.c)
  extern char rt_trap_msg[];   // last trap's message
}

typedef intptr_t (*thunk_t)(void);

static std::unique_ptr<LLJIT> JIT;

// Add one IR module and run its entry thunk; print the value or "!<error>".
static void handle_form(const std::string &name, std::string ir) {
  auto ctx = std::make_unique<LLVMContext>();
  SMDiagnostic err;
  auto buf = MemoryBuffer::getMemBuffer(ir, "<repl-form>");
  std::unique_ptr<Module> mod = parseIR(buf->getMemBufferRef(), err, *ctx);
  if (!mod) {
    std::string msg;
    raw_string_ostream os(msg);
    err.print("<repl-form>", os);
    std::cout << "!parse error: " << os.str() << "\n" << std::flush;
    return;
  }
  mod->setDataLayout(JIT->getDataLayout());

  if (Error e = JIT->addIRModule(ThreadSafeModule(std::move(mod), std::move(ctx)))) {
    std::cout << "!add error: " << toString(std::move(e)) << "\n" << std::flush;
    return;
  }

  Expected<ExecutorAddr> sym = JIT->lookup(name);
  if (!sym) {
    std::cout << "!lookup error: " << toString(sym.takeError()) << "\n" << std::flush;
    return;
  }
  thunk_t fn = sym->toPtr<thunk_t>();

  // Trap isolation: a runtime trap longjmps back here instead of exit()ing, so
  // the session survives.  Conservative GC needs no unwinding of JIT'd frames.
  jmp_buf buf2;
  rt_trap = &buf2;
  if (setjmp(buf2) == 0) {
    intptr_t r = fn();
    rt_write(r);               // prints the value (no newline)
    std::printf("\n");
    std::fflush(stdout);
  } else {
    std::cout << "!trap: " << rt_trap_msg << "\n" << std::flush;
  }
  rt_trap = nullptr;
}

int main() {
  GC_INIT();                                   // once for the whole session

  InitializeNativeTarget();
  InitializeNativeTargetAsmPrinter();
  InitializeNativeTargetAsmParser();

  // The parent (Chez `process`) merges our stderr into the result pipe, so keep
  // all framed output on stdout and report fatal startup errors there too.
  auto jitOr = LLJITBuilder().create();
  if (!jitOr) {
    std::cout << "!fatal: failed to create LLJIT: " << toString(jitOr.takeError())
              << "\n" << std::flush;
    return 1;
  }
  JIT = std::move(*jitOr);

  // Resolve rt_* and GC symbols from this host process (runtime.c is linked in,
  // exported via -rdynamic).
  auto gen = DynamicLibrarySearchGenerator::GetForCurrentProcess(
      JIT->getDataLayout().getGlobalPrefix());
  if (!gen) {
    std::cout << "!fatal: generator error: " << toString(gen.takeError())
              << "\n" << std::flush;
    return 1;
  }
  JIT->getMainJITDylib().addGenerator(std::move(*gen));

  // Frame loop: "<name> <count>\n" then <count> bytes of IR.
  std::string header;
  while (std::getline(std::cin, header)) {
    if (header.empty()) continue;
    std::istringstream hs(header);
    std::string name;
    size_t count = 0;
    hs >> name >> count;
    std::string ir(count, '\0');
    std::cin.read(&ir[0], (std::streamsize)count);
    handle_form(name, std::move(ir));
  }
  return 0;
}
