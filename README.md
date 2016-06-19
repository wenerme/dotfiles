dotfiles
========
Relax dotfiles for Linux, Cygwin & Mac OSX

## 可检测的配置/Features

* Homebrew
* Linuxbrew
* Java
* Go
* npm
* nvm
* bash_completion

## 要求/Requirement

* bash 4+

## 安装/Install
```
cd ~
git init
git remote add origin https://github.com/wenerme/dotfiles
git fetch --depth=1
# Warning: this will replace exists files.
git checkout -t origin/master -f

# Replace my name and email to yours
vim ~/.gitconfig
```

## 加载顺序/Load order

```
.bashrc -> .bash_profile -> utils.sh -> log4bash.sh ->
func,exports,prompt,alias,extra,after -> rc_my_*
```

## 扩展和自定义/Customize
可在 .bashrc.d 下添加自己的扩展配置,文件名格式为 `rc_my_*`.会在 after 后加载

## 目录说明
```
.font
	包含了一些我喜欢的字体文件
.bashrc.d
	所有 bashrc 的文件都在这里
.completion.d
	包含了一部分补全脚本
```

# 配置文件说明

```
/bin/bash
	The bash executable
/etc/profile
	The systemwide initialization file, executed for login shells
/etc/bash.bash_logout
	The systemwide login shell cleanup file, executed when a login shell exits
~/.bash_profile
	The personal initialization file, executed for login shells
~/.bashrc
	The individual per-interactive-shell startup file
~/.bash_logout
	The individual login shell cleanup file, executed when a login shell exits
~/.inputrc
	Individual readline initialization file
```
From [man bash](http://linux.die.net/man/1/bash).

# 文档/Document

以下文档使用 `BASH_DOC_CAT=1 lrc` 生成

```bash
# Update docs
BASH_DOC_CAT=1 lrc > /tmp/BASH_DOC_CAT
sed -e '/^<!--\s*BEGIN-BASH-DOC/,/END-BASH-DOC/c\<!-- BEGIN-BASH-DOC -->\nHERE-BASH-DOC\n<!-- END-BASH-DOC -->' README.md -i
sed -e '/^HERE-BASH-DOC/{
	s/^HERE-BASH-DOC//g
	r /tmp/BASH_DOC_CAT
}' README.md -i
```


<!-- BEGIN-BASH-DOC -->

<!-- source(.bashrc.d/utils.sh:104) -->
## utils.sh
工具类定义


### Commands

Command | Arguments | Description | e.g.
----|----|----|----
bashdoc | | 用于接收脚本中的文档
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

# 接收文档并放在剪切板中
BASH_DOC_CAT=1 lrc | pbcopy
```

<!-- source(.bashrc.d/log4bash.sh:10) -->
## log4bash.sh

log for shell.

Based on [fredpalmer/log4bash](http://github.com/fredpalmer/log4bash).

```
log4bash - Makes logging in Bash scripting suck less
Copyright (c) Fred Palmer
Licensed under the MIT license
http://github.com/fredpalmer/log4bash
```

### Changelog
* Add log level
* use `tput colors` to test the term

### Commands
Command | Arguments | Description
----|---|---
log | message level color | Basic log command
log_speak | msg | speak out
log_debug | msg | DEBUG level
log_info | msg | INFO level
log_warn | msg | WARN level
log_error | msg | ERROR level
log_success | msg | SUCCESS level
log_captains | msg |
log_campfire | msg |
log_level | [level] | set/get log level

### Log level
Use level like this
```shell
log_level WARN # Only show WARN ERROR
log_level DEBUG # Only show DEBUG
log_level NONE # no log
log_level # display log level
```


<!-- source(.bashrc.d/rc_func.sh:3) -->

## rc_func

* `o [dir]`
  * 在资源管理器中打开指定目录,如果不指定目录则为当前目录
  * 支持 cmd,cygwin,Centos(nautilus),Mint(nemo),OS X
* mkd
  * mkdir && cd
* colorname
  * 输出 bash 颜色名字和相应数字
* 256colors
  * 输出 256 色
* 16colors
  * 输出 16 色
* server [port:-8000]
  * 在当前目录启动一个 http 服务器
  * 会尝试使用 python, npm server, php

<!-- source(.bashrc.d/rc_exports.sh:3) -->

## rx_exports

* 设置 LESS 颜色
* 设置 LS 颜色
* 默认语言为 en_US,如果能使用 zh_CN 则使用 zh_CN
* 设置 Bash 历史 控制


<!-- source(.bashrc.d/rc_after.sh:5) -->
## rc_after
* 检测 Homebrew 环境
  * 添加 bin 目录
  * 添加无前缀的 coreutils
  * 加载补全
  * 设置 ANDROID_HOME
  * 初始化 command-not-found-init


<!-- source(.bashrc.d/rc_after.sh:58) -->

* nvm
  * 检测并加载 nvm 环境
  * nvm use node
* npm
  * 检测 npm 环境
  * 添加全局 bin 目录到 `PATH`
  * 添加 `npm-exec` 别名来执行安装的命令


<!-- source(.bashrc.d/rc_after.sh:91) -->

* go
  * 检测 go 语言环境
    * 也会检测 /usr/local/go 目录,大多直接解压的会安装到这里
  * 设置 GOROOT,GOPATH
  * 添加 bin 目录

<!-- source(.bashrc.d/rc_after.sh:120) -->

* sshrc
  * 在 sshrc 下做一些后续处理
  * 为 `~/.inputrc` 设置符号链接
  * 为 `~/.gitconfig` 设置符号链接

<!-- source(.bashrc.d/rc_alias.sh:3) -->

## rc_alias

__cd__
* 定义 `..`,`...`,`....`,`.....`,`~`,`-` 来作为常用的目录跳转
* 定义 `cd-`,`cd..`,`cd...`

__ls__

* 默认启用 `-h` 使输出的 size 更可读
* 定义 `l`,`la`,`ll`,`lsd`,`lst`

__cls/clear__
使 `cls` 和 `clear` 命令可互换使用

__ifconfig/ipconfig__
* 使 `ifconfig` 和 `ipconfig` 命令可互换使用
* 在 `*nix` 在可能 `ipconfig` 已被使用,则不会替换为 `ifconfig`


__其他__

* pushcd 将当前目录入栈
* lrc 重新加载 bashrc 配置
* ports 显示所有使用的端口
* utf82gbk,gbk2utf8 编码互转
* please 使用 sudo 从新执行上一条命令
* tolower,toupper 字符转换
* random-string 生成一串随机字符串,用于作为密码什么的
* Darwin
	* saynow 报时


<!-- source(.bashrc.d/rc_my_osx.sh:5) -->
## rc_my_osx
定义我在 osx 下使用的一些配置

* 将 macvim (mvim) 映射为 gvim
* lockscreen 锁屏
* screensaver 屏保


<!-- source(.bashrc.d/rc_my_wener.sh:8) -->

## rc_my_wener
我的个人设置,主要用于检测一些环境

* Linux
	* 检测 Java 环境
	* 检测 Maven 环境
	* 检测 tomcat 环境
	* 检测 Hadoop 环境



<!-- END-BASH-DOC -->

# Misc

* 因为针对的是 bash 4+,所以使用bash-completion时要求使用[bash-completion2](https://github.com/Homebrew/homebrew-versions)
	brew 默认是 bash-completion,因为 OS 默认的 Bash 是3+的

# Reference

* [Advanced Bash-Scripting Guide](http://tldp.org/LDP/abs/html/)
* [What rc mean ?](http://unix.stackexchange.com/a/3469/47774)
