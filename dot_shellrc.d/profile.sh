#!/bin/sh

isdebug() {
  return 1
}

log() {
  isdebug && {
    printf "[$(date +%Y-%m-%dT%H:%M:%S)] %s\n" "$*"
    return
  }
}

log "Loading shell profile..."

# Add directories to PATH if they exist
trypath() {
  _force=0
  if [ "$1" = "-f" ]; then
    _force=1
    shift
  fi
  i=$#
  while [ $i -gt 0 ]; do
    eval "dir=\${$i}"

    if [ -d "$dir" ]; then
      if [ $_force -eq 1 ]; then
        log "Adding(forced) $dir to PATH"
        PATH="$dir:$PATH"
      else
      case ":$PATH:" in
      *":$dir:"*)
        log "Directory $dir is already in PATH"
      ;;
      *)
        log "Adding $dir to PATH"
        PATH="$dir:$PATH" ;;
      esac
      fi

    fi
    i=$((i - 1))
  done
  if [ $_force -eq 1 ]; then
    PATH="$(echo "$PATH" | tr : '\n' | awk '!x[$0]++' | tr '\n' ':')"
  fi
  export PATH
}

trysource() {
  for _f in "$@"; do
    [ -f "$_f" ] && . "$_f"
  done
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

isbrewed() {
  iscmd brew && brew list "$1" >/dev/null 2>&1
}

isinteractive() {
  case $- in
  *i*) return 0 ;;
  *) return 1 ;;
  esac
}

# e.g. isshell bash && echo Bash
isshell() {
  [ $# -eq 0 ] && return 1
  shell="$1"
  case "$shell" in
    bash) [ -n "$BASH_VERSION" ] ;;
    zsh) [ -n "$ZSH_VERSION" ] ;;
    fish) [ -n "$FISH_VERSION" ] ;;
    *)
      curr_shell="$(ps -p $$ -ocomm= | awk -F/ '{print $NF}')"
      [ "$curr_shell" = "$shell" ]
      ;;
  esac
}

#region Brew
trypath -f "/opt/homebrew/bin"

iscmd brew && {
  BREW_PREFIX="$(brew --prefix)"
  export BREW_PREFIX
  trypath "$BREW_PREFIX/sbin" "${BREW_PREFIX}/opt/bash/bin" "${BREW_PREFIX}"/opt/{curl,coreutils,make,grep,findutils,gnu-{sed,which,time}}/libexec/gnubin "${BREW_PREFIX}/opt/curl/bin"
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

# bun completions
trysource "$HOME/.bun/_bun"
#endregion

#region Personalized

export DO_NOT_TRACK=1

# ls -d $(brew --prefix)/opt/*/libexec/gnubin
# libexec is to compact with macOS
trypath ~/bin ~/.local/bin ~/go/bin

#endregion

#region Interactive
isinteractive && {
  trysource ~/.shellrc.d/rc.sh
  # debug
  # xargs -d need gnu xargs
  # alias lspath='echo $PATH | xargs -n 1 -d ':'  echo'
}
#endregion
