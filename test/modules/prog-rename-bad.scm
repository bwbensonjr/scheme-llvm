;;; prog-rename-bad.scm -- the INTERNAL name of a renamed export is not visible;
;;; referencing %fast-map (only fmap is exported) must fail to build.
(import (rename-lib))
(%fast-map)
