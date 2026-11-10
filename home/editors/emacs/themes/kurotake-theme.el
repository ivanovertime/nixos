;;; kurotake-theme.el --- Kurotake theme, matched to COSMIC -*- lexical-binding: t; -*-

;; Kurotake syntax colors ported from the VS Code theme, with the chrome
;; (background, surfaces, text, accent) derived from the current COSMIC dark
;; theme at load time.  Change the accent in COSMIC Settings and reload the
;; theme (`M-x load-theme RET kurotake RET') to pick it up.
;;
;; Sources:
;;   ~/.config/cosmic/com.system76.CosmicTheme.Dark.Builder/v2/accent
;;   ~/.config/cosmic/com.system76.CosmicTheme.Dark.Builder/v2/bg_color

(defconst kurotake--cosmic-dir
  (expand-file-name "~/.config/cosmic/")
  "Directory where COSMIC stores its theme configuration.")

(defun kurotake--rgb-to-hex (red green blue)
  "Convert RED, GREEN and BLUE floats (0..1) to a \"#rrggbb\" string."
  (format "#%02x%02x%02x"
          (round (* 255 red))
          (round (* 255 green))
          (round (* 255 blue))))

(defun kurotake--cosmic-color (file)
  "Return the (red: .., green: .., blue: ..) tuple in FILE as hex, or nil."
  (when (file-readable-p file)
    (with-temp-buffer
      (insert-file-contents file)
      (let ((text (replace-regexp-in-string "[[:space:]]+" " " (buffer-string))))
        (when (string-match
               "red: \\([0-9.]+\\)[^0-9]*green: \\([0-9.]+\\)[^0-9]*blue: \\([0-9.]+\\)"
               text)
          (kurotake--rgb-to-hex (string-to-number (match-string 1 text))
                                (string-to-number (match-string 2 text))
                                (string-to-number (match-string 3 text))))))))

(defun kurotake--cosmic (name fallback)
  "Return the COSMIC dark theme color NAME, or FALLBACK."
  (or (kurotake--cosmic-color
       (expand-file-name (concat "com.system76.CosmicTheme.Dark.Builder/v2/" name)
                         kurotake--cosmic-dir))
      fallback))

(defun kurotake--mix (color-a color-b alpha)
  "Blend COLOR-A over COLOR-B by ALPHA (0..1), returning \"#rrggbb\"."
  (let ((a (list (/ (string-to-number (substring color-a 1 3) 16) 255.0)
                 (/ (string-to-number (substring color-a 3 5) 16) 255.0)
                 (/ (string-to-number (substring color-a 5 7) 16) 255.0)))
        (b (list (/ (string-to-number (substring color-b 1 3) 16) 255.0)
                 (/ (string-to-number (substring color-b 3 5) 16) 255.0)
                 (/ (string-to-number (substring color-b 5 7) 16) 255.0))))
    (kurotake--rgb-to-hex (+ (* alpha (nth 0 a)) (* (- 1.0 alpha) (nth 0 b)))
                          (+ (* alpha (nth 1 a)) (* (- 1.0 alpha) (nth 1 b)))
                          (+ (* alpha (nth 2 a)) (* (- 1.0 alpha) (nth 2 b))))))

(deftheme kurotake "Kurotake syntax with COSMIC's dark chrome and accent.")

(let* ((class '((class color) (min-colors 89)))
       ;; COSMIC dark theme: background and accent are read from the live
       ;; configuration; surfaces and text follow its neutral palette.
       (accent (kurotake--cosmic "accent" "#7db46c"))
       (bg (kurotake--cosmic "bg_color" "#1b1b1b"))
       (surface "#262626")   ; COSMIC gray_2
       (surface-2 "#2e2e2e") ; COSMIC neutral_3
       (border "#3a3a3a")
       (fg "#dedede")        ; COSMIC neutral_9
       (muted "#636363")     ; COSMIC neutral_5
       (dim "#808080")       ; COSMIC neutral_6
       (selection (kurotake--mix accent bg 0.30))
       (accent-dim (kurotake--mix accent bg 0.65))
       (accent-soft (kurotake--mix accent bg 0.15))
       (green "#7db46c")
       (green-soft (kurotake--mix green bg 0.15))
       (orange "#d2691e")
       (orange-soft (kurotake--mix orange bg 0.15)))
  (custom-theme-set-faces
   'kurotake
   ;; Base
   `(default ((,class (:background ,bg :foreground ,fg))))
   `(cursor ((,class (:background ,accent))))
   `(region ((,class (:background ,selection))))
   `(secondary-selection ((,class (:background ,surface-2))))
   `(highlight ((,class (:background ,surface-2))))
   `(hl-line ((,class (:background ,surface))))
   `(shadow ((,class (:foreground ,dim))))
   `(fringe ((,class (:background ,bg :foreground ,border))))
   `(vertical-border ((,class (:foreground ,border))))
   `(window-divider ((,class (:foreground ,border))))
   `(window-divider-first-pixel ((,class (:foreground ,border))))
   `(window-divider-last-pixel ((,class (:foreground ,border))))
   `(scroll-bar ((,class (:background ,surface))))
   `(tooltip ((,class (:background ,surface :foreground ,fg))))
   `(button ((,class (:foreground ,accent :underline t))))
   `(link ((,class (:foreground ,accent :underline t))))
   `(link-visited ((,class (:foreground ,accent-dim :underline t))))
   `(error ((,class (:foreground ,orange))))
   `(warning ((,class (:foreground "#daa520"))))
   `(success ((,class (:foreground ,green))))

   ;; Chrome
   `(mode-line ((,class (:background ,surface :foreground ,accent :box nil))))
   `(mode-line-inactive ((,class (:background ,surface :foreground ,muted :box nil))))
   `(mode-line-buffer-id ((,class (:foreground ,accent :weight bold))))
   `(mode-line-emphasis ((,class (:foreground ,fg))))
   `(mode-line-highlight ((,class (:foreground ,accent))))
   `(header-line ((,class (:background ,surface :foreground ,fg :box nil))))
   `(minibuffer-prompt ((,class (:foreground ,accent :weight bold))))
   `(line-number ((,class (:background ,bg :foreground ,muted))))
   `(line-number-current-line ((,class (:background ,bg :foreground ,accent))))
   `(tab-bar ((,class (:background ,surface :foreground ,muted))))
   `(tab-bar-tab ((,class (:background ,bg :foreground ,fg))))
   `(tab-bar-tab-inactive ((,class (:background ,surface :foreground ,muted))))

   ;; Search and matching
   `(isearch ((,class (:background ,accent :foreground ,bg))))
   `(isearch-fail ((,class (:background ,orange :foreground ,bg))))
   `(lazy-highlight ((,class (:background ,surface-2 :foreground ,fg))))
   `(match ((,class (:background ,surface-2 :foreground ,accent))))
   `(show-paren-match ((,class (:foreground ,accent :weight bold))))
   `(show-paren-mismatch ((,class (:background ,orange :foreground ,bg))))
   `(trailing-whitespace ((,class (:background ,orange))))
   `(whitespace-space ((,class (:foreground ,border))))
   `(whitespace-tab ((,class (:foreground ,border))))
   `(whitespace-newline ((,class (:foreground ,border))))

   ;; Font lock
   `(font-lock-comment-face ((,class (:foreground "#4da941" :slant italic))))
   `(font-lock-comment-delimiter-face ((,class (:foreground "#4da941" :slant italic))))
   `(font-lock-string-face ((,class (:foreground "#90ee90"))))
   `(font-lock-doc-face ((,class (:foreground "#90ee90" :slant italic))))
   `(font-lock-keyword-face ((,class (:foreground "#8fbc8f"))))
   `(font-lock-builtin-face ((,class (:foreground "#deb887"))))
   `(font-lock-function-name-face ((,class (:foreground ,accent))))
   `(font-lock-variable-name-face ((,class (:foreground ,fg))))
   `(font-lock-type-face ((,class (:foreground "#8fbc8f"))))
   `(font-lock-constant-face ((,class (:foreground "#daa520"))))
   `(font-lock-number-face ((,class (:foreground "#daa520"))))
   `(font-lock-operator-face ((,class (:foreground "#cd853f"))))
   `(font-lock-preprocessor-face ((,class (:foreground "#cd853f"))))
   `(font-lock-negation-char-face ((,class (:foreground ,orange))))
   `(font-lock-warning-face ((,class (:foreground ,orange :weight bold))))
   `(font-lock-regexp-grouping-backslash ((,class (:foreground "#cd853f"))))
   `(font-lock-regexp-grouping-construct ((,class (:foreground "#deb887"))))

   ;; Completion
   `(completions-common-part ((,class (:foreground ,accent :weight bold))))
   `(completions-first-difference ((,class (:foreground "#deb887"))))
   `(vertico-current ((,class (:background ,surface-2 :foreground ,accent))))
   `(vertico-group-title ((,class (:foreground ,accent :weight bold))))
   `(vertico-group-separator ((,class (:foreground ,border))))
   `(marginalia-documentation ((,class (:foreground ,dim))))
   `(marginalia-file-name ((,class (:foreground ,fg))))
   `(marginalia-size ((,class (:foreground ,dim))))
   `(marginalia-date ((,class (:foreground ,dim))))
   `(marginalia-mode ((,class (:foreground "#deb887"))))
   `(marginalia-type ((,class (:foreground ,accent-dim))))

   ;; Org
   `(org-level-1 ((,class (:foreground ,accent :weight bold))))
   `(org-level-2 ((,class (:foreground "#8fbc8f" :weight bold))))
   `(org-level-3 ((,class (:foreground "#90ee90" :weight bold))))
   `(org-level-4 ((,class (:foreground "#deb887" :weight bold))))
   `(org-level-5 ((,class (:foreground "#cd853f" :weight bold))))
   `(org-level-6 ((,class (:foreground "#daa520" :weight bold))))
   `(org-level-7 ((,class (:foreground "#98fb98" :weight bold))))
   `(org-level-8 ((,class (:foreground ,dim :weight bold))))
   `(org-document-title ((,class (:foreground ,fg :weight bold :height 1.2))))
   `(org-document-info ((,class (:foreground ,dim))))
   `(org-todo ((,class (:foreground ,orange :weight bold))))
   `(org-done ((,class (:foreground ,accent :weight bold))))
   `(org-headline-done ((,class (:foreground ,dim))))
   `(org-block ((,class (:background ,surface :extend t))))
   `(org-block-begin-line ((,class (:background ,surface :foreground ,muted :slant italic :extend t))))
   `(org-block-end-line ((,class (:background ,surface :foreground ,muted :slant italic :extend t))))
   `(org-code ((,class (:background ,surface :foreground "#daa520"))))
   `(org-verbatim ((,class (:background ,surface :foreground "#90ee90"))))
   `(org-link ((,class (:foreground ,accent :underline t))))
   `(org-date ((,class (:foreground "#deb887" :underline t))))
   `(org-special-keyword ((,class (:foreground "#cd853f"))))
   `(org-property-value ((,class (:foreground ,fg))))
   `(org-tag ((,class (:foreground "#8fbc8f"))))
   `(org-priority ((,class (:foreground ,orange))))
   `(org-checkbox ((,class (:foreground ,accent))))
   `(org-table ((,class (:foreground ,fg))))
   `(org-formula ((,class (:foreground "#daa520"))))
   `(org-agenda-date ((,class (:foreground ,accent :weight bold))))
   `(org-agenda-date-today ((,class (:foreground "#98fb98" :weight bold :underline t))))
   `(org-agenda-date-weekend ((,class (:foreground ,dim))))
   `(org-agenda-structure ((,class (:foreground "#8fbc8f" :weight bold))))
   `(org-agenda-done ((,class (:foreground ,muted))))
   `(org-scheduled ((,class (:foreground ,accent))))
   `(org-scheduled-today ((,class (:foreground "#98fb98"))))
   `(org-deadline-warning ((,class (:foreground ,orange :weight bold))))
   `(org-upcoming-deadline ((,class (:foreground "#daa520"))))

   ;; Magit
   `(magit-section-heading ((,class (:foreground ,accent :weight bold))))
   `(magit-section-highlight ((,class (:background ,surface))))
   `(magit-branch-local ((,class (:foreground ,accent))))
   `(magit-branch-remote ((,class (:foreground ,accent-dim))))
   `(magit-tag ((,class (:foreground "#daa520"))))
   `(magit-hash ((,class (:foreground ,dim))))
   `(magit-log-author ((,class (:foreground "#deb887"))))
   `(magit-log-date ((,class (:foreground ,dim))))
   `(magit-diff-file-heading ((,class (:foreground ,fg :weight bold))))
   `(magit-diff-hunk-heading ((,class (:background ,surface-2 :foreground ,accent))))
   `(magit-diff-hunk-heading-highlight ((,class (:background ,border :foreground "#98fb98"))))
   `(magit-diff-added ((,class (:foreground ,green))))
   `(magit-diff-added-highlight ((,class (:background ,green-soft :foreground "#98fb98"))))
   `(magit-diff-removed ((,class (:foreground ,orange))))
   `(magit-diff-removed-highlight ((,class (:background ,orange-soft :foreground "#ff7f50"))))
   `(magit-diff-context ((,class (:foreground ,dim))))
   `(magit-diff-context-highlight ((,class (:background ,surface :foreground ,fg))))
   `(magit-process-ok ((,class (:foreground ,green))))
   `(magit-process-ng ((,class (:foreground ,orange))))
   `(magit-signature-good ((,class (:foreground ,green))))
   `(magit-signature-bad ((,class (:foreground ,orange))))
   `(magit-signature-untrusted ((,class (:foreground "#daa520"))))

   ;; Diff (used by magit and vc)
   `(diff-added ((,class (:foreground ,green))))
   `(diff-removed ((,class (:foreground ,orange))))
   `(diff-changed ((,class (:foreground "#daa520"))))
   `(diff-header ((,class (:foreground ,dim))))
   `(diff-file-header ((,class (:foreground ,fg :weight bold))))

   ;; Dired
   `(dired-directory ((,class (:foreground ,accent))))
   `(dired-marked ((,class (:foreground "#daa520"))))
   `(dired-symlink ((,class (:foreground "#90ee90" :slant italic))))
   `(dired-ignored ((,class (:foreground ,muted))))

   ;; Diagnostics
   `(flymake-error ((,class (:underline (:style wave :color ,orange)))))
   `(flymake-warning ((,class (:underline (:style wave :color "#daa520")))))
   `(flymake-note ((,class (:underline (:style wave :color "#8fbc8f")))))
   `(flyspell-incorrect ((,class (:underline (:style wave :color ,orange)))))
   `(flyspell-duplicate ((,class (:underline (:style wave :color "#daa520")))))

   ;; Commit messages
   `(git-commit-summary ((,class (:foreground "#98fb98"))))
   `(git-commit-overlong-summary ((,class (:foreground ,orange))))
   `(git-commit-nonempty-second-line ((,class (:foreground "#daa520"))))

   ;; Shell
   `(eshell-prompt ((,class (:foreground ,accent :weight bold))))))

(provide-theme 'kurotake)

;;; kurotake-theme.el ends here
