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

# Host-agnostic toolchain via the shared resolver (tools/toolchain.sh) -- the
# same source of truth the Scheme driver and test harnesses use.  Override with
# LLVM_CONFIG/LLVM_PREFIX or GC_PREFIX; see `configurable-llvm-toolchain`.
LLVM_CONFIG := $(shell tools/toolchain.sh llvm-config)
LLVM_BINDIR := $(shell tools/toolchain.sh llvm-bindir)
CXX        := $(LLVM_BINDIR)/clang++
CC         := $(LLVM_BINDIR)/clang
GC_INC     := $(shell tools/toolchain.sh gc-inc)
GC_LIB     := $(shell tools/toolchain.sh gc-lib)

CXXFLAGS   := $(shell $(LLVM_CONFIG) --cxxflags) -I$(GC_INC)
LDFLAGS    := $(shell $(LLVM_CONFIG) --ldflags --libs orcjit native --system-libs)

HOST       := build/repl-host

.PHONY: repl-host clean
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

build:
	mkdir -p build

clean:
	rm -f $(HOST) build/host.o build/runtime-host.o
