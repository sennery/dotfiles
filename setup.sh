#!/bin/bash

function runcmd {
    echo "$@"
    "$@"
}

function replace_file {
    local old_file=$1
    local new_file=$2
    if [[ -e "${old_file}" ]]; then
        if [[ -L "${old_file}" ]]; then
            runcmd unlink "${old_file}"
        else
            runcmd mv "${old_file}" "${old_file}.backup"
        fi
    fi

    if [[ -n "${new_file}" && -n "${old_file}" ]]; then
        ln -s "${new_file}" "${old_file}"
    fi
}

function replace_dir {
    local old_dir=$1
    local new_dir=$2
    if [[ -d "${old_dir}" ]]; then
        # Symlink, just remove it
        if [[ -L "${old_dir}" ]]; then
            runcmd unlink "${old_dir}"
        else
            runcmd mv "${old_dir}" "${old_dir} backup"
        fi
    fi

    if [[ -n "${new_dir}" && -n "${old_dir}" ]]; then
        ln -s "${new_dir}" "${old_dir}"
    fi
}

PAD=$(printf "%0.1s" "-"{1..100})
PAD_LENGTH=100
function printh {
    printf "\n%*.*s" 0 $(((PAD_LENGTH - ${#1}) / 2 )) "$PAD"
    printf " %s " "$1"
    printf "%*.*s\n\n" 0 $(((PAD_LENGTH - ${#1}) / 2 + (PAD_LENGTH - ${#1}) % 2 )) "$PAD"
}

printh "https://sennery.dev"
printh "dotfiles setup script"

export CONFIG_HOME=$HOME/.config
if [[ ! -d "$CONFIG_HOME" ]]; then
    mkdir -p "$CONFIG_HOME"
fi
export DF_HOME=$HOME/dotfiles
export NVIM_HOME=$CONFIG_HOME/nvim

HAS_NVM="$(command -v nvm)"
HAS_NVIM="$(command -v nvim)"

PS3="What to setup: "
CONFIGS=(all neovim git bash quit)
select conf in ${CONFIGS[@]}; do
    case $conf in
        all)
            printh "Installing all"
            break;;
        neovim)
            echo "You chose ${conf}"
            ;;
        git)
            echo "You chose ${conf}"
            ;;
        bash)
            echo "You chose ${conf}"
            ;;
        quit)
            echo "Okay, bye!"
            break;;
        *)
            echo "Whoops"
            ;;
    esac
done
