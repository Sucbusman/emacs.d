;; #+LATEX_HEADER: \usepackage{xeCJK}
;; #+LATEX_HEADER: \setCJKmainfont{SimSun}
(when (fboundp 'org-mode)
  (defun org-settings nil
    "add keybindings in orgmode"
    (setq org-latex-pdf-process '("xelatex -interaction nonstopmode %f"
                              "xelatex -interaction nonstopmode %f"))
    (evil-define-key 'normal org-mode-map
      ",e" 'org-export-dispatch))
  (add-hook 'org-mode-hook 'org-settings))
