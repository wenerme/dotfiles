#!/usr/bin/env bash

bashdoc zh <<'DOC-HERE'

## rc_exports

* 设置 LESS 颜色
* 设置 LS 颜色,并为以下类型设置特殊的颜色
  * 压缩包
  * 图片
  * 音频
  * 视屏
* 默认语言为 en_US,如果能使用 zh_CN 则使用 zh_CN
* 设置 Bash 历史 控制

DOC-HERE

# common path
try-path "$HOME/.local/bin" "$HOME/bin" "/usr/local/sbin"
try-path -m "$HOME/man"

# We may depends on these commands
# gunbin install by brew without g-prefix
log_info "Prefer to use homebrew's gnubin /usr/local/opt/*/libexec/gnubin"
try-path -f /usr/local/opt/*/libexec/gnubin
try-path -m /usr/local/opt/*/libexec/gnuman

# Make vim the default editor
export EDITOR="vim"

# Larger bash history (allow 32³ entries; default is 500)
export HISTSIZE=32768
export HISTFILESIZE=$HISTSIZE
export HISTCONTROL=ignoredups
# Make some commands not show up in history
export HISTIGNORE="ls:cd:cd -:pwd:exit:date"

# Prefer US English and use UTF-8
export LANG="en_US"
export LC_ALL="en_US.UTF-8"
# 如果有中文则启用
iscmd locale && locale -a | grep -q ^zh_CN && {
  export LANG="zh_CN"
  export LC_ALL="zh_CN.UTF-8"
}

# Don’t clear the screen after quitting a manual page
export MANPAGER="less -X"

# Color man pages: {{

export LESS_TERMCAP_mb=$'\E[01;31m'      # begin blinking
export LESS_TERMCAP_md=$'\E[01;31m'      # begin bold
export LESS_TERMCAP_me=$'\E[0m'          # end mode
export LESS_TERMCAP_se=$'\E[0m'          # end standout-mode
export LESS_TERMCAP_so=$'\E[01;44;33m'   # begin standout-mode - info box
export LESS_TERMCAP_ue=$'\E[0m'          # end underline
export LESS_TERMCAP_us=$'\E[01;32m'      # begin underline

# }}


#==================
# color them all
#==================
# {{

# http://linux-sxs.org/housekeeping/lscolors.html
export LS_COLORS='no=00:fi=00:di=01;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32'

exts="
tar|tgz|arj|taz|lzh|zip|z|Z|gz|bz2|deb|rpm|jar=01;31
jpg|jpeg|gif|bmp|pbm|pgm|ppm|tga|xbm|xpm|tif|tiff|png=01;34
mov|fli|gl|dl|xcf|xwd|ogg|mp3|wav=01;35
flv|mkv|mp4|mpg|mpeg|avi=01;36
"
# http://stackoverflow.com/q/37904939/1870054
# fixme macOS default sed not support
# read -r -d '' exts < <( echo $exts | xargs -n1 | sed -r 's/\|/\n/g;:a;s/\n(.*(=.*))/\2:*.\1/;ta' | sed "s/^/*./g" | tr "\n" ":" )
# export LS_COLORS="$LS_COLORS:$exts"
# unset exts SED

# Most FreeBSD & Apple Darwin supports colors
export CLICOLOR=true

# }}


# vim: set sw=4 ts=4 sts=4 et tw=78 foldmarker={{,}} foldlevel=0 foldmethod=marker:
