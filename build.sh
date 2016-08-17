#!/bin/sh

cmd="$1"
gist=$(cat ./scala/GIST_ID)

html() {
    echo $(cd ./html && git add -A && git commit -m Render && git push github master)
}

go() {
    case "$1" in
        publish)
            go build

            echo -e "\nBUILD: Publish HTML"
            html || exit

            echo -e "\nBUILD: Publish Scala Gist"
            gist scala-fiddle/README.org scala-fiddle/*.scala \
                 -u "$gist" -d 'Get Typed (Scala)'
            ;;
        *)
            emacs --batch -Q -l .orgen/orgen.el -f orgen-noninteractive-publish
            ;;
    esac
}

if [[ "$IN_NIX_SHELL" ]]
then
    go "$cmd"
elif type -P nix-shell >/dev/null
then
    echo 'IN_NIX_SHELL'
    nix-shell --run "./build.sh $@"
else
    go "$cmd"
fi
