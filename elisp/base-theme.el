(use-package zenburn-theme
  :disabled t
  :defer t
  :init
  (load-theme 'zenburn t))

(use-package monokai-theme
  :disabled t
  :init
  (load-theme 'monokai t))

(use-package solarized-theme
  :defer t
  :disabled t
  :init
  (load-theme 'solarized-dark t))

(use-package leuven-theme
  :defer t)

(use-package doom-themes
  :config (setq doom-themes-enable-bold t
                doom-themes-enable-italic t)
  (load-theme 'doom-one t)
  (doom-themes-neotree-config)
  (doom-themes-org-config)
  ;;DOOM mode line
  (use-package doom-modeline
    :config
    ;; This can have weird behaviour when running
    ;; from terminal
    (setq doom-modeline-icon t
          doom-modeline-major-mode-icon nil
          doom-modeline-buffer-file-name-style 'relative-from-project
          doom-modeline-buffer-encoding nil)
    :hook ((after-init . doom-modeline-mode))
    )
  )

(use-package nyan-mode
  :after doom-modeline
  :config
  (setq nyan-cat-face-number 1
        nyan-animate-nyancat t
        nyan-wavy-trail t)
  :hook
  (doom-modeline-mode . nyan-mode))

;; Helm package for choosing themes
(use-package helm-themes)

(use-package all-the-icons)

(provide 'base-theme)
