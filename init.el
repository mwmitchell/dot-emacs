;; NOTE: This requires emacs 24
;; See: https://github.com/technomancy/emacs-starter-kit
;; HOW: symlink your .emacs.d directory to this project directory

;; load up a custom user init
(load-file (concat "~/" (user-login-name) ".el"))

;;(set-default-font "-adobe-courier-medium-r-normal--16-180-75-75-m-110-iso8859-1")

;;(set-face-attribute 'default nil :height 115)
;;(set-fontset-font "Courier New-10")
;;(set-frame-parameter nil 'font "Courier New-15")
;;(set-frame-parameter nil 'font "Arial Unicode MS-12")
;;(set-frame-parameter nil 'font "Unifont-12")
(set-frame-parameter nil 'font "FixedsysTTF-12")
;;(set-frame-parameter nil 'font "Code2000-12")
;;(set-frame-parameter nil 'font "Lucida Sans Unicode-11")

;; show line nums
;;(global-linum-mode 1)

(require 'package)
(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/") t)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.milkbox.net/packages/"))

(package-initialize)

(when (not package-archive-contents)
  (package-refresh-contents))

(defvar my-packages
  '(starter-kit
    ;;starter-kit-ruby
    starter-kit-lisp
    ;;starter-kit-eshell
    maxframe
    clojure-mode
    auto-complete
    color-theme
    ac-nrepl
    cider
    ;;smartparens
    ;;midje-mode
    rainbow-delimiters
    color-theme-monokai
    color-theme-github
    color-theme-cobalt)
  "A list of packages to ensure are installed at launch.")

(dolist (p my-packages)
  (when (not (package-installed-p p))
    (package-install p)))

;; maxframe
(add-hook 'window-setup-hook 'maximize-frame t)

;; formats a clojure function doc string while keeping the binding
;;vector on a new line.
;;clojure-fill-docstring

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(mf-display-padding-height 150)
 ;;'(mf-offset-y 0)
 '(send-mail-function nil))

;; TODO: bind this to a command... this shrinks the window down --
;; useful for getting your window back after unplugging and external
;; monitor!

(set-frame-size (selected-frame) 189 55)

(add-to-list 'load-path
             (concat user-emacs-directory "midje-mode"))

;; CLOJURE
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

(require 'cider)
(setq cider-repl-popup-stacktraces t)
(setq cider-popup-stacktraces t)
(setq cider-auto-select-error-buffer nil)

;; MIDJE
(require 'midje-mode)
(add-hook 'clojure-mode-hook 'midje-mode)

(add-hook 'cider-repl-mode-hook 'rainbow-delimiters-mode)

(eval-when-compile
  (require 'color-theme))

(require 'auto-complete)
(require 'auto-complete-config)
(ac-config-default)

;;(require 'color-theme-github)
;;(color-theme-github)

(color-theme-cobalt)

;; http://stackoverflow.com/questions/4177929/how-to-change-the-indentation-width-in-emacs-javascript-mode
(setq js-indent-level 2)
;;(setq c-basic-offset 2)
