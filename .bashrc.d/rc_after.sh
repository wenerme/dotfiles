#! /usr/bin/env bash
# For test
command -v osis &>/dev/null || { . utils.sh ; . log4bash.sh; log_level DEBUG; }

# After all, we will try to detect the env and setup some otherthings

# Homebrew {{

# Detect linux brew
[ -e ~/.linuxbrew/bin ] && try_prepend_path ~/.linuxbrew/bin && log_info Detect linuxbrew/bin add to PATH $_

# Detect brew
iscmd brew &&
{
log_debug Homebrew detected

[ -e /usr/local/opt/coreutils ] &&
{
    log_debug Prefer to use homebrew\'s coreutils,not g prefix
    try_prepend_path /usr/local/opt/coreutils/libexec/gnubin
    try_prepend_manpath /usr/local/opt/coreutils/libexec/gnuman
}

# Try load bash_completion
try_source $(brew --prefix)/etc/bash_completion && log_info Load bash_completion $_
try_source $(brew --prefix)/share/bash-completion/bash_completion && log_info Load bash_completion $_


# Load formula completion
[ -e `brew --prefix`/etc/bash_completion.d ] && find -L `brew --prefix`/etc/bash_completion.d -maxdepth 1 -type f | while read -r file; do
	log_debug Load completion ${file}
    . ${file} 2>&1 | {
        read -d "\0" -t 0.01 error
		[ -z "$error" ] || log_warn Load completion ${file} failed: "\n${error}"
    }
done

[[ -z "$ANDROID_HOME" ]] && isbrewed android && export ANDROID_HOME=/usr/local/opt/android-sdk

# Init command not found
if brew command command-not-found-init >/dev/null 2>&1; then eval "$(brew command-not-found-init)"; fi

unset -v file error
}
# }} Homebrew


# nvm {{
[ -e ~/.nvm/ ] &&
{
	log_debug nvm detected
	export NVM_DIR=~/.nvm
	source $(brew --prefix nvm)/nvm.sh
  iscmd node || nvm use node > /dev/null && log_debug nvm use node
}
# }} nvm

# npm {{
iscmd npm &&
{
	log_debug npm detected

  alias npm-exec='PATH=$(npm bin):$PATH'
	log_info Add npm/bin `npm config get prefix`/bin to PATH
	try_prepend_path "`npm config get prefix`/bin"
}
# }} npm


# go {{

# If we don't have go command detected, try /usr/local/go
! iscmd go && [ -e /usr/local/go ] &&
{
  log_debug Detect go at /usr/local/go
  export GOROOT=/usr/local/go
  try_prepend_path $GOROOT/bin
}

iscmd go &&
{
	log_debug Go detected
	[[ -z "$GOPATH" ]]  && export GOPATH=~/go && log_info Set GOPATH to ~/go

	log_info Add $GOPATH/bin to PATH
	try_prepend_path $GOPATH/bin
}
# }} go

# by SSHRC
[ "$SSHHOME" ] &&
{
  # Will replace broken inputrc
  [ -e ~/.inputrc ] || ln -fs $SSHHOME/.sshrc.d/.inputrc ~/.inputrc
}


log_debug After rc_after,the PATH become "$PATH"

# vim: set sw=4 ts=4 sts=4 et tw=78 foldmarker={{,}} foldlevel=0 foldmethod=marker:
