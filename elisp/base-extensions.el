;;; Package --- Summary
;; Code:
;;; Commentary:


;;  Need to find out
;; how to use this effectively
(use-package ace-jump-mode
  :bind
  ("C-c SPC" . ace-jump-mode))

(use-package company
  :config
  (add-hook 'after-init-hook 'global-company-mode)
  :bind
  ("M-/" . 'company-complete))

(use-package dashboard
  :init
  (add-hook 'after-init-hook 'dashboard-refresh-buffer)
  (add-hook 'dashboard-mode-hook 'my/dashboard-banner)
  :config
  (setq dashboard-items '((recents . 10)
                          (bookmarks . 5)
                          (projects . 5)
                          (agenda . 5)))
  (dashboard-setup-startup-hook))

(use-package ediff
  :config
  (setq ediff-window-setup-function 'ediff-setup-windows-plain)
  (setq-default ediff-highlight-all-diffs 'nil)
  (setq ediff-diff-options "-w"))

(use-package exec-path-from-shell
  :config
  ;; Add GOPATH to shell
  (when (memq window-system '(mac ns x))
    (exec-path-from-shell-copy-env "GOPATH")
    (exec-path-from-shell-copy-env "PYTHONPATH")
    (exec-path-from-shell-initialize)))

;; Semantically expands region
;; Instead of <C-SPC> to set mark and then set then selecting
;; the region using C-p or C-n, I can now select region by
;; C-=.
(use-package expand-region
  :bind
  ("C-=" . er/expand-region))

(use-package flycheck
  :init
  (global-flycheck-mode))

(use-package helm
  :diminish
  :init
  (require 'helm-config)
  :config
  (setq helm-split-window-inside-p t
        helm-split-window-default-side 'below
        ;; helm-idle-delay 0.0
        helm-input-idle-delay 0.01
        ;; helm-quick-update t
        ;; helm-ff-skip-boring-files t
        )
  (helm-mode 1)
  :bind (
         ;;("M-x" . helm-M-x)
         ("C-x C-m" . helm-M-x)
         ("C-x C-f" . helm-find-files)
         ("C-x v" . helm-projectile)
         ("C-x c o" . helm-occur)
         ("C-x c p" . helm-projectile-ag)
         ("C-x c k" . helm-show-kill-ring)
         :map helm-map
         ("<tab>" . helm-execute-persistent-action)
         ("C-z" . helm-select-action)))

;; I  do not know how to use this
(use-package helm-ag
  :disabled t)

;; I  do not know how to use this
(use-package helm-git-grep
  :disabled t)

(use-package helm-projectile
  :config
  (helm-projectile-on))

;; This seems interesting but I am
;; not sure yet.
(use-package helm-swoop
  :bind
  ("C-x c s" . helm-swoop))


(use-package hlinum
  :config
  (hlinum-activate))

;; I  do not need this anymore
(use-package linum
  :config
  (setq linum-format " %3d ")
  ;;(global-linum-mode nil)
  )

(use-package magit
  :config
  :bind
  ;; Magic
  ("C-x g s" . magit-status)
  ("C-x g x" . magit-checkout)
  ("C-x g c" . magit-commit)
  ("C-x g p" . magit-push)
  ("C-x g u" . magit-pull)
  ("C-x g e" . magit-ediff-resolve)
  ("C-x g r" . magit-rebase-interactive))

(use-package magit-popup)

(use-package multiple-cursors
  :bind
  ("C-S-c C-S-c" . mc/edit-lines)
  ("C->" . mc/mark-next-like-this)
  ("C-<" . mc/mark-previous-like-this)
  ("C-c C->" . mc/mark-all-like-this))

(use-package neotree
  :bind
  ("<f8>" . 'neotree-toggle)
  :config
  (setq neo-theme 'arrow
        neo-smart-open t
        neo-window-fixed-size nil
        projectile-switch-project-action 'neotree-projectile-action)
  ;; Disable linum for neotree
  ;;(add-hook 'neo-after-create-hook 'disable-neotree-hook)
  )

(use-package page-break-lines)

(use-package projectile
  :init
  (setq projectile-known-projects-file
        (expand-file-name "projectile-bookmarks.eld" temp-dir))
  (setq projectile-switch-project-action #'projectile-dired)
  (setq projectile-mode-line-prefix " Proj")
  :config
  ;;This is now deprecated
  ;;(setq projectile--mode-line '(:eval (format " Proj[%s]" (projectile-project-name))))
  (projectile-mode +1)
  :bind
  ("C-c p" . projectile-command-map))

;; I  do not require this package
;; Dashboard has this feature.
(use-package recentf
  :config
  (setq recentf-save-file (recentf-expand-file-name "~/.emacs.d/private/cache/recentf"))
  (recentf-mode 1))

(use-package smartparens-config
  :diminish
  :ensure smartparens
  :config
  (setq show-smartparens-global-mode t)
  :hook
  ((prog-mode markdown-mode) . 'turn-on-smartparens-strict-mode))

;; SMEX is amazing
;; Pity that it does not integrate with helm
;; If Helm can keep track of which commands are
;; used freq and also report which  do not have
;; keybindings. I can get rid of SMEX.
(use-package smex
  :bind
  ("M-x" . 'smex)
  ("M-X" . 'smex-major-mode-commands)
  ("C-c C-c M-x" . 'helm-M-x)
  )

(use-package undo-tree
  :diminish
  :config
  ;; Remember undo history
  (setq
   undo-tree-auto-save-history nil
   undo-tree-history-directory-alist `(("." . ,(concat temp-dir "/undo/"))))
  (global-undo-tree-mode 1))

(use-package which-key
  :diminish
  :config
  (which-key-mode))

(use-package windmove
  :bind
  ("C-x <up>" . windmove-up)
  ("C-x <down>" . windmove-down)
  ("C-x <left>" . windmove-left)
  ("C-x <right>" . windmove-right))

;; This may be usefull
;; Never used grep in Emacs a lot.

(use-package wgrep)

;; Underutilised package
;; Really need to start using this
;; more.
(use-package yasnippet
  ;;:defer 2 ;; Load 2s after start
  :config
  (yas-global-mode 1))


(use-package tex
  :ensure auctex :ensure cdlatex
  :config
  (setq TeX-auto-save t)
  (setq Tex-parse-self t)
  (setq-default TeX-master nil)
  (add-hook 'LaTeX-mode-hook 'visual-line-mode)
  (add-hook 'LaTeX-mode-hook 'flyspell-mode)
  (add-hook 'LaTeX-mode-hook 'LaTeX-math-mode)
  (add-hook 'LaTeX-mode-hook 'turn-on-reftex)
  (add-hook 'org-mode-hook 'turn-on-org-cdlatex)
  (setq reftex-plug-into-AUCTeX t))



(use-package openwith
  :config
  (openwith-mode t)
  (setq openwith-associations '(;;("\\.pdf\\'" "evince" (file))
                                ("\\.\\(?:jp?g\\|png\\|tif\\)\\'" "display" (file)))))

;; Much better package then using DocView to view PDFs
;; Also, this beats opening PDFs in external viewer!
(use-package pdf-tools
  :config
  (pdf-tools-install))

;; With interleave I can take notes while
;; reading an pdf.
(use-package interleave)

;; Keep around
;; For cmake projects
(use-package cmake-mode
  :mode "CMakeLists\\.txt\\'" "\\.cmake\\'")

;;
(use-package whitespace
  :diminish
  :config
  ;; Visualise the following whitespace:
  ;; empty lines at start/end of buffer
  ;; tabs
  ;; indentation
  ;; FIXME: Which ws are cleaned on save??
  (setq whitespace-style `(face empty tabs
                                indentation
                                lines-tail
                                trailing)
        whitespace-line-column 80)
  (global-whitespace-mode t))

(use-package markdown-mode
  :commands (markdown-mode gfm-mode)
  :mode (("\\.md\\'" . markdown-mode)
         ("README\\.md\\'" . gfm-mode))
  :init (setq markdown-command "pandoc"))

;; The abbrev file should be portable.
(use-package abbrev
  :ensure nil
  :diminish
  :init
  (setq abbrev-file-name "~/.emacs.d/abbrev_defs")
  :config
  (setq save-abbrevs t)
  (setq-default abbrev-mode t))

(use-package flyspell
 :diminish
 :config
  ;; Sets flyspell correction to use two-finger mouse click
  (define-key flyspell-mouse-map [down-mouse-3] #'flyspell-correct-word)
  :hook
  ((prog-mode . flyspell-prog-mode)
   (text-mode . flyspell-mode)))

;; (use-package lua-mode)

;; Emacs major mode for MOOS
;; This gives some strange errors
(use-package moos-mode
  :disabled t
  :load-path "elisp/moos-mode"
  :ensure nil
  :mode "\\.moos\\'")



;; Useful to remove crap from the mode line.
(use-package diminish)

;; I  do not use this much.
;; Maybe get rid of this?

;; (use-package golden-ratio
;;   :disabled t
;;   :ensure t
;;   :diminish golden-ratio-mode
;;   :init
;;   (golden-ratio-mode 1))

;; Cute buffer pos indicator
;; Keep :)
(use-package nyan-mode
  :init
  (nyan-mode 1))

(use-package google-this
  :diminish
  :config
  (google-this-mode)
  :bind
  ("C-c q" . 'google-this-mode-submap)) ;; I  do not understand what this func does

(use-package google-translate-smooth-ui
  :ensure google-translate
  :bind
  ("C-c t" . 'google-translate-smooth-translate))

;; (use-package clang-format)

(use-package benchmark-init
  :config
  ;; To disable collection of benchmark data after init is done.
  (add-hook 'after-init-hook 'benchmark-init/deactivate))

;; (use-package esup)

(provide 'base-extensions)
;;; base-extensions.el ends here
