;; #+LATEX_HEADER: \usepackage{xeCJK}
;; #+LATEX_HEADER: \setCJKmainfont{SimSun}
(when (fboundp 'org-mode)
  (defun org-settings nil
    "add keybindings in orgmode"
    (setq org-latex-pdf-process '("xelatex -interaction nonstopmode %f"
                                  "xelatex -interaction nonstopmode %f"))
    (evil-define-key 'normal org-mode-map
      ",e" 'org-export-dispatch
      ",a" 'org-agenda
      (kbd "<tab>") 'org-cycle)
    (setq org-todo-keywords
          '((sequence "TODO(t!)" "NEXT(n)" "WAITTING(w)" "SOMEDAY(s)" "|" "DONE(d@/!)" "ABORT(a@/!)")
            ))
		(setq org-startup-folded t)
    (setq org-agenda-files (list "~/doc/org/inbox.org"
                                 "~/doc/org/plan.org")))
  (add-hook 'org-mode-hook 'org-settings))

(defun org-chinise nil
  "add chinise latex output support"
  (interactive)
  (let ((conf "#+LATEX_HEADER: \\usepackage{xeCJK}
#+LATEX_HEADER: \\setCJKmainfont{WenQuanYi Zen Hei}"))
    (save-excursion
      (goto-char (point-min))
      (insert conf)
      )))

