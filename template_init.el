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
;;(load-relative-lib "global/custom")
(load-relative-lib "global/appearance")
(load-relative-lib "global/packages")
(load-relative-lib "global/functions")
(load-relative-lib "global/settings")
(load-relative-lib "languages/c")
(load-relative-lib "languages/go")
(load-relative-lib "languages/lisp")
;;(load-relative-lib "languages/ruby")


;; shell
