;; All my major and minor mode loading and configuration

;; IDO mode is awesome
(ido-mode t)
(setq
 ido-enable-prefix nil
 ido-enable-flex-matching t
 ido-create-new-buffer 'always
 ido-use-filename-at-point nil
 ido-max-prospects 10
 ido-case-fold t)

;; force wrap magit commit messages
(add-hook 'magit-log-edit-mode-hook 'bw-turn-on-auto-fill)
(add-hook 'magit-log-edit-mode-hook 'bw-fill-column)

;; TODO: make all these modes a list and operate on those
(add-hook 'magit-mode-hook 'local-hl-line-mode-off)
(add-hook 'magit-log-edit-mode-hook 'local-hl-line-mode-off)

;; turn off hl-line-mode for compilation mode
(add-hook 'compilation-mode-hook 'local-hl-line-mode-off)
;; turn off hl-line-mode for shells
(add-hook 'term-mode-hook 'local-hl-line-mode-off)

;; Textmate mode is on for everything
(textmate-mode)

;; haskell mode, loaded via Elpa
(add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)
(add-hook 'haskell-mode-hook 'turn-on-haskell-indentation)
(add-hook 'inferior-haskell-mode-hook 'local-hl-line-mode-off)

;; JS2 mode, not espresso
;;(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))

;; Jinja mode is a bit crap, really
(require 'jinja)
(add-to-list 'auto-mode-alist '("\\.jinja$" . jinja-mode))

;; JSON files
(add-to-list 'auto-mode-alist '("\\.json$" . json-mode))

(defun my-html-mode-hook ()
  (setq tab-width 4)
  (auto-fill-mode 0)
  (define-key html-mode-map (kbd "<tab>") 'my-insert-tab)
  (define-key html-mode-map (kbd "C->") 'sgml-close-tag))

;; just insert tabs
(defun my-insert-tab (&optional arg)
  (interactive "P")
  (insert-tab arg))

(add-hook 'html-mode-hook 'my-html-mode-hook)

;; load yaml files correctly
;; yaml-mode doesn't auto-load for some reason
(require 'yaml-mode)
(add-to-list 'auto-mode-alist '("\\.ya?ml$" . yaml-mode))

;; Restructured text
(require 'rst)
(add-to-list 'auto-mode-alist '("\\.rst$" . rst-mode))
(add-hook 'rst-mode-hook 'bw-turn-on-auto-fill)
(add-hook 'rst-mode-hook 'magit-fill-column)

;; kill stupid heading faces
(set-face-background 'rst-level-1-face nil)
(set-face-background 'rst-level-2-face nil)

;; Random missing file types
(add-to-list 'auto-mode-alist '("[vV]agrantfile$" . ruby-mode))

;; Puppet manifests
(add-to-list 'auto-mode-alist '("\\.pp$" . puppet-mode))

;; ansi-term stuff
;; force ansi-term to be utf-8 after it launches
(defadvice ansi-term
  (after advise-ansi-term-coding-system)
  (set-buffer-process-coding-system 'utf-8-unix 'utf-8-unix))
(ad-activate 'ansi-term)

(when (require 'ansi-color nil t)
  (autoload 'ansi-color-for-comint-mode-on "ansi-color" nil t)
  (add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on))

;; since I use Magit, disable vc-mode for Git
(delete 'Git vc-handled-backends)

;; Saveplace
;;   - places cursor in the last place you edited file
(require 'saveplace)
(setq-default save-place t)
;; Keep places in the load path
(setq save-place-file (concat tmp-local-dir "/emacs-places"))

;; yasnippet
(require 'yasnippet)
(setq yas/root-directory "~/Dropbox/.emacs/yasnippets")
(yas/load-directory yas/root-directory)
(yas/initialize)

;; setup tramp mode
;; Tramp mode: allow me to SSH to hosts and edit as sudo like:
;;   C-x C-f /sudo:example.com:/etc/something-owned-by-root
;; from: http://www.gnu.org/software/tramp/#Multi_002dhops
(require 'tramp)
(setq tramp-default-method "ssh")
(add-to-list 'tramp-default-proxies-alist
             '(nil "\\`root\\'" "/ssh:%h:"))
(add-to-list 'tramp-default-proxies-alist
             '((regexp-quote (system-name)) nil nil))

;; Clojure mode, installed via Elpa
(add-hook 'clojure-mode-hook 'turn-on-paredit)
(add-hook 'clojure-mode-hook 'bw-clojure-repl-program)
(add-hook 'slime-repl-mode-hook 'bw-clojure-slime-repl-font-lock)
(add-hook 'slime-repl-mode-hook 'local-hl-line-mode-off)
(add-hook 'slime-repl-mode-hook 'turn-on-paredit)

;; load Flymake cursor
(when (load "flymake" t)
  (require 'flymake-cursor))

;; new python-mode IDE
(setq python-mode-path (concat vendor-dotfiles-dir "/python-mode"))
(add-to-list 'load-path python-mode-path)
(setq py-install-directory python-mode-path)
(require 'python-mode)
;; don't launch a Python shell all the time
(setq py-start-run-py-shell nil)

;; markdown
(add-to-list 'auto-mode-alist '("\\.md$" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.markdown$" . markdown-mode))

;; PHP - why doesn't PHP-mode do this already?
(add-to-list 'auto-mode-alist '("\\.php$" . php-mode))

;; emacs lisp
(add-hook 'emacs-lisp-mode-hook 'turn-on-paredit)

;; eshell
(eval-after-load 'esh-opt
  '(progn
     ;; we need this to override visual commands
     (require 'em-term)
     ;; If I try to SSH from an eshell, launch it in ansi-term instead
     (add-to-list 'eshell-visual-commands "ssh")))

;; Ruby mode

;; this variable is stupid - apparently Ruby needs its own indent
;; variable
;; 2-space indent is idiomatic
(setq ruby-indent-level 2)

;; http://stackoverflow.com/a/4485083/61435
;; Automatically save and restore sessions
(setq desktop-dirname             "~/.emacs.d/.tmp/desktops/"
      desktop-base-file-name      "emacs.desktop"
      desktop-base-lock-name      "lock"
      desktop-path                (list desktop-dirname)
      desktop-save                t
      desktop-files-not-to-save   "^$" ;reload tramp paths
      desktop-load-locked-desktop nil)
(desktop-save-mode 1)

;; ediff
(setq ediff-split-window-function 'split-window-horizontally
      ediff-diff-options          "-w"
      ediff-window-setup-function 'ediff-setup-windows-plain)

;; load some other modules
(defun bw-load-mode-files ()
  "Loads all files resident in the `modes` directory"
  ;; TODO: should I just use dotfiles-dir here?
  (let ((modes-dir (concat (file-name-directory
                            (or (buffer-file-name) load-file-name)) "/modes")))
    (mapc 'load (directory-files modes-dir t "^[^#].*el$"))))

(add-hook 'bw-after-custom-load-hook 'bw-load-mode-files)
