;;; -*- lexical-binding: t -*-
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 ;'(desktop-path '("~/.emacs-desktops" "~"))
 '(desktop-save-mode t)
 '(initial-buffer-choice "./")
 ;;'(lsp-java-server-install-dir "/home/mercury/.lsp/eclipse.jdt.ls/")
 ;;'(lsp-java-workspace-cache-dir "/home/mercury/.lsp/workspace/.cache")
 ;;'(lsp-java-workspace-dir "/home/mercury/.lsp/workspace")
 ;;'(lsp-server-install-dir "/home/mercury/.lsp/install")
 ;;'(lsp-session-file "/home/mercury/.lsp/session-v1")
 '(org-format-latex-options
   '(:foreground default :background default :scale 2.25 :html-foreground
		 "Black" :html-background "Transparent" :html-scale
		 1.0 :matchers ("begin" "$1" "$" "$$" "\\(" "\\[")))
 '(org-roam-extract-new-file-path "nodes/${slug}.org")
 ;;'(project-list-file "~/.emacs-packages/projects")
 '(safe-local-variable-values '((lexical-bindings . t)))
 '(truncate-lines t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :extend nil :stipple nil :background "#282828" :foreground "#ebdbb2" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight regular :height 158 :width normal :foundry "    " :family "Maple Mono"))))
 '(ivy-current-match ((t (:extend t :foreground "#ffffc8" :underline nil :slant italic :weight bold))))
 '(org-level-4 ((t (:extend nil :foreground "medium spring green" :weight normal)))))

(provide 'customizations)
