#!/bin/sh

trysource ~/.shellrc.d/z.sh

iscmd brew && {
  isshell bash && {
    trysource "$(brew --prefix)/etc/profile.d/bash_completion.sh"
  }

  isshell zsh && {
    _dir=$(brew --prefix)/share/zsh-completions
    if [ -e "$_dir" ]; then
      FPATH=$_dir:$FPATH

      autoload -Uz compinit
      compinit
    fi
  }

  unset _dir
}

iscmd git && {
  alias g='git'
}

iscmd kubectl && {
  # todo auto completion
  alias k='kubectl'
  # todo helm  completion
}

# Get week number
alias week='date +%V'

# usefull for password/secrets
random_string() {
  env LC_CTYPE=C tr -dc 'a-zA-Z0-9' </dev/urandom | head -c 32
  # tr -dc [:graph:] < /dev/urandom | head -c 32
}

osis Darwin && {
  # mac use upper uuid
  alias uuidgen="uuidgen | tr '[:upper:]' '[:lower:]'"
}

o() {
  if [ $# -eq 0 ]; then
    opath=.
  else
    opath="$@"
  fi
  # macOS
  command -v open >/dev/null && open "$opath" && return
  # Windows
  command -v cygstart >/dev/null && cygstart "$opath" && return
  command -v cygpath >/dev/null && start "$(cygpath -d "$opath")" && return
  # Windows
  command -v cmd >/dev/null && cmd /c start "$opath" && return
  # Centos
  command -v nautilus >/dev/null && nautilus --browser "$opath" && return
  # Linux Mint Cinnamon
  command -v nemo >/dev/null && nemo "$opath" && return
}

server() {
  port=${1:-8000}

  iscmd python3 && {
    (sleep 1 && o "http://localhost:${port}/") &
    python3 -m http.server "$port"
    return
  }

  iscmd python && {
    (sleep 1 && o "http://localhost:${port}/") &
    python -m SimpleHTTPServer "$port"
    return
  }

  iscmd npm && (npm -g ls --depth=0 | grep server@) >/dev/null && {
    (sleep 1 && o "http://localhost:${port}/") &
    npx server "$port"
    return
  }

  iscmd php && {
    (sleep 1 && o "http://localhost:${port}/") &
    php -S "localhost:$port"
    return
  }
}

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
  Colors: $(tput colors)
  Column: $(tput cols)
"
}

# ex: ts=4 sw=4 et filetype=sh
