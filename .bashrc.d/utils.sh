#!/usr/bin/env bash

# 检测系统
osis()
{
	local n=0
	if [[ "$1" = "-n" ]]; then n=1;shift; fi

    # echo $OS|grep $1 -i >/dev/null
    uname -s |grep -i "$1" >/dev/null

	return $(( $n ^ $? ))
}

# 检测 term
termis()
{
	local n=0
	if [[ "$1" = "-n" ]]; then n=1;shift; fi

    echo $TERM |grep $1 -i >/dev/null

    return $(( $n ^ $? ))
}

# Command exists
iscmd()
{
	local n=0
	if [[ "$1" = "-n" ]]; then n=1;shift; fi

    command -v $1 > /dev/null

    return $(( $n ^ $? ))
}

# 判断元素是否在数组中
iscontains ()
{
	local n=0
	if [[ "$1" = "-n" ]]; then n=1;shift; fi

    local e
    for e in "${@:2}"; do [[ "$e" == "$1" ]] && return $(( $n ^ 0 )); done

    return $(( $n ^ 1 ))
}


# Document

echo -n <<'DOC-HERE'
## utils.sh
辅助操作


### Commands
command | args | description
----|---|---
osis| -n |判断操作系统
termis| -n | 判断 term 类型
iscmd | -n | 判断是否为可执行命令
iscontains | -n | 判断数组是否包含指定元素

* -n for negative

### Examples
```
iscmd cls || alias cls="echo -en '\ec'"
iscmd clear ||  alias clear="cls"

osis Cygwin && {
	# Cygwin stuff
}
osis Linux && {
	# Linux stuff
}
osis Darwin && {
	# Mac OS X stuff
}

```
DOC-HERE

