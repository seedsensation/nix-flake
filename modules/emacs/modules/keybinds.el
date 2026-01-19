;;;;;;;;;;;;;;;;;;;;; GLOBAL KEYBINDS ;;;;;;;;;;;;;;;;;;;;;

(defvar window-map (define-keymap 
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
		     "r" #'redraw-display
		     ))

(defvar config-map (define-keymap 
		     "r" (lambda () (interactive) (load "~/nixos/modules/emacs/init.el"))
		     "h" (lambda () (interactive) (find-file "~/org/contents.org"))
		     "c" (lambda () (interactive) (find-file "~/nixos/modules/emacs/init.el"))
		     "k" (lambda () (interactive) (find-file "~/nixos/modules/emacs/modules/keybinds.el"))
		     ))

(defvar view-map (define-keymap 
		   "v" #'org-toggle-narrow-to-subtree
		   "h" (lambda() (interactive) (org-cycle-hide-drawers 'all))
		   "l" #'lsp-describe-at-point
		   ))

(defvar buffer-map (define-keymap :full t
		     "p" #'previous-buffer
		     "n" #'next-buffer
		     "b" #'buffer-menu
		     ))

(defvar customize-map (define-keymap
		        "c" #'customize-browse
			"f" #'list-faces-display
			"v" #'customize-variable
			"g" #'customize-group
			))

(defvar leader-map (define-keymap
  "." #'find-file
  "w" window-map
  "d" config-map
  "v" view-map
  "b" buffer-map
  "c" customize-map
  "h" help-map
  "/" #'avy-goto-char-2
  ))

			
(evil-define-key 'normal global-map (kbd "<SPC>") leader-map)
(evil-define-key 'normal global-map (kbd "=") 'pop-global-mark)
(evil-define-key '(list normal motion visual) global-map (kbd "-") 'avy-goto-char)
(evil-define-key '(list normal motion visual) global-map (kbd "_") 'avy-goto-line)
(evil-define-key 'visual global-map "S" 'surround-insert)

;;;;;;;;;;;;;;;;;;;;; LOCAL KEYBINDS ;;;;;;;;;;;;;;;;;;;;;


(defmacro set-local-leader-map (current-map new-map)
  `(evil-define-key 'normal ,current-map (kbd "<SPC>")
    (let ((map (make-sparse-keymap)))
      (set-keymap-parent map leader-map)
      (define-key map (kbd "m") ,new-map)
      map
      ))
  )


(defun org-id-reload-all ()
    (interactive)
    (org-id-update-id-locations)
    (org-roam-update-org-id-locations)
    (org-roam-db-sync))

(set-local-leader-map org-mode-map
		      (define-keymap
			"." #'consult-org-heading
			"l i" #'org-id-get-create
			"i" #'org-roam-node-insert
			"f" #'org-roam-node-find
			"r" #'org-id-reload-all
			"b" #'org-mark-ring-goto
			))



(provide 'keybinds)
