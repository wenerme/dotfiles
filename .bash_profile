#!/usr/bin/env bash

# Load dependencies {{
. .bashrc.d/utils.sh

# Default: Only show WARN and ERROR
# Allowed level: INFO DEBUG WARN ERROR ALL
[ -z $LOG4BASH_LOG_LEVEL ] && export LOG4BASH_LOG_LEVEL=(WARN ERROR)


. .bashrc.d/log4bash.sh
log_info Load dependency log4bash
# }}

 #Allow \r in shell see https://cygwin.com/ml/cygwin-announce/2010-08/msg00015.html
(set -o igncr) 2>/dev/null && set -o igncr; # this comment is needed

# Load seperate shell dotfiles {{
#   func    should contain some simple thing to support after config.
#   exports define PATH, variables
#   prompt  define the prompt
#   alias   some usefual alias
#   extra   will not commit, custom thing
# The order is matter.
for file in ~/.bashrc_{func,exports,prompt,alias,extra};
do
    log_info Try load dotfile [$file, ~/.bashrc.d/`basename $file`]
    [ -r "$file" ] && [ -f "$file" ] && source "$file" && continue
    # possible in ~/.bashrc.d
    file=~/.bashrc.d/`basename $file`
    [ -r "$file" ] && [ -f "$file" ] && source "$file"
done

# Optional rc
find ~/.bashrc.d/ -type f -iname ".bashrc_my_*" -print0 | while IFS= read -r -d $'\0' line; do
    # [ -r "$file" ] || chmod +x $file
    log_info Load custom dotfile $file
    source "$line"
done

# }} dotfiles

unset file

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

# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
[ -e "$HOME/.ssh/config" ] && 
complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2 | tr ' ' '\n')" scp sftp ssh

# Add tab completion for `defaults read|write NSGlobalDomain`
# You could just use `-g` instead, but I like being explicit
complete -W "NSGlobalDomain" defaults

# Add `killall` tab completion for common apps
complete -o "nospace" -W "Contacts Calendar Dock Finder Mail Safari iTunes SystemUIServer Terminal Twitter" killall

# If possible, add tab completion for many more commands
[ -f /etc/bash_completion ] && source /etc/bash_completion

# ensure loaded
BASHRC_LOADED=yes

# Back to load .bashrc
[ -f ~/.bashrc ] && source ~/.bashrc


# vim: set sw=4 ts=4 sts=4 et tw=78 foldmarker={{,}} foldlevel=0 foldmethod=marker:
