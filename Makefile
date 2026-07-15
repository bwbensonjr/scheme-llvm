# Makefile -- Chez-free build for Emit (change: self-hosting-completion).
#
# THE MODEL: a developer needs only LLVM 22 + libgc.  The committed compiler IR
# under bootstrap/ (schemec.ll, embed.ll, embed-repl.ll) is the FAVORED,
# AUTHORITATIVE form -- host-agnostic stage-0 artifacts produced by the compiled
# compiler itself (the self-hosting fixed point).  The default build LINKS those
# committed inputs with the C runtime using LLVM only; it never runs Chez and
# never regenerates IR.
#
#   make            -> scheme-run + repl-host        (link committed IR, no Chez)
#   make schemec    -> the batch text->IR compiler   (link committed IR, no Chez)
#   make regen      -> rebuild the committed IR from source with the compiled
#                      compiler (Chez-free; see tools/regen.sh), then relink
#
# COMMITTED IR IS A CHECKED-IN INPUT, NOT A BUILD PRODUCT (design D4).  The
# bootstrap/*.ll targets carry NO source prerequisites in the default graph, so
# `make` cannot decide they are "stale" and shell out to a regenerator.  This
# deliberately REVERSES fix-stale-repl-host-rebuild's auto-rebuild-on-source-change:
# the committed IR is authoritative and is regenerated only by the explicit
# `make regen`.  The anti-stale guarantee moves to the Chez-gated trust-check
# (run-dev-tests.sh: `make regen` from a clean tree must leave `git diff
# bootstrap/` empty), so a compiler edit that forgot `make regen` fails loudly in
# CI rather than silently shipping stale binaries.
#
# Chez is NOT required for anything here.  It is used only by run-dev-tests.sh
# (the trust-check + IL-level unit tests + the independent-host fixed-point
# re-derivation), and the historical genesis tooling lives in historical/genesis/.

LLVM        := /opt/homebrew/opt/llvm@22
CXX         := $(LLVM)/bin/clang++
CC          := $(LLVM)/bin/clang
LLVM_CONFIG := $(LLVM)/bin/llvm-config
GC_INC      := /opt/homebrew/include
GC_LIB      := /opt/homebrew/lib

CXXFLAGS    := $(shell $(LLVM_CONFIG) --cxxflags) -I$(GC_INC)
LDFLAGS     := $(shell $(LLVM_CONFIG) --ldflags --libs orcjit native --system-libs)

# Binaries.
HOST        := build/repl-host
RUN         := build/scheme-run
SCHEMEC     := build/schemec

# Committed, host-agnostic stage-0 compiler IR (checked-in INPUTS; design D3/D4).
SCHEMEC_LL     := bootstrap/schemec.ll
EMBED_LL       := bootstrap/embed.ll
EMBED_REPL_LL  := bootstrap/embed-repl.ll

# ===========================================================================
# Default build: link binaries from the committed IR with LLVM only (no Chez).
# ===========================================================================
.PHONY: all
all: $(RUN) $(HOST)

.PHONY: scheme-run repl-host schemec
scheme-run: $(RUN)
repl-host:  $(HOST)
schemec:    $(SCHEMEC)

# Interactive REPL host: A-links the embedded interactive compiler (embed-repl.ll)
# and exports rt_* / scheme_entry (-rdynamic) so JIT'd code resolves them here.
$(HOST): build/host.o build/runtime-host.o $(EMBED_REPL_LL) Makefile
	$(CXX) build/host.o build/runtime-host.o $(EMBED_REPL_LL) \
	  -rdynamic $(LDFLAGS) -L$(GC_LIB) -lgc -o $@
	@echo "built $@"

# In-process compile-and-run runner: A-links the embedded batch compiler
# (embed.ll).  Supports `--emit` (write IR to stdout; Chez-free AOT, design D7).
$(RUN): build/run.o build/runtime-host.o $(EMBED_LL) Makefile
	$(CXX) build/run.o build/runtime-host.o $(EMBED_LL) \
	  -rdynamic $(LDFLAGS) -L$(GC_LIB) -lgc -o $@
	@echo "built $@"

# Batch text->IR filter compiler: links the committed schemec IR with the
# runtime's RT_FILTER_MAIN (so the program's output is exactly the emitted IR).
$(SCHEMEC): $(SCHEMEC_LL) src/runtime/runtime.c Makefile | build
	$(CC) -O2 -DRT_FILTER_MAIN -I$(GC_INC) -L$(GC_LIB) \
	  src/runtime/runtime.c $(SCHEMEC_LL) -lgc -o $@
	@echo "built $@"

# --- objects ---------------------------------------------------------------
# Runtime compiled as C without its standalone main (the hosts supply one).
build/runtime-host.o: src/runtime/runtime.c Makefile | build
	$(CC) -std=c11 -O2 -I$(GC_INC) -DRT_NO_MAIN -c $< -o $@

# REPL host, compiled as C++ against the LLVM headers.
build/host.o: src/repl/host.cpp Makefile | build
	$(CXX) $(CXXFLAGS) -c $< -o $@

# Runner host, compiled as C++ against the LLVM headers.
build/run.o: src/run.cpp Makefile | build
	$(CXX) $(CXXFLAGS) -c $< -o $@

# ===========================================================================
# Regeneration: rebuild the committed IR from source, Chez-free (explicit only).
# ===========================================================================
# tools/regen.sh assembles the flat source by ordered `cat` and compiles it with
# the self-hosted schemec (iterating to the byte-identical fixed point).  It needs
# the current schemec binary, so build that from committed IR first; then relink
# every binary from the regenerated IR.
.PHONY: regen
regen: $(SCHEMEC)
	CC="$(CC)" GC_INC="$(GC_INC)" GC_LIB="$(GC_LIB)" tools/regen.sh
	$(MAKE) all schemec
	@echo "regen complete -- committed IR + binaries rebuilt with no Chez"

# build/ is a real directory (order-only prerequisite), not a phony target.
build:
	mkdir -p build

# clean removes the binaries and every build/ intermediate, but LEAVES the
# committed bootstrap/*.ll (checked-in inputs; rebuild them with 'make regen').
.PHONY: clean
clean:
	rm -f $(HOST) $(RUN) $(SCHEMEC) \
	      build/host.o build/run.o build/runtime-host.o \
	      build/schemec build/schemec-next \
	      build/schemec.scm build/embed.scm build/embed-repl.scm \
	      build/prelude-source.scm build/T-*.scm \
	      build/schemec.ll build/schemec.ll.check
	@echo "note: committed bootstrap/*.ll are checked-in inputs, left in place"
	@echo "      (rebuild from source with 'make regen')"
