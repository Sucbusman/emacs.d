(setq inhibit-startup-message t)
(setq-default auto-save-timeout 15)
(setq make-backup-files nil)
(electric-pair-mode 1)
(show-paren-mode 1)
(law-keystroke)
(setq visible-bell 0)
(global-set-key (kbd "M-c") 'open-conf)
(global-set-key (kbd "C-l") 'lookup-current-word)
(global-set-key (kbd "C-=") 'text-scale-adjust)

;;font
(set-fontset-font
 t
 'han
 (cond
  ((member "Microsoft YaHei" (font-family-list)) "Microsoft YaHei")
  ((member "Microsoft JhengHei" (font-family-list)) "Microsoft JhengHei")
  ;; ((member "SimHei" (font-family-list)) "SimHei")
  ((member "PingFang SC" (font-family-list)) "PingFang SC")
  ;; ((member "Heiti SC" (font-family-list)) "Heiti SC")
  ;; ((member "Heiti TC" (font-family-list)) "Heiti TC")
  ((member "WenQuanYi Micro Hei" (font-family-list)) "WenQuanYi Micro Hei")))
