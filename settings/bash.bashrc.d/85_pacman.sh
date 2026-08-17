# shellcheck shell=bash
# Depends on LINUX_DISTRIBUTION from 00_shell-options.sh, sourced ahead of this file.

if [ "$LINUX_DISTRIBUTION" = "arch" ] || [ "$LINUX_DISTRIBUTION" = "cachyos" ]; then

    # Other pacman-* aliases below intentionally reference this alias at their
    # own invocation time (once the shell is interactive), not at parse time.
    # The sudo pacman calls in 95_update.sh's update() function intentionally
    # bypass this alias.
    # shellcheck disable=SC2262,SC2032
    alias pacman='sudo pacman'
    alias pacman-reinstall="pacman -Qqn | sudo pacman -Syyu --noconfirm -"

    # A function (not an alias) so "pacman -Qqme" is re-evaluated every time
    # this is run, rather than being frozen to whatever AUR packages were
    # installed when bash.bashrc.d was sourced.
    #
    # NOTE: this calls the AUR helper `yay`, which conflicts with this repo's
    # own AUR-helper policy (ai/local/arch-packages.instructions.md - AUR
    # helpers must be removed, never invoked). Kept at explicit request for
    # machines where an AUR helper is deliberately retained outside this
    # repo's own installs; install.d/remove-aur-helpers still removes yay on
    # any machine this repo's install script is run against.
    pacman-rebuild-aur() {
        # Word-splitting is intentional here: each installed package becomes
        # a separate argument to --rebuildall.
        # shellcheck disable=SC2046
        yay -Sy --rebuildtree --rebuildall $(pacman -Qqme)
    }
    alias pacman-remove-unused="pacman -Qdtq | sudo pacman -Rs -"

fi
