#!/usr/bin/env bash

if [[ ! "$IN_NIX_SHELL" ]] && type -P nix-shell >/dev/null
then
    exec nix-shell --run "$0 $*" ../shell.nix
fi

case "$1" in
    test)
        sbt compile test
        ;;
    '')
        sbt compile
        ;;
esac
