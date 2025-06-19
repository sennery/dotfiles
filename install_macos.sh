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
interactive="0"
nvim="0"
fnm="0"
omz="0"
ghostty="0"

for arg in "$@"; do
    if [[ $arg == "-i" ]]; then
        interactive="1"
    elif [[ $arg == "nvim" ]]; then
        nvim="1"
    elif [[ $arg == "fnm" ]]; then
        fnm="1"
    elif [[ $arg == "omz" ]]; then
        omz="1"
    elif [[ $arg == "ghostty" ]]; then
        ghostty="1"
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

function install_nvim {
    NVIM_HOME="$HOME/.local/opt/nvim"
    if [[ ! -d $NVIM_HOME ]]; then
        runcmd mkdir -p $NVIM_HOME
    fi

    print_bold "Installing neovim\n"
    runcmd curl -LO https://github.com/neovim/neovim/releases/download/nightly/nvim-macos-arm64.tar.gz
    runcmd xattr -c ./nvim-macos-arm64.tar.gz
    runcmd tar -xzf nvim-macos-arm64.tar.gz
    runcmd rm -rf $NVIM_HOME
    runcmd mv ./nvim-macos-arm64 $NVIM_HOME
    runcmd rm nvim-macos-arm64.tar.gz
    print_bold "Done\n\n"
}

function install_fnm {
    print_bold "Installing fnm\n"
    runcmd brew install fnm
    runcmd fnm install --lts
    runcmd fnm use lts-latest
    print_bold "Done\n\n"
}

function install_omz {
    print_bold "Installing omz\n"
    if [[ -d "$HOME/.oh-my-zsh" ]]; then
        print_warn "oh-my-zsh already installed, skipping"
        return
    fi

    runcmd sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    print_bold "Done\n\n"
}

function install_ghostty {
    print_bold "Installing ghostty\n"
    runcmd brew install --cask ghostty
    print_bold "Done\n\n"
}

function install_all {
    print_info "Installing everything...\n"
    install_omz
    install_fnm
    install_nvim
    install_ghostty
}

print_bold "\n> https://sennery.dev\n"
print_bold "> dotfiles install script\n\n"

if [[ $interactive == "1" ]]; then
    print_info "Running in interactive mode\n"
    PS3="What to setup: "
    CONFIGS=("all" "neovim" "fnm" "omz" "ghostty" "quit")
    select conf in "${CONFIGS[@]}"; do
        case $conf in
            all)
                install_all
                ;;
            neovim)
                install_nvim
                ;;
            fnm)
                install_nvim
                ;;
            omz)
                install_omz
                ;;
            ghostty)
                install_omz
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
if [[ $fnm == "1" ]]; then
    install_fnm
fi
if [[ $omz == "1" ]]; then
    install_omz
fi
if [[ $ghostty == "1" ]]; then
    install_ghostty
fi

if [[ $fnm == "1" || $nvim == "1" || $omz == "1" || $ghostty == "1" ]]; then
    exit 0
fi

install_all
