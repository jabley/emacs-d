;;; Linux CLI changes

(color-theme-solarized-dark)

;; Enable the mouse, gotten from:
;; http://www.iterm2.com/#/section/faq
(require 'mouse)
(xterm-mouse-mode t)
(defun track-mouse (e))