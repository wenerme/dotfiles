#!/usr/bin/env bash

# 由于不确定加载顺序 所以为了保证两个都加载,就做了这样一个处理
[ "$BASHRC_LOADED" == 'yes' ] || 
{
    source .bash_profile
    return
}


# vim: set sw=4 ts=4 sts=4 et tw=78 foldmarker={{,}} foldlevel=0 foldmethod=marker:
