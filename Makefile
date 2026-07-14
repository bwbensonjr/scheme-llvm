# Makefile -- dependency-driven build for the persistent ORC/LLJIT REPL host
# (change: fix-stale-repl-host-rebuild).
#
# The host links a snapshot of the C runtime into itself and the ORC JIT resolves
# rt_* symbols from the running process, so the host MUST be rebuilt whenever the
# runtime or host sources change -- otherwise a newly added rt_* function is
# absent and the prelude (loaded as one batch module) fails to materialize.  This
# graph makes that automatic: callers run `make build/repl-host` unconditionally
# and make no-ops when the binary is already up to date.
#
# NOTE (mtime caveat): staleness is decided by file mtimes.  `git checkout`/`clone`
# sets working-tree mtimes to checkout time, so a source can end up older than an
# existing binary even when its content differs; make (like any timestamp check)
# will not rebuild in that case.  Recover with `touch` on the source or
# `rm build/repl-host`.  Accepted limitation; a content-hash stamp would be the
# only fully robust fix and is out of scope.

LLVM       := /opt/homebrew/opt/llvm@22
CXX        := $(LLVM)/bin/clang++
CC         := $(LLVM)/bin/clang
LLVM_CONFIG := $(LLVM)/bin/llvm-config
GC_INC     := /opt/homebrew/include
GC_LIB     := /opt/homebrew/lib

CXXFLAGS   := $(shell $(LLVM_CONFIG) --cxxflags) -I$(GC_INC)
LDFLAGS    := $(shell $(LLVM_CONFIG) --ldflags --libs orcjit native --system-libs)

HOST       := build/repl-host
CHEZ       := chez

.PHONY: repl-host schemec clean
repl-host: $(HOST)

# Link; -rdynamic exports rt_* so JIT'd code resolves them from this process.
$(HOST): build/host.o build/runtime-host.o Makefile
	$(CXX) build/host.o build/runtime-host.o \
	  -rdynamic $(LDFLAGS) -L$(GC_LIB) -lgc -o $@
	@echo "built $@"

# Runtime compiled as C, without its standalone main (the host supplies one).
build/runtime-host.o: src/runtime/runtime.c Makefile | build
	$(CC) -std=c11 -O2 -I$(GC_INC) -DRT_NO_MAIN -c $< -o $@

# Host compiled as C++ against the LLVM headers.
build/host.o: src/repl/host.cpp Makefile | build
	$(CXX) $(CXXFLAGS) -c $< -o $@

# --- self-hosted `schemec` (self-hosting-bootstrap task 2.1) ---------------
# Stage-1 schemec: the compiler core assembled into one program with a
# stdin->stdout filter entry `(display (compile-source-string (read-all-stdin)))`,
# compiled to native by the Chez-hosted compiler.  Linked with the runtime's
# RT_FILTER_MAIN so the program's output is exactly the emitted IR (the filter
# main suppresses the final-value print that would otherwise append `()\n`).
# Prelude is prepended at --emit-ir time; header/toolchain stay the driver's job.
SCHEMEC    := build/schemec
CORE_SS    := src/match.sls src/util.ss src/parse.ss \
              src/passes/expand.ss src/passes/recognize-let.ss \
              src/passes/convert-assignments.ss src/passes/convert-closures.ss \
              src/passes/lower.ss src/emit.ss src/core.ss
DRIVER_SS  := src/compile.ss $(CORE_SS) src/prelude.scm

schemec: $(SCHEMEC)

# 1) assemble the core into one program with the filter entry
build/schemec.scm: tools/assemble-core.ss $(CORE_SS) | build
	$(CHEZ) --script tools/assemble-core.ss --filter-main

# 2) compile to core IR (prelude prepended) via the Chez-hosted compiler
build/schemec.ll: build/schemec.scm $(DRIVER_SS) | build
	$(CHEZ) --libdirs src --script src/compile.ss --emit-ir < build/schemec.scm > $@

# 3) link with the runtime's filter main into a native stdin->stdout IR filter
$(SCHEMEC): build/schemec.ll src/runtime/runtime.c Makefile | build
	$(CC) -O2 -DRT_FILTER_MAIN -I$(GC_INC) -L$(GC_LIB) src/runtime/runtime.c build/schemec.ll -lgc -o $@
	@echo "built $@"

build:
	mkdir -p build

clean:
	rm -f $(HOST) build/host.o build/runtime-host.o \
	      $(SCHEMEC) build/schemec.scm build/schemec.ll
