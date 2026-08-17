# shellcheck shell=sh
alias cp='cp -i'
alias mv='mv -i'
# 95_update.sh's update() function deliberately bypasses this alias in favour
# of the real rm.
alias rm='rm -iv'
alias mkdir='mkdir -p'
alias ps='ps auxf'
alias ping='ping -c 10'
alias less='less -R'
