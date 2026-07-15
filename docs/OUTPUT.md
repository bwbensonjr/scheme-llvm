# Tool Output Convention

> The durable principle behind this doc: **every tool, script, and pipeline stage
> narrates what it is doing, names its inputs and outputs, and reports the metrics that
> make the work observable** — concise by default, quiet or verbose on request, and never
> at the expense of a tool's data output. The normative contract lives in
> `openspec/specs/tooling-observability/`; this page is the "how to write a conforming
> message" contributors actually read. (Origin: issue #3.)

## Message format

```
<verb> <input> -> <output>  [<metrics>]
```

- **verb** — a lowercase action word: `link`, `compile`, `emit`, `assemble`, `regen`,
  `run`, `stage`. First token of the line.
- **input -> output** — for a step that transforms one artifact into another, show the
  arrow. When a step has many inputs (e.g. a link with several objects), name the logical
  target instead of listing them all: `link scheme-run -> build/scheme-run`.
- **metrics** — a trailing clause with the numbers relevant to the action: byte sizes
  (`[12345 bytes]`), durations (`[1.2s]` or `[3s]`), counts (`iter 2`, `12/12 passed`).
  Metrics accompany the action they describe; they are not deferred to a distant summary.

Multi-stage tools that interleave output prefix their lines with a short tag so the
source stays attributable: `regen:`, `test:`, `stage`.

Examples:

```
link scheme-run -> build/scheme-run  [48213 bytes]
emit demos/fact.scm -> /tmp/…/out.ll  [9021 bytes IR]
regen: assemble flat source (ordered cat; no Chez)  [0s]
   schemec fixed point reached (iter 2)
  [PASS] demo values (scheme-run) (3s)
```

## Stream discipline

- **Narration and status go to standard error.** Informational lines, step banners,
  progress, and metrics are all stderr.
- **Standard output carries only machine-consumable data.** For the filter tools —
  `scheme-run --emit` and `schemec` — stdout *is* the emitted LLVM IR, and the
  self-hosting fixed-point and self-emission-equivalence checks compare it byte-for-byte.
  Adding or changing narration MUST NOT alter one byte of stdout.
- A tool whose primary product is itself a human report (the test runners) may print that
  report to stdout; it produces no machine-data stream to protect.

## Verbosity

One control, three levels, read uniformly from the environment variable
`EMIT_VERBOSITY` (unset = `default`):

| level     | value                | shows                                              |
|-----------|----------------------|----------------------------------------------------|
| `quiet`   | `quiet` / `q` / `0`  | errors and data output only — no narration         |
| `default` | unset / anything     | principal actions + headline metrics (concise)     |
| `verbose` | `verbose` / `v` / `2`| per-stage and per-metric detail                    |

Tools that parse their own argv also accept `-q` / `-v` as front-ends to the same
levels. The default is informative enough to follow the work without flooding the
terminal with per-item detail.

```sh
EMIT_VERBOSITY=quiet   make            # errors only
make                                   # concise (default)
EMIT_VERBOSITY=verbose make regen      # per-step timing and detail
```

## Implementing a conforming tool

- **Bash scripts** — source `tools/log.sh` (after `cd`-ing to the repo root) and use its
  helpers: `say` (default-level line), `vsay` (verbose-only line), and `bytes <file>`
  (byte count for a metrics clause). Time steps with the shell's built-in `SECONDS` or a
  `date +%s` delta — no external dependency.
- **Makefile recipes** — source `tools/log.sh` in the recipe line, then `say`.
- **The Chez driver (`compile.ss`)** — reads `EMIT_VERBOSITY` (and `-q`/`-v`); stage
  announcements are gated to `verbose`, and `--dump` additionally pretty-prints the full
  intermediate form after each pass.

## Reviewer checklist

- [ ] Every file read/write, link, and compile is announced (unless `quiet`).
- [ ] Transforms use the `input -> output` arrow.
- [ ] Produced binaries/IR report their byte size; non-trivial steps report duration.
- [ ] All narration is on stderr; no tool's stdout data changed.
- [ ] The tool is quiet under `EMIT_VERBOSITY=quiet` and detailed under `verbose`.
