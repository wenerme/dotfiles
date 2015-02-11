#!/usr/bin/env bash

bash_doc()
{
# reset file
if [ $# -gt 0 ]
then
	[ "$1" = "reset" ] && rm /tmp/bash_doc_temporary 2> /dev/null
return
fi

local IN
read -t 0.001 -r -d "\0" IN
if [ -z "$IN" ]; then
	echo do cat
	cat /tmp/bash_doc_temporary 2> /dev/null
else
	echo "$IN" >> /tmp/bash_doc_temporary
fi
}
bash_doc reset

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


# Document

bash_doc <<EOF
## utils.sh
工具类
### bash_doc
将输入的内存暂存,主要用于 shell 中的文档创建,示例

```
$ bash_doc <<DOC
some doc for a
DOC
$ bash_doc <<DOC
some doc for b
DOC

$ bash_doc
some doc for a
some doc for b
$ bash_doc reset # clean all
```

### osis
判断操作系统

### termis
判断 term

### iscmd
判断是否为可执行命令
### iscontains
判断是否包含指定元素
EOF