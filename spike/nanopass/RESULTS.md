# Spike results: nanopass vs. hand-rolled `match`

Three probe passes, each written both ways, run on the same shared inputs
(`tests.ss`) with output compared for equality (`run.ss`). **All 12 cases agree**
— the two implementations are behaviorally identical.

Reproduce:

```sh
cd spike/nanopass
chez --libdirs ".:vendor:vendor/nanopass" --script run.ss
# => 12/12 agree; 0 mismatch(es)
```

## What each pass does (distilled from Chez `s/cpnanopass.ss`)

| pass | transition | essential transform |
|------|------------|---------------------|
| `recognize-let`       | L1→L2 | `(call (lambda (x…) body) e…)` → `(let ([x e]…) body)` |
| `convert-assignments` | L3→L4 | remove `set!` by boxing assigned vars (ref→`unbox`, `set!`→`set-box!`, binder→temp+`box`) |
| `convert-closures`    | L5→L6 | `letrec` of lambdas → `closures` form naming each lambda's free vars |

Simplifications vs. production Chez (both sides, equally): bare `lambda` instead of
case-lambda/clause/interface; alpha-renamed vars so "assigned?"/"free" are simple set
ops; explicit `box`/`unbox`/`set-box!` forms instead of `cons`/`car`/`set-car!`
primcalls. These keep the probe at this project's altitude without favoring either side.

## Scoring (design D4)

### 1. Line count

Per-pass **logic** (code lines, comments/blanks stripped):

| pass | nanopass | hand-rolled |
|------|---------:|------------:|
| recognize-let          |  9 | 15 |
| convert-assignments    | 43 | 44 |
| convert-closures       | 22 | 32 |
| **3-pass total**       | **74** | **91** |

**One-time cost:** nanopass requires `languages.ss` = **40** lines of `define-language`
IL definitions. Hand-rolled requires **0** (the IR is plain s-exprs; the "language" is
whatever set of `match` clauses each pass handles). Both share `util.ss` (13 lines).

**Total maintained code at 3 passes:** nanopass `40 + 74 = 114`; hand-rolled `91`.
Hand-rolled is ~20% lighter *here*, because the 40-line IL tax dominates the ~17-line
logic savings.

**Crossover:** nanopass saves ≈ 5.7 logic lines/pass but costs ≈ 40 lines of IL up
front, so nanopass total drops below hand-rolled only past **~7–8 passes** — and later
still in practice, since more passes usually add IL forms (the 40 grows). This is the
design's "nanopass's payoff scales with pass count" hypothesis, now quantified.

### 2. Boilerplate share

- **Trivial structural pass (`recognize-let`)**: nanopass wins decisively. Its
  auto-catamorphism means the 9 lines are almost entirely the one real clause; the
  hand-rolled 15 are ~80% pass-through plumbing (quote/if/seq/letrec/call recurring
  unchanged). Absolute savings are small (6 lines), but the *signal-to-noise* gap is
  large.
- **Analysis-bearing passes (`convert-assignments`, `convert-closures`)**: the
  advantage **evaporates**. Both passes need a full traversal that folds the IR down to
  a *set* (`find-assigned`, `free-vars`), not an IR→IR rewrite — and nanopass's
  catamorphism does **not** help there. On both sides that analysis is a hand-written
  walk (`nanopass-case` vs. `match`), nearly line-for-line equal. Hence 43≈44 and 22 vs
  32 with most of the closures gap being the two pass-through box clauses, not logic.

> Finding: nanopass automates IR→IR structural recursion, but **not IR→data analysis**.
> Real pipelines have many analysis passes, which blunts nanopass's headline advantage.

### 3. Readability

Genuinely split, and it splits exactly along the two values in `CLAUDE.md`:

- **nanopass** — the 40 lines of `define-language` *are* an executable spec of every
  stage's IL. That is the "clear stages, transparency" goal delivered as an artifact.
  Cost: a reader must know nanopass (`define-pass`, cata `,[…]`, `with-output-language`,
  meta-var stems) to follow a pass.
- **hand-rolled** — plain Scheme + `match`; any Scheme reader follows it with zero
  framework knowledge. That is the "as simple as possible / read every line" goal. Cost:
  no artifact states each stage's IL; the "language" is implicit and unchecked.

### 4. Safety lost

nanopass's real free win: **exhaustiveness**. An unhandled input form is a
pass-definition-time error, and output is checked against the target language. The
hand-rolled side has neither — an unhandled form is a run-time `match` failure (or worse,
silent if a catch-all is added), and nothing checks that output is well-formed. For a
fast-moving frontend this is the strongest point in nanopass's favor.

## Self-hosting tie-breaker (design D1 / risks)

Parked as a goal, but it is the sharpest differentiator here: the **dependency weight**.

- nanopass: **9,683 LOC**, heavily `syntax-case`/hygiene-based — a large surface a future
  self-hosted compiler must support before it can run its own passes.
- `match`: **325 LOC**, easily vendored/ported.

For an eventual drop-Chez self-host, `match` is dramatically lighter to carry.

## Verdict

**It is close — no blowout — and the top-third pipeline sits right at the crossover.**

Scorecard for *this* project (minimal Scheme→LLVM, ~5–9 frontend passes, values simplicity
and eventual self-hosting):

| dimension | winner |
|-----------|--------|
| total lines @ realistic pass count | hand-rolled (until ~7–8 passes) |
| boilerplate on trivial structural passes | nanopass |
| boilerplate on analysis passes | tie |
| readability — stages-as-artifact | nanopass |
| readability — no framework to learn | hand-rolled |
| exhaustiveness / output well-formedness | **nanopass** |
| dependency weight (self-hosting) | **hand-rolled** |

**Recommendation: start hand-rolled with the Chez `match`, and keep this spike as the
reference.** At the realistic early pass count the total-line and dependency-weight
numbers favor it, `match` is a 325-line vendorable dependency vs. nanopass's ~10k
syntax-case-heavy one that complicates self-hosting, and the analysis passes real
pipelines are full of do not benefit from nanopass's catamorphism anyway.

**Revisit nanopass if the pipeline grows past ~7–10 passes or the IL churns often** —
at that scale its line savings, self-documenting ILs, and free exhaustiveness check
start to dominate. The one thing worth stealing regardless: nanopass's discipline of a
**named, explicit IL per stage** (even as a comment/spec), because that is the
transparency the project is after.

This leans *against* `LLVM.md`'s current "uses the nanopass framework" commitment —
softening it (not reversing it) is the reconciliation `docs/PIPELINE.md` records.
