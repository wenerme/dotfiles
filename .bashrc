#!/usr/bin/env bash

pushd $PWD
cd ~

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
log_info Load dependency utils,log4bash
# }}

# dotfiles {{
#   func    should contain some simple thing to support after config.
#   exports define PATH, variables
#   prompt  define the prompt
#   alias   some usefual alias
#   after   After all
#   extra   will not commit, custom thing
# The order is matter.

log_debug Detect seperate rc
for file in .bashrc.d/rc_{func,exports,prompt,alias,after,extra}.sh;
do
    [ -r "$file" ] && [ -f "$file" ] && { source "$file" ; log_info Load rc $file;continue; }
done

log_debug Detect optional rc
find .bashrc.d/ -type f -iname "rc_my_*" | while read -r file; do
    # [ -r "$file" ] || chmod +x $file
    log_info Load optional rc ${file}
    source "$file"
done

unset file
# }} dotfiles


log_debug Set PS1 to name@host dir [time]
export PS1="\[\e[32m\]\u@\h \[\e[01;33m\]\w \[\e[34m\][\t] \[\e[0m\]\n# "

# 尝试启动 ssh-agent {{
[ -e ~/.ssh/agent.env ] && {

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


# ensure loaded
BASHRC_LOADED=yes
# Back to load .bashrc
[ -f .bash_profile ] && source .bash_profile

popd

# vim: set sw=4 ts=4 sts=4 et tw=78 foldmarker={{,}} foldlevel=0 foldmethod=marker:

