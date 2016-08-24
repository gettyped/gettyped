#!/usr/bin/env bash

if [[ ! "$IN_NIX_SHELL" ]] && type -P nix-shell >/dev/null
then
    exec nix-shell --run "$0 $*"
fi

cmds="$@"
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

_publish() {
    echo -e "\nPublishing to Firebase"
    if [[ -z "$FIREBASE_TOKEN" ]]
    then
        firebase deploy --token "$FIREBASE_TOKEN"
    else
        firebase deploy
    fi
}

_push() {
    _push_html && _push_gist
}

_test() {
    echo -e "\nBUILD: Test Code"
    (cd ./scala && ./build.sh test)
}

_serve() {
    echo -e "\nSERVE: With Caddy"
    (cd ./html && exec caddy -port 8000)
}

_help() {
    echo 'COMMANDS:'
    echo '  make       generate output from org files'
    echo '  test       build and test generated source code'
    echo '  push       push generated output to remote repository'
    echo '  push-html  push generated HTML only'
    echo '  push-gist  push generated gist source only'
    echo '  publish    publish to firebase'
    echo '  serve      serve generated HTML using Caddy'
    echo '  all        make && test && push'
    echo '  help       this message'
}

_dispatch() {
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
        publish)
            _publish || exit 1
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
        help)
            _help
            ;;
    esac
}

_go() {
    [[ -z "$cmds" ]] && cmds='make-html'
    for cmd in $cmds
    do
        _dispatch "$cmd"
    done
}

_go
