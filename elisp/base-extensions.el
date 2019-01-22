;;; Package --- Summary
;; Code:
;;; Commentary:


;;  Need to find out
;; how to use this effectively
(use-package ace-jump-mode
  :bind
  ("C-c SPC" . ace-jump-mode))


;; Configure company to use rtags when its
;; available. If not use clang.

(use-package company
  :init
  (global-company-mode)
  :config
  (setq company-minimum-prefix-length 2
        company-idle-delay 0.1
        company-require-match nil
        company-tooltip-align-annotations t
        company-dabbrev-downcase 0
        company-show-numbers t
        company-transformers '(company-sort-by-occurrence))
  )

(use-package dashboard
  :init
  (add-hook 'after-init-hook 'dashboard-refresh-buffer)
  (add-hook 'dashboard-mode-hook 'my/dashboard-banner)
  :config
  (setq dashboard-items '((recents . 10)
                          (bookmarks . 5)
                          (projects . 10)
                          (agenda . 5)))
  (setq initial-buffer-choice (lambda () (get-buffer "*dashboard*")))
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
  :diminish
  :hook (prog-mode . global-flycheck-mode))

(use-package helm
  :diminish
  :init
  (require 'helm-config)
  :config
  (setq helm-split-window-inside-p t
        helm-split-window-default-side 'below
        ;; helm-idle-delay 0.0
        helm-input-idle-delay 0.01
        helm-quick-update t
        helm-ff-skip-boring-files t)
  (helm-mode)
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

;; This is a very useful package
;; for searching in current buffer
(use-package helm-swoop
  :config
  (setq helm-swoop-split-direction 'split-window-horizontally)
  :bind
  ("C-x c s" . helm-swoop))

;; This is a very cool package
;; to use with org files.
(use-package helm-org-rifle)

(use-package hlinum
  :config
  (hlinum-activate))

;; I  do not need this anymore
(use-package linum
  :disabled
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
  (setq neo-smart-open t
        neo-window-fixed-size t
        ;;projectile-switch-project-action 'neotree-projectile-action
        neo-autorefresh t
        neo-toggle-window-keep-p t)
  ;; Disable linum for neotree
  ;;(add-hook 'neo-after-create-hook 'disable-neotree-hook)
  )

(use-package page-break-lines)

(use-package projectile
  :init
  (setq projectile-known-projects-file
        (expand-file-name "projectile-bookmarks.eld" temp-dir))
  (setq projectile-switch-project-action 'projectile-dired)
  :config
  ;;(setq projectile-mode-line-function (lambda () (format " Proj[%s]" (projectile-project-name))))
  (projectile-mode)
  :bind
  ("C-c p" . 'projectile-command-map)
  ("<f5>" . 'projectile-compile-project))

;; I  do not require this package
;; Dashboard has this feature.
(use-package recentf
  :config
  (setq recentf-save-file (recentf-expand-file-name "~/.emacs.d/private/cache/recentf"))
  (recentf-mode 1))


;; Configure smartparens for c++ mode.
;; Mainly, replace c-defun functions with good alt from smartparens

(use-package smartparens-config
  :diminish
  :ensure smartparens
  :diminish smartparens-mode
  :config
  :bind
  ;; Disabled bindings as it led to mistakes while
  ;; working in C++-mode. The bound functions do not behave as well
  ;; as they do in, for example lisp mode.

  ;; (:map smartparens-mode-map
  ;;       ("C-)" . sp-forward-slurp-sexp)
  ;;       ("C-}" . sp-forward-barf-sexp)
  ;;       ("C-(" . sp-backward-slurp-sexp)
  ;;       ("C-{" . sp-backward-barf-sexp))
  :hook
  (((prog-mode markdown-mode) . 'smartparens-mode)
   ((prog-mode markdown-mode) . 'show-smartparens-mode))
  )

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
  (global-undo-tree-mode))

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
  (global-whitespace-mode))

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
  (setq save-abbrevs 'silently)
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

(use-package origami
  :config
  (add-hook 'prog-mode-hook 'origami-mode))

(use-package helpful
  :bind
  ("C-h f" . 'helpful-callable)
  ("C-h v" . 'helpful-variable)
  ("C-h k" . 'helpful-key))

(use-package discover-my-major)

;; Better speedbar
(use-package sr-speedbar
  :config
  (setq sr-speedbar-right-side nil
        sr-speedbar-delete-windows nil
        sr-speedbar-skip-other-window-p t
        sr-speedbar-width 30
        sr-speedbar-max-width 40)
  :bind
  ("s-s" . 'sr-speedbar-toggle))

;; Package updater
;; Configure this to update packages at regular
;; interval; 1 month??
(use-package auto-package-update)

(use-package minions
  :config (minions-mode 1))

(use-package magit-todos
  :config
  :hook
  (magit-status-mode . magit-todos-mode)
  )

(use-package rainbow-delimiters
  :hook
  (prog-mode . rainbow-delimiters-mode))

(use-package paredit
  :hook ((emacs-lisp-mode
         eval-expression-minibuffer-setup
         lisp-mode
         lisp-interaction-mode) . 'enable-paredit-mode))

;; Evil mode!
;; Is this worth the effort? Let's find out!
(use-package evil)

;; LSP suport for emacs
(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :config (setq lsp-auto-configure t
                lsp-auto-guess-root t
                lsp-log-io t
                ;; Do not use flymake
                lsp-prefer-flymake nil
                lsp-enable-xref t
                ;; This can be annoying.
                lsp-enable-on-type-formatting t
                lsp-imenu-show-container-name t)
  (setq lsp-clients-clangd-args '("-j=2" "-background-index" "-log=error"))
  :hook (c++-mode . lsp-deferred))

;; Didnot like the C++ experience
;; Hence sideline mode is disabled.
(use-package lsp-ui
  :config
  (setq lsp-ui-sideline-enable nil)
  :bind
  (:map lsp-ui-mode-map
        ([remap xref-find-definitions] . 'lsp-ui-peek-find-definitions)
        ([remap xref-find-references] . 'lsp-ui-peek-find-references)))

(use-package company-lsp)
(use-package helm-lsp)

;; Treemacs
(use-package treemacs
  :ensure t
  :defer t
  :init
  (with-eval-after-load 'winum
    (define-key winum-keymap (kbd "M-0") #'treemacs-select-window))
  :config
  (progn
    (setq treemacs-collapse-dirs                 (if treemacs-python-executable 3 0)
          treemacs-deferred-git-apply-delay      0.5
          treemacs-display-in-side-window        t
          treemacs-eldoc-display                 t
          treemacs-file-event-delay              5000
          treemacs-file-follow-delay             0.2
          treemacs-follow-after-init             t
          treemacs-git-command-pipe              ""
          treemacs-goto-tag-strategy             'refetch-index
          treemacs-indentation                   2
          treemacs-indentation-string            " "
          treemacs-is-never-other-window         nil
          treemacs-max-git-entries               5000
          treemacs-missing-project-action        'ask
          treemacs-no-png-images                 nil
          treemacs-no-delete-other-windows       t
          treemacs-project-follow-cleanup        nil
          treemacs-persist-file                  (expand-file-name ".cache/treemacs-persist" user-emacs-directory)
          treemacs-position                      'left
          treemacs-recenter-distance             0.1
          treemacs-recenter-after-file-follow    nil
          treemacs-recenter-after-tag-follow     nil
          treemacs-recenter-after-project-jump   'always
          treemacs-recenter-after-project-expand 'on-distance
          treemacs-show-cursor                   nil
          treemacs-show-hidden-files             t
          treemacs-silent-filewatch              nil
          treemacs-silent-refresh                nil
          treemacs-sorting                       'alphabetic-desc
          treemacs-space-between-root-nodes      t
          treemacs-tag-follow-cleanup            t
          treemacs-tag-follow-delay              1.5
          treemacs-width                         35)

    ;; The default width and height of the icons is 22 pixels. If you are
    ;; using a Hi-DPI display, uncomment this to double the icon size.
    ;;(treemacs-resize-icons 44)

    (treemacs-follow-mode t)
    (treemacs-filewatch-mode t)
    (treemacs-fringe-indicator-mode t)
    (pcase (cons (not (null (executable-find "git")))
                 (not (null treemacs-python-executable)))
      (`(t . t)
       (treemacs-git-mode 'deferred))
      (`(t . _)
       (treemacs-git-mode 'simple))))
  :bind
  (:map global-map
        ("M-0"       . treemacs-select-window)
        ("C-x t 1"   . treemacs-delete-other-windows)
        ("C-x t t"   . treemacs)
        ("C-x t B"   . treemacs-bookmark)
        ("C-x t C-t" . treemacs-find-file)
        ("C-x t M-t" . treemacs-find-tag)))


;; Only if I use evil
(use-package treemacs-evil
  :disabled t
  :after treemacs evil
  :ensure t)

(use-package treemacs-projectile
  :after treemacs projectile
  :ensure t)

(use-package treemacs-icons-dired
  :after treemacs dired
  :ensure t
  :config (treemacs-icons-dired-mode))

(use-package treemacs-magit
  :after treemacs magit
  :ensure t)

(use-package lsp-treemacs
  :after treemacs )

(provide 'base-extensions)
;;; base-extensions.el ends here
