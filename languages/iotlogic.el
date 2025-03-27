(use-package iotlogic-mode
  :load-path (lambda () (concat
              user-emacs-directory
              "mypackages/iotlogic/")))

(when (fboundp 'iotlogic-mode)
  (defun iotlogic-settings ()
    "settings for iotlogic"
    (rainbow-delimiters-mode))
  (add-hook 'iotlogic-mode-hook 'iotlogic-settings))
