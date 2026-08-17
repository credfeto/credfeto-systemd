# shellcheck shell=sh
# Sourced from both /etc/profile.d and /etc/bash.bashrc.d - keep POSIX-safe.

export XDG_DATA_HOME="$HOME/.local/share"
[ -d "$XDG_DATA_HOME" ] || mkdir -p "$XDG_DATA_HOME" 2> /dev/null

export XDG_CONFIG_HOME="$HOME/.config"
[ -d "$XDG_CONFIG_HOME" ] || mkdir -p "$XDG_CONFIG_HOME" 2> /dev/null

export XDG_STATE_HOME="$HOME/.local/state"
[ -d "$XDG_STATE_HOME" ] || mkdir -p "$XDG_STATE_HOME" 2> /dev/null

export XDG_CACHE_HOME="$HOME/.cache"
[ -d "$XDG_CACHE_HOME" ] || mkdir -p "$XDG_CACHE_HOME" 2> /dev/null

# The projects dir
export XDG_PROJECTS_DIR="$HOME/work"
[ -d "$XDG_PROJECTS_DIR" ] || mkdir -p "$XDG_PROJECTS_DIR" 2> /dev/null
