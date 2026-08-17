# shellcheck shell=sh
# Sourced from both /etc/profile.d and /etc/bash.bashrc.d - keep POSIX-safe.
# Depends on the XDG_*_HOME vars from 20_xdg-dirs.sh, which is deployed and
# sourced ahead of this file in both locations.

## Android/ADB
export ANDROID_USER_HOME="$XDG_DATA_HOME/android"

## Ansible
export ANSIBLE_HOME="$XDG_DATA_HOME/ansible"

## AWS
[ -d "$XDG_CONFIG_HOME/aws" ] || mkdir -p "$XDG_CONFIG_HOME/aws" 2> /dev/null
export AWS_SHARED_CREDENTIALS_FILE="$XDG_CONFIG_HOME/aws/credentials"
export AWS_CONFIG_FILE="$XDG_CONFIG_HOME/aws/config"

# Bash History
[ -d "$XDG_STATE_HOME/bash" ] || mkdir -p "$XDG_STATE_HOME/bash" 2> /dev/null
export HISTFILE="$XDG_STATE_HOME/bash/history"

# Cargo
[ -d "$XDG_DATA_HOME/cargo" ] || mkdir -p "$XDG_DATA_HOME/cargo" 2> /dev/null
export CARGO_HOME="$XDG_DATA_HOME/cargo"

# Docker
[ -d "$XDG_CONFIG_HOME/docker" ] || mkdir -p "$XDG_CONFIG_HOME/docker" 2> /dev/null
export DOCKER_CONFIG="$XDG_CONFIG_HOME/docker"

# GnuPG
[ -d "$XDG_DATA_HOME/gnupg" ] || mkdir -p "$XDG_DATA_HOME/gnupg" 2> /dev/null
export GNUPGHOME="$XDG_DATA_HOME/gnupg"

# GO
[ -d "$XDG_DATA_HOME/go" ] || mkdir -p "$XDG_DATA_HOME/go" 2> /dev/null
export GOPATH="$XDG_DATA_HOME/go"

# GTK
[ -d "$XDG_CONFIG_HOME/gtk-2.0" ] || mkdir -p "$XDG_CONFIG_HOME/gtk-2.0" 2> /dev/null
export GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc"

# IPFS
[ -d "$XDG_DATA_HOME/ipfs" ] || mkdir -p "$XDG_DATA_HOME/ipfs" 2> /dev/null
export IPFS_PATH="$XDG_DATA_HOME/ipfs"

# KDE
[ -d "$XDG_CONFIG_HOME/kde" ] || mkdir -p "$XDG_CONFIG_HOME/kde" 2> /dev/null
export KDEHOME="$XDG_CONFIG_HOME/kde"

# Less
[ -d "$XDG_CACHE_HOME/less" ] || mkdir -p "$XDG_CACHE_HOME/less" 2> /dev/null
export LESSHISTFILE="$XDG_CACHE_HOME/less/history"

# NPM
[ -d "$XDG_CONFIG_HOME/npm" ] || mkdir -p "$XDG_CONFIG_HOME/npm" 2> /dev/null
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"

# NuGet
[ -d "$XDG_CACHE_HOME/NuGetPackages" ] || mkdir -p "$XDG_CACHE_HOME/NuGetPackages" 2> /dev/null
export NUGET_PACKAGES="$XDG_CACHE_HOME/NuGetPackages"

# Nvidia
export CUDA_CACHE_PATH="$XDG_CACHE_HOME/nv"

# NVM
export NVM_DIR="$XDG_DATA_HOME/nvm"

# XAuthority
export XAUTHORITY="$XDG_RUNTIME_DIR/Xauthority"

export PSQL_HISTORY="$XDG_DATA_HOME/psql_history"
