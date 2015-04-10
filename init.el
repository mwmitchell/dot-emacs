;; NOTE: This requires emacs 24
(setq inhibit-splash-screen t)

(defun set-exec-path-from-shell-PATH ()
  "Set up Emacs' `exec-path' and PATH environment variable to match that used by the user's shell.

This is particularly useful under Mac OSX, where GUI apps are not started from a shell."
  (interactive)
  (let ((path-from-shell (replace-regexp-in-string "[ \t\n]*$" "" (shell-command-to-string "$SHELL --login -i -c 'echo $PATH'"))))
    (setenv "PATH" path-from-shell)
    (setq exec-path (split-string path-from-shell path-separator))))

(set-exec-path-from-shell-PATH)

(add-to-list 'load-path "~/.emacs.d/lib/web-beautify")

(add-to-list 'custom-theme-load-path "~/.emacs.d/lib/color-themes/noctilux-theme")
(load-theme 'noctilux t)

;; (set-face-attribute 'default nil :height 160)

(set-default-font "Courier New-18")

;;(set-face-attribute 'default nil :height 160)
;;(set-frame-size (selected-frame) 125 40)

;;(set-face-attribute 'font-lock-string-face nil :foreground "#ABC")
(set-face-attribute 'font-lock-comment-face nil :foreground "#888")
(set-face-attribute 'font-lock-doc-face nil :foreground "#DBB")

;; show line nums
(global-linum-mode 1)

(require 'package)

(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/") t)

(add-to-list 'package-archives
             '("melpa" . "http://melpa.milkbox.net/packages/"))

;;(add-to-list 'package-archives
;;             '("melpa-stable" . "http://stable.melpa.org/packages/") t)

(package-initialize)

(when (not package-archive-contents)
  (package-refresh-contents))

(defvar my-packages
  '(company
    better-defaults
    idle-highlight-mode
    ido-ubiquitous
    find-file-in-project
    magit
    smex
    paredit
    maxframe
    clojure-mode
    clojure-mode-extra-font-locking
    projectile
    rainbow-delimiters
    tagedit
    popup
    auto-complete
    color-theme
    ac-cider
    cider
    auto-complete
    yasnippet
    color-theme-monokai
    color-theme-github
    color-theme-cobalt)
  "A list of packages to ensure are installed at launch.")

(if (eq system-type 'darwin)
    (add-to-list 'my-packages 'exec-path-from-shell))

(dolist (p my-packages)
  (when (not (package-installed-p p))
    (package-install p)))

;; Clojure
(require 'clojure-mode)
(defun clojure-mode-untabify ()
  (save-excursion
    (goto-char (point-min))
    (while (re-search-forward "[ \t]+$" nil t)
      (delete-region (match-beginning 0) (match-end 0)))
    (goto-char (point-min))
    (if (search-forward "\t" nil t)
        (untabify (1- (point)) (point-max))))
  nil)

(add-hook 'clojure-mode-hook
          '(lambda () (add-hook 'write-contents-hooks 'clojure-mode-untabify nil t)))

(add-hook 'clojure-mode-hook 'paredit-mode)
(add-to-list 'auto-mode-alist '("\\.clj$" . clojure-mode))

;; https://github.com/clojure-emacs/cider#icomplete
;; seems to work, but fugly
;; (require 'icomplete)

(ido-everywhere)
(ido-ubiquitous)

(require 'cider)

(add-hook 'after-init-hook 'global-company-mode)
(global-company-mode)

(setq cider-show-error-buffer t)
(setq cider-repl-popup-stacktraces t)
(setq cider-popup-stacktraces t)
(setq cider-auto-select-error-buffer nil)
(add-hook 'cider-mode-hook
          'set-auto-complete-as-completion-at-point-function)
(add-hook 'cider-mode-hook #'eldoc-mode)
(setq cider-test-show-report-on-success t)

(setq cider-auto-jump-to-error nil)

(setq cider-auto-select-test-report-bufferrepl nil)

;;
;; https://github.com/clojure-emacs/ac-cider
;;
(require 'ac-cider)
(add-hook 'cider-mode-hook 'ac-flyspell-workaround)
(add-hook 'cider-mode-hook 'ac-cider-setup)
(add-hook 'cider-repl-mode-hook 'ac-cider-setup)
(eval-after-load "auto-complete"
  '(progn
     (add-to-list 'ac-modes 'cider-mode)
     (add-to-list 'ac-modes 'cider-repl-mode)))

(defun set-auto-complete-as-completion-at-point-function ()
  (setq completion-at-point-functions '(auto-complete)))

;; (setq ac-quick-help-delay 0.2)

(add-hook 'auto-complete-mode-hook 'set-auto-complete-as-completion-at-point-function)
;;
;;

;;
(load "auto-complete")
;;

(add-hook 'clojure-mode-hook 'auto-complete-mode)

;; ;; http://www.emacswiki.org/emacs/EmacsForMacOS
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(prefer-coding-system 'utf-8)

;; ;; http://stackoverflow.com/questions/4177929/how-to-change-the-indentation-width-in-emacs-javascript-mode
(setq js-indent-level 2)
(setq c-basic-offset 2)

(add-to-list 'auto-mode-alist '("\\.json$" . js-mode))
;; (add-hook 'js-mode-hook 'js2-minor-mode)
;; (add-hook 'js2-mode-hook 'ac-js2-mode)

;; (setq js2-highlight-level 3)

(setq mouse-wheel-scroll-amount '(1 ((shift) . 1))) ;; one line at a time
(setq mouse-wheel-progressive-speed nil) ;; don't accelerate scrolling
(setq mouse-wheel-follow-mouse 't) ;; scroll window under mouse
(setq scroll-step 1) ;; keyboard scroll one line at a time


(require 'web-beautify) ;; Not necessary if using ELPA package
(eval-after-load 'js2-mode
  '(define-key js2-mode-map (kbd "C-c b") 'web-beautify-js))
;; Or if you're using 'js-mode' (a.k.a 'javascript-mode')
(eval-after-load 'js
  '(define-key js-mode-map (kbd "C-c b") 'web-beautify-js))
(eval-after-load 'json-mode
  '(define-key json-mode-map (kbd "C-c b") 'web-beautify-js))
(eval-after-load 'sgml-mode
  '(define-key html-mode-map (kbd "C-c b") 'web-beautify-html))
(eval-after-load 'css-mode
  '(define-key css-mode-map (kbd "C-c b") 'web-beautify-css))
