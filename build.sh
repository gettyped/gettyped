#!/bin/sh

gist=$(cat ./scala/GIST_ID)

_make() {
    echo -e "\nBUILD: Generate HTML"
    emacs --batch -Q -l .orgen/orgen.el -f orgen-noninteractive-publish
}

_push_html() {
    echo -e "\nBUILD: Publish HTML"
    (cd ./html && git add -A && git commit -m Render && git push github master)
}

_push_gist() {
    echo -e "\nBUILD: Publish Scala Gist"
    gist scala-fiddle/README.org scala-fiddle/*.scala \
         -u "$gist" \
         -d 'Get Typed (Scala)'
}

_push() {
    _push_html && _push_gist
}

_test() {
    echo -e "\nBUILD: Test Code"
    (cd ./scala && ./build.sh test)
}

_serve() {
    (cd ./html && exec caddy -port 8000)
}

go() {
    case "$1" in
        make)
            _make || exit 1
            ;;
        push)
            _push || exit 1
            ;;
        test)
            _test || exit 1
            ;;
        push-html)
            _push_html || exit 1
            ;;
        push-gist)
            _push_gist || exit 1
            ;;
        all)
            _make || exit 1
            _test || exit 1
            _push || exit 1
            ;;
        serve)
            _serve
            ;;
    esac
}

if [[ "$IN_NIX_SHELL" ]] || ! type -P nix-shell >/dev/null
then
    cmds="$@"
    [[ -z "$cmds" ]] && cmds='make-html'
    echo "CMDS: '$*'"
    for cmd in $cmds
    do
        go "$cmd"
    done
else
    echo 'IN_NIX_SHELL'
    nix-shell --run "./build.sh $*"
fi
