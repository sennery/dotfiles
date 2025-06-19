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
interactive="0"
nvim="0"
kitty="0"

for arg in "$@"; do
    if [[ $arg == "-i" ]]; then
        interactive="1"
    elif [[ $arg == "nvim" ]]; then
        nvim="1"
    elif [[ $arg == "nvim" ]]; then
        nvim="1"
    elif [[ $arg == "kitty" ]]; then
        kitty="1"
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

function install_nvim {
    NVIM_HOME="$HOME/.local/opt/nvim"
    if [[ ! -d $NVIM_HOME ]]; then
        runcmd mkdir -p $NVIM_HOME
    fi

    print_bold "Installing neovim\n"
    runcmd curl -LO https://github.com/neovim/neovim/releases/download/nightly/nvim-linux-x86_64.tar.gz
    runcmd tar -xzf nvim-linux-x86_64.tar.gz
    runcmd rm -rf $NVIM_HOME
    runcmd mv ./nvim-linux-x86_64 $NVIM_HOME
    runcmd rm nvim-linux-x86_64.tar.gz
    print_bold "Done\n\n"
}

function install_all {
    print_info "Installing everything...\n"
    install_nvim
    install_kitty
}

print_bold "\n> https://sennery.dev\n"
print_bold "> dotfiles install script\n\n"

if [[ $interactive == "1" ]]; then
    print_info "Running in interactive mode\n"
    PS3="What to setup: "
    CONFIGS=("install" "install kitty" "install neovim" "quit")
    select conf in "${CONFIGS[@]}"; do
        case $conf in
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

if [[ $nvim == "1" ]]; then
    install_nvim
fi
if [[ $kitty == "1" ]]; then
    install_kitty
fi

if [[ $kitty == "1" || $nvim == "1" ]]; then
    exit 0
fi

install_all
