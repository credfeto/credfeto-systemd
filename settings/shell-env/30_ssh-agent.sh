# shellcheck shell=sh
# Sourced from both /etc/profile.d and /etc/bash.bashrc.d - keep POSIX-safe.

# If ssh-agent is being used
if [ -n "$XDG_RUNTIME_DIR" ]; then
    export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"
fi

# If gpg-agent is being used instead of ssh-agent:
#export SSH_AGENT_PID=""
#export SSH_AUTH_SOCK="${XDG_RUNTIME_DIR}/gnupg/S.gpg-agent.ssh"
