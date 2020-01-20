(defun run-ghc ()
  (interactive)
  (file-run-helper '(concat "runghc " fn)))

(defun show-ui-doc-in-normal ()
  (add-hook 'evil-normal-state-exit-hook '(lambda () (setq lsp-ui-doc-enable nil) (setq lsp-eldoc-enable-hover 1)))
  (add-hook 'evil-normal-state-entry-hook '(lambda () (setq lsp-ui-doc-enable 1) (setq lsp-eldoc-enable-hover nil)))
  )


(use-package lsp-haskell
  :ensure t
  :config
  (add-hook 'haskell-mode-hook #'lsp)
  (add-hook 'haskell-literate-mode-hook #'lsp)
  (setq lsp-haskell-server-path "/home/lawliet/.ghcup/bin/haskell-language-server-wrapper")
  (setenv "PATH" (concat (getenv "PATH") ":/home/lawliet/.ghcup/bin"))
  (setq lsp-ui-doc-enable nil)
  (setq lsp-eldoc-enable-hover 1)
  )

(when (fboundp 'haskell-mode)
  (defun haskell-settings ()
    "settings for editing haskell code"
    (evil-define-key 'normal haskell-mode-map
      ",r" 'run-ghc)
    (evil-define-key 'normal haskell-mode-map
      (kbd "<tab>") 'indent-for-tab-command)
    (evil-define-key 'insert haskell-mode-map
      (kbd "<tab>") 'indent-for-tab-command)
    (evil-define-key 'insert haskell-mode-map
      (kbd "M-<tab>") 'company-complete-common)
    )
  (setq haskell-font-lock-symbols t)
  (add-hook 'haskell-mode-hook 'yas-minor-mode)
  (add-hook 'haskell-mode-hook 'haskell-settings)
  )
