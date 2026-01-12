(require 'package)
  (setq package-archives
    '(("melpa" . "https://melpa.org/packages/")
    ("elp" . "https://elpa.gnu.org/packages/")
    ("gnu-devel" . "https://elpa.gnu.org/devel/")
    ("nongnu" . "https://elpa.nongnu.org/nongnu/")
    ))
(require 'use-package-ensure)
(setq use-package-always-ensure t)
(use-package auto-package-update
:config
(setq auto-package-update-delete-old-versions t)
(setq auto-package-update-hide-results t)
(auto-package-update-maybe))
(use-package evil)
