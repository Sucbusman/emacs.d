(use-package paredit
	:ensure t
  :hook ((emacs-lisp-mode
          eval-expression-minibuffer-setup
          ielm-mode
          lisp-mode
          lisp-interaction-mode
          scheme-mode
          prettify-symbols-mode) .
          (lambda ()
            (paredit-mode))))

(use-package rainbow-delimiters
	:ensure t
  :hook ((emacs-lisp-mode
          lisp-mode
          ielm-mode
          scheme-mode) .
          (lambda ()
            (rainbow-delimiters-mode))))
(when (fboundp 'emacs-lisp-mode)
  (defun elisp-keybindings ()
    "add keybinding in elisp mode"
    (evil-define-key 'normal emacs-lisp-mode-map
      ",e" 'eval-last-sexp
      ",m" 'merge-init
      )
    (evil-define-key 'visual emacs-lisp-mode-map
      (kbd "r") 'eval-region))
  (add-hook 'emacs-lisp-mode-hook 'elisp-keybindings)
  (add-hook 'emacs-lisp-mode-hook 'prettify-symbols-mode))
