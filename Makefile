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

# The interactive REPL host A-links the EMBEDDED compiler (change:
# repl-embedded-incremental): a compiler-source change must relink the host, so
# bootstrap/embed-repl.ll is a prerequisite of $(HOST) and is itself rebuilt from
# the core sources below (same staleness graph as scheme-run's embed.ll).
EMBED_REPL_LL := bootstrap/embed-repl.ll

.PHONY: repl-host schemec scheme-run clean
repl-host: $(HOST)

# Link; -rdynamic exports rt_* AND the embedded compiler's scheme_entry so JIT'd
# code resolves them from this process.  The embedded compiler IR is linked in.
$(HOST): build/host.o build/runtime-host.o $(EMBED_REPL_LL) Makefile
	$(CXX) build/host.o build/runtime-host.o $(EMBED_REPL_LL) \
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

# --- in-process compile-and-run runner (change: path-a-embedding) ----------
# `build/scheme-run` compiles AND runs a whole Scheme program in one process,
# with no Chez and no clang/lli: the compiled compiler (bootstrap/embed.ll) is
# LINKED into the runner; its ccc `scheme_entry` reads the program from stdin and
# returns the emitted IR as a string, which src/run.cpp then JITs (ORC/LLJIT) and
# runs.  bootstrap/embed.ll is a committed, host-agnostic stage-0 artifact (it
# carries no target header), so a Chez-free checkout still links the runner; it is
# regenerated here whenever the core sources change (same mtime caveat as the host
# graph above).  The runner reuses build/runtime-host.o (RT_NO_MAIN).
RUN        := build/scheme-run
EMBED_LL   := bootstrap/embed.ll

scheme-run: $(RUN)

# assemble the core into one program with the embedded-compiler entry
build/embed.scm: tools/assemble-core.ss $(CORE_SS) src/prelude.scm | build
	$(CHEZ) --script tools/assemble-core.ss --embed-entry

# compile the embedded compiler to host-agnostic IR (prelude prepended); the
# committed stage-0 artifact.
$(EMBED_LL): build/embed.scm $(DRIVER_SS) | bootstrap
	$(CHEZ) --libdirs src --script src/compile.ss --emit-ir < build/embed.scm > $@

# --- interactive embedded compiler (change: repl-embedded-incremental) ------
# bootstrap/embed-repl.ll is the assembled core PLUS src/repl-core.ss (the ported
# run-repl orchestration), ending in the dispatched scheme_entry the REPL host
# calls per operation.  Committed host-agnostic stage-0 artifact (no target
# header), regenerated whenever the core, repl-core, assembly, or prelude change;
# linked into build/repl-host above so a compiler-source change relinks the host.

# assemble the core + repl-core into one program with the --repl-entry dispatcher
build/embed-repl.scm: tools/assemble-core.ss $(CORE_SS) src/repl-core.ss src/prelude.scm | build
	$(CHEZ) --script tools/assemble-core.ss --repl-entry

$(EMBED_REPL_LL): build/embed-repl.scm $(DRIVER_SS) | bootstrap
	$(CHEZ) --libdirs src --script src/compile.ss --emit-ir < build/embed-repl.scm > $@

# run.cpp compiled as C++ against the LLVM headers.
build/run.o: src/run.cpp Makefile | build
	$(CXX) $(CXXFLAGS) -c $< -o $@

# link: embedded compiler IR + runtime (no standalone main) + the runner host.
$(RUN): build/run.o build/runtime-host.o $(EMBED_LL) Makefile
	$(CXX) build/run.o build/runtime-host.o $(EMBED_LL) \
	  -rdynamic $(LDFLAGS) -L$(GC_LIB) -lgc -o $@
	@echo "built $@"

build:
	mkdir -p build

bootstrap:
	mkdir -p bootstrap

clean:
	rm -f $(HOST) build/host.o build/runtime-host.o \
	      $(SCHEMEC) build/schemec.scm build/schemec.ll \
	      $(RUN) build/run.o build/embed.scm build/embed-repl.scm
	@echo "note: committed $(EMBED_LL) and $(EMBED_REPL_LL) are left in place (regenerate with 'make $(EMBED_LL) $(EMBED_REPL_LL)')"
