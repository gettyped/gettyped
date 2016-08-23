("Get Typed"
 :use-timestamps nil
 :babel-header-args ((:mkdirp . "yes")
                     (:exports . "code")
                     (:noweb . "yes"))
 :babel-inline-header-args ((:exports . "code") (:post-blank . 0))
 :require (htmlize
           bnfc
           scala-mode
           csharp-mode
           purescript-mode
           haskell-mode)
 :link-abbrevs
 (("src-purs" .
   "https://github.com/gettyped/gettyped/purescript/src/GetTyped/")
  ("src-flow" .
   "https://github.com/gettyped/gettyped/flow/src/GetTyped/")
  ("scala-js-fiddle" .
   "http://www.scala-js-fiddle.com/gist/1b8808f797de1909ac95371eaf1ed97b/"))
 :inline-code-template
 "src_%lang[:exports code %switches%flags]{%body}" 
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
   :html-head
   "<link rel='stylesheet' type='text/css' href='https://cdnjs.cloudflare.com/ajax/libs/normalize/4.2.0/normalize.css'>
    <link rel='stylesheet' type='text/css' href='/_static/main.css'>
    <link rel='stylesheet' type='text/css' href='/_static/htmlize.css'/>
    <script src='/_static/main.js'></script>"
   :with-smart-quotes nil
   :with-tags t
   :with-emphasize t
   :with-special-strings nil
   :with-fixed-width t
   :with-timestamps nil
   :preserve-breaks nil
   :section-numbers nil
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
