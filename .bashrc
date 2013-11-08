# 配置过程
PS1='\033]0;${PWD}\n\033[32m${USER}@${HOSTNAME} \033[33m${PWD/${HOME}/~}\033[0m\n$ '

if [ -f "${HOME}/.bash_profile" ]; then
    source "${HOME}/.bash_profile"
fi

if [ -f "${HOME}/.bash_func" ]; then
    source "${HOME}/.bash_func"
fi

if [ -f "${HOME}/.bash_alias" ]; then
    source "${HOME}/.bash_alias"
fi

if [ -f "${HOME}/.bash_post" ]; then
    source "${HOME}/.bash_post"
fi
