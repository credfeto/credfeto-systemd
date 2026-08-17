# shellcheck shell=sh
# Depends on ANDROID_USER_HOME from 25_xdg-tool-paths.sh, sourced ahead of this file.
alias ls='ls -aFh --color=always' # add colours and file type extensions
alias ll='ls -Fls' # long listing format
alias adb='HOME="$ANDROID_USER_HOME" adb'
