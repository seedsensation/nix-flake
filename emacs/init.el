;; Variables to Set
;; If any of these variables break, the whole config
;;   will fail to go through.
(setq variable-configs 'go-here

      ;; Basic configs
      custom-file "~/nixos/emacs/modules/customizations.el"
      display-line-numbers 'relative
      ring-bell-function 'ignore
      inhibit-startup-screen t

      ;; Org Mode Configs
      org-latex-create-formula-image-program 'dvipng
      org-preview-latex-default-process 'dvipng
      org-roam-directory (file-truename "~/org")
      org-id-locations-file (expand-file-name ".org-id-locations" org-roam-directory)
      org-roam-db-location (expand-file-name "org-roam.db" org-roam-directory)
      ;;org-roam-database-connector 'sqlite-builtin

      ;; Completion Settings
      read-file-name-completion-ignore-case t
      read-buffer-completion-ignore-case t
      completion-ignore-case t
      completion-styles '(basic substring partial-completion flex)


      )

;; Modes Setup
(evil-mode 1)
(vertico-mode 1)
(ivy-mode 1)
(ivy-prescient-mode 1)
(org-roam-db-autosync-mode 1)
(which-key-mode 1)
(menu-bar-mode 0)
(tool-bar-mode 0)
(scroll-bar-mode 0)
(indent-tabs-mode 0)

(add-to-list 'load-path "~/.config/emacs/modules/")

;; Load Files
(require 'evil-window-controls)
(require 'misc-functions)
(require 'emacs-outside)
(require 'keybinds)
(require 'customizations)
(require 'artist)
;(load "~/.emacs.d/modules/evil-window-controls.el")
;(load "~/.emacs.d/modules/org-cycle-hide-drawers.el")
;(load "~/.emacs.d/modules/emacs-outside.el")
;(load "~/.emacs.d/modules/keybinds.el")
;(load "~/.emacs.d/modules/customizations.el")
;(load "~/.emacs.d/modules/artist.el")




;; Enable themes
(load-theme 'gruvbox t)


(toggle-truncate-lines 1)
(evil-set-undo-system 'undo-redo)

(set-face-attribute 'default nil :font "Maple Mono" :height 160)

(add-hook 'org-mode-hook (lambda ()
	    (define-key evil-normal-state-local-map
			(kbd "TAB") 'org-cycle)
	    (org-fragtog-mode 1)
	    (org-indent-mode)
	    (org-roam-db-autosync-mode)

	    ))

	    


(add-hook 'text-mode-hook (lambda ()
	    (visual-line-mode)
	    ))



(defun setup-line-numbers ()
  (interactive)
  (display-line-numbers-mode)
  (setq display-line-numbers 'relative))

(add-hook 'prog-mode-hook (lambda ()
			    (setup-line-numbers)
			    ;;(lsp-mode)
			    (lsp-ui-mode)
			    (lsp-mode)
			    (format-all-mode)
			    ))

(setq path "~/.emacs-desktop/")
(if (file-exists-p
     (concat path ".emacs.desktop"))
    (desktop-read path))

(add-hook 'kill-emacs-hook
	  `(lambda ()
	     (desktop-save ,path t)))
