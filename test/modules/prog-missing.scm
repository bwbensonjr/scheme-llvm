;;; prog-missing.scm -- importing a library absent from the manifest must error.
(import (nope))
(nope-proc)
