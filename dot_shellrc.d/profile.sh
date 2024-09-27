#!/bin/sh

# Add directories to PATH if they exist
trypath() {
  i=$#
  while [ $i -gt 0 ]; do
    eval "dir=\${$i}"
    if [ -d "$dir" ]; then
      case ":$PATH:" in
      *":$dir:"*) ;;
      *) PATH="$dir:$PATH" ;;
      esac
    fi
    i=$((i - 1))
  done
  export PATH
}

trysource() {
  if [ -f "$1" ]; then
    . "$1"
  fi
}

# Check OS Type by `uname -s`
osis() {
  n=0
  if [ "$1" = "-n" ]; then
    n=1
    shift
  fi
  uname -s | grep -i "$1" >/dev/null
  return $((n ^ $?))
}

iscmd() {
  # POSIX Shell &> /dev/null -> > /dev/null 2>&1
  command -v "$1" >/dev/null 2>&1
}

trypath /opt/homebrew/bin /opt/homebrew/sbin

iscmd brew && {
  BREW_PREFIX="$(brew --prefix)"
  export BREW_PREFIX
  trypath "${BREW_PREFIX}/opt/bash/bin" "${BREW_PREFIX}"/opt/{coreutils,make,grep,findutils,gnu-{sed,which,time}}/libexec/gnubin
}

# ls -d $(brew --prefix)/opt/*/libexec/gnubin
# echo $PATH | gxargs -n 1 -d ':'  echo
# libexec is to compact with macOS
trypath ~/bin ~/.local/bin ~/go/bin

#region macOS
osis Darwin && {
  # Jetbrains Toolbox
  trypath "$HOME/Library/Application Support/JetBrains/Toolbox/scripts"
  # OrbStack
  trypath "$HOME/.orbstack/bin"
}
#endregion

#region Windows MSYS
osis _NT && {
  [ "$MSYSTEM" = "MSYS" ] && {
    export MSYSTEM=MINGW32
    trysource /etc/profile
  }
}
#endregion

unset trypath
unset trysource
