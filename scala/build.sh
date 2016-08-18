#!/bin/sh

cmd="$1"

go() {
    case "$1" in
         test)
             sbt compile test
             ;;
         '')
             sbt compile
             ;;
    esac
}

if [[ "$IN_NIX_SHELL" ]] || ! type -P nix-shell >/dev/null
then
    go "$cmd"
else
    echo 'IN_NIX_SHELL'
    nix-shell --run "./build.sh $@" ../shell.nix
fi
