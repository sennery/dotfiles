# oh-my-zsh
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(git fnm)
source $ZSH/oh-my-zsh.sh

# fnm
FNM_PATH="$HOME/.local/share/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="$FNM_PATH:$PATH"
fi
if [[ -n $(command -v fnm) ]]; then
  eval "$(fnm env --use-on-cd --shell zsh)"
fi

# nvim
NVIM_PATH="$HOME/.local/opt/nvim/bin"
if [ -d "$NVIM_PATH" ]; then
  export PATH="$NVIM_PATH:$PATH"
fi

# Set default editor
export EDITOR="$(which nvim)"
export VISUAL="$EDITOR"

# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
if [ -d "$PNPM_HOME" ]; then
  export PATH="$PNPM_HOME:$PATH"
fi
