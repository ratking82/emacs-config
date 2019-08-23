;;; package --- C/C++ configs
;;; Commentary:
;;; Contains my C/C++ mode configs

;;; Code:
(use-package clang-format)

(use-package rtags
  :commands 'rtags-start-process-unless-running
  :config
  (progn
    (unless (rtags-executable-find "rc") (error "Binary rc is not installed!"))
    (unless (rtags-executable-find "rdm") (error "Binary rdm is not installed!"))
    (rtags-enable-standard-keybindings)

    (define-key c-mode-base-map (kbd "M-.") 'rtags-find-symbol-at-point)
    (define-key c-mode-base-map (kbd "M-,") 'rtags-find-references-at-point)
    (define-key c-mode-base-map (kbd "M-?") 'rtags-display-summary)
    (define-key c-mode-base-map (kbd "M-[") 'rtags-location-stack-back)
    (define-key c-mode-base-map (kbd "M-]") 'rtags-location-stack-forward)

    (setq rtags-use-helm t)
    (setq rtags-track-container t)

    ;; Shutdown rdm when leaving emacs.
    (add-hook 'kill-emacs-hook 'rtags-quit-rdm)
    (add-hook 'find-file-hook
              (lambda () (setq header-line-format
                                      (when (rtags-is-indexed)
                                        '(:eval
                                          rtags-cached-current-container)))))
    (add-hook 'c++-mode-hook 'rtags-start-process-unless-running)))

;; TODO: Has no coloring! How can I get coloring?
(use-package helm-rtags
  :config
    (setq rtags-display-result-backend 'helm))

;; Use rtags for auto-completion.
(use-package company-rtags
  :config
  (progn
    (setq rtags-autostart-diagnostics t)
    (rtags-diagnostics)
    (setq rtags-completions-enabled t)
    (push 'company-rtags company-backends)))

;; Live code checking.
(use-package flycheck-rtags
  :config
  (progn
    ;; ensure that we use only rtags checking
    ;; https://github.com/Andersbakken/rtags#optional-1
    (defun setup-flycheck-rtags ()
      (flycheck-select-checker 'rtags)
      (setq-local flycheck-highlighting-mode nil) ;; RTags creates more accurate overlays.
      (setq-local flycheck-check-syntax-automatically nil)
      (rtags-set-periodic-reparse-timeout 2.0)  ;; Run flycheck 2 seconds after being idle.
      )
    (add-hook 'c-mode-hook #'setup-flycheck-rtags)
    (add-hook 'c++-mode-hook #'setup-flycheck-rtags)
    )
  )

(use-package cmake-ide
  :disabled t
  :config
  (cmake-ide-setup))


(use-package srefactor
  :config
  (semantic-mode)
  :bind
  (:map c++-mode-map
   ("M-RET" . srefactor-refactor-at-point)))

(provide 'lang-c++)
;;; lang-c++.el ends here
