#! /bin/env bash

# 检测系统
osis()
{
    # echo $OS|grep $1 -i >/dev/null
    uname -s |grep -i $1 >/dev/null
    return $?
}

# 检测 term
termis()
{
    echo $TERM |grep $1 -i >/dev/null
    return $?
}

# Command exists
iscmd()
{
    command -v $1 > /dev/null
    return $?
}

# 判断元素是否在数组中
iscontains () {
    local e
    for e in "${@:2}"; do [[ "$e" == "$1" ]] && return 0; done
    return 1
}
