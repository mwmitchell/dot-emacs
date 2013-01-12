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
    ;;slime
    ;;ac-slime
	nrepl
	ac-nrepl
    midje-mode
    ;;color-theme
    ;;color-theme-sanityinc-solarized
    ;;color-theme-wombat
    ;;color-theme-wombat+
    ;;color-theme-gruber-darker
	)
  "A list of packages to ensure are installed at launch.")

(dolist (p my-packages)
  (when (not (package-installed-p p))
    (package-install p)))

;; maxframe
(add-hook 'window-setup-hook 'maximize-frame t)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(mf-display-padding-height 100)
 '(mf-offset-y 0)
 ;;'(slime-net-coding-system (quote utf-8-unix))
 )

;; TODO: bind this to a command... this shrinks the window down --
;; useful for getting your window back after unplugging and external
;; monitor!

;;(set-frame-size (selected-frame) 40 15)

;; color-theme
(load "color-theme")
;; (load "color-theme-gruber-darker")
;; (load "color-theme-wombat")
;;(load "color-theme-wombat+")
;; (color-theme-gruber-darker)
;;(load "color-theme-github")
(load "color-theme-sanityinc-solarized")

(eval-when-compile
  (require 'color-theme))

(require 'color-theme)
(require 'color-theme-sanityinc-solarized)
(color-theme-sanityinc-solarized-dark)

(defun clojure-mode-untabify ()
 (save-excursion
   (goto-char (point-min))
   (while (re-search-forward "[ \t]+$" nil t)
     (delete-region (match-beginning 0) (match-end 0)))
   (goto-char (point-min))
   (if (search-forward "\t" nil t)
       (untabify (1- (point)) (point-max))))
 nil)

;;(add-hook 'clojure-mode-hook
;;          '(lambda ()
;;             (define-key clojure-mode-map "\C-c\C-f" 'slime-eval-defun)))

(add-hook 'clojure-mode-hook
          '(lambda () (add-hook 'write-contents-hooks 'clojure-mode-untabify nil t)))

(add-hook 'clojure-mode-hook 'nrepl-interaction-mode)
(add-hook 'clojure-mode-hook 'paredit-mode)

(load "auto-complete")

;;(add-hook 'slime-mode-hook 'auto-complete-mode)
;;(add-hook 'slime-mode-hook 'set-up-slime-ac)

(eshell)

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
 
;;;;;;;;;;;;

(require 'ido)
(ido-mode t)
(setq ido-enable-prefix nil
      ido-enable-flex-matching t
      ido-auto-merge-work-directories-length nil
      ido-create-new-buffer 'always
      ido-use-filename-at-point 'guess
      ido-use-virtual-buffers t
      ido-handle-duplicate-virtual-buffers 2
      ido-max-prospects 10)

;; Display ido results vertically, rather than horizontally
(setq ido-decorations (quote ("\n-> " "" "\n " "\n ..." "[" "]" " [No match]" " [Matched]" " [Not readable]" " [Too big]" " [Confirm]")))
(defun ido-disable-line-trucation () (set (make-local-variable 'truncate-lines) nil))
(add-hook 'ido-minibuffer-setup-hook 'ido-disable-line-trucation)
