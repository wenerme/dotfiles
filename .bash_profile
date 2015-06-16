#!/usr/bin/env bash

[ "$HOME" = "$PWD" ] || {
command -v osis &>/dev/null && log_info Load from .bash_profile && log_info Will CD to HOME for Loading RC, PWD is `pwd`
pushd "$HOME" >/dev/null
CD_TO_HOME=yes
}

# 由于不确定加载顺序 所以为了保证两个都加载,就做了这样一个处理
[ "$BASHRC_LOADED" == 'yes' ] || { . .bashrc; unset BASHRC_LOADED; }

# vim: set sw=4 ts=4 sts=4 et tw=78 foldmarker={{,}} foldlevel=0 foldmethod=marker:
