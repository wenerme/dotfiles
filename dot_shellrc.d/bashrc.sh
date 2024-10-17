#!/bin/bash

#Allow \r in shell see https://cygwin.com/ml/cygwin-announce/2010-08/msg00015.html
(set -o igncr) 2>/dev/null && set -o igncr; # this comment is needed

#region sshopt

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob
# Append to the Bash history file, rather than overwriting it
shopt -s histappend
# Autocorrect typos in path names when using `cd`
shopt -s cdspell

if [ "${BASH_VERSINFO}" -ge 4 ]; then
  # `autocd`, e.g. `**/qux` will enter `./foo/bar/baz/qux`
  shopt -s autocd
  # Recursive globbing, e.g. `echo **/*.txt`
  shopt -s globstar
fi
#endregion

# NOTE ERRONO 无法放到后面，不生效，暂不知道为什么
# [> ERRONO] USER@HOST [$MSYSTEM] PATH [(GIT-BRANCH)] \[HH:MM:SS\]
# %
__git_branch() {
    if git rev-parse --git-dir > /dev/null 2>&1; then
        local branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
        echo -e " \e[33m(${branch})"
    fi
}

__prompt_char() {
    if [ "$EUID" -eq 0 ]; then
        echo "#"
    else
        echo "%"
    fi
}
export PS1='\[\e[0;31m\]$(_rc=${?##0};echo ${_rc:+"> ${_rc} "})\[\e[32m\]\u@\h\[\e[35m\]$(echo ${MSYSTEM:+" ${MSYSTEM}"}) \[\e[34m\]\w$(__git_branch) \[\e[36m\][$(date +"%H:%M:%S")]\[\e[0m\]
$(__prompt_char) '
