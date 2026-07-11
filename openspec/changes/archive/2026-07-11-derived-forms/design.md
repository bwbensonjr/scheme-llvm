## Context

The compiler accepts the core forms `if`, `lambda`, application, `let`, `letrec`,
`begin`, `set!`, and (from M2) top-level `define`. There is no multi-way `cond`, no
`and`/`or`, `when`/`unless`, `let*`, or named `let`. M2's `collect-toplevel` already
established the precedent that a source→source desugaring is a legitimate, observable
frontend stage. This change generalizes that: a small `expand` pass that rewrites derived
forms to core, and doubles as a rehearsal for the eventual `syntax-rules` expander.

## Goals / Non-Goals

**Goals:**
- Add `cond`, `and`, `or`, `when`, `unless`, `let*`, and named `let` as derived forms.
- Implement them as one **observable, source→source `expand` stage** feeding the existing
  parser — no new core IL, no backend or runtime changes.
- Preserve correct Scheme semantics: short-circuit evaluation, single evaluation of each
  operand (notably `or`), and proper tail position for the last form of a branch.

**Non-Goals:**
- `case`, `cond` `=>` clauses, `cond` bare-test clauses, `quasiquote`, `do`,
  `delay`/`force`, `parameterize` — deferred to the macro system.
- A general hygienic macro expander. This pass is hand-written per form; it only
  *rehearses* the shape.
- Internal `define` (still top-level only, per M2).

## Decisions

### D1 — A dedicated source→source `expand` stage (not folded into `parse`)

`expand` rewrites derived forms into core s-expressions, which then flow through the
existing `parse-expr`. It runs on the single whole-program expression produced by
`collect-toplevel`, recursively over the entire tree.

Pipeline position:
```
read → collect-toplevel → expand → parse+rename → recognize-let → … → emit
                          ▲ NEW
```

**Rationale:** (a) observability — the project's transparency discipline wants each
desugaring visible under `--dump`; (b) it keeps `parse-expr` a thin core-only reader;
(c) it is the intended rehearsal for the macro expander, which will also be a
source→source pass in this slot.

**Alternative considered:** add clauses directly to `parse-expr` producing core IL.
Rejected — it entangles surface sugar with core parsing and hides the expansion from
`--dump`.

### D2 — Desugarings

| form | expansion |
|------|-----------|
| `(cond [t b...] ... [else e...])` | `(if t (begin b...) <rest>)`, `else` → `(begin e...)`, empty → `#f` |
| `(and)` | `#t` |
| `(and e)` | `e` |
| `(and e rest...)` | `(if e (and rest...) #f)` — intermediates are tests (eval once), last operand in value position |
| `(or)` | `#f` |
| `(or e)` | `e` |
| `(or e rest...)` | `(let ([t e]) (if t t (or rest...)))` — `t` a **fresh** name so `e` is evaluated once |
| `(when t b...)` | `(if t (begin b...) #f)` |
| `(unless t b...)` | `(if t #f (begin b...))` |
| `(let* () b...)` | `(begin b...)` |
| `(let* ([x e] rest...) b...)` | `(let ([x e]) (let* (rest...) b...))` |
| `(let name ([x e]...) b...)` | `(letrec ([name (lambda (x...) b...)]) (name e...))` |

`and` needs **no** temp: intermediate operands appear only as `if` tests (evaluated
once), and the final operand appears once in value position. `or` **does** need a temp,
because it must return the truthy operand's value without re-evaluating it.

### D3 — Fresh names for `or` come from the existing rename counter

`or`'s temp is generated via the same `fresh-name` counter the alpha-renamer uses (reset
per program in `compile-file`). The temp is an ordinary binding; `parse`+`rename` treat
it like any other, so no special hygiene machinery is needed at this scale. This is a
known limitation vs. real macro hygiene (a user variable literally named like the
generated temp could theoretically collide) — acceptable here because the generator
controls the name and can make it unrepresentable in source (e.g. a reserved prefix).

### D4 — Derived keywords become reserved

Like the primitive names, `cond and or when unless let*` are recognized structurally and
cannot be rebound. Named `let` is disambiguated from ordinary `let` by a symbol in the
first position. This is a minor breaking change with no impact on existing demos.

## Risks / Trade-offs

- **`or` temp hygiene** → Mitigation: generate temps with a reserved, source-illegal
  prefix and rely on alpha-rename; revisit when the real macro expander lands.
- **Tail position of branch bodies** → the last form of a `cond`/`when` body must remain
  in tail position so `musttail` still applies. Mitigation: desugar to `if`/`begin` that
  keep the last form in tail position (verified with a tail-recursive `cond` demo).
- **Expansion order vs. `collect-toplevel`** → `expand` runs on the already-collected
  single expression, so top-level `define` bodies are expanded too; confirm a derived
  form inside a top-level `define` body works (covered by a demo).
- **Scope creep toward macros** → keep the pass a fixed per-form rewrite; resist adding a
  general pattern matcher here (that is the macro change).
