#!/usr/bin/env bash

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
# TODO This will failed when we use brew, because we will change PATH later.
if ls --color > /dev/null 2>&1;
then # GNU `ls`
	colorflag="--color"
else # OS X `ls`
	colorflag="-G"
fi

# Always use color output for `ls`
alias ls="command ls -h ${colorflag}"
unset -v colorflag

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

# ls 颜色配置
export LS_COLORS='no=00:fi=00:di=01;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.ogg=01;35:*.mp3=01;35:*.wav=01;35:'

# }} ls

#==================
# other alias
#==================

# More Readable
alias grep="grep --color=auto"
alias du="du -h"

# Gzip-enabled `curl`
alias gurl='curl --compressed'

# Get week number
alias week='date +%V'

# g for git
iscmd git && alias g="git"

# clear/cls switchable
iscmd cls && iscmd -n clear && alias cls="clear" || alias cls="echo -en '\ec'"
iscmd clear && iscmd -n cls && alias clear="cls" || alias clear="echo -en '\ec'"

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
}

osis Linux && {
alias ports="netstat -tulanp"
}
# vim: set foldmarker={,} foldlevel=0 foldmethod=marker:
