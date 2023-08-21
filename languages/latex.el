(use-package tex
  :ensure auctex)

(use-package company-auctex
  :config
  (company-auctex-init))

(use-package cdlatex
  :config
  (add-hook 'org-mode-hook 'turn-on-org-cdlatex)
  (add-hook 'LaTeX-mode-hook 'turn-on-cdlatex))

(when (fboundp 'LaTeX-mode)
  (add-hook 'LaTeX-mode-hook
            (lambda ()
              (setq TeX-auto-untabify t     ; strip TAB when saving
                    TeX-engine 'xetex       
                    TeX-show-compilation t)
              (TeX-global-PDF-mode t)
              (setq TeX-save-query nil)
              (imenu-add-menubar-index)
              (define-key LaTeX-mode-map (kbd "TAB") 'TeX-complete-symbol)))
  (mapc (lambda (mode)
	        (add-hook 'LaTeX-mode-hook mode))
        (list 'LaTeX-math-mode
              'turn-on-reftex
              'company-mode))
  (setq TeX-auto-save t)
  (setq TeX-parse-self t)
  (setq-default TeX-master nil)
  ;;key
  (evil-define-key 'normal LaTeX-mode-map
    ",e"  'LaTeX-environment)
  )
