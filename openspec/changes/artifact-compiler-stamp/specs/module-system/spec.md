## MODIFIED Requirements

### Requirement: Stale-artifact rebuild

The build driver SHALL rebuild a library's `.ll` and `.exports` artifacts when they are
missing, older than the library's source, **or produced by a different compiler**, and SHALL
reuse existing artifacts only when they are newer than the source **and** were produced by the
current compiler, so a multi-unit build does not recompile units whose source is unchanged yet
never reuses a unit compiled by a different (e.g. older) compiler.

Compiler identity SHALL be captured as a **compiler-identity stamp** — a version marker
combined with a content hash over the compiler sources that determine the emitted IR — and
SHALL be recorded alongside each unit's artifacts when they are written. An artifact whose
recorded stamp differs from the current compiler's stamp SHALL be treated as stale and
recompiled, even when its source is unchanged.

#### Scenario: A changed source triggers a rebuild

- **WHEN** a library's source is newer than its committed `.ll`/`.exports` artifacts (or the
  artifacts are absent) and a build resolves an import of that library
- **THEN** the driver recompiles the library, writing fresh `.ll` and `.exports`

#### Scenario: Fresh artifacts are reused

- **WHEN** a library's artifacts are newer than its source and carry the current compiler's
  identity stamp, and a build resolves an import of that library
- **THEN** the driver reuses the existing artifacts without recompiling the library

#### Scenario: A compiler change invalidates unchanged-source artifacts

- **WHEN** the compiler that determines emitted IR has changed (its identity stamp differs
  from the stamp recorded with a unit's artifacts) but the library's source is unchanged, and
  a build resolves an import of that library
- **THEN** the driver recompiles the library instead of reusing the stale artifact, so the
  emitted IR reflects the current compiler (e.g. a boolean literal re-encoding is not served
  from a unit compiled by the old emitter)
