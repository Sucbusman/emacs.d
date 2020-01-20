;; hide menu bar and tool bar
(menu-bar-mode 0)
(tool-bar-mode 0)
(push '(vertical-scroll-bars) default-frame-alist)
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
                      '(font . "DejaVu Sans Mono-16"))

;; dashboard
(use-package dashboard
  :config
  (dashboard-setup-startup-hook))

(setq dashboard-banner-logo-title "FUTURE")
;; Set the banner
(setq dashboard-startup-banner 1)

(set-face-foreground 'mode-line "#ff11ff")
(set-face-background 'mode-line "#eeffee")
(set-face-foreground 'mode-line-inactive "#ee22ee")
(set-face-background 'mode-line-inactive "#eeffee")
