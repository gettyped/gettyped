(babel-default-header-args
 ((:mkdirp . "yes")
  (:noweb . "yes"))

 html-head "org-head.html"

 html-link-home "/"

 link-abbrev-alist
 (("src-purs" . "https://github.com/gettyped/gettyped/purescript/src/GetTyped/")
  ("src-flow" . "https://github.com/gettyped/gettyped/flow/src/GetTyped/"))

 index-file "doc/index.org"

 projects
 (("org"
   :base-extension "org"
   :base-directory "doc"
   :publishing-directory "html"
   :html-doctype "html5"
   :html-preamble nil
   :html-postamble nil
   :recursive t
   :publishing-function org-html-publish-to-html
   :preparation-function spacemacs/toggle-vim-empty-lines-mode-off
   :completion-function spacemacs/toggle-vim-empty-lines-mode-on)
  ("tangle"
   :base-extension "org"
   :base-directory "doc"
   :publishing-directory "."
   :recursive t
   :publishing-function jdh--org-babel-tangle-publish-inplace)
  ("static"
   :base-extension "css\|js\|png\|jpg"
   :base-directory "doc"
   :publishing-directory "html"
   :recursive t
   :publishing-function org-publish-attachment)))
