# shellcheck shell=sh
[ -d "$HOME/work/personal/scripts/db" ] && PATH="$PATH:$HOME/work/personal/scripts/db"
[ -d "$HOME/work/personal/scripts/development" ] && PATH="$PATH:$HOME/work/personal/scripts/development"
[ -d "$HOME/work/personal/scripts/general" ] && PATH="$PATH:$HOME/work/personal/scripts/general"
[ -d "$HOME/work/personal/scripts/git" ] && PATH="$PATH:$HOME/work/personal/scripts/git"
[ -d "$HOME/work/personal/scripts/github" ] && PATH="$PATH:$HOME/work/personal/scripts/github"
[ -d "$HOME/work/personal/scripts/network" ] && PATH="$PATH:$HOME/work/personal/scripts/network"

# JetBrains Toolbox scripts dir (launcher symlinks) - fixed to check -d, not
# the original's -f, since Toolbox creates this as a directory.
[ -d "$HOME/.local/share/JetBrains/Toolbox/scripts" ] && PATH="$PATH:$HOME/.local/share/JetBrains/Toolbox/scripts"

PATH="$PATH:$HOME/.local/bin:$HOME/.cargo/bin"
