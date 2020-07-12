(defun go-run ()
  (interactive)
  (let ((fn (buffer-file-name)))
    (shell-command (concat "go run " fn))))

(use-package go-mode
  :ensure t
  :defer)

(use-package company-go
  :ensure t
  :defer
	:hook ((go-mode) .
				 (lambda ()
         	(set (make-local-variable 'company-backends) '(company-go))
         	(company-mode))))

(when (fboundp 'go-mode)
  (defun go-bindings nil
    "add keybindings in go"
    (evil-define-key 'normal go-mode-map
      ",r" 'go-run
      ",f" 'gofmt
      ))
  (add-hook 'go-mode-hook 'go-bindings))
