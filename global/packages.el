(use-package evil
	:ensure t
	:config
	(setcdr evil-insert-state-map nil)
	;; ESC to switch back normal-state
	(define-key evil-insert-state-map [escape] 'evil-normal-state))

(evil-mode 1)

(use-package try
  :ensure t)

(use-package which-key
  :ensure t
  :config
  (which-key-mode))

(use-package eldoc
  :config
 (eldoc-add-command
 'paredit-backward-delete
 'paredit-close-round) 
  )

(use-package company
  :ensure t
  :commands company-mode
  :config
  (setq company-tooltip-limit 20)                      ; bigger popup window
  (setq company-idle-delay .3)                         ; decrease delay before autocompletion popup shows
  (setq company-echo-delay 0)                          ; remove annoying blinking
  (setq company-begin-commands '(self-insert-command)) ; start autocompletion only after typing
  )

(use-package lsp-mode
  :commands lsp
  :ensure t
  :config
  (setq lsp-file-watch-threshold 20))

(use-package lsp-ui :commands lsp-ui-mode :ensure t)

(use-package company-lsp
  :commands company-lsp
  :ensure t
  :config (push 'company-lsp company-backends))

(use-package org-bullets
	:ensure t
	:config
	(add-hook 'org-mode-hook (lambda () (org-bullets-mode 1))))
