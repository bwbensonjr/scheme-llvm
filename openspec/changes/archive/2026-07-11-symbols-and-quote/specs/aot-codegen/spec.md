## MODIFIED Requirements

### Requirement: Emit textual LLVM IR and link a native executable

The compiler SHALL lower the lambda-lifted core IL to textual LLVM IR (opaque `ptr`,
LLVM 22 syntax) and drive `clang` to compile and link that IR against the C runtime and
Boehm GC (`libgc`) into a runnable native executable.

#### Scenario: End-to-end AOT build

- **WHEN** a demo program is compiled
- **THEN** the compiler writes a `.ll` file, invokes `clang` to link it with the runtime
  and `libgc`, and the resulting executable runs and reports the program's value

#### Scenario: Values are tagged pointers with heap objects under Boehm

- **WHEN** the emitted IR and runtime represent values
- **THEN** immediates (fixnums, booleans, `()`) are tagged inline, heap objects (pairs,
  closures, interned symbols) are pointer-tagged and allocated through `libgc`, and
  closures are called indirectly through their `code_ptr`

#### Scenario: Symbols are interned and quoted structure is materialized

- **WHEN** the IR encodes a quoted symbol or a quoted list
- **THEN** a symbol is a call to `rt_intern` on an emitted private string constant (equal
  names canonicalize to one object), and a quoted pair is materialized by emitted
  `rt_cons` code over the recursively encoded elements
