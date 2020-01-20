(use-package smv-mode
  :load-path (lambda () (concat
              user-emacs-directory
              "smv/")))

(when (fboundp 'smv-mode)
  (defun smv-settings ()
    "settings for smv"
    (add-to-list 'auto-mode-alist '("\\.smv$" . smv-mode))
    (add-to-list 'auto-mode-alist '("\\.ord$" . smv-ord-mode))
    (add-to-list 'completion-ignored-extensions ".ord")
    (add-to-list 'completion-ignored-extensions ".opt")
    )
  (add-hook 'smv-mode-hook 'smv-settings))
