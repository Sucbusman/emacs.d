(use-package sml-mode
  :ensure t)

(when (fboundp 'sml-mode)
  (defun sml-settings nil
    "sml settings"
    (evil-define-key 'normal sml-mode-map
      ",c" 'sml-prog-proc-compile
      ",l" 'sml-prog-proc-load-file
      ",b" 'sml-prog-proc-send-buffer)
    (evil-define-key 'visual sml-mode-map
      "r" 'sml-prog-proc-send-region))
  (defun inferior-sml-settings nil
    "settings in sml comint"
    (setq sml-program-name "smlnj")
    (evil-define-key 'insert inferior-sml-mode-map
      (kbd "<tab>") '(lambda () (interactive) (dabbrev-expand 1))
      (kbd "<up>") 'comint-previous-input
      (kbd "<down>") 'comint-next-input))
  (add-hook 'sml-mode-hook 'sml-settings)
  (add-hook 'inferior-sml-mode-hook 'inferior-sml-settings))
