#!/usr/bin/env bash

dry_run="0"
install="0"
interactive="0"

for arg in "$@"; do
    if [[ $arg == "--install" ]]; then
        install="1"
    elif [[ $arg == "-i" ]]; then
        interactive="1"
    elif [[ $arg == "--dry" ]]; then
        dry_run="1"
        echo "[DRY_RUN] mode"
    fi
done

function runcmd {
    if [[ $dry_run == "1" ]]; then
        echo "[DRY_RUN] Running: $@"
    else
        echo "Running: $@"
        "$@"
    fi
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
    printf "%*.*s" 0 $(((PAD_LENGTH - ${#1}) / 2 )) "$PAD"
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

function install_kitty {
    printh "Installing kitty"
    runcmd curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
    runcmd ln -s ~/.local/kitty.app /usr/bin/kitty
    printf "Done\n\n"
}

function setup_kitty {
    printh "Setup kitty"
    if [[ -z $(command -v kitty) ]]; then
        echo "No kitty installation found, installing..."
        install_kitty
        echo "Kitty is installed, continue setup"
    fi
    replace_dir "$CONFIG_HOME/kitty" "$DF_HOME/kitty"
    printf "Done\n\n"
}

function install_nvim {
    printh "Installing neovim"
    runcmd curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
    runcmd sudo rm -rf /opt/nvim
    runcmd sudo tar -C /opt -xzf nvim-linux64.tar.gz
    runcmd rm nvim-linux64.tar.gz
    printf "Done\n\n"
}

function setup_nvim {
    printh "Setup neovim"
    if [[ -z $(command -v nvim) ]]; then
        echo "No neovim installation found, installing..."
        install_nvim
        echo "Neovim is installed, continue setup"
    fi
    replace_dir "$CONFIG_HOME/nvim" "$DF_HOME/nvim"
    printf "Done\n\n"
}

function setup_config {
    printh "Full setup"
    setup_bash
    setup_git
    setup_kitty
    setup_nvim
}

function install_all {
    printh "Installing..."
    install_nvim
    install_kitty
}

printh "https://sennery.dev"
printh "dotfiles setup script"

if [[ $interactive == "1" ]]; then
    printh "running in interactive mode"
    PS3="What to setup: "
    CONFIGS=("config" "install" "install kitty" "install neovim" "quit")
    select conf in "${CONFIGS[@]}"; do
        case $conf in
            config)
                setup_config
                ;;
            install)
                install_all
                ;;
            "install kitty")
                install_kitty
                ;;
            "install neovim")
                install_nvim
                ;;
            quit)
                echo "Okay, bye!"
                break;;
            *)
                echo "Whoops, there is no option like this. Choose another"
                ;;
        esac
    done
    exit 0
fi

if [[ $install == "1" ]]; then
    install_all
    exit 0
fi

setup_config

