#!/usr/bin/env bash

if [[ ! "$IN_NIX_SHELL" ]] && type -P nix-shell >/dev/null
then
    exec nix-shell --run "$0 $*"
fi

cmds="$@"
gist=$(cat ./scala/GIST_ID)

_msg() {
    echo -e "\nBUILD: $1"
}

_clean_all() {
    rm -rf ./html
    rm -rf ./scala
    rm -rf ./scala-fiddle
}

_copy_static() {
    rm -rf ./html/static
    mkdir -p ./html
    cp -R ./doc/static ./html/
}

_org_html() {
    _msg 'Generate from Org files'
    rm -rf ./html
    _copy_static
    emacs --batch -Q -l .orgen/orgen.el -f orgen-noninteractive-publish
}

_push_github() {
    _msg 'Push to Github'
    (cd ./html && git add -A && git commit -m Render && git push github master)
}

_push_gist() {
    _msg 'Push gists'
    gist scala-fiddle/README.org scala-fiddle/*.scala \
         -u "$gist" \
         -d 'Get Typed (Scala)'
}

_push_firebase() {
    _msg 'Push to Firebase'
    if [[ -z "$FIREBASE_TOKEN" ]]
    then
        firebase deploy --token "$FIREBASE_TOKEN"
    else
        firebase deploy
    fi
}

_push() {
    _push_firebase && _push_gist
}

_test() {
    _msg 'Run tests'
    (cd ./scala && sbt compile test)
}

_tar_src() {
    _msg 'Tar source'
    rm -rf ./html/gettyped.tar.gz
    tar -c ./scala | gzip > ./html/gettyped.tar.gz
}

_zip_src() {
    _msg 'Zip source'
    rm -rf ./html/gettyped.zip
    zip -r ./html/gettyped.zip ./scala
}

_archive_src() {
    _tar_src && _zip_src
}

_caddy() {
    _msg 'Serve with Caddy'
    (cd ./html && exec caddy -port 8000)
}

_help() {
    echo 'COMMANDS:'
    echo '  copy-static    copy static files to output'
    echo '  make           generate output from org files'
    echo '  test           build and test generated source code'
    echo '  push           default push (push-gist && push-firebase)'
    echo '  push-github    push site to github'
    echo '  push-gist      push generated gist source to github'
    echo '  push-firebase  push site to firebase including src archives'
    echo '  tar            tar generated source'
    echo '  zip            zip generated source'
    echo '  archive        tar and zip generated source'
    echo '  serve          serve generated HTML using Caddy'
    echo '  all            make && test && push'
    echo '  clean-all      remove all generated files'
    echo '  help           this message'
}

_dispatch() {
    case "$1" in
        copy-static)
            _copy_static || exit 1
            ;;
        make)
            _org_html || exit 1
            ;;
        push-github)
            _push_github || exit 1
            ;;
        push-gist)
            _push_gist || exit 1
            ;;
        push-firebase)
            _push_firebase || exit 1
            ;;
        push)
            _push || exit 1
            ;;
        test)
            _test || exit 1
            ;;
        all)
            _org_html || exit 1
            _archive_src || exit 1
            _test || exit 1
            ;;
        tar)
            _tar_src || exit 1
            ;;
        zip)
            _zip_src || exit 1
            ;;
        archive)
            _archive_src || exit 1
            ;;
        serve)
            _caddy
            ;;
        clean-all)
            _clean_all || exit 1
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
