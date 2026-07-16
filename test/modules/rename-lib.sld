;;; rename-lib.sld -- export-rename fixture (change: module-generalize).
;;; The internal name %fast-map is exported under the external name fmap; the
;;; internal name must NOT be visible to importers, and the emitted symbol is based
;;; on the INTERNAL name (@"rename.lib:%fast-map").
(define-library (rename-lib)
  (export (rename %fast-map fmap))
  (begin
    (define (%fast-map) 77)))
