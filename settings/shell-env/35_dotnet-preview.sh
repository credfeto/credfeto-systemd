# shellcheck shell=sh
# Sourced from both /etc/profile.d and /etc/bash.bashrc.d - keep POSIX-safe.

# Consumed by settings/scripts/git/{init-preview,update-preview,update-dotnet-sdk}
# - a single machine-wide preview SDK track rather than a per-repo value.
export DOTNET_PREVIEW_VERSION=11
