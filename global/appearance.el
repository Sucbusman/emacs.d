;; hide menu bar and tool bar
(menu-bar-mode 0)
(tool-bar-mode 0)

;; no blink cursor
(blink-cursor-mode 0)

;; transparent
(set-frame-parameter (selected-frame) 'alpha (list 90 85))
(setq-default tab-width 2)
(setq tab-width 2)
(progn
  ;; make indent commands use space only (never tab character)
  (setq-default indent-tabs-mode nil)
  ;; emacs 23.1 to 26, default to t
  ;; if indent-tabs-mode is t, it means it may use tab, resulting mixed space and tab
  )

;; font
(add-to-list 'default-frame-alist
                      '(font . "DejaVu Sans Mono-17"))

