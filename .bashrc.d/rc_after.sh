#! /usr/bin/env bash
# For test
command -v osis &>/dev/null || { . utils.sh ; . log4bash.sh; log_level DEBUG; }

bashdoc <<'DOC-HERE'
## rc_after
* 检测 Homebrew 环境
  * 添加 bin 目录
  * 添加无前缀的 coreutils
  * 加载补全
  * 设置 ANDROID_HOME
  * 初始化 command-not-found-init

DOC-HERE

# After all, we will try to detect the env and setup some otherthings

# Homebrew {{

# Detect linux brew
[ -e ~/.linuxbrew/bin ] && { try_prepend_path ~/.linuxbrew/bin;try_prepend_path ~/.linuxbrew/sbin; } && log_info Detect linuxbrew/[s]bin add to PATH $_

# Detect brew
iscmd brew &&
{
log_debug Homebrew detected

[ -e /usr/local/opt/coreutils ] &&
{
    log_debug Prefer to use homebrew\'s coreutils,not g prefix
    try_prepend_path $(brew --prefix coreutils)/libexec/gnubin
    try_prepend_manpath $(brew --prefix coreutils)/libexec/gnuman
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

bashdoc <<'DOC-HERE'

* nvm
  * 检测并加载 nvm 环境
  * nvm use node
* npm
  * 检测 npm 环境
  * 添加全局 bin 目录到 `PATH`
  * 添加 `npm-exec` 别名来执行安装的命令

DOC-HERE

# nvm {{
iscmd brew && [ -e ~/.nvm/ ] &&
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

bashdoc <<'DOC-HERE'

* go
  * 检测 go 语言环境
    * 也会检测 /usr/local/go 目录,大多直接解压的会安装到这里
  * 设置 GOROOT,GOPATH
  * 添加 bin 目录
DOC-HERE

# go {{

# If we don't have go command detected, try /usr/local/go
iscmd -n go && [ -e /usr/local/go ] &&
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



# go {{
# Detect java versions, setup some homes
[[ -f /usr/libexec/java_home ]] && /usr/libexec/java_home &>/dev/null 2>&1 &&
{
	log_debug Java detected
	[[ -z "$JAVA_HOME" ]] && export JAVA_HOME=`/usr/libexec/java_home` &&
		log_info Set JAVA_HOME=`/usr/libexec/java_home`

	for v in 1.5 1.6 1.7 1.8 1.9;
	do
		/usr/libexec/java_home -v ${v} &>/dev/null 2>&1 &&
		{
			p=`/usr/libexec/java_home -v ${v}`
			log_info Set "JAVA_${v/./_}_HOME"="$p"
			export "JAVA_${v/./_}_HOME"="$p"
		}
	done

	[[ -z "$M2" ]] && [[ -e ~/.m2 ]] && { log_info Detect M2;export M2=~/.m2; }

	# Detect some common java tools
	# Detect M2_HOME, no need
	isbrewed maven && [[ -z "$M2_HOME" ]] && false &&
	{
		# 如果 brew 没有该包,则会设置为空
		export M2_HOME=`brew --prefix maven 2>/dev/null`
		# 如果设置失败,则删除该变量
		[[ -z "$M2_HOME" ]] && unset -v M2_HOME || log_info Set M2_HOME=${M2_HOME}
	}
	# Detect HADOOP_HOME
	isbrewed hadoop && [[ -z "$HADOOP_HOME" ]] &&
	{
		export HADOOP_HOME=`brew --prefix hadoop 2>/dev/null`
		[[ -z "$HADOOP_HOME" ]] && unset -v HADOOP_HOME || log_info Set HADOOP_HOME=${HADOOP_HOME}
	}
	# Detect ZOOKEEPER_HOME
	isbrewed zookeeper && [[ -z "$ZOOKEEPER_HOME" ]] &&
	{
		export ZOOKEEPER_HOME=`brew --prefix zookeeper 2>/dev/null`
		[[ -z "$ZOOKEEPER_HOME" ]] && unset -v ZOOKEEPER_HOME || log_info Set ZOOKEEPER_HOME=${ZOOKEEPER_HOME}
	}

	isbrewed groovy && [[ -z "$GROOVY_HOME" ]] &&
	{
		export GROOVY_HOME=/usr/local/opt/groovy/libexec
		[[ -z "$GROOVY_HOME" ]] && unset -v GROOVY_HOME || log_info Set ZOOKEEPER_HOME=${ZOOKEEPER_HOME}
	}

	unset -v v p
}
# }} java

bashdoc <<'DOC-HERE'
* direnv
  * `eval "$(direnv hook bash)"`
DOC-HERE
# 初始化 direnv
iscmd direnv &&
{
  eval "$(direnv hook bash)"
}

bashdoc <<'DOC-HERE'

* sshrc
  * 在 sshrc 下做一些后续处理
  * 为 `~/.inputrc` 设置符号链接
  * 为 `~/.gitconfig` 设置符号链接
DOC-HERE

# by SSHRC
[ "$SSHHOME" ] &&
{
  # Will replace broken inputrc
  [ -e ~/.inputrc ] || ln -fs $SSHHOME/.sshrc.d/.inputrc ~/.inputrc
  [ -e ~/.gitconfig ] || ln -fs $SSHHOME/.sshrc.d/.gitconfig ~/.gitconfig
}


log_debug After rc_after,the PATH become "$PATH"

# vim: set sw=4 ts=4 sts=4 et tw=78 foldmarker={{,}} foldlevel=0 foldmethod=marker:
