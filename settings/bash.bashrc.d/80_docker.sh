# shellcheck shell=sh
if command -v docker > /dev/null 2>&1; then
    alias docker="sudo docker"
fi
