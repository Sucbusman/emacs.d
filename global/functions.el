(defun lookup-current-word ()
	"Look up the word under current point"
	(interactive)
	(browse-url
	 (concat "https://www.google.com/search?client=firefox-b-d&q=" (thing-at-point
                                                                'symbol))))

(defun insert-string (s)
  "insert char repeatly"
  (dolist (ch (append s nil))
    (insert-char ch)))

(defun translate ()
	(interactive)
  (let ((query (thing-at-point 'symbol)) (tl "zh_CN"))
    (when (< 128 (aref query 0))
        ;;chinese
      (setq tl "en_US"))
    (request
          "http://translate.google.cn/translate_a/single"
          :params `(("client" . "gtx") ("dt" . "t") ("dj" . "1") ("ie" . "UTF-8") ("sl" . "auto")
                    ("tl" . ,tl) ("q" . ,query))
          :parser 'json-read
          :success (cl-function
                    (lambda (&key data &allow-other-keys)
                      (let ((str (assoc-default 'trans (aref (assoc-default 'sentences data) 0))))
                        (forward-word)
                        (insert-string str)
                        (message "%s" str))))
          :error
          (cl-function (lambda (&rest args &key error-thrown &allow-other-keys)
                         (message "Got error: %S" error-thrown))))))

(defun open-conf ()
  "open emacs config to write"
  (interactive)
  (let ((econf "~/.emacs.d/template_init.el"))
    (split-window-horizontally)
    (find-file econf)))

(defun merge-init ()
  "use compress.rb to merge separated elisp files together"
  (interactive)
  (shell-command (concat "ruby " user-emacs-directory "compress.rb")))

(defun template-helper (conditions)
  (mapcar #'(lambda (pair)
             (let ((ext (car pair))
                   (action (cdr pair)))
               (list (seq-concatenate 'list
                                      '(string-equal ext)
                                      (list ext))
                     action)))
          conditions))

(defmacro newfile-template (&rest conditions)
  `(when (zerop (buffer-size))
      (let ((ext (file-name-extension (buffer-name)))
            (fnb (file-name-base (buffer-name))))
        (cond ,@(template-helper conditions)))))

(defun law-expand-file-name-at-point ()
  "Use hippie-expand to expand the filename"
  (interactive)
  (let ((hippie-expand-try-functions-list '(try-complete-file-name-partially try-complete-file-name)))
    (call-interactively 'hippie-expand)))

(defun law-keystroke ()
  (global-unset-key (kbd "C-b"))
  (global-unset-key (kbd "C-f"))
  (global-unset-key (kbd "C-n"))
  (global-unset-key (kbd "C-p"))
  (global-unset-key (kbd "M-b"))
  (global-unset-key (kbd "M-f"))
  (global-unset-key (kbd "M-n"))
  (global-unset-key (kbd "M-p"))
  (global-unset-key (kbd "C-x 0"))
  (global-unset-key (kbd "C-x 1"))
  (global-unset-key (kbd "C-x 2"))
  (global-unset-key (kbd "C-x 3"))
  (global-unset-key (kbd "C-x 9"))
  (define-prefix-command 'window-prefix)
  (global-set-key (kbd "<f12> 0") 'delete-window)
  (global-set-key (kbd "<f12> 1") 'delete-other-windows)
  (global-set-key (kbd "<f12> 2") 'split-window-below)
  (global-set-key (kbd "<f12> 3") 'split-window-right)
  (global-set-key (kbd "<f12> 8") 'switch-to-buffer)
  (global-set-key (kbd "<f12> 9") 'other-window)
  (evil-define-key nil evil-normal-state-map
    ",op" 'open-plan
    ",w" 'save-buffer
    ",q" '(lambda () (interactive) (kill-buffer) (delete-window))
    ",t" 'translate
    (kbd "+")  'undo-tree-redo
    (kbd "-")  'undo-tree-undo
    (kbd "M-f") 'find-file
    )
  (evil-define-key nil evil-insert-state-map
    (kbd "M-p") '(lambda () (interactive)(dabbrev-expand 1))
    (kbd "M-n") '(lambda () (interactive)(dabbrev-expand (- 0 1)))
    (kbd "M-h") 'left-char
    (kbd "M-l") 'right-char
    (kbd "M-k") 'previous-line
    (kbd "M-j") 'next-line
    (kbd "M-e") 'eval-last-sexp
    (kbd "M-r") 'eval-region
    (kbd "M-f") 'law-expand-file-name-at-point
    ))

(defun file-run-helper (cmd)
  (let (fn fn_noext truecmd)
    (setq fn (buffer-file-name)
          fn_noext (file-name-sans-extension fn)
          truecmd (eval cmd))
    (shell-command truecmd)))

(defun copy-left nil
  "copyleft!"
  (interactive)
  (insert (concat "(ɔ)" (shell-command-to-string "date +%Y-%m-%d"))))

(defun open-plan ()
  "open plan.org"
  (interactive)
  (let ((plan-file "~/doc/org/plan.org"))
    (find-file plan-file)))

(defun symmetric-encrypt (str shift)
  "Encrypt STR with Caesar cipher using SHIFT."
  (apply #'string
         (mapcar (lambda (c) (+ shift c))
                 (string-to-list str))))

(defun symmetric-decrypt (str shift)
  "Decrypt STR with Caesar cipher using SHIFT."
  (apply #'string
         (mapcar (lambda (c) (- c shift))
                 (string-to-list str))))

(defun caesar-encrypt (str &optional shift)
  "Apply Caesar cipher to visible ASCII (32-126) with optional SHIFT.
Default SHIFT is 1 (symmetric). Handles both encryption and decryption."
  (let* ((result "")
         (shift (or shift 1))
         (min-char 32)
         (max-char 126)
         (range (1+ (- max-char min-char))))
    (dolist (c (string-to-list str) result)
      (setq result
            (concat result
                   (string
                    (cond
                     ((< c min-char) c)  ; leave non-visible chars unchanged
                     (t
                      ;; Perform shift with modulo wrapping
                      (+ min-char
                         (mod (+ (- c min-char) shift) range))))))))))

(defun read-file-content (file-path)
  "Read content of FILE-PATH as string."
  (with-temp-buffer
    (insert-file-contents file-path)
    (buffer-string)))

(defun write-bytes-to-file (bytes file-path)
  "Write BYTES (unibyte string) to FILE-PATH."
  (with-temp-file file-path
    (set-buffer-multibyte nil)
    (insert bytes)))
