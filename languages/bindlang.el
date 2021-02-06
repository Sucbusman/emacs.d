(use-package bindlang-mode
  :load-path (lambda () (concat
              user-emacs-directory
              "mypackages/bindlang/")))

(defun bindlang-run ()
  (interactive)
  (file-run-helper '(concat "bindlang " fn)))

(when (fboundp 'bindlang-mode)
  (defun bindlang-settings ()
    "settings for bindlang"
    (evil-define-key 'normal bindlang-mode-map
      ",r" 'bindlang-run)
    (rainbow-delimiters-mode))
  (add-hook 'bindlang-mode-hook 'bindlang-settings))
