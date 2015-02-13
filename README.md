dotfiles
========

可检测的配置

*  Homebrew

## 要求

* bash 4+



## rc 加载顺序

```
.bashrc -> .bash_profile -> utils.sh -> log4bash.sh ->
func,exports,prompt,alias,extra,after -> rc_my
```

## 扩展和自定义
可在 .bashrc.d 下添加自己的扩展配置,文件名格式为 `rc_my_*`.会在 after 后加载

## 目录说明
.font
	包含了一些我喜欢的字体文件
.bashrc.d
	所有 bashrc 的文件都在这里
.completion.d
	包含了一部分补全脚本

个人很喜欢的一些命令
-----------------

o 打开文件管理器, 支持 windows, mac os, gnome 等
g alias for git

../.../- 等目录命令  可直接省略 cd 输入

cls <-> clear

gvimr = gvim --remote

lrc = . ~/.bashrc 
	从新加载配置文件

lst 以树形显示, 在没有 tree 命令的时候很有用

其他命令可查看 .bashrc_alias 和 .bashrc_func


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
from [man bash](http://linux.die.net/man/1/bash).

# Document

# Misc

* 因为针对的是 bash 4+,所以使用bash-completion时要求使用[bash-completion2](https://github.com/Homebrew/homebrew-versions)
	brew 默认是 bash-completion,因为 OS 默认的 Bash 是3+的

# Reference

* [Advanced Bash-Scripting Guide](http://tldp.org/LDP/abs/html/)
* [What rc mean ?](http://unix.stackexchange.com/a/3469/47774)