(defun go-run ()
  (interactive)
  (let ((fn (buffer-file-name)))
    (shell-command (concat "go run " fn))))

(defun my-go-bindings ()
  "In go mode key bindings"
  (evil-define-key nil evil-normal-state-map
    ",r" 'go-run))

(use-package go-mode
  :ensure t
  :defer
  :config
  (my-go-bindings))

(use-package company-go
  :ensure t
	:hook ((go-mode) .
				 (lambda ()
         	(set (make-local-variable 'company-backends) '(company-go))
         	(company-mode))))

