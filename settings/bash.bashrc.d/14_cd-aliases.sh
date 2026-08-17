# shellcheck shell=bash
# Change-directory-up aliases: N dots = N-1 directories up, extending the
# original 2-5 dot set up to 10 dots / 9 levels (add more numbers to the list
# below if you need to go further). Each depth gets both a dots-only alias
# (the common convention) and a "cd"-prefixed alias (matching the original
# cd.. alias).
_cd_up_path=".."
for _cd_up_n in 2 3 4 5 6 7 8 9 10; do
    _cd_up_dots=$(printf '.%.0s' $(seq 1 "$_cd_up_n"))
    # shellcheck disable=SC2139
    alias "$_cd_up_dots"="cd $_cd_up_path"
    # shellcheck disable=SC2139
    alias "cd$_cd_up_dots"="cd $_cd_up_path"
    _cd_up_path="../$_cd_up_path"
done
unset _cd_up_path _cd_up_n _cd_up_dots
