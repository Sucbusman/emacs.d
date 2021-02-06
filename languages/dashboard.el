(when (fboundp 'dashboard-mode)
  (defun law-dashboard-settings ()
    (evil-define-key 'normal dashboard-mode-map
      (kbd "<down-mouse-1>") 'dashboard-return
      ))
  (add-hook 'dashboard-mode-hook 'law-dashboard-settings))
