(require 'package)

(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/"))
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("elpy" . "https://jorgenschaefer.github.io/packages/"))
(add-to-list 'package-archives '("melpa-stable" . "http://stable.melpa.org/packages/"))

(setq package-enable-at-startup nil)
(package-initialize)
;;(package-list-packages)

(setq make-backup-files         nil) ; Don't want any backup files
(setq auto-save-list-file-name  nil) ; Don't want any .saves files
(setq auto-save-default         nil) ; Don't want any auto saving
(setq-default truncate-lines t)

;; turn off menu and toolbar
(menu-bar-mode 1)
(tool-bar-mode -1)
(setq inhibit-startup-message t)

;; auto close bracket insertion.
(electric-pair-mode 1)
(push '(?\' . ?\') electric-pair-pairs)      ; Automatically pair single-quotes

;; Key remapping
(global-set-key (kbd "<f9>") 'other-window)
(global-set-key (kbd "M-/") 'comment-or-uncomment-region)

;; set a default font
(set-default-font "Ubuntu Mono-12")

;;colour scheme (download manually)
(add-to-list 'custom-theme-load-path "~/.emacs.d/atom-one-dark-theme/")
(load-theme 'atom-one-dark t)

;;function to install missing packages automatiotially
(defun ensure-package-installed (&rest packages)
    "Assure every package is installed, ask for installation if it’s not.
  
  Return a list of installed packages or nil for every skipped package."
    (mapcar
         (lambda (package)
                (if (package-installed-p package)
                           nil
                                  (if (y-or-n-p (format "Package %s is missing. Install it? " package))
                                               (package-install package)
                                                        package)))
            packages))

;; Make sure to have downloaded archive description.
(or (file-exists-p package-user-dir)
        (package-refresh-contents))

;; Assuming you wish to install and "magit"
(ensure-package-installed 'evil 'sr-speedbar 'anaconda-mode 'ac-anaconda 'relative-line-numbers 'flycheck 'yasnippet 'fill-column-indicator 'powerline-evil 'evil-surround 'projectile 'yaml-mode)

;; Add yaml support
(require 'yaml-mode)
(add-to-list 'auto-mode-alist '("\\.yaml\\'" . yaml-mode))

;;Enable projecttile plugin
(projectile-global-mode)
(setq projectile-globally-ignored-files
	  (append projectile-globally-ignored-files '("*.txt" "*.log" "*.xml" "*.html")))
(global-unset-key (kbd "C-s"))
(global-set-key (kbd "C-s g") 'projectile-grep)
(global-set-key (kbd "C-s f") 'projectile-find-file)


;; Add line numbers
(global-relative-line-numbers-mode)

(require 'fill-column-indicator)
(add-hook 'python-mode-hook (lambda ()
    (fci-mode 1)
  ))
(setq-default fill-column 80)

;; allow to use c-u for page up in evil mode, need to add befo evil init
(setq evil-want-C-u-scroll t)
;; load evil mode
(require 'evil)
(evil-mode t)

;; list of buffers by F2
(require 'bs)
(global-set-key (kbd "<f2>") 'bs-show)
(global-set-key (kbd "C-<f1>") 'bs-cycle-previous)
(global-set-key (kbd "C-<f2>") 'bs-cycle-next)

(require 'powerline-evil)
(powerline-evil-center-color-theme)

;; list of folders
(require 'sr-speedbar)
(global-set-key (kbd "<f12>") 'sr-speedbar-toggle)

;;Snippets settings
(require 'yasnippet)
(yas-global-mode 1)

;; Surround text plugin
(require 'evil-surround)
(global-evil-surround-mode 1)

;; Remove Yasnippet's default tab key binding
(define-key yas-minor-mode-map (kbd "<tab>") nil)
(define-key yas-minor-mode-map (kbd "TAB") nil)
;; Set Yasnippet's key binding to shift+tab
(define-key yas-minor-mode-map (kbd "<backtab>") 'yas-expand)
(eval-after-load 'yasnippet
  '(progn
     ;; (define-key yas-keymap (kbd "TAB") nil)
     (define-key yas-keymap (kbd "<backtab>") 'yas-next-field-or-maybe-expand)))

;; RObot Framework mode
(load-file "~/.emacs.d/robot-mode.el")
(add-to-list 'auto-mode-alist '("\\.robot\\'" . robot-mode))
(add-hook 'robot-mode-hook 'auto-complete-mode)

;; PYTHON section
(add-hook 'python-mode-hook 'anaconda-mode)
(add-hook 'python-mode-hook 'ac-anaconda-setup)

;; Flycheck to check python code
(package-install 'flycheck)
(global-flycheck-mode)
