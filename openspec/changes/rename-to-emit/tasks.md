## 1. Documentation and user-visible strings

- [x] 1.1 Update `README.md`: change the `# Scheme LLVM` title to `# Emit` and update the tagline/prose (e.g. "A Scheme to LLVM compiler", "self-hosting Scheme→LLVM compiler") to name *Emit* while keeping the accurate "Scheme→LLVM" technical description of what it does.
- [x] 1.2 Update the REPL banner in `src/repl/host.cpp:203` (`"scheme-llvm REPL ..."`) to say `Emit REPL`.
- [x] 1.3 Update the REPL banner in `test/repl.ss:85` (`"scheme-llvm REPL ..."`) to say `Emit REPL`.
- [x] 1.4 Update the `Makefile` header comment (line 1) to name *Emit* instead of `scheme-llvm`.

## 2. Source-comment terminology sweep

- [x] 2.1 Update `scheme-llvm` references in code comments to *Emit* in `src/emit.ss` (line ~251), `src/parse.ss` (line ~31), `src/repl-core.ss` (line ~5), and `src/prelude.scm` (line ~210).
- [x] 2.2 Update `scheme-llvm` references in the comments of `test/self-host-fixpoint.sh` to *Emit* (does not affect emitted IR; test-script prose only).
- [x] 2.3 Confirm the sweep is complete: `grep -rIn -e "scheme-llvm" -e "Scheme LLVM" --exclude-dir=.git --exclude-dir=openspec --exclude-dir=bootstrap --exclude-dir=historical --exclude-dir=spike` returns nothing except intentional "Scheme→LLVM" technical descriptions.

## 3. Spec prose (main specs)

- [ ] 3.1 Sync the three delta specs (`core-language`, `self-hosting`, `compiler-pipeline`) into the main specs so the MODIFIED requirement prose reads *Emit* (handled by `/opsx:apply` or `openspec sync`/`archive`).
- [x] 3.2 Directly edit the non-requirement prose that names the compiler and is not covered by a delta: the **Purpose** paragraph of `openspec/specs/self-hosting/spec.md` (line ~6, "the subset scheme-llvm accepts" → "the subset Emit accepts").
- [ ] 3.3 Confirm no `scheme-llvm` / `Scheme LLVM` prose remains in `openspec/specs/` (excluding archived changes).

## 4. Regenerate bootstrap IR and verify self-hosting

- [x] 4.1 Regenerate the committed bootstrap IR from source, Chez-free: `make regen` (rebuilds `bootstrap/embed.ll`, `bootstrap/embed-repl.ll`, `bootstrap/schemec.ll` — which embed the prelude source text edited in 2.1 — and relinks binaries). Fixed point reached at iteration 1; `embed`/`embed-repl` each shrank 7 bytes.
- [x] 4.2 Verify the self-hosting fixed point and trust-check: `test/self-host-fixpoint.sh` passes (stage-2 == stage-3, and Chez stage-2 == committed `bootstrap/schemec.ll`).
- [x] 4.3 Run the full test suite (`./run-all-tests.sh`) to confirm no behavior changed (53 + 7 passed, 0 failed).
- [x] 4.4 Commit any regenerated `bootstrap/*.ll` artifacts alongside the source edits.

## 5. Repository rename and hosting

- [ ] 5.1 Merge the in-repo edits to `main`.
- [ ] 5.2 Rename the GitHub repository `bwbensonjr/scheme-llvm` → `bwbensonjr/emit`.
- [ ] 5.3 Update the GitHub repository description to name the project *Emit*.
- [ ] 5.4 Update the local `origin` remote URL to the renamed repository (`git remote set-url origin ssh://git@github.com/bwbensonjr/emit`).
- [ ] 5.5 Verify `git fetch` / `git push` work against the new remote and close issue #2.
