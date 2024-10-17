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

isinteractive() {
  case $- in
  *i*) return 0 ;;
  *) return 1 ;;
  esac
}

# e.g. isshell bash && echo Bash
isshell() {
  case $0 in
  bash) [ -n "$BASH_VERSION" ] ;;
  zsh) [ -n "$ZSH_VERSION" ] ;;
  fish) [ -n "$FISH_VERSION" ] ;;
  *) return 1 ;;
  esac
}

#region Brew
trypath "/opt/homebrew/bin"
iscmd brew && {
  BREW_PREFIX="$(brew --prefix)"
  export BREW_PREFIX
  trypath "$BREW_PREFIX/sbin" "${BREW_PREFIX}/opt/bash/bin" "${BREW_PREFIX}"/opt/{coreutils,make,grep,findutils,gnu-{sed,which,time}}/libexec/gnubin
}
#endregion

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
    # UCRT64 is recommended for Windows 10+
    export MSYSTEM=UCRT64
    trysource /etc/profile
  }
  trysource "$HOME/bin/win-sudo/s/path.sh"
}
#endregion

#region JDK
[ -e "$HOME/.sdkman" ] && {
  export SDKMAN_DIR="$HOME/.sdkman"
  [ -e "$HOME/.sdkman/bin/sdkman-init.sh" ] && . "$HOME/.sdkman/bin/sdkman-init.sh"
}
#endregion

#region NodeJS
[ -e "$HOME/.nvm" ] && {
  export NVM_DIR="$HOME/.nvm"
  trysource "$NVM_DIR/nvm.sh"
}

iscmd npm && {
  trypath "$(npm config -g get prefix)/bin"
}
#endregion

#region Personalized

# ls -d $(brew --prefix)/opt/*/libexec/gnubin
# libexec is to compact with macOS
trypath ~/bin ~/.local/bin ~/go/bin

#endregion

#region Interactive
[[ "$-" == *i* ]] && {
  trysource ~/.shellrc.d/rc.sh
  # debug
  alias lspath='echo $PATH | xargs -n 1 -d ':'  echo'
}
#endregion
