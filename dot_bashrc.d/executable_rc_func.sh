#!/usr/bin/env bash

bashdoc en <<'DOC-HERE'
## rc_func

* `o [dir]`
  * Open director
  * Support cmd,cygwin,Centos(nautilus),Mint(nemo),OS X
* mkd
  * mkdir && cd
* colorname
  * Echo manual for color and name
* 256colors
  * for 256 color
* 16colors
  * for 16 color
* server [port:-8000]
  * stary a simple http server
  * will try python, npm server, php
DOC-HERE

bashdoc zh <<'DOC-HERE'
## rc_func

* `o [dir]`
  * 在资源管理器中打开指定目录,如果不指定目录则为当前目录
  * 支持 cmd,cygwin,Centos(nautilus),Mint(nemo),OS X
* mkd
  * mkdir && cd
* colorname
  * 输出 bash 颜色名字和相应数字
* 256colors
  * 输出 256 色
* 16colors
  * 输出 16 色
* server [port:-8000]
  * 在当前目录启动一个 http 服务器
  * 会尝试使用 python, npm server, php
DOC-HERE

# `o` 打开目录
function o()
{
    if [ $# -eq 0 ]; then
        local opath=.
    else
        local opath="$@"
    fi
    # Mac
    command -v open > /dev/null && open "$opath" && return
    # Windows
    command -v cygstart > /dev/null && cygstart "$opath" && return
    command -v cygpath > /dev/null && start "$(cygpath -d $opath)" && return
    # Windows
    command -v cmd > /dev/null && cmd /c start "$opath" && return
    # Centos
    command -v nautilus > /dev/null && nautilus --browser "$opath" && return
    # Linux Mint Cinnamon
    command -v nemo > /dev/null && nemo "$opath" && return
}

# print the header (the first line of input)
# and then run the specified command on the body (the rest of the input)
# use it in a pipeline, e.g. ps | body grep somepattern
# see http://unix.stackexchange.com/a/11859/47774
body() {
    IFS= read -r header
    printf '%s\n' "$header"
    "$@"
}

# 显示exe文件包含的dll
# objdump a.exe -p|grep DLL\ [^:]\*|sed 's/^\s*//g'
# objdump rex_pcre.dll -p|sed 's/^\s*DLL[^:：]*[:：]\s*\(.*\)/\t\1/p' -n
incdll()
{
    for i in "$@"
    do
        if [ -f "$i" ]
        then
            echo $i: included
            # objdump $i -p|grep DLL\ [^:]:|sed 's/^.*:/\t/g'
            objdump $i -p|sed 's/^\s*DLL[^:：]*[:：]\s*\(.*\)/\t\1/p' -n
            echo
        else
            echo incdll:\'$i\' file not exists or permission deny
        fi
    done
}


# Create a new directory and enter it
function mkd()
{
    mkdir -p "$@" && cd "$@"
}

# 输出颜色

colorname(){
  # https://wiki.archlinux.org/index.php/Bash/Prompt_customization
  # http://misc.flogisoft.com/bash/tip_colors_and_formatting
echo -e "
Format:
  <Esc>[\e[31mFormatCode\e[0mm | \\\\e[\e[31mFormatCode\e[0mm
  \\\\e[\e[31mBold\e[0m;\e[31mUnderlined\e[0mm
  \\\\e[\e[31mBold\e[0m;\e[31mForground\e[0m;\e[31mBackground\e[0mm

    Set                         Reset
1   \e[1mBold/Bright\e[0m   21  Reset bold/bright
2   \e[2mDim\e[0m           22  Reset dim
4   \e[4mUnderlined\e[0m    24  Reset underlined
5   \e[5mBlink\e[0m         25  Reset blink
7   \e[7mReverse\e[0m       27  Reset reverse
8   \e[8mHidden\e[0m        28  Reset hidden
                            0   Reset all attributes

8 Colors

    Foreground                    Background

39	\e[39mDefault\e[0m        49	\e[30m\e[49mDefault\e[0m
30	\e[107m\e[30mBlack\e[0m          40	\e[97m\e[40mBlack\e[0m
31	\e[31mRed\e[0m            41	\e[30m\e[41mRed\e[0m
32	\e[32mGreen\e[0m          42	\e[30m\e[42mGreen\e[0m
33	\e[33mYellow\e[0m         43	\e[30m\e[43mYellow\e[0m
34	\e[34mBlue\e[0m           44	\e[30m\e[44mBlue\e[0m
35	\e[35mMagenta\e[0m        45	\e[30m\e[45mMagenta\e[0m
36	\e[36mCyan\e[0m           46	\e[30m\e[46mCyan\e[0m
37	\e[37mLight gray\e[0m     47	\e[30m\e[47mLight gray\e[0m
90	\e[90mDark gray\e[0m     100	\e[30m\e[100mDark gray\e[0m
91	\e[91mLight red\e[0m     101	\e[30m\e[101mLight red\e[0m
92	\e[92mLight green\e[0m   102	\e[30m\e[102mLight green\e[0m
93	\e[93mLight yellow\e[0m  103	\e[30m\e[103mLight yellow\e[0m
94	\e[94mLight blue\e[0m    104	\e[30m\e[104mLight blue\e[0m
95	\e[95mLight magenta\e[0m 105	\e[30m\e[105mLight magenta\e[0m
96	\e[96mLight cyan\e[0m    106	\e[30m\e[106mLight cyan\e[0m
97	\e[97mWhite\e[0m         107	\e[30m\e[107mWhite\e[0m

256 Colors
  Foreground: <Esc>[38;5;\e[31mColorNumber\e[0mm | \\\\e[38;5;\e[31mColorNumber\e[0mm
  Background: <Esc>[48;5;\e[31mColorNumber\e[0mm | \\\\e[48;5;\e[31mColorNumber\e[0mm
 ColorNumber: 0-255

Current term
    Term: $TERM
  Colors: `tput colors`
  Column: `tput cols`
"
}

16colors(){
  # This program is free software. It comes without any warranty, to
  # the extent permitted by applicable law. You can redistribute it
  # and/or modify it under the terms of the Do What The Fuck You Want
  # To Public License, Version 2, as published by Sam Hocevar. See
  # http://sam.zoy.org/wtfpl/COPYING for more details.

  #Background
  for clbg in {40..47} {100..107} 49 ; do
  	#Foreground
  	for clfg in {30..37} {90..97} 39 ; do
  		#Formatting
  		for attr in 0 1 2 4 5 7 ; do
  			#Print the result
  			echo -en "\e[${attr};${clbg};${clfg}m ^[${attr};${clbg};${clfg}m \e[0m"
  		done
  		echo #Newline
  	done
  done
}

256colors(){
  for fgbg in 38 48 ; do #Foreground/Background
    for color in {0..15} ; do
      echo -en "\e[${fgbg};5;${color}m `printf "%3s" ${color}` \e[0m"
      if [ $((($color + 1) % ${1:-6})) == 0 ] ; then
  			echo
  		fi
    done
    echo
    # Better layout
  	for color in {16..255} ; do
  		echo -en "\e[${fgbg};5;${color}m `printf "%3s" ${color}` \e[0m"
  		if [ $((($color - 16 + 1) % ${1:-6})) == 0 ] ; then
  			echo
  		fi
  	done
  	echo
  done
}

# Determine size of a file or total size of a directory
function fs()
{
    if du -b /dev/null > /dev/null 2>&1; then
        local arg=-sbh
    else
        local arg=-sh
    fi
    if [[ -n "$@" ]]; then
        du $arg -- "$@"
    else
        du $arg .[^.]* *
    fi
}

# Use Git’s colored diff when available
hash git &>/dev/null
if [ $? -eq 0 ]; then
    function diff() {
    git diff --no-index --color-words "$@"
}
fi

# Create a data URL from a file
function dataurl()
{
    local mimeType=$(file -b --mime-type "$1")
    if [[ $mimeType == text/* ]]; then
        mimeType="${mimeType};charset=utf-8"
    fi
    echo "data:${mimeType};base64,$(openssl base64 -in "$1" | tr -d '\n')"
}

# Create a git.io short URL
function gitio()
{
    if [ -z "${1}" -o -z "${2}" ]; then
        echo "Usage: \`gitio slug url\`"
        return 1
    fi
    curl -i http://git.io/ -F "url=${2}" -F "code=${1}"
}

# Start a PHP server from a directory, optionally specifying the port
# (Requires PHP 5.4.0+.)
function phpserver()
{
    local port="${1:-4000}"
    local ip=$(ipconfig getifaddr en1)
    sleep 1 && open "http://${ip}:${port}/" &
    php -S "${ip}:${port}"
}

# Compare original and gzipped file size
function gz()
{
    local origsize=$(wc -c < "$1")
    local gzipsize=$(gzip -c "$1" | wc -c)
    local ratio=$(echo "$gzipsize * 100/ $origsize" | bc -l)
    printf "orig: %d bytes\n" "$origsize"
    printf "gzip: %d bytes (%2.2f%%)\n" "$gzipsize" "$ratio"
}

# Escape UTF-8 characters into their 3-byte format
function escape()
{
    printf "\\\x%s" $(printf "$@" | xxd -p -c1 -u)
    # print a newline unless we’re piping the output to another program
    if [ -t 1 ]; then
        echo # newline
    fi
}

# Decode \x{ABCD}-style Unicode escape sequences
function unidecode()
{
    perl -e "binmode(STDOUT, ':utf8'); print \"$@\""
    # print a newline unless we’re piping the output to another program
    if [ -t 1 ]; then
        echo # newline
    fi
}

# Get a character’s Unicode code point
function codepoint()
{
    perl -e "use utf8; print sprintf('U+%04X', ord(\"$@\"))"
    # print a newline unless we’re piping the output to another program
    if [ -t 1 ]; then
        echo # newline
    fi
}

# `v` with no arguments opens the current directory in Vim, otherwise opens the
# given location
function v()
{
    if [ $# -eq 0 ]; then
        vim .
    else
        vim "$@"
    fi
}

# `np` with an optional argument `patch`/`minor`/`major`/`<version>`
# defaults to `patch`
# function np()
# {
#     git pull --rebase && \
#         npm install && \
#         npm test && \
#         npm version ${1:=patch} && \
#         npm publish && \
#         git push origin master && \
#         git push origin master --tags
# }

# `tre` is a shorthand for `tree` with hidden files and color enabled, ignoring
# the `.git` directory, listing directories first. The output gets piped into
# `less` with options to preserve color and line numbers, unless the output is
# small enough for one screen.
function tre()
{
    tree -aC -I '.git|node_modules|bower_components' --dirsfirst "$@" | less -FRNX
}

# Instant Server for Current Directory
# https://gist.github.com/JeffreyWay/1525217
function server()
{
	local port=${1:-8000}
	iscmd python && {
		(sleep 1 && o "http://localhost:${port}/")&
		python -m SimpleHTTPServer ${port}
        return
	}

	iscmd npm && (npm -g ls --depth=0 | grep server@) >/dev/null && {
		# Use npm server
		(sleep 1 && o "http://localhost:${port}/")&
		server ${port}
        return
	}

	iscmd php && {
		(sleep 1 && o "http://localhost:${port}/")&
		php -S localhost:${port}
        return
	}
}

function sshtrc(){
	sshrc "$*" tmuxrc new -A -s main
}
# vim: set foldmarker={{,}} foldlevel=0 foldmethod=marker:
