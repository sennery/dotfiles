# XDG base directories.
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

# It is here for applications from .local/bin that will be used in DE apps menu
export PATH="$HOME/.local/bin:$PATH"

# Set default editor
export EDITOR="$(which nvim)"
export VISUAL="$EDITOR"
