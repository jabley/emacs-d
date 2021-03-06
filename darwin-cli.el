;;; -*- lexical-binding: t -*-

;; Configuration to make Emacs run semi-normally in an OS X terminal

;; XXX: strongly recommended to run in iTerm2, as it's more
;; configurable than Terminal.app.

;; Make sure cut/paste works properly. Gotten from:
;; http://mindlev.wordpress.com/2011/06/13/emacs-in-a-terminal-on-osx/#comment-20
(defun copy-from-osx ()
  "Copies the current clipboard content using the `pbcopy` command"
  (shell-command-to-string "pbpaste"))

(defun paste-to-osx (text &optional push)
  "Copies the top of the kill ring stack to the OSX clipboard"
  (let ((process-connection-type nil))
    (let ((proc (start-process "pbcopy" "*Messages*" "pbcopy")))
      (process-send-string proc text)
      (process-send-eof proc))))

;; Override defaults to use the mac copy and paste
(unless (getenv "TMUX")
  ;; tmux breaks pbcopy/pbpaste, see:
  ;; https://github.com/ChrisJohnsen/tmux-MacOSX-pasteboard
  (setq interprogram-cut-function 'paste-to-osx)
  (setq interprogram-paste-function 'copy-from-osx))
