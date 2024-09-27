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

trypath /opt/homebrew/bin /opt/homebrew/sbin

iscmd brew && {
  BREW_PREFIX="$(brew --prefix)"
  export BREW_PREFIX
  trypath "${BREW_PREFIX}/opt/bash/bin" "${BREW_PREFIX}"/opt/{coreutils,make,grep,findutils,gnu-{sed,which,time}}/libexec/gnubin
}


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
    [ -s "$HOME/.sdkman/bin/sdkman-init.sh" ] && . "$HOME/.sdkman/bin/sdkman-init.sh"
}
#endregion

#region NodeJS
[ -s "$HOME/.nvm" ] && {
  export NVM_DIR="$HOME/.nvm"
  trysource "$NVM_DIR/nvm.sh"
  # "/usr/local/opt/nvm/etc/bash_completion.d/nvm"
}
#endregion

#region Personalized

# ls -d $(brew --prefix)/opt/*/libexec/gnubin
# echo $PATH | gxargs -n 1 -d ':'  echo
# libexec is to compact with macOS
trypath ~/bin ~/.local/bin ~/go/bin

#endregion

unset trypath
unset trysource
