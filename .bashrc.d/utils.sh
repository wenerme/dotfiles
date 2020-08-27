#!/usr/bin/env bash

# for test
# command -v log_debug &>/dev/null || { . log4bash.sh; log_level DEBUG; }

# Use this function to accept the docs
# e.g. BASH_DOC_GEN=en lrc > doc.md # This will generate all docs to doc.md
bashdoc()
{
	# https://www.gnu.org/software/bash/manual/html_node/Bash-Variables.html
	[ "$BASH_DOC_GEN" != "" ] && ( [ "$1" == "" -o "$BASH_DOC_GEN" == "$1" ] ) && {
		# printf '%s - %s - %s\n' "${FUNCNAME[@]}" "${BASH_SOURCE[@]}" "${BASH_LINENO[@]}"
		echo "<!-- ${FUNCNAME[-2]}(${BASH_SOURCE[-2]}:${BASH_LINENO[-3]}) -->"
		cat
		echo
	}
}

bashdoc en <<'DOC-HERE'
## utils.sh
Utils used for whole configs.
### Docs

```bash
# Generate doc for en
BASH_DOC_GEN=en lrc > doc_en.md
```

	# You can write doc in scripts like this, if no locale, this doc will used for all locale
	bashdoc en <<'DOC-HERE'
	# Header
	Content
	DOC-HERE

DOC-HERE


# Check OS Type
osis()
{
	local n=0
	if [[ "$1" = "-n" ]]; then n=1;shift; fi

    # echo $OS|grep $1 -i >/dev/null
    uname -s |grep -i "$1" >/dev/null

	return $(( $n ^ $? ))
}

# Check $TERM Type
termis()
{
	local n=0
	if [[ "$1" = "-n" ]]; then n=1;shift; fi

    echo $TERM |grep $1 -i >/dev/null

    return $(( $n ^ $? ))
}

# Check Command exists
iscmd()
{
	local n=0
	if [[ "$1" = "-n" ]]; then n=1;shift; fi

    command -v $1 > /dev/null

    return $(( $n ^ $? ))
}

# Check is element in array
iscontains ()
{
	local n=0
	if [[ "$1" = "-n" ]]; then n=1;shift; fi

    local e
    for e in "${@:2}"; do [[ "$e" == "$1" ]] && return $(( $n ^ 0 )); done

    return $(( $n ^ 1 ))
}

# Prepend Given Path To $PATH
try_prepend_path()
{
	for p in "$@"
	do
		# Ensure prepent
		# export PATH=$(unique_path "$p:$PATH")

    if [[ "$PATH" =~ "$p" ]]; then continue; fi
    log_info Prepand path \'$p\'
    export PATH="$p:$PATH"

		# (echo $PATH | grep "$p:" > /dev/null ) &&
		# 	log_debug Ignore prepand \'$p\',alread in PATH ||
		# 	{ log_info Prepand path \'$p\' ;export PATH="$p:$PATH"; }
	done
}

# Prepend Given Path To $MANPATH
try_prepend_manpath()
{
	for p in "$@"
	do
		# export MANPATH=$(unique_path "$p:$MANPATH")

    if [[ "$MANPATH" =~ "$p" ]]; then continue; fi
    log_info Prepand manpath \'$p\'
    export MANPATH="$p:$PATH"

		# (echo "$MANPATH" | grep "$p:" > /dev/null ) &&
		# 	log_debug Ignore prepand \'$p\',alread in MANPATH ||
		# 	{ log_info Prepand manpath \'$p\' ;export MANPATH="$p:$MANPATH"; }
	done
}

# Remove duplicated path
unique_path()
{
    local old=${1:-$PATH}:
    local neo
    local x
    while [ -n "$old" ]; do
        x=${old%%:*}       # the first remaining entry
        case $neo: in
          *:"$x":*) ;;         # already there
          *) neo=$neo:$x;;    # not there yet
        esac
        old=${old#*:}
    done
    neo=${neo#:}
    echo ${neo}
}

try_source()
{
	if [ -f "$1" ]; then
		log_debug Source "$1"
		. "$1"
		return 0
	fi
	log_debug Source failed, "$1" not a file
	return 1
}

# Detect have this formula
isbrewed()
{
	iscmd brew || return 1
  # brew use 11s, -d check use 5s for lrc
	# brew --prefix $1 1>/dev/null 2>/dev/null
	[ -d "/usr/local/Cellar/$1" ]
}

# brew --prefix <formula> very slow
brew-prefix()
{
  [ -z "$1" ] && brew --prefix || echo $(brew --prefix)/opt/$1
}

bashdoc en <<'DOC-HERE'

### Commands

Command | Arguments | Description | e.g.
----|----|----|----
bashdoc | | Used to accept docs | `bashdoc <<<'#Title Here'`
osis| -n | OS check | `osis cygwin`, `osis -n linux`
termis| -n | `$TERM` typ check | `termis xterm`
iscmd | -n | Command chech | `iscmd git`,`iscmd -n brew`
iscontains | -n | Check element in array
isbrewed | | Check formula is installed | `isbrewed go`
try_prepend_path | | Ensure prepend givend path to `$PATH` | `try_prepend_path ~/bin`
try_prepend_manpath | | Ensure prepend givend path to `$MANPATH` | `try_prepend_path ~/man`
try_source | | 尝试 source 文件 | `try_source ~/my-bash`

* `-n` for negative

### Examples
```
iscmd cls || alias cls="echo -en '\ec'"
iscmd -n clear &&  alias clear="cls"

osis Cygwin && {
	# Cygwin stuff
}
osis Linux && {
	# Linux stuff
}
osis Darwin && {
	# Mac OS X stuff
}

	bashdoc <<'DOC-HERE'
	# Markdown title

	What dose `this` mean.
	DOC-HERE

# Generate docs
BASH_DOC_GEN=en lrc
```
DOC-HERE

bashdoc zh <<'DOC-HERE'
## utils.sh
工具类定义

### Commands

Command | Arguments | Description | e.g.
----|----|----|----
bashdoc | | 用于接收脚本中的文档 | `bashdoc <<<'#Title Here'`
osis| -n |判断操作系统 | `osis cygwin`, `osis -n linux`
termis| -n | 判断 term 类型 | `termis xterm`
iscmd | -n | 判断是否为可执行命令 | `iscmd git`,`iscmd -n brew`
iscontains | -n | 判断数组是否包含指定元素
isbrewed | | 判断给定的 formula 是否被安装 | `isbrewed go`
try_prepend_path | | 如果给定路径不在 PATH 中,则添加 | `try_prepend_path ~/bin`
try_prepend_manpath | | 如果给定路径不在  MANPATH 中,则添加 | `try_prepend_path ~/man`
try_source | | 尝试 source 文件 | `try_source ~/my-bash`

* `-n` for negative

### Examples
```
iscmd cls || alias cls="echo -en '\ec'"
iscmd -n clear &&  alias clear="cls"

osis Cygwin && {
	# Cygwin stuff
}
osis Linux && {
	# Linux stuff
}
osis Darwin && {
	# Mac OS X stuff
}

	bashdoc <<'DOC-HERE'
	# Markdown title

	What dose `this` mean.
	DOC-HERE

# Generate docs
BASH_DOC_GEN=en lrc
```
DOC-HERE
