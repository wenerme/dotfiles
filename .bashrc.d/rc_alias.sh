#!/usr/bin/env bash

# { cd alias
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
# }

# { ls configuration

# Detect which `ls` flavor is in use
if ls --color > /dev/null 2>&1; 
then # GNU `ls`
	colorflag="--color"
else # OS X `ls`
	colorflag="-G"
fi

# Always use color output for `ls`
alias ls="command ls -h ${colorflag}"

# List all files colorized in long format
alias l="ls -lF"

# List all files colorized in long format, including dot files
alias la="ls -aF"

alias ll="ls -alF"

# List only directories
alias lsd='ls -lF | grep "^d"'

# List as tree
lst() {
    ls -R "$@" | grep ":$" | sed -e 's/:$//' -e 's/[^-][^\/]*\//--/g' -e 's/^/   /' -e 's/-/|/';
}
# ls 颜色配置
export LS_COLORS='no=00:fi=00:di=01;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.ogg=01;35:*.mp3=01;35:*.wav=01;35:'

# }

# Gzip-enabled `curl`
alias gurl='curl --compressed'

# Get week number
alias week='date +%V'

# g for git
iscmd git && alias g="git"

# clear/cls alternative
iscmd cls || alias cls="echo -en '\ec'"
iscmd clear ||  alias clear="cls"
# ifconfig/ipconfig alternative
iscmd ifconfig || alias ifconfig="ipconfig"
iscmd ipconfig || alias ipconfig="ifconfig"


alias lrc="(cd ~;. .bash_profile)" # reload run configuration

# 测试命令是否存在
# type foo >/dev/null 2>&1 || { echo >&2 "I require foo but it's not installed.  Aborting."; exit 1; }
# command -v grunt > /dev/null && alias grunt="grunt --stack"

# 编码转换
alias utf82gbk="iconv -f utf-8 -t gbk"
alias gbk2utf8="iconv -f gbk -t utf-8"


alias grep="grep --color=auto"
alias du="du -h"


# 压入当前位置
alias pushcd="pushd $PWD"

# 在已经打开的窗口中打开 vim
iscmd gvim && alias gvimr="gvim --remote"



# vim: set foldmarker={,} foldlevel=0 foldmethod=marker:
