#!/usr/bin/env bash

set -eu

DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

confirm_overwrite () {
    local file=$1
    confirm_continue "Overwrite $file?"
}

confirm_continue () {
    local prompt=$1 rsp=
    while :; do
        read -n1 -p "$prompt [y/n] " rsp
        echo
        if [[ $rsp == y ]]; then
            return 0
        elif [[ $rsp == n ]]; then
            return 1
        fi
    done
}

link_dot () {
    local opt= folder=
    OPTIND=1
    while getopts f opt; do
        case $opt in
            f)  # Linking a folder, not a file
                folder=yes
                ;;
        esac
    done
    shift $(( OPTIND - 1 ))
    local src=$1 dst=$2

    if [[ ! -e $dst ]] || ([[ ! $src -ef $dst ]] && confirm_overwrite "$dst")
    then
        echo "Installing $dst"
        if [[ $folder ]]; then
            rm -rf "$dst"
        else
            rm -f "$dst"
        fi
        ln -s "$src" "$dst"
    fi
}

if command -v vim >/dev/null; then
    if vim --version | grep -qF 'Vi IMproved 7.3' ||
        confirm_continue "Vim version information not recognized. Continue?"
    then
        link_dot "$DIR/vimrc" ~/.vimrc
        link_dot -f "$DIR/vim" ~/.vim
    fi
fi

if command -v startxwin >/dev/null; then
    link_dot "$DIR/startxwinrc" ~/.startxwinrc
fi

if command -v ctags >/dev/null; then
    # Check if ctags supports the `--recurse` option; the man page says it's
    # not supported on all platforms.
    if ctags --help | grep -qe --recurse ||
        confirm_continue "Ctags doesn't support recurse. Continue?"
    then
        link_dot "$DIR/ctags" ~/.ctags
    fi
fi

if command -v mintty >/dev/null; then
    link_dot "$DIR/minttyrc" ~/.minttyrc
fi

if command -v bash >/dev/null; then
    link_dot "$DIR/bash_logout" ~/.bash_logout
    link_dot "$DIR/bash_completion" ~/.bash_completion
    link_dot "$DIR/bash_profile" ~/.bash_profile
    link_dot "$DIR/bashrc" ~/.bashrc
    link_dot "$DIR/profile" ~/.profile
fi

if command -v irssi >/dev/null; then
    link_dot -f "$DIR/irssi" ~/.irssi
fi
