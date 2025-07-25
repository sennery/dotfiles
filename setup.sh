#!/usr/bin/env bash

function print_dim {
    printf "\033[2m%b\033[0m" "$1"
}
function print_bold {
    printf "\033[1m%b\033[0m" "$1"
}
function print_color {
    printf "\033[38;5;%s;48;5;%sm %b \033[0m" "$1" "$2" "$3"
}

function print_info {
    print_color "232" "224" "INFO"
    printf " %b\n" "$1"
}
function print_warn {
    print_color "235" "214" "WARN"
    printf " %b\n" "$1"
}

dry_run="0"
for arg in "$@"; do
    if [[ $arg == "--dry" ]]; then
        dry_run="1"
        print_warn "used [DRY_RUN] mode - nothing will be installed!"
    fi
done

function runcmd {
    if [[ $dry_run == "1" ]]; then
        printf "[DRY_RUN] "
        print_dim "Running: "
        printf "%s \n" "$*"
    else
        print_dim "Running: "
        printf "%s \n" "$*"
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
    if [[ -L "${old_dir}" ]]; then
        runcmd unlink "${old_dir}"
    elif [[ -d "${old_dir}" ]]; then
        runcmd mv "${old_dir}" "${old_dir} backup"
    fi

    if [[ -n "${new_dir}" && -n "${old_dir}" ]]; then
        runcmd ln -s "${new_dir}" "${old_dir}"
    fi
}

CONFIG_HOME="$HOME/.config"
if [[ ! -d "$CONFIG_HOME" ]]; then
    mkdir -p "$CONFIG_HOME"
fi
DF_HOME="$HOME/dotfiles"
DF_CONFIG="$DF_HOME/.config"

function setup_zsh {
    print_bold "Setup zsh\n"
    replace_file "$HOME/.bashrc" "$DF_HOME/.bashrc"
    replace_file "$HOME/.zshrc" "$DF_HOME/.zshrc"
    replace_file "$HOME/.zshenv" "$DF_HOME/.zshenv"
    replace_file "$HOME/.zprofile" "$DF_HOME/.zprofile"
    if [[ $SHELL != $(which zsh) ]]; then
        runcmd chsh -s $(which zsh)
        # fedora only
        # runcmd sudo chsh $USER
    fi
    print_bold "Done\n\n"
}

function setup_git {
    print_bold "Setup git\n"
    replace_file "$HOME/.gitconfig" "$DF_HOME/.gitconfig"
    print_bold "Done\n\n"
}

function setup_kitty {
    print_bold "Setup kitty\n"
    if [[ -z $(command -v kitty) ]]; then
        echo "No kitty installation found, don't forget to install it"
    fi
    replace_dir "$CONFIG_HOME/kitty" "$DF_CONFIG/kitty"
    print_bold "Done\n\n"
}

function setup_nvim {
    print_bold "Setup neovim\n"
    if [[ -z $(command -v nvim) ]]; then
        echo "No neovim installation found, don't forget to install it"
    fi
    replace_dir "$CONFIG_HOME/nvim" "$DF_CONFIG/nvim"
    print_bold "Done\n\n"
}

function setup_ghostty {
    print_bold "Setup ghostty\n"
    if [[ -z $(command -v ghostty) ]]; then
        echo "No ghostty installation found, don't forget to install it"
    fi
    replace_dir "$CONFIG_HOME/ghostty" "$DF_CONFIG/ghostty"
    print_bold "Done\n\n"
}

function setup_config {
    print_info "Full setup\n"
    setup_zsh
    setup_git
    # setup_kitty
    setup_nvim
    setup_ghostty
}

print_bold "\n> https://sennery.dev\n"
print_bold "> dotfiles setup script\n\n"

setup_config
