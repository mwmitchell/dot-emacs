
;; NOTE: This requires emacs 24
;; See: https://github.com/technomancy/emacs-starter-kit
;; HOW: symlink your .emacs.d directory to this project directory

;; load up a custom user init
;;(load-file (concat "~/" (user-login-name) ".el"))

;;(set-default-font "-adobe-courier-medium-r-normal--16-180-75-75-m-110-iso8859-1")

;;(set-face-attribute 'default nil :height 115)
;;(set-fontset-font "Courier New-10")
;;(set-frame-parameter nil 'font "Courier New-15")
;;(set-frame-parameter nil 'font "Arial Unicode MS-12")
;;(set-frame-parameter nil 'font "Unifont-12")

(set-face-attribute 'default nil :height 160)
;;(set-frame-parameter nil 'font "FixedsysTTF-14")
(set-frame-size (selected-frame) 140 42)

;;(set-frame-parameter nil 'font "Code2000-12")
;;(set-frame-parameter nil 'font "Lucida Sans Unicode-11")

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
    auto-complete
    color-theme
    ac-nrepl
    cider
    auto-complete
    ;;smartparens
    ;;rainbow-delimiters
    color-theme-monokai
    color-theme-github
    color-theme-cobalt)
  "A list of packages to ensure are installed at launch.")

(dolist (p my-packages)
  (when (not (package-installed-p p))
    (package-install p)))

;; maxframe
;;(add-hook 'window-setup-hook 'maximize-frame t)

;; formats a clojure function doc string while keeping the binding
;;vector on a new line.
;;clojure-fill-docstring

(custom-set-variables
 '(mf-display-padding-height 150)
 '(mf-offset-y 0)
 '(send-mail-function nil))

;; TODO: bind this to a command... this shrinks the window down --
;; useful for getting your window back after unplugging and external
;; monitor!


;;(set-frame-size (selected-frame) 189 55)

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

;; http://www.emacswiki.org/emacs/EmacsForMacOS
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(prefer-coding-system 'utf-8)

(eval-when-compile
  (require 'color-theme))


;;(color-theme-cobalt)

;;(require 'color-theme-github)
;;(color-theme-github)

;;(require 'color-theme-solarized)
;;(color-theme-solarized )

;;(require 'color-theme-blackboard)
;;(color-theme-blackboard)

(require 'color-theme-monokai)
(color-theme-monokai)

;; http://stackoverflow.com/questions/4177929/how-to-change-the-indentation-width-in-emacs-javascript-mode
(setq js-indent-level 2)
;;(setq c-basic-offset 2)

(let ((path (shell-command-to-string ". ~/.bashrc; echo -n $PATH")))
  (setenv "PATH" path)
  (setq exec-path 
        (append
         (split-string-and-unquote path ":")
         exec-path)))

(add-to-list 'auto-mode-alist '("\\.json$" . js-mode))

(add-hook 'js-mode-hook 'js2-minor-mode)
(add-hook 'js2-mode-hook 'ac-js2-mode)

(setq js2-highlight-level 3)


;; (require 'web-beautify) ;; Not necessary if using ELPA package
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

;; (eval-after-load 'web-beautify
;;   '(defconst web-beautify-args '("-f" "-" "-s" "2" "-j" "true")))

(defconst web-beautify-args '("-f" "-" "-s" "2" "-j" "true"))

;;

;;; yasnippet
;;; should be loaded before auto complete so that they can work together
(require 'yasnippet)
(yas-global-mode 1)

;;; auto complete mod
;;; should be loaded after yasnippet so that they can work together
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/ac-dict")
(ac-config-default)
;;; set the trigger key so that it can work together with yasnippet on tab key,
;;; if the word exists in yasnippet, pressing tab will cause yasnippet to
;;; activate, otherwise, auto-complete will
(ac-set-trigger-key "TAB")
(ac-set-trigger-key "<tab>")

;;;

(require 'auto-complete)
(require 'auto-complete-config)
(ac-config-default)


;; (defgroup js-beautify nil
;;   "Use jsbeautify to beautify some js"
;;   :group 'editing)

;; (defcustom js-beautify-args "--indent-size=2 --space-in-paren=true --space-in-empty-paren=false --keep-array-indentation=true"
;;   "Arguments to pass to jsbeautify script"
;;   :type '(string)
;;   :group 'js-beautify)

;; (defcustom js-beautify-path "/usr/local/bin/js-beautify"
;;   "Path to jsbeautifier python file"
;;   :type '(string)
;;   :group 'js-beautify)

;; (defun js-beautify ()
;;   "Beautify a region of javascript using the code from jsbeautify.org"
;;   (interactive)
;;   (let ((orig-point (point)))
;;     (unless (mark)
;;       (mark-defun))
;;     (shell-command-on-region (point)
;;                              (mark)
;;                              (concat js-beautify-path
;;                                      " - "
;;                                      js-beautify-args)
;;                              nil t)
;;     (goto-char orig-point)))

;; (provide 'js-beautify)
