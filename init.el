;; NOTE: This requires emacs 24
;; See: https://github.com/technomancy/emacs-starter-kit
;; HOW: symlink your .emacs.d directory to this project directory

;; load up a custom user init
(load-file (concat "~/" (user-login-name) ".el"))

(add-to-list 'load-path
             (concat (file-name-directory load-file-name) "auto-complete-1.3.1/"))

(set-default-font "-adobe-courier-medium-r-normal--16-180-75-75-m-110-iso8859-1")

;; show line nums
(global-linum-mode 1)

(require 'package)
(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/") t)
(package-initialize)

(when (not package-archive-contents)
  (package-refresh-contents))

(defvar my-packages
  '(starter-kit
    starter-kit-ruby
    starter-kit-lisp
    starter-kit-eshell
    maxframe
    clojure-mode
    slime
    ac-slime
    midje-mode
    color-theme
    color-theme-wombat
    color-theme-wombat+
    color-theme-gruber-darker)
  "A list of packages to ensure are installed at launch.")

(dolist (p my-packages)
  (when (not (package-installed-p p))
    (package-install p)))

;; maxframe
(add-hook 'window-setup-hook 'maximize-frame t)
(custom-set-variables
 '(mf-display-padding-height 100)
 '(mf-offset-y 0))

;; color-theme
(load "color-theme")
(load "color-theme-gruber-darker")
(load "color-theme-wombat")
(load "color-theme-wombat+")
(color-theme-gruber-darker)

;; clojure stuff
(add-hook 'slime-repl-mode-hook 'clojure-mode-font-lock-setup)
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
          '(lambda ()
             (define-key clojure-mode-map "\C-c\C-f" 'slime-eval-defun)))
(add-hook 'clojure-mode-hook
          '(lambda () (add-hook 'write-contents-hooks 'clojure-mode-untabify nil t)))


(load "auto-complete")

(add-hook 'slime-mode-hook 'auto-complete-mode)
(add-hook 'slime-mode-hook 'set-up-slime-ac)
