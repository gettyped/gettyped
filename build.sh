#!/bin/sh

gist=$(cat ./scala/GIST_ID)

make_html() {
    echo -e "\nBUILD: Generate HTML"
    emacs --batch -Q -l .orgen/orgen.el -f orgen-noninteractive-publish
}

push_html() {
    echo -e "\nBUILD: Publish HTML"
    (cd ./html && git add -A && git commit -m Render && git push github master)
}

push_gist() {
    echo -e "\nBUILD: Publish Scala Gist"
    gist scala-fiddle/README.org scala-fiddle/*.scala \
         -u "$gist" \
         -d 'Get Typed (Scala)'
}

test_code() {
    echo -e "\nBUILD: Test Code"
    (cd ./scala && ./build.sh test)
}

serve_html() {
    (cd ./html && exec caddy -port 8000)
}

go() {
    case "$1" in
        make-html)
            make_html || exit 1
            ;;
        push-html)
            push_html || exit 1
            ;;
        test)
            test_code || exit 1
            ;;
        push-gist)
            push_gist || exit 1
            ;;
        publish-html)
            make_html || exit 1
            push_html || exit 1
            ;;
        publish-all)
            make_html || exit 1
            test_code || exit 1
            push_html || exit 1
            push_gist || exit 1
            ;;
        serve)
            serve_html
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
