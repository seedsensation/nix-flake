
(defun +evil/window-split-and-follow()
  "Split current window horizontally, then focus on new window.
   If `evil-split-window-below` is non-nil, the new window isn't focused."
  (interactive)
  (let ((evil-split-window-below (not evil-split-window-below)))
    (call-interactively #'evil-window-split)))

(defun +evil/window-vsplit-and-follow()
  "Split current window vertically, then focus on new window.
   If `evil-split-window-below` is non-nil, the new window isn't focused."
  (interactive)
  (let ((evil-vsplit-window-right (not evil-vsplit-window-right)))
    (call-interactively #'evil-window-vsplit)))

(defun +evil/window-move-left (&optional arg)
  "Swap windows to the left."
  (interactive "P")
  (+evil--window-swap 'left (or arg +evil-want-move-window-to-wrap-around)))
(defun +evil/window-move-right (&optional arg)
  "Swap windows to the right."
  (interactive "P")
  (+evil--window-swap 'right (or arg +evil-want-move-window-to-wrap-around)))
(defun +evil/window-move-up (&optional arg)
  "Swap windows up."
  (interactive "P")
  (+evil--window-swap 'up (or arg +evil-want-move-window-to-wrap-around)))
(defun +evil/window-move-down (&optional arg)
  "Swap windows down."
  (interactive "P")
  (+evil--window-swap 'down (or arg +evil-want-move-window-to-wrap-around)))
