(defun lookup-current-word ()
	"Look up the word under current point"
	(interactive)
	(browse-url
	 (concat "https://www.google.com/search?client=firefox-b-d&q=" (thing-at-point
                                                                'symbol))))

(defun open-conf ()
  "open emacs config to write"
  (interactive)
  (let ((econf "~/.emacs.d/template_init.el"))
    (split-window-horizontally)
    (find-file econf)))

(defun merge-init ()
  "use compress.rb to merge separated elisp files together"
  (interactive)
  (shell-command (concat "ruby " user-emacs-directory "compress.rb")))

(defun law-keystroke ()
  (global-unset-key (kbd "C-b"))
  (global-unset-key (kbd "C-f"))
  (global-unset-key (kbd "C-n"))
  (global-unset-key (kbd "C-p"))
  (global-unset-key (kbd "M-b"))
  (global-unset-key (kbd "M-f"))
  (global-unset-key (kbd "M-n"))
  (global-unset-key (kbd "M-p"))

  (evil-define-key nil evil-normal-state-map
    ",c" 'open-conf
    ",w" 'save-buffer
    ",q" 'kill-buffer
    (kbd "+")  'undo-tree-redo
    (kbd "-")  'undo-tree-undo
    (kbd "M-f") 'find-file
    )
  (evil-define-key nil evil-insert-state-map
    (kbd "M-p") '(lambda () (interactive)(dabbrev-expand 1))
    (kbd "M-n") '(lambda () (interactive)(dabbrev-expand -1))
    (kbd "M-h") 'left-char
    (kbd "M-l") 'right-char
    (kbd "M-k") 'previous-line
    (kbd "M-j") 'next-line
    (kbd "M-e") 'eval-last-sexp
    (kbd "M-r") 'eval-region
    ))
