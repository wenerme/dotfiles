#!/bin/sh

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
