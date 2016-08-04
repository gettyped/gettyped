#!/bin/sh

emacs --batch -l org-project.el -f gettyped-publish || /bin/sh build.sh
