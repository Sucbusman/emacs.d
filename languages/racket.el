(use-package racket-mode
  :ensure t)

(defun racket-run nil
  (interactive)
  (let (fn)
    (setq fn (buffer-file-name))
    (shell-command (concat "racket " fn))))

(when (fboundp 'racket-mode)
  (defun racket-settings nil
    (evil-define-key 'normal racket-mode-map
      ",r" 'racket-run
      ",e" 'racket-send-last-sexp)
    (evil-define-key 'insert racket-mode-map
      (kbd "C-l") 'racket-insert-lambda
      (kbd "M-e") 'racket-send-last-sexp)
    (paredit-mode t))

  (add-hook 'racket-mode-hook 'racket-settings))
