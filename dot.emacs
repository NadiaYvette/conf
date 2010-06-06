;-*- emacs-lisp -*-
(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(case-fold-search t)
 '(current-language-environment "English")
 '(global-font-lock-mode t nil (font-lock))
 '(indent-tabs-mode nil)
 '(inhibit-startup-screen t)
 '(jit-lock-defer-time 0.25)
 '(js2-auto-indent-flag nil)
 '(js2-bounce-indent-flag t)
 '(js2-highlight-level 3)
 '(js2-mirror-mode nil)
 '(mouse-wheel-follow-mouse t)
 '(mouse-wheel-mode t nil (mwheel))
 '(ps-black-white-faces (quote ((font-lock-builtin-face "black" nil bold underline) (font-lock-comment-face "gray20" nil italic) (font-lock-constant-face "black" nil bold) (font-lock-function-name-face "black" nil bold) (font-lock-keyword-face "black" nil bold underline) (font-lock-string-face "black" nil italic) (font-lock-type-face "black" nil italic) (font-lock-variable-name-face "black" nil bold italic) (font-lock-warning-face "black" nil bold italic))))
 '(ps-line-number t)
 '(ps-print-color-p (quote black-white))
 '(rst-level-face-base-color "not-a-color-so-ill-get-black")
 '(save-place t nil (saveplace))
 '(show-paren-mode t nil (paren))
 '(standard-indent 2)
 '(tab-width 4)
 '(transient-mark-mode t)
 '(uniquify-buffer-name-style (quote forward) nil (uniquify)))
 
;; java
;;
;; make arguments indented only 4 spaces past function, when all
;; function args on subsequent lines.  Good for
;; reallyLongJavaMethodNames.
;;
;; setting the c-style messes up the indent distance (c-basic-offset),
;; so reset after setting c-style.
(add-hook 'java-mode-hook
          (lambda ()
            (progn
              (c-set-style "linux")
              (setq c-basic-offset 4))))

 ; removed
 ;'(desktop-save-mode 1)

; Make all backups in same place: Avoid clutter, and danger of typing
; {rm -rf * ~} instead of {rm -rf *~} when removing clutter. See
; http://www.gnu.org/software/emacs/manual/html_node/emacs/Backup.html
; for some explanation of when backups are created, and some ways to
; force backup creation.
;
; NB: The backup dir specified here is created if it doesn't exist.
; This is bad if this creation happens while you're sudo'd since then
; root owns the backup dir ...
(setq backup-directory-alist '(("" . "~/.emacs.d/backups")))

; Make M-x apropos, and maybe C-h a, show more results. This var has
; documentation *after* apropos.el loads, e.g. after using M-x
; apropos.
(setq apropos-do-all t)

(iswitchb-mode t)
(icomplete-mode t)
(partial-completion-mode t)

; Soft wrap lines in split frames.  Lines in full width frames are
; soft wrapped by default, and lines in split frames are truncated by
; default.
(setq truncate-partial-width-windows nil)

; Make svn commits hapen in text mode. SVN commit tmp files have names
; like svn-commit.2.tmp or svn-commit.tmp.  NB: it seems the file name
; that the auto-mode regexps match against is a *full* path, so it
; doesn't work to anchor at the beginning (^).
(add-to-list 'auto-mode-alist '("svn-commit\\(\\.[0-9]+\\)?\\.tmp$" . text-mode))

;(add-hook 'font-lock-mode-hook 'flyspell-prog-mode)
;(add-hook 'text-mode-hook 'flyspell-mode)

; Turn on flyspell-prog-mode in all modes except ..., which should use
; full flyspell-mode.
(add-hook 'font-lock-mode-hook
          (lambda ()
            (if (member major-mode '(text-mode rst-mode latex-mode))
                (flyspell-mode t)
              (flyspell-prog-mode))))

; vi/less style jk navigation in view-mode.  Kind of pointless because
; du keys scroll half page.  But the default <enter>y for <down><up>
; were too annoying.
(when (boundp 'view-mode-map)
  (mapc (lambda (kv) (define-key view-mode-map (car kv) (cadr kv)))
        '(("j" View-scroll-line-forward)
          ("k" View-scroll-line-backward))))

; Make it darker
;(set-foreground-color "grey")
;(set-background-color "black")

;; Enable math-mode by default, i.e. the ` escapes in auctex.
;(require 'latex)                ; defines LaTeX-math-mode
(add-hook 'TeX-mode-hook 'LaTeX-math-mode)

;;; Some customization from the UW CSL .emacs
(column-number-mode t)
(display-time)

;; If you would like smooth scrolling, uncomment this line
(setq scroll-step 1)

;; For a much better buffer list:
(global-set-key "\C-x\C-b" 'electric-buffer-list)

; Not sure which modes become more decorated?
(setq font-lock-maximum-decoration t)

; The default history length, at least in sml-run, is apparently 30,
; which is pretty worthless for an interpreter.
(setq history-length 5000)

;; Make emacs shell display ascii color escapes properly.
(ansi-color-for-comint-mode-on)

; A useful looking snippet for setting up custom colors...

;        (font-lock-make-faces t)
;        (setq font-lock-face-attributes
;              '((font-lock-comment-face "Firebrick")
;                (font-lock-string-face "RosyBrown")
;                (font-lock-keyword-face "Purple")
;                (font-lock-function-name-face "Blue")
;                (font-lock-variable-name-face "DarkGoldenrod")
;                (font-lock-type-face "DarkOliveGreen")
;                (font-lock-reference-face "CadetBlue")))

;;; End CSL stuff

;; more flexible auto-completion
(global-set-key (kbd "M-/") 'hippie-expand)

;;; Some customization from
;;; http://www.xsteve.at/prg/emacs/power-user-tips.html

(desktop-load-default) ; From the ``desktop'' docs.

;; save a list of open files in ~/.emacs.desktop
;; save the desktop file automatically if it already exists
;(setq desktop-save 'if-exists)
;;(when (boundp 'desktop-save-mode) ; Not defined on UW CS machines.
;;  (desktop-save-mode 1))

;; save a bunch of variables to the desktop file
;; for lists specify the len of the maximal saved data also
(setq desktop-globals-to-save
      (append '((extended-command-history . 30)
                (file-name-history        . 100)
                (grep-history             . 30)
                (compile-history          . 30)
                (minibuffer-history       . 50)
                (query-replace-history    . 60)
                (read-expression-history  . 60)
                (regexp-history           . 60)
                (regexp-search-ring       . 20)
                (search-ring              . 20)
                (shell-command-history    . 50)
                tags-file-name
                register-alist)))

;(desktop-read) ; From the ``desktop'' docs.


;; Use M-x desktop-save once to save the desktop.  When it exists,
;; Emacs updates it on every exit.  The desktop is saved in the
;; directory where you started emacs, i.e. you have per-project
;; desktops.  If you ever save a desktop in your home dir, then that
;; desktop will be the default in the future when you start emacs in a
;; dir with no desktop.  See the ``desktop'' docs for more info.

;;; End xsteve stuff.

;;; Org mode

;; suggested global bindings from docs
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-ca" 'org-agenda)
(setq org-agenda-files '("~/versioned/org/"))

;;; control-lock
(add-to-list 'load-path "~/.emacs.d/")
(require 'control-lock)
(control-lock-keys)


;;; linum-mode, new in emacs 23
(when (require 'linum nil t)
  (global-linum-mode t)
  ;; linum in terminal has no margin after numbers.  don't add the
  ;; margin in x11 since then you get two margins.
  (when (null (window-system))
    (setq linum-format "%d ")))

;;; Make custom modes available

; Add my custom lib dir to the path.
(push "~/.emacs.d" load-path)
; I'll put system (as in the math.wisc.edu vs uoregon.edu) specific
; code here.  This is useful if I want to version control my .emacs,
; because I might not want to load all the same stuff on all systems
; (e.g. no need for matlab-mode on a system without matlab).
(let ((file "~/.emacs.d/system-custom.el"))
  (if (file-exists-p file)
       (load-file file)))
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 )
