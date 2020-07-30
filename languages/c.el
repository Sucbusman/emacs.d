(use-package clang-format
  :ensure t)

(use-package eglot
  :ensure t)

(defun law/cpp-eglot-enable nil
  (interactive)
  (add-to-list 'eglot-server-programs
               '((c++-mode c-mode) "clangd"))
  (with-eval-after-load 'company-mode
    (setq company-backends
        (cons 'company-capf
              (remove 'company-capf company-backends))))
  (add-hook 'c-mode-hook 'eglot-ensure)
  (add-hook 'c++-mode-hook 'eglot-ensure))

(defun c*-compile-run-helper (compiler)
  (let (fnc fnb fno)
    (setq fnc (buffer-file-name)
          fnb (file-name-sans-extension fnc))
    (shell-command (concat compiler " " fnc " -o " fnb " && "
                           fnb))))
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
      (concat "#ifndef " head 
              newline
              "#define " head
              newline
              newline
              "#endif"))))

(when (fboundp 'c-mode)
  (defun law-c-common-settings ()
    "settings for c*,include common header file"
    (c-set-offset 'case-label '+)
    (newfile-template
     ("h" . (insert (make-c*-header fnb))))
    (law/cpp-eglot-enable))

  (defun law-c-settings ()
    "settings for c"
    (evil-define-key 'normal c-mode-map
      ",r" 'c-compile-run)
    (newfile-template
     ("c" . (insert "#include <stdio.h>\n"))))

  (defun law-c++-settings ()
    "settings for cpp"
    (c-set-offset 'innamespace nil)
    (evil-define-key 'normal c++-mode-map
      ",r" 'c++-compile-run)
    (newfile-template
     ("cpp" . (insert "#include <iostream>\n"))))

  (add-hook 'c-mode-common-hook 'company-mode)
  (add-hook 'c-mode-common-hook 'yas-minor-mode)
  (add-hook 'c-mode-common-hook 'law-c-common-settings)
  (add-hook 'c-mode-hook 'law-c-settings)
  (add-hook 'c++-mode-hook 'law-c++-settings))
