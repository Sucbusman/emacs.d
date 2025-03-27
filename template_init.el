;; -*- lexical-binding:t -*-

;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.

(setq lexical-binding t)
(require 'package)
(setq package-enable-at-startup nil)
(package-initialize)
(setq package-archives '(("gnu" . "http://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/")
			 ("melpa" . "http://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/")))


(defun load-relative-lib (l)
	"load library relative to user-emacs-directory"
	(load (concat user-emacs-directory l ".el")))

(setq custom-file (concat user-emacs-directory "global/custom.el"))
(load-relative-lib "global/custom")
(load-relative-lib "global/appearance")
(load-relative-lib "global/packages")
(load-relative-lib "global/functions")
(load-relative-lib "global/settings")
(load-relative-lib "global/ai")
(load-relative-lib "languages/c")
(load-relative-lib "languages/go")
(load-relative-lib "languages/lisp")
(load-relative-lib "languages/org")
(load-relative-lib "languages/sml")
(load-relative-lib "languages/ruby")
(load-relative-lib "languages/racket")
(load-relative-lib "languages/haskell")
(load-relative-lib "languages/bindlang")
(load-relative-lib "languages/iotlogic")
(load-relative-lib "languages/dashboard")
(load-relative-lib "languages/twelf")
(load-relative-lib "languages/latex")
(load-relative-lib "languages/maude")
;;(load-relative-lib "languages/spthy")
;;(load-relative-lib "languages/java")
;; shell
