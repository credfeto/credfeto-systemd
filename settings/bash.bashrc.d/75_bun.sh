# shellcheck shell=sh
if [ -d "$HOME/.bun" ]; then
    # bun
    export BUN_INSTALL="$HOME/.bun"
    export PATH="$BUN_INSTALL/bin:$PATH"
fi
