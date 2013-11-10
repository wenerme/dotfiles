# 配置过程
PS1='\033]0;${PWD}\n\033[32m${USER}@${HOSTNAME} \033[33m${PWD/${HOME}/~}\033[0m\n$ '

if [ -f "${HOME}/.bash_profile" ]; then
    source "${HOME}/.bash_profile"
fi

# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
# * ~/.extra can be used for other settings you don’t want to commit.
for file in ~/.bashrc_{path,prompt,exports,alias,func,extra}; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file"
done
unset file
