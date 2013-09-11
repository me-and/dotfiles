#!/usr/bin/env bash

set -eu

DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

confirm_overwrite () {
    local file=$1
    confirm_continue "Overwrite $file?"
}

confirm_continue () {
    local prompt=$1 rsp=
    while :
    do
        read -n1 -p "$prompt [y/n] " rsp
        echo
        if [[ $rsp == y ]]
        then
            return 0
        elif [[ $rsp == n ]]
        then
            return 1
        fi
    done
}

for filename in $DIR/*
do
    if ! [[ $filename -ef ${BASH_SOURCE[0]} ]]
    then
        dotname=.$(basename $filename)
        if [[ ! -e ~/$dotname ]] || confirm_overwrite ~/"$dotname"
        then
            echo "Installing $dotname"
            rm -rf ~/"$dotname"
            ln -s "$filename" ~/"$dotname"
        fi
    fi
done
