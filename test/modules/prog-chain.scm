;;; prog-chain.scm -- import (chain-a), which transitively imports (chain-b). => 15
(import (chain-a))
(a-plus)
