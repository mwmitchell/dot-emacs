;; NOTE: This requires emacs 24
;; See: https://github.com/technomancy/emacs-starter-kit
;; HOW: symlink your .emacs.d directory to this project directory

;;(set-face-attribute 'default nil :height 160)
;;(set-frame-size (selected-frame) 125 40)

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

(dolist (p my-packages)
  (when (not (package-installed-p p))
    (package-install p)))

;; ;; CLOJURE
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
(require 'icomplete)

(ido-everywhere)
(ido-ubiquitous)

(require 'cider)

(add-hook 'after-init-hook 'global-company-mode)
(global-company-mode)

(setq cider-auto-select-error-buffer nil)

;; (setq cider-repl-popup-stacktraces t)
;; (setq cider-popup-stacktraces t)
;; (setq cider-auto-select-error-buffer nil)

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

(add-hook 'auto-complete-mode-hook 'set-auto-complete-as-completion-at-point-function)
(add-hook 'cider-mode-hook 'set-auto-complete-as-completion-at-point-function)
;;
;;
;;

(add-hook 'clojure-mode-hook 'auto-complete-mode)

;; ;; http://www.emacswiki.org/emacs/EmacsForMacOS
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(prefer-coding-system 'utf-8)

;; ;; http://stackoverflow.com/questions/4177929/how-to-change-the-indentation-width-in-emacs-javascript-mode
(setq js-indent-level 2)
;; ;;(setq c-basic-offset 2)

(add-to-list 'auto-mode-alist '("\\.json$" . js-mode))
;; (add-hook 'js-mode-hook 'js2-minor-mode)
;; (add-hook 'js2-mode-hook 'ac-js2-mode)

;; (setq js2-highlight-level 3)

;; (add-hook 'cider-mode-hook #'eldoc-mode)
;; (setq cider-test-show-report-on-success t)
