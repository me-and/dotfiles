#!/usr/bin/env bash

set -e

DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

confirm_overwrite () {
    read -n1 -p "Overwrite ${1}? [y/n] " rsp
    echo
    [[ $rsp == y ]] && return 0
    return 1
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
