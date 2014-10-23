#!/bin/bash

# Add `~/bin` to the `$PATH`
export PATH="$HOME/bin:$PATH"

# Allow \r in shell see https://cygwin.com/ml/cygwin-announce/2010-08/msg00015.html
(set -o igncr) 2>/dev/null && set -o igncr; # this comment is needed

# Load the shell dotfiles, and then some:
# * ~/.bashrc_path can be used to extend `$PATH`.
# * ~/.bashrc_cygwin for cygwin only
# * ~/.bashrc_extra can be used for other settings you don’t want to commit.
for file in ~/.bashrc_{path,prompt,func,exports,alias,cygwin,linux,extra};
do
	[ -r "$file" ] && [ -f "$file" ] && source "$file" && continue
	# possible in ~/.bashrc.d
	file=~/.bashrc.d/`basename $file`
	[ -r "$file" ] && [ -f "$file" ] && source "$file"
done

find ~/.bashrc.d/ -type f -iname ".bashrc_my_*" -print0 | while IFS= read -r -d $'\0' line; do
    # [ -r "$file" ] || chmod +x $file
    echo "$line"
    source "$line"
done

unset file

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

[ -f ~/.bashrc ] && source ~/.bashrc


[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
