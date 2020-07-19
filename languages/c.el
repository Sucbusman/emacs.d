(use-package ccls
  :ensure t
  :defer
  :config
  (setq ccls-executable "ccls")
  (setq lsp-prefer-flymake nil)
  (setq-default flycheck-disabled-checkers '(c/c++-clang c/c++-cppcheck c/c++-gcc))
  ;;(setq lsp-diagnostic-package nil)
  ;;(flycheck-mode -1)
  :hook ((c-mode c++-mode objc-mode cuda-mode) .
         (lambda () (require 'ccls) (lsp))))

(defun c*-compile-run-helper (compiler)
  (let (fnc fnb fno)
    (setq fnc (buffer-file-name)
          fnb (file-name-sans-extension fnc)
          fno (concat fnb ".o"))
    (shell-command (concat compiler " " fnc " -o " fno " && "
                           fno))))
(defun c-compile-run ()
  (interactive)
  (c*-compile-run-helper "gcc"))

(defun c++-compile-run ()
  (interactive)
  (c*-compile-run-helper "g++"))

(defun make-c*-header (s)
  "use s to generate a c header"
  (let ((addition "__") (newline "\n"))
    (let ((head (concat addition s addition)))
      (concat "#ifdef " head 
              newline
              "#define " head
              newline
              newline
              "#endif"))))

(when (fboundp 'c-mode)
  (defun c-common-settings ()
    "settings for c*,include common header file"
    (newfile-template
     ("h" . (insert (make-c*-header fnb)))))

  (defun c-settings ()
    "settings for c"
    (evil-define-key 'normal c-mode-map
      ",r" 'c-compile-run)
    (newfile-template
     ("c" . (insert "#include <stdio.h>\n"))))

  (defun c++-settings ()
    "settings for cpp"
    (evil-define-key 'normal c++-mode-map
      ",r" 'c++-compile-run)
    (newfile-template
     ("cpp" . (insert "#include <iostream>\n"))))

  (add-hook 'c-mode-common-hook 'c-common-settings)
  (add-hook 'c-mode-hook 'c-settings)
  (add-hook 'c++-mode-hook 'c++-settings))
