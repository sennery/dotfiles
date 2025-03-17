#!/usr/bin/env bash

# TODO: add fnm installation
# TODO: add ghostty installation
# TODO: add oh-my-zsh installation

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
install="0"
interactive="0"

for arg in "$@"; do
    if [[ $arg == "--install" ]]; then
        install="1"
    elif [[ $arg == "-i" ]]; then
        interactive="1"
    elif [[ $arg == "--dry" ]]; then
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

CONFIG_HOME=$HOME/.config
if [[ ! -d "$CONFIG_HOME" ]]; then
    mkdir -p "$CONFIG_HOME"
fi
DF_HOME=$HOME/dotfiles

function setup_zsh {
    print_bold "Setup zsh\n"
    replace_file "$HOME/.bashrc" "$DF_HOME/.bashrc"
    replace_file "$HOME/.zshrc" "$DF_HOME/.zshrc"
    replace_file "$HOME/.zshenv" "$DF_HOME/.zshenv"
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

function load_kitty {
    curl -LO https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
}
function install_kitty {
    print_bold "Installing kitty\n"
    runcmd load_kitty
    if [[ -e /usr/bin/kitty ]]; then
        if [[ -L /usr/bin/kitty ]]; then
            runcmd unlink /usr/bin/kitty
        else
            runcmd mv /usr/bin/kitty
        fi
    fi
    runcmd ln -s ~/.local/kitty.app /usr/bin/kitty
    print_bold "Done\n\n"
}

function setup_kitty {
    print_bold "Setup kitty\n"
    if [[ -z $(command -v kitty) ]]; then
        echo "No kitty installation found, installing..."
        install_kitty
        echo "Kitty is installed, continue setup"
    fi
    replace_dir "$CONFIG_HOME/kitty" "$DF_HOME/kitty"
    print_bold "Done\n\n"
}

function install_nvim {
    print_bold "Installing neovim\n"
    runcmd curl -LO https://github.com/neovim/neovim/releases/download/nightly/nvim-linux-x86_64.tar.gz
    runcmd sudo rm -rf /opt/nvim-linux-x86_64
    runcmd sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
    runcmd rm nvim-linux-x86_64.tar.gz
    print_bold "Done\n\n"
}

function setup_nvim {
    print_bold "Setup neovim\n"
    if [[ -z $(command -v nvim) ]]; then
        echo "No neovim installation found, installing..."
        install_nvim
        echo "Neovim is installed, continue setup"
    fi
    replace_dir "$CONFIG_HOME/nvim" "$DF_HOME/nvim"
    print_bold "Done\n\n"
}

function setup_config {
    print_info "Full setup\n"
    setup_zsh
    setup_git
    # setup_kitty
    setup_nvim
}

function install_all {
    print_info "Installing...\n"
    install_nvim
    install_kitty
}

print_bold "\n> https://sennery.dev\n"
print_bold "> dotfiles setup script\n\n"

if [[ $interactive == "1" ]]; then
    print_info "Running in interactive mode\n"
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

