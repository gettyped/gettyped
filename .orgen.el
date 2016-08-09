("Get Typed"
 :use-timestamps t
 :babel-header-args ((:mkdirp . "yes")
                     (:exports . "both")
                     (:noweb . "yes"))
 :require (htmlize
           scala-mode
           csharp-mode
           purescript-mode
           haskell-mode)
 :link-abbrevs
 (("src-purs" .
   "https://github.com/gettyped/gettyped/purescript/src/GetTyped/")
  ("src-flow" .
   "https://github.com/gettyped/gettyped/flow/src/GetTyped/"))
 :org-projects
 (("org"
   :base-extension "org"
   :base-directory "doc"
   :exclude "^_"
   :publishing-directory "html"
   :html-doctype "html5"
   :html-preamble nil
   :html-postamble nil
   :recursive t
   :publishing-function orgen-org-html-publish-to-html
   :html-link-home "/"
   :html-head-include-default-style nil
   :html-head-include-scripts nil
   :with-smart-quotes nil
   :with-tags t
   :with-emphasize t
   :with-special-strings nil
   :with-fixed-width t
   :with-timestamps nil
   :preserve-breaks nil
   :with-section-numbers nil
   :with-sub-superscripts t
   :with-tables t
   :with-toc t
   :html-html5-fancy t)
  ("tangle"
   :base-extension "org"
   :base-directory "doc"
   :publishing-directory "."
   :recursive t
   :publishing-function orgen-org-babel-tangle-publish-inplace)
  ("static"
   :base-extension "css\|js\|png\|jpg"
   :base-directory "doc"
   :publishing-directory "html"
   :recursive t
   :publishing-function org-publish-attachment)))
