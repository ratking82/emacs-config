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
        helm-idle-delay 0.0
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

(use-package helm-ag)

(use-package helm-git-grep)

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


(use-package org
  :config
  (setq org-directory "~/org"
        org-default-notes-file (concat org-directory "/refile.org")
        org-agenda-files '("~/org")
        org-log-into-drawer t
        org-log-done-with-time t
        org-cycle-separator-lines 0
        org-startup-indented t
        org-use-fast-todo-selection t
        org-treat-S-cursor-todo-selection-as-state-change nil)

  (setq org-modules (quote
                     (org-bbdb org-bibtex org-docview org-gnus org-habit org-id
                               org-info org-irc org-mhe org-rmail org-w3m)))

  (setq org-capture-templates
        '(("t" "todo" entry
          (file "")
          "* TODO %? \n%U\n" :clock-in t :clock-resume t)
         ("n" "note" entry
          (file "")
          "* %? :NOTE:\n %U \n" :clock-in t :clock-resume t)
         ("j" "Daily WorkLogs" entry
          (file+datetree "dailylogs.org")
          "* %?\n%U\n" :clock-in t :clock-resume t :tree-type week)))

  (setq org-todo-keywords
        (quote ((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d!)")
                (sequence "WAITING(w@/!)" "HOLD(h@/!)" "|" "CANCELLED(c@/!)"))))

  (setq org-todo-keyword-faces
        (quote (("TODO" :foreground "red" :weight bold)
                ("NEXT" :foreground "blue" :weight bold)
                ("DONE" :foreground "forest green" :weight bold)
                ("WAITING" :foreground "orange" :weight bold)
                ("HOLD" :foreground "magenta" :weight bold)
                ("CANCELLED" :foreground "forest green" :weight bold)
                ("MEETING" :foreground "forest green" :weight bold)
                ("PHONE" :foreground "forest green" :weight bold))))

  (setq org-todo-state-tags-triggers
        (quote (("CANCELLED" ("CANCELLED" . t))
                ("WAITING" ("WAITING" . t))
                ("HOLD" ("WAITING") ("HOLD" . t))
                (done ("WAITING") ("HOLD"))
                ("TODO" ("WAITING") ("CANCELLED") ("HOLD"))
                ("NEXT" ("WAITING") ("CANCELLED") ("HOLD"))
                ("DONE" ("WAITING") ("CANCELLED") ("HOLD")))))

  ;; (add-hook 'org-clock-out-hook 'bh/remove-empty-drawer-on-clock-out 'append)

  ;; Targets include this file and any file contributing to the agenda - up to 9 levels deep
  (setq org-refile-targets (quote ((nil :maxlevel . 9)
                                   (org-agenda-files :maxlevel . 9))))

  ;; Use full outline paths for refile targets - we file directly with IDO
  (setq org-refile-use-outline-path t)

  ;; Targets complete directly with IDO
  (setq org-outline-path-complete-in-steps nil)

  ;; Allow refile to create parent tasks with confirmation
  (setq org-refile-allow-creating-parent-nodes (quote confirm))

  (setq org-refile-target-verify-function 'bh/verify-refile-target)

  ;; Do not dim blocked tasks
  (setq org-agenda-dim-blocked-tasks nil)

  ;; Compact the block agenda view
  (setq org-agenda-compact-blocks t)

  ;; Custom agenda command definitions
  (setq org-agenda-custom-commands
        (quote (("N" "Notes" tags "NOTE"
                 ((org-agenda-overriding-header "Notes")
                  (org-tags-match-list-sublevels t)))
                ("h" "Habits" tags-todo "STYLE=\"habit\""
                 ((org-agenda-overriding-header "Habits")
                  (org-agenda-sorting-strategy
                   '(todo-state-down effort-up category-keep))))
                (" " "Agenda"
                 ((agenda "" nil)
                  (tags "REFILE"
                        ((org-agenda-overriding-header "Tasks to Refile")
                         (org-tags-match-list-sublevels nil)))
                  (tags-todo "-CANCELLED/!"
                             ((org-agenda-overriding-header "Stuck Projects")
                              (org-agenda-skip-function 'bh/skip-non-stuck-projects)
                              (org-agenda-sorting-strategy
                               '(category-keep))))
                  (tags-todo "-HOLD-CANCELLED/!"
                             ((org-agenda-overriding-header "Projects")
                              (org-agenda-skip-function 'bh/skip-non-projects)
                              (org-tags-match-list-sublevels 'indented)
                              (org-agenda-sorting-strategy
                               '(category-keep))))
                  (tags-todo "-CANCELLED/!NEXT"
                             ((org-agenda-overriding-header (concat "Project Next Tasks"
                                                                    (if bh/hide-scheduled-and-waiting-next-tasks
                                                                        ""
                                                                      " (including WAITING and SCHEDULED tasks)")))
                              (org-agenda-skip-function 'bh/skip-projects-and-habits-and-single-tasks)
                              (org-tags-match-list-sublevels t)
                              (org-agenda-todo-ignore-scheduled bh/hide-scheduled-and-waiting-next-tasks)
                              (org-agenda-todo-ignore-deadlines bh/hide-scheduled-and-waiting-next-tasks)
                              (org-agenda-todo-ignore-with-date bh/hide-scheduled-and-waiting-next-tasks)
                              (org-agenda-sorting-strategy
                               '(todo-state-down effort-up category-keep))))
                  (tags-todo "-REFILE-CANCELLED-WAITING-HOLD/!"
                             ((org-agenda-overriding-header (concat "Project Subtasks"
                                                                    (if bh/hide-scheduled-and-waiting-next-tasks
                                                                        ""
                                                                      " (including WAITING and SCHEDULED tasks)")))
                              (org-agenda-skip-function 'bh/skip-non-project-tasks)
                              (org-agenda-todo-ignore-scheduled bh/hide-scheduled-and-waiting-next-tasks)
                              (org-agenda-todo-ignore-deadlines bh/hide-scheduled-and-waiting-next-tasks)
                              (org-agenda-todo-ignore-with-date bh/hide-scheduled-and-waiting-next-tasks)
                              (org-agenda-sorting-strategy
                               '(category-keep))))
                  (tags-todo "-REFILE-CANCELLED-WAITING-HOLD/!"
                             ((org-agenda-overriding-header (concat "Standalone Tasks"
                                                                    (if bh/hide-scheduled-and-waiting-next-tasks
                                                                        ""
                                                                      " (including WAITING and SCHEDULED tasks)")))
                              (org-agenda-skip-function 'bh/skip-project-tasks)
                              (org-agenda-todo-ignore-scheduled bh/hide-scheduled-and-waiting-next-tasks)
                              (org-agenda-todo-ignore-deadlines bh/hide-scheduled-and-waiting-next-tasks)
                              (org-agenda-todo-ignore-with-date bh/hide-scheduled-and-waiting-next-tasks)
                              (org-agenda-sorting-strategy
                               '(category-keep))))
                  (tags-todo "-CANCELLED+WAITING|HOLD/!"
                             ((org-agenda-overriding-header "Waiting and Postponed Tasks")
                              (org-agenda-skip-function 'bh/skip-stuck-projects)
                              (org-tags-match-list-sublevels nil)
                              (org-agenda-todo-ignore-scheduled t)
                              (org-agenda-todo-ignore-deadlines t)))
                  (tags "-REFILE/"
                        ((org-agenda-overriding-header "Tasks to Archive")
                         (org-agenda-skip-function 'bh/skip-non-archivable-tasks)
                         (org-tags-match-list-sublevels nil))))
                 nil))))



  (setq org-agenda-auto-exclude-function 'bh/org-auto-exclude-function)

  ;;
  ;; Resume clocking task when emacs is restarted
  (org-clock-persistence-insinuate)
  ;;
  ;; Show lot of clocking history so it's easy to pick items off the C-F11 list
  (setq org-clock-history-length 23)
  ;; Resume clocking task on clock-in if the clock is open
  (setq org-clock-in-resume t)
  ;; Change tasks to NEXT when clocking in
  (setq org-clock-in-switch-to-state 'bh/clock-in-to-next)
  ;; Separate drawers for clocking and logs
  (setq org-drawers (quote ("PROPERTIES" "LOGBOOK")))
  ;; Save clock data and state changes and notes in the LOGBOOK drawer
  (setq org-clock-into-drawer t)
  ;; Sometimes I change tasks I'm clocking quickly - this removes clocked tasks with 0:00 duration
  (setq org-clock-out-remove-zero-time-clocks t)
  ;; Clock out when moving task to a done state
  (setq org-clock-out-when-done t)
  ;; Save the running clock and all clock history when exiting Emacs, load it on startup
  (setq org-clock-persist t)
  ;; Do not prompt to resume an active clock
  (setq org-clock-persist-query-resume nil)
  ;; Enable auto clock resolution for finding open clocks
  (setq org-clock-auto-clock-resolution (quote when-no-clock-is-running))
  ;; Include current clocking task in clock reports
  (setq org-clock-report-include-clocking-task t)

  (setq bh/keep-clock-running nil)

  ;; (require 'org-id)

  (setq org-time-stamp-rounding-minutes (quote (1 1)))

  (setq org-agenda-clock-consistency-checks
        (quote (:max-duration "4:00"
                              :min-duration 0
                              :max-gap 0
                              :gap-ok-around ("4:00"))))

  ;; Sometimes I change tasks I'm clocking quickly - this removes clocked tasks with 0:00 duration
  (setq org-clock-out-remove-zero-time-clocks t)

  ;; Agenda clock report parameters
  (setq org-agenda-clockreport-parameter-plist
        (quote (:link t :maxlevel 5 :fileskip0 t :compact t :narrow 80)))

                                        ; Set default column view headings: Task Effort Clock_Summary
  (setq org-columns-default-format "%80ITEM(Task) %10Effort(Effort){:} %10CLOCKSUM")

                                        ; global Effort estimate values
                                        ; global STYLE property values for completion
  (setq org-global-properties (quote (("Effort_ALL" . "0:15 0:30 0:45 1:00 2:00 3:00 4:00 5:00 6:00 0:00")
                                      ("STYLE_ALL" . "habit"))))

  ;; Agenda log mode items to display (closed and state changes by default)
  (setq org-agenda-log-mode-items (quote (closed state)))

                                        ; Tags with fast selection keys
  (setq org-tag-alist (quote ((:startgroup)
                              ("@errand" . ?e)
                              ("@office" . ?o)
                              ("@home" . ?H)
                              ("@farm" . ?f)
                              (:endgroup)
                              ("WAITING" . ?w)
                              ("HOLD" . ?h)
                              ("PERSONAL" . ?P)
                              ("WORK" . ?W)
                              ("FARM" . ?F)
                              ("ORG" . ?O)
                              ("NORANG" . ?N)
                              ("crypt" . ?E)
                              ("NOTE" . ?n)
                              ("CANCELLED" . ?c)
                              ("FLAGGED" . ??))))

  ;; Allow setting single tags without the menu
  (setq org-fast-tag-selection-single-key (quote expert))

  ;; For tag searches ignore tasks with scheduled and deadline dates
  (setq org-agenda-tags-todo-honor-ignore-options t)

  (setq org-agenda-span 'day)

  (setq org-stuck-projects (quote ("" nil nil "")))

  (setq org-archive-mark-done nil)
  (setq org-archive-location "%s_archive::* Archived Tasks")

  (setq org-alphabetical-lists t)

  :bind
  ("C-c l" . org-store-link)
  ("C-c a" . org-agenda)
  ("<f12>" . org-agenda)
  ("C-c c" . org-capture))

(defvar sr:properties-string "
:PROPERTIES:
:CREATED: %U
:END:")

(use-package org-projectile
  :after org
  :config
  (org-projectile-per-project)
  (setq org-projectile-per-project-filepath "TODO.org"
        org-projectile-capture-template (format "%s%s%s" "* TODO %?" sr:properties-string "\n%A\n")
        )
  (setq org-agenda-files (append org-agenda-files (org-projectile-todo-files)))
  (add-to-list 'org-capture-templates
               (org-projectile-project-todo-entry
                :capture-character "l"
                :capture-heading "Linked Project TODO"))
  (add-to-list 'org-capture-templates
               (org-projectile-project-todo-completing-read
                :capture-character "p"))
  )

(use-package org-bullets
  :config
  (setq org-hide-leading-stars t)
  (add-hook 'org-mode-hook
            (lambda ()
              (org-bullets-mode t))))

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

(use-package recentf
  :config
  (setq recentf-save-file (recentf-expand-file-name "~/.emacs.d/private/cache/recentf"))
  (recentf-mode 1))


;; Configure smartparens for c++ mode.
;; Mainly, replace c-defun functions with good alt from smartparens

(use-package smartparens-config
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

(use-package wgrep)

(use-package yasnippet
  :config
  (yas-global-mode 1))

(use-package tex
  :defer t
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

(use-package org-brain
  :defer 2
  :init
  (setq org-brain-path "~/org")
  ;; For Evil users
  (with-eval-after-load 'evil
    (evil-set-initial-state 'org-brain-visualize-mode 'emacs))
  :config
  (setq org-id-track-globally t)
  (setq org-id-locations-file "~/.emacs.d/.org-id-locations")
  (push '("b" "Brain" plain (function org-brain-goto-end)
          "* %i%?" :empty-lines 1)
        org-capture-templates)
  (setq org-brain-visualize-default-choices 'all)
  (setq org-brain-title-max-length 12)
  :bind ("C-c b" . org-brain-visualize))

(use-package org-ref
  :defer t
  :init
  (setq reftex-default-bibliography '("~/bibliography/references.bib"))

  ;; see org-ref for use of these variables
  (setq org-ref-bibliography-notes "~/bibliography/notes.org"
        org-ref-default-bibliography '("~/bibliography/references.bib")
        org-ref-pdf-directory "~/bibliography/bibtex-pdfs/")

  ;; For using helm-bibtex
  (setq bibtex-completion-bibliography "~/bibliography/references.bib"
        bibtex-completion-library-path "~/bibliography/bibtex-pdfs"
        bibtex-completion-notes-path "~/bibliography/helm-bibtex-notes"))

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

(use-package interleave)

(use-package cmake-mode
  :mode "CMakeLists\\.txt\\'" "\\.cmake\\'")

(use-package whitespace
  :diminish
  :config
  (setq whitespace-style `(face empty tabs lines-tail trailing)
        whitespace-line-column 80)
  (global-whitespace-mode))

(use-package markdown-mode
  :commands (markdown-mode gfm-mode)
  :mode (("\\.md\\'" . markdown-mode)
         ("README\\.md\\'" . gfm-mode))
  :init (setq markdown-command "pandoc"))

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

(use-package lua-mode
  :defer t)

;; Emacs major mode for MOOS
;; This gives some strange errors
(use-package moos-mode
  :disabled t
  :load-path "elisp/moos-mode"
  :ensure nil
  :mode "\\.moos\\'")

(use-package org-download)

(use-package diminish)

(use-package golden-ratio
  :disabled t
  :ensure t
  :diminish golden-ratio-mode
  :init
  (golden-ratio-mode 1))


(use-package google-this
  :defer t
  :config
  (google-this-mode 1))

(use-package google-translate-smooth-ui
  :defer t
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
