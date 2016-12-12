#!/usr/bin/env bash
# DEBUGGING=true
[[ -z "$DEBUGGING" ]] || command -v osis &>/dev/null || { . .bashrc.d/utils.sh ; . .bashrc.d/log4bash.sh; log_level DEBUG; }

# If we are not home, then we go HOME
[ "$HOME" = "$PWD" -o "$WE_GO_HOME" = "no"  ] || {
command -v osis &>/dev/null && log_info Will CD to HOME for Loading RC, PWD is `pwd`
pushd "$HOME" >/dev/null
WE_GO_HOME=yes
}

#Allow \r in shell see https://cygwin.com/ml/cygwin-announce/2010-08/msg00015.html
(set -o igncr) 2>/dev/null && set -o igncr; # this comment is needed

# sshopt {{
# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob

# Append to the Bash history file, rather than overwriting it
shopt -s histappend

# Autocorrect typos in path names when using `cd`
shopt -s cdspell

# Enable some Bash 4 features when possible:
# * `autocd`, e.g. `**/qux` will enter `./foo/bar/baz/qux`
# * Recursive globbing, e.g. `echo **/*.txt`
for option in autocd globstar; do
    shopt -s "$option" 2> /dev/null
done
# }} sshopt

# Load dependencies {{
. .bashrc.d/utils.sh
. .bashrc.d/log4bash.sh

[[ -z "$DEBUGGING" ]] || { log_level DEBUG; log_debug In debug mode.; }

log_info Load dependency utils,log4bash
# }}

# dotfiles {{
#   func    contain util funcs
#   exports define PATH, variables
#   after   after basic env was setup, we need to detect current env
#   alias   some usefual alias
#   extra   should not commit, custom thing
# The order is matter.

log_debug Detect seperate rc, current PATH is "$PATH"
for file in .bashrc.d/rc_{func,exports,after,alias,extra}.sh;
do
    [ -r "$file" ] && [ -f "$file" ] && { log_info Load rc $file;source "$file";log_debug Load ${file} complete ; }
done
log_debug Load seperate rc complete, current PATH is "$PATH"

log_debug Detect optional rc
while read -r file; do
    log_info Load optional rc ${file}
    source "$file"
    log_debug Load ${file} complete
done < <(find .bashrc.d/ -type f -iname "rc_my_*" )

unset file
# }} dotfiles


log_debug Set PS1 to name@host dir [time]
# export PS1="\[\e[32m\]\u@\h \[\e[01;33m\]\w \[\e[34m\][\t] \[\e[0m\]\n$ "
export PROMPT_COMMAND=__prompt_command

function __prompt_command() {
    local EXIT="$?"             # This needs to be first
    PS1="\[\e[32m\]\u@\h \[\e[01;33m\]\w \[\e[34m\][\t] \[\e[0m\]"

    if [ $EXIT != 0 ]; then
        PS1+="❗️"
    fi

    PS1+="\n$ "
}

# 尝试启动 ssh-agent {{
[ -z "$SSH_CLIENT" ] && [ -e ~/.ssh/agent.env ] && {

#-----------------------------
# See https://help.github.com/articles/working-with-ssh-key-passphrases
# ----------------------------
#
# Note: ~/.ssh/environment should not be used, as it
#       already has a different purpose in SSH.

env=~/.ssh/agent.env

# Note: Don't bother checking SSH_AGENT_PID. It's not used
#       by SSH itself, and it might even be incorrect
#       (for example, when using agent-forwarding over SSH).

agent_is_running() {
    if [ "$SSH_AUTH_SOCK" ]; then
        # ssh-add returns:
        #   0 = agent running, has keys
        #   1 = agent running, no keys
        #   2 = agent not running
        ssh-add -l >/dev/null 2>&1 || [ $? -eq 1 ]
    else
        false
    fi
}

agent_has_keys() {
    ssh-add -l >/dev/null 2>&1
}

agent_load_env() {
    . "$env" >/dev/null
}

agent_start() {
    (umask 077; ssh-agent >"$env")
    . "$env" >/dev/null
}

if ! agent_is_running; then
    agent_load_env
fi

if ! agent_is_running; then
    agent_start
    ssh-add
elif ! agent_has_keys; then
    ssh-add
fi

unset env
unset -f agent_is_running agent_load_env agent_is_running agent_start agent_has_keys

} # [ -e ~/.ssh/agent.env ]

# }} ssh agent


[ "$WE_GO_HOME" = "yes" ] && {
log_debug Current is CD to HOME to load rc, will popd now
popd >/dev/null
log_info popd from HOME to $PWD
}
unset -v WE_GO_HOME
# vim: set sw=4 ts=4 sts=4 et tw=78 foldmarker={{,}} foldlevel=0 foldmethod=marker:
