;;; emit-libs.scm -- library manifest for the module suites.
;;; (changes: module-artifacts-vertical-slice, module-generalize).  Maps each
;;; library name to its source file and (optionally) an artifact directory;
;;; artifacts default under build/lib when the entry omits `artifacts`.  Entry
;;; order is irrelevant: the build resolves the transitive closure and orders it
;;; topologically (dependencies before dependents).  Note chain-a is listed BEFORE
;;; its dependency chain-b, and dia-a/dia-b before dia-c, on purpose.
((library (mylib)      (source "test/modules/mylib.sld"))
 (library (liba)       (source "test/modules/liba.sld"))
 (library (libb)       (source "test/modules/libb.sld"))
 (library (chain-a)    (source "test/modules/chain-a.sld"))
 (library (chain-b)    (source "test/modules/chain-b.sld"))
 (library (dia-a)      (source "test/modules/dia-a.sld"))
 (library (dia-b)      (source "test/modules/dia-b.sld"))
 (library (dia-c)      (source "test/modules/dia-c.sld"))
 (library (rename-lib) (source "test/modules/rename-lib.sld")))
