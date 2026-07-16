;;; emit-libs-cycle.scm -- manifest for the import-cycle test (change:
;;; module-generalize).  Kept SEPARATE from the main manifest so the REPL's eager
;;; preload of every manifest library does not trip over the deliberate cycle.
((library (cyc-a) (source "test/modules/cyc-a.sld"))
 (library (cyc-b) (source "test/modules/cyc-b.sld")))
