
; activate all the packages (in particular autoloads)
(package-initialize)
(add-to-list 'package-archives
              '(("elpa" . "http://tromey.com/elpa/")
                         ("gnu" . "http://elpa.gnu.org/packages/")
                         ("melpa" . "https://melpa.org/packages/")
                         ("marmalade" . "http://marmalade-repo.org/packages/")))


(defun install-if-needed (package)
  (unless (package-installed-p package)
    (package-install package)))

; fetch the list of packages available
(unless package-archive-contents
  (package-refresh-contents))

; list the packages you want

(setq package-list
      '(better-defaults
                     helm
                     helm-projectile
                     helm-ag
                     ;;ruby related
                     ruby-electric
                     seeing-is-believing
                     rvm
                     inf-ruby
                     ruby-test-mode
                     ;;generally useful packages
                     company
                     company-jedi
                     rainbow-mode
                     rainbow-delimiters
                     smartparens
                    ;; need to find  a package to use  showkey
                     ;; git/github
                     magit
                     magithub
                     ;; python related packages
                     jedi
                     pytest
                     ;; themesn
                     afternoon-theme
                     noctilux-theme
                     dracula-theme
                     yasnippet))

; install the missing packages
(dolist (package package-list)
  (unless (package-installed-p package)
    (package-install package)))

(require 'better-defaults)

(setq inhibit-splash-screen t
      initial-scratch-message nil
      initial-major-mode 'ruby-mode)

;; show the function you are in
(which-function-mode t)

;; company is the completion backend
(global-company-mode t)

;; nicer parenthesis handling
(smartparens-global-mode t)

;; show the parens
(show-paren-mode t)

;; show column number
(column-number-mode t)


;; Show line numbers
(global-linum-mode)

(add-hook 'prog-mode-hook #'rainbow-delimiters-mode)
(add-hook 'prog-mode-hook #'rainbow-mode)

(yas-global-mode t)

;; python specific stuff
(require 'company-jedi)

;; various settings for Jedi
(setq
 jedi:complete-on-dot t
 jedi:setup-keys t
 py-electric-colon-active t
 py-smart-indentation t)

(add-hook 'python-mode-hook
          (lambda ()
            (add-to-list 'company-backends 'company-jedi)
            (hack-local-variables)
            (jedi:setup)
            (local-set-key "\C-cd" 'jedi:show-doc)
            (local-set-key (kbd "M-.") 'jedi:goto-definition)
            (local-set-key (kbd "M-D") 'ca-python-remove-pdb)
            (local-set-key [f6] 'pytest-module)))


(load-library "magit")
;; (load-library "magithub")
;; (magithub-feature-autoinject t)
(global-set-key "\C-xg" 'magit-status)

;; Typography
(set-face-attribute 'default nil
                    :family "Source Code Pro"
                    :height 150
                    :weight 'normal
                    :width 'normal)

(require 'helm)
(require 'helm-projectile)
(require 'helm-ag)
(global-set-key (kbd "M-x") #'helm-M-x)
(global-set-key (kbd "s-f") #'helm-projectile-ag)
(global-set-key (kbd "s-t") #'helm-projectile-find-file-dwim)

;; Autoclose paired syntax elements like parens, quotes, etc
(require 'ruby-electric)
(add-hook 'ruby-mode-hook 'ruby-electric-mode)
;;(chruby "2.2.2")
(rvm-use-default)

(setq seeing-is-believing-prefix "C-.")
(add-hook 'ruby-mode-hook 'seeing-is-believing)
(require 'seeing-is-believing)

(autoload 'inf-ruby-minor-mode "inf-ruby" "Run an inferior Ruby process" t)
(add-hook 'ruby-mode-hook 'inf-ruby-minor-mode)

(require 'ruby-test-mode)
(add-hook 'ruby-mode-hook 'ruby-test-mode)

(add-hook 'compilation-finish-functions
          (lambda (buf strg)
            (switch-to-buffer-other-window "*compilation*")
            (read-only-mode)
            (goto-char (point-max))
            (local-set-key (kbd "q")
                           (lambda () (interactive) (quit-restore-window)))))

(autoload 'python-mode "python-mode" "Python Mode." t)
 (add-to-list 'auto-mode-alist '("\\.py\\'" . python-mode))
(add-to-list 'interpreter-mode-alist '("python" . python-mode))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (dracula-theme noctilux-theme pytest jedi magithub magit showkey smartparens rainbow-delimiters rainbow-mode company-jedi company yasnippet-snippets feature-mode afternoon-theme seeing-is-believing rvm ruby-test-mode ruby-electric inf-ruby helm-projectile helm-ag better-defaults))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(load-theme 'noctilux t)
