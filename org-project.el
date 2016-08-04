(defvar gettyped--nil nil)

(setq gettyped--root
      (file-name-directory (or (symbol-file 'gettyped--nil)
                               load-file-name
                               (buffer-file-name))))

(when noninteractive
  (require 'package)
  (add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/"))
  (add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
  (setq package-user-dir (concat gettyped--root ".elisp"))
  (package-initialize))

(require 'org)

(when (and noninteractive
           (or (version< org-version "8.3")
               (not (require 'htmlize nil 'noerror))
               (not (require 'purescript-mode nil 'noerror))))
  (message "org-version is %s. updating..." org-version)
    (message "Installing up-to-date org")
    (package-refresh-contents)
    (package-install 'org-plus-contrib)
    (package-install 'htmlize)
    (package-install 'purescript-mode)
    (message "org updated. please re-run")
    (kill-emacs 1))

(require 'ox)
(require 'ox-publish)
(require 'ox-html)

(defun trace-baby (f &rest args)
  (message "ENTER: %s" args)
  (let ((x (apply f args)))
    (message "EXIT: %s" x)
    x))

;; (advice-add 'org-export-expand-include-keyword :around #'trace-baby)

(defun gettyped--translate-org-link-html (link contents info)
  (let ((props (plist-get link 'link)))
    (if (string= "proj" (plist-get props :type))
        (progn (plist-put props :type "file")
               (plist-put props :path (concat "/" (plist-get props :path)))
               (replace-regexp-in-string
                "file:///\\|file://[a-zA-Z]:/" "/"
                (org-export-with-backend 'html link contents info)))
      (org-export-with-backend 'html link contents info))))

(defun gettyped-publish ()
  (interactive)
  (let* ((current default-directory)
         (plist (with-temp-buffer
                  (insert-file-contents-literally
                   (concat gettyped--root "org-project.el"))
                  (goto-char (point-min))
                  (read (current-buffer))))
         (index-file (concat gettyped--root "docs/index.org"))
         (org-babel-default-header-args '((:mkdirp . "yes")
                                          (:noweb . "yes")))
         (org-link-abbrev-alist
          '(("src-purs" . "https://github.com/gettyped/gettyped/purescript/src/GetTyped/")
            ("src-flow" . "https://github.com/gettyped/gettyped/flow/src/GetTyped/")))
         (org-html-head (with-temp-buffer
                          (insert-file-contents-literally
                           (concat gettyped--root "org-head.html"))
                          (buffer-string)))
         (org-html-htmlize-output-type 'css)
         (org-publish-use-timestamps-flag nil)
         (org-html-link-home "/")
         (org-export-with-smart-quotes nil)
         (org-export-with-emphasize t)
         (org-export-with-special-strings nil)
         (org-export-with-fixed-width t)
         (org-export-with-timestamps nil)
         (org-export-preserve-breaks nil)
         (org-export-with-section-numbers nil)
         (org-export-with-sub-superscripts t)
         (org-export-with-tables t)
         (org-export-with-toc t)
         (org-html-html5-fancy t)
         (projects (gettyped--projects)))
    (message "publishing: %s" projects)
    (mapc
     (lambda (proj)
       (let ((props (cdr proj)))
         (plist-put props :base-directory
                    (concat gettyped--root(plist-get props :base-directory)))
         (plist-put props :publishing-directory
                    (concat gettyped--root(plist-get props :publishing-directory)))))
     projects)
    (unwind-protect
        (with-current-buffer (find-file-noselect index-file)
          (org-publish-projects projects))
      (cd current))))

(defun gettyped--org-babel-tangle-publish-inplace (_ filename _)
  (org-babel-tangle-file filename))

(defun gettyped--org-babel-tangle-publish (_ filename pub-dir)
  "Tangle FILENAME and place the results in PUB-DIR."
  (unless (file-exists-p pub-dir)
    (make-directory pub-dir t))
  (mapc (lambda (el) (rename-file el pub-dir t))
        (org-babel-tangle-file filename)))

(defun gettyped--org-html-publish-to-html (plist filename pub-dir)
  (org-publish-org-to 'gettyped-html filename ".html" plist pub-dir))

(defun gettyped--vim-empty-lines-off ()
  (when (fboundp 'vim-empty-lines-mode)
    (global-vim-empty-lines-mode -1)))

(defun gettyped--vim-empty-lines-on ()
  (when (fboundp 'vim-empty-lines-mode)
    (global-vim-empty-lines-mode 1)))

(defun gettyped--projects ()
  (list
   (list "org"
         :base-extension "org"
         :base-directory "doc"
         :publishing-directory "html"
         :html-doctype "html5"
         :html-preamble nil
         :html-postamble nil
         :recursive t
         :publishing-function 'gettyped--org-html-publish-to-html
         :preparation-function 'gettyped--vim-empty-lines-off
         :completion-function 'gettyped--vim-empty-lines-on)
   (list "tangle"
         :base-extension "org"
         :base-directory "doc"
         :publishing-directory "."
         :recursive t
         :publishing-function 'gettyped--org-babel-tangle-publish-inplace)
   (list "static"
         :base-extension "css\|js\|png\|jpg"
         :base-directory "doc"
         :publishing-directory "html"
         :recursive t
         :publishing-function 'org-publish-attachment)))

(org-add-link-type "proj"
                   (lambda (path)
                     (find-file (concat gettyped--root "doc" path))))

(org-export-define-derived-backend
 'gettyped-html 'html
 :translate-alist '((link . gettyped--translate-org-link-html)))

(provide 'gettyped-org-project)
