
;; Enable Vim Motions <3
(evil-mode)

;; Enable themes
(load-theme 'gruvbox t)

;; Standard modes
(vertico-mode 1)
(company-mode 1)

(menu-bar-mode 0)

;; Load additional stuff
(load "~/.emacs.d/modules/evil-window-controls.el")
(load "~/.emacs.d/modules/org-cycle-hide-drawers.el")

;; Set variables
(setq display-line-numbers 'relative)

;; KEYMAPS !!
(defvar window-map (define-keymap :full t
		     "h" #'evil-window-left
		     "j" #'evil-window-down
		     "k" #'evil-window-up
		     "l" #'evil-window-right
                     "H" #'window-move-left
		     "J" #'window-move-down
		     "K" #'window-move-up
		     "L" #'window-move-right
		     "v" #'+evil/window-vsplit-and-follow
		     "n" #'+evil/window-split-and-follow
		     ))
(defvar config-map (define-keymap :full t
		     "r" (lambda () (interactive) (load "~/nixos/modules/emacs.d/init.el"))
		     "h" (lambda () (interactive) (find-file "~/org/home.org"))
		     "c" (lambda () (interactive) (find-file "~/nixos/modules/emacs.d/init.el"))

		     ))

(defvar view-map (define-keymap :full t
		   "v" #'org-toggle-narrow-to-subtree
		   "h" (lambda() (interactive) (org-cycle-hide-drawers 'all))
		   "l" #'lsp-describe-at-point
		   ))


(defvar leader-map (define-keymap :full t
  "." #'find-file
  "w" window-map
  "d" config-map
  "v" view-map
  ))

(add-hook 'org-mode-hook
	  (lambda ()
	    (define-key evil-normal-state-local-map
			(kbd "TAB") 'org-cycle)))

(setq cursor-type 'hollow)

(defun show-line-numbers-relative ()
  (interactive)
  (display-line-numbers-mode)
  (setq display-line-numbers 'relative))

(add-hook 'prog-mode-hook 'show-line-numbers-relative)

(define-key evil-normal-state-map (kbd "<SPC>") leader-map)
(global-set-key [<ESC>] "C-g")




