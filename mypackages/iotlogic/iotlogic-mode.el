(defvar iotlogic-mode-hook nil)

(add-to-list 'auto-mode-alist
             '("\\.iotlogic\\'" . iotlogic-mode))

(defvar iotlogic-highlights
  `((,(rx symbol-start 
         (group  (or "if" "else" 
                     "says" "Verify"))
         symbol-end)
     (1 font-lock-keyword-face))
    (,(rx symbol-start (group (or "A" "E" "G" "F" "X" "U" "W")) symbol-end)
											 . font-lock-builtin-face)
		(,(rx (group (or "&" "|" "!" "=>" ":" "<>"))) . font-lock-builtin-face)
    (,(rx  (group "$" (1+ word)))
     (1 font-lock-variable-name-face))
		(,(rx symbol-start (group (1+ (or word ?_)) (0+ space) "=")) (1 font-lock-function-name-face))
    (,(rx symbol-start (group "---" (*? anything) ) symbol-end eol) (1 font-lock-comment-face))
    ))

(define-derived-mode iotlogic-mode fundamental-mode "iotlogic"
  "Major mode for bindlang language files."
  (set (make-local-variable 'font-lock-defaults) '(iotlogic-highlights))
  )
(provide 'iotlogic-mode)
