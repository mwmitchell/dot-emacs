;; NOTE: This requires emacs 24
;; See: https://github.com/technomancy/emacs-starter-kit
;; HOW: symlink your .emacs.d directory to this project directory

;; load up a custom user init
(load-file (concat "~/" (user-login-name) ".el"))

;; (add-to-list 'load-path
;;              (concat (file-name-directory load-file-name) "auto-complete-1.3.1/"))

(set-default-font "-adobe-courier-medium-r-normal--16-180-75-75-m-110-iso8859-1")

;; show line nums
(global-linum-mode 1)

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
    ;;nrepl
    auto-complete
    color-theme
    ac-nrepl
    ;;midje-mode
    rainbow-delimiters
    color-theme-monokai
    color-theme-github)
  "A list of packages to ensure are installed at launch.")

(dolist (p my-packages)
  (when (not (package-installed-p p))
    (package-install p)))

;;(require 'auto-complete)

;; (require 'auto-complete-config)
;; ;;(add-to-list 'ac-dictionary-directories "~/.emacs.d/dict")
;; (ac-config-default)

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
 '(mf-display-padding-height 105)
 '(mf-offset-y 0)
 '(send-mail-function nil))

;; TODO: bind this to a command... this shrinks the window down --
;; useful for getting your window back after unplugging and external
;; monitor!

;;(set-frame-size (selected-frame) 40 15)

;; NREPL
(add-to-list 'load-path             	
             (concat user-emacs-directory "midje-mode")
             (concat user-emacs-directory "nrepl"))

(require 'nrepl)
(add-hook 'nrepl-interaction-mode-hook 'nrepl-turn-on-eldoc-mode)
(add-to-list 'same-window-buffer-names "*nrepl*")

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

;;nrepl-enable-on-existing-buffers
;;(add-hook 'clojure-mode-hook 'nrepl-interaction-mode)
(add-hook 'clojure-mode-hook 'paredit-mode)
(add-to-list 'auto-mode-alist '("\\.clj$" . clojure-mode))

;; MIDJE
(require 'midje-mode)
(add-hook 'clojure-mode-hook 'midje-mode)

(eval-when-compile
  (require 'color-theme))

(require 'auto-complete)
(require 'auto-complete-config)
(ac-config-default)

;;(color-theme-charcoal-black)
;;(color-theme-monokai)
(require 'color-theme-github)
(color-theme-github)

;; http://stackoverflow.com/questions/4177929/how-to-change-the-indentation-width-in-emacs-javascript-mode

(setq js-indent-level 2)
;;(setq c-basic-offset 2)
