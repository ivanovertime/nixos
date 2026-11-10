;;; init.el --- Ivan's Emacs config -*- lexical-binding: t; -*-

;;; Basics

(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (file-exists-p custom-file)
  (load custom-file :no-error))

(setq inhibit-startup-screen t
      ring-bell-function 'ignore
      use-short-answers t
      sentence-end-double-space nil)

(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(global-auto-revert-mode 1)
(recentf-mode 1)
(savehist-mode 1)

(load-theme 'modus-vivendi t)

;;; Completion

(require 'vertico)
(vertico-mode 1)

(require 'marginalia)
(marginalia-mode 1)

(require 'consult)
(global-set-key (kbd "C-x b") #'consult-buffer)
(global-set-key (kbd "C-x C-r") #'consult-recent-file)
(global-set-key (kbd "M-s r") #'consult-ripgrep)
(global-set-key (kbd "M-s f") #'consult-find)

;;; Org

(setq org-directory (expand-file-name "~/org")
      org-default-notes-file (expand-file-name "inbox.org" org-directory)
      org-agenda-files (list (expand-file-name "inbox.org" org-directory))
      org-startup-folded 'content
      org-log-done 'time
      org-todo-keywords
      '((sequence "TODO(t)" "NEXT(n)" "WAIT(w@/!)" "|" "DONE(d!)" "CANCELED(c@)")))

(setq org-capture-templates
      `(("t" "Todo" entry
         (file+headline ,(expand-file-name "inbox.org" org-directory) "Tasks")
         "* TODO %?\n%U\n")
        ("n" "Note" entry
         (file+headline ,(expand-file-name "inbox.org" org-directory) "Notes")
         "* %?\n%U\n")
        ("j" "Journal" entry
         (file+olp+datetree ,(expand-file-name "journal.org" org-directory))
         "* %?\n")))

(global-set-key (kbd "C-c c") #'org-capture)
(global-set-key (kbd "C-c a") #'org-agenda)
(global-set-key (kbd "C-c l") #'org-store-link)

;;; Denote

(require 'denote)
(require 'denote-journal)
(setq denote-directory (expand-file-name "notes/" org-directory))

(global-set-key (kbd "C-c n n") #'denote-open-or-create)
(global-set-key (kbd "C-c n j") #'denote-journal-new-or-existing-entry)
(global-set-key (kbd "C-c n l") #'denote-link)
(global-set-key (kbd "C-c n b") #'denote-backlinks)

;;; Git

(require 'magit)
(global-set-key (kbd "C-x g") #'magit-status)
