(defun c-compile-run ()
  (interactive)
  (let (fnc fnb fno)
    (setq fnc (buffer-file-name)
          fnb (file-name-sans-extension fnc)
          fno (concat fnb ".o"))
    (shell-command (concat "gcc " fnc " -o " fno " && "
                           fno))))

(use-package ccls
  :ensure t
  :config
  (setq ccls-executable "ccls")
  (setq lsp-prefer-flymake nil)
  (setq-default flycheck-disabled-checkers '(c/c++-clang c/c++-cppcheck c/c++-gcc))
  ;;(setq lsp-diagnostic-package nil)
  ;;(flycheck-mode -1)
  :hook ((c-mode c++-mode objc-mode cuda-mode) .
         (lambda () (require 'ccls) (lsp))))

