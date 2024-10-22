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
        runcmd ln -s "${new_file}" "${old_file}"
    fi
}

function replace_dir {
    local old_dir=$1
    local new_dir=$2
    if [[ -d "${old_dir}" ]]; then
        if [[ -L "${old_dir}" ]]; then
            runcmd unlink "${old_dir}"
        else
            runcmd mv "${old_dir}" "${old_dir} backup"
        fi
    fi

    if [[ -n "${new_dir}" && -n "${old_dir}" ]]; then
        runcmd ln -s "${new_dir}" "${old_dir}"
    fi
}

PAD=$(printf "%0.1s" "."{1..100})
PAD_LENGTH=70
function printh {
    printf "\n%*.*s" 0 $(((PAD_LENGTH - ${#1}) / 2 )) "$PAD"
    printf " %s " "$1"
    printf "%*.*s\n\n" 0 $(((PAD_LENGTH - ${#1}) / 2 + (PAD_LENGTH - ${#1}) % 2 )) "$PAD"
}

CONFIG_HOME=$HOME/.config
if [[ ! -d "$CONFIG_HOME" ]]; then
    mkdir -p "$CONFIG_HOME"
fi
DF_HOME=$HOME/dotfiles

function setup_bash {
    printh "Setup bash"
    replace_file "$HOME/.bashrc" "$DF_HOME/.bashrc"
    printf "Done\n\n"
}

function setup_git {
    printh "Setup git"
    replace_file "$HOME/.gitconfig" "$DF_HOME/.gitconfig"
    printf "Done\n\n"
}

function setup_kitty {
    printh "Setup kitty"
    if [[ -z $(command -v kitty) ]]; then
        echo "No kitty installation found, installing..."
    fi
    replace_dir "$CONFIG_HOME/kitty" "$DF_HOME/kitty"
    printf "Done\n\n"
}

function setup_nvim {
    printh "Setup neovim"
    if [[ -z $(command -v nvim) ]]; then
        echo "No neovim installation found, installing..."
    fi
    replace_dir "$CONFIG_HOME/nvim" "$DF_HOME/nvim"
    printf "Done\n\n"
}

printh "https://sennery.dev"
printh "dotfiles setup script"

PS3="What to setup: "
CONFIGS=(all neovim git bash kitty quit)
select conf in ${CONFIGS[@]}; do
    case $conf in
        all)
            printh "Installing all"
            setup_bash
            setup_git
            setup_kitty
            setup_nvim
            break;;
        neovim)
            setup_nvim
            ;;
        git)
            setup_git
            ;;
        bash)
            setup_bash
            ;;
        kitty)
            setup_kitty
            ;;
        quit)
            echo "Okay, bye!"
            break;;
        *)
            echo "Whoops, there is no option like this. Choose another"
            ;;
    esac
done
