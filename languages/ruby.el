(use-package enh-ruby-mode
  :ensure t)
(defun ruby-run nil
  (interactive)
  (let (fn)
    (setq fn (buffer-file-name))
    (shell-command (concat "ruby " fn))))
(when (fboundp 'ruby-mode)
  (defun ruby-settings nil
    (evil-define-key 'normal ruby-mode-map
      ",r" 'ruby-run))
  (add-hook 'ruby-mode-hook 'ruby-settings))
