#!/usr/bin/env bash

bashdoc <<'DOC-HERE'

## rc_alias

__cd__
* 定义 `..`,`...`,`....`,`.....`,`~`,`-` 来作为常用的目录跳转
* 定义 `cd-`,`cd..`,`cd...`

__ls__

* 默认启用 `-h` 使输出的 size 更可读
* 定义 `l`,`la`,`ll`,`lsd`,`lst`

__cls/clear__
使 `cls` 和 `clear` 命令可互换使用

__ifconfig/ipconfig__
* 使 `ifconfig` 和 `ipconfig` 命令可互换使用
* 在 `*nix` 在可能 `ipconfig` 已被使用,则不会替换为 `ifconfig`


__其他__

* pushcd 将当前目录入栈
* lrc 重新加载 bashrc 配置
* ports 显示所有使用的端口
* utf82gbk,gbk2utf8 编码互转
* please 使用 sudo 从新执行上一条命令
* tolower,toupper 字符转换
* random-string 生成一串随机字符串,用于作为密码什么的
* Darwin
	* saynow 报时

DOC-HERE

#==================
# cd alias
#==================
# {{
# Easier navigation: .., ..., ...., ....., ~ and -
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ~="cd ~" # `cd` is probably faster to type though
alias -- -="cd -"

alias cd-="cd -"
alias cd..="cd .."
alias cd...="cd ../.."
# }} cd

#==================
# ls alias
#==================
# {{
# Detect which `ls` flavor is in use
# Don't expect use the Darwin flavor ls
# if ls --color > /dev/null 2>&1;
# then # GNU `ls`
# 	colorflag="--color"
# else # OS X `ls`
# 	colorflag="-G"
# fi
# alias ls="command ls -h ${colorflag}"
# unset -v colorflag
# alias ls="command ls --color=auto"
# Not works
# export LS_OPTS='--color=auto'

# Human Readable
alias ls="command ls --color=auto -h"

# List all files colorized in long format
alias l="ls -lF"

# List all files colorized in long format, including dot files
alias la="ls -aF"

alias ll="ls -alF"

# List only directories
alias lsd='ls -lF | grep "^d"'

# List as tree
lst()
{
    ls -R "$@" | grep ":$" | sed -e 's/:$//' -e 's/[^-][^\/]*\//--/g' -e 's/^/   /' -e 's/-/|/';
}

# }} ls

#==================
# other alias
#==================

# deprecated
# export GREP_OPTIONS="--color=auto"
alias grep="grep --color=auto"

# More Readable
alias du="du -h"

# Gzip-enabled `curl`
alias gurl='curl --compressed'

# Get week number
alias week='date +%V'

# g for git
iscmd git && alias g="git"

# clear/cls switchable
iscmd cls && iscmd -n clear && alias clear="cls"
iscmd clear && iscmd -n cls && alias cls="clear"
iscmd -n cls && alias cls="echo -en '\ec'"
iscmd -n clear && alias clear="echo -en '\ec'"

# ifconfig/ipconfig switchable
iscmd ipconfig && iscmd -n ifconfig && alias ifconfig="ipconfig"
iscmd ifconfig && iscmd -n ipconfig && alias ipconfig="ifconfig"

# 压入当前位置
alias pushcd="pushd $PWD"
alias lrc=". ~/.bashrc" # reload run configuration

# 编码转换
alias utf82gbk="iconv -f utf-8 -t gbk"
alias gbk2utf8="iconv -f gbk -t utf-8"

# 在已经打开的窗口中打开 vim
iscmd gvim && alias gvimr="gvim --remote"

# XD
alias please='sudo $(fc -ln -1)'

alias tolower="tr '[:upper:]' '[:lower:]'"
alias toupper="tr '[:lower:]' '[:upper:]'"
random-string()
{
    cat /dev/urandom | env LC_CTYPE=C tr -dc 'a-zA-Z0-9' | head -c 32
		# tr -dc [:graph:] < /dev/urandom | head -c 32
}

osis Darwin && {
alias ports="netstat -tulanp tcp"
alias saynow='say `date +现在%H点%M分`'
}

osis Linux && {
alias ports="netstat -tulanp"
}
# vim: set foldmarker={,} foldlevel=0 foldmethod=marker:
