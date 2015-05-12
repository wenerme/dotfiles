#! /usr/bin/env bash
# For test
command -v osis &>/dev/null || { . utils.sh ; . log4bash.sh; log_level DEBUG; }

# After all, we will try to detect the env and setup some otherthing

# Homebrew {{
iscmd brew &&
{
log_debug Homebrew detected

log_debug Prefer to use homebeww\'s coreutils,not g prefix
try_prepend_path /usr/local/opt/coreutils/libexec/gnubin
try_prepend_manpath /usr/local/opt/coreutils/libexec/gnuman

# Try load bash_completion
try_source $(brew --prefix)/etc/bash_completion && log_info Load bash_completion $_
try_source $(brew --prefix)/share/bash-completion/bash_completion && log_info Load bash_completion $_

# Load formula completion
find -L `brew --prefix`/etc/bash_completion.d -maxdepth 1 -type f | while read -r file; do
	log_debug Load completion ${file}
    . ${file} 2>&1 | {
        read -d "\0" -t 0.01 error
		[ -z "$error" ] || log_warn Load completion ${file} failed: "\n${error}"
    }
done
unset -v file error
}
# }} Homebrew

# npm {{
iscmd npm &&
{
	log_debug npm detected

	log_info Add npm/bin to PATH
	try_prepend_path "~/go/bin"
}
# }} npm


# go {{
iscmd go &&
{
	log_debug go detected

	log_info Set GOPATH to ~/go
	export GOPATH=~/go

	log_info Add $GOPATH/bin to PATH
	try_prepend_path $GOPATH/bin
}
# }} go


# vim: set sw=4 ts=4 sts=4 et tw=78 foldmarker={{,}} foldlevel=0 foldmethod=marker:

