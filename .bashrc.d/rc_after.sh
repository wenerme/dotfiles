#!/usr/bin/env bash
# For test
command -v osis &>/dev/null || { . utils.sh ; . log4bash.sh; log_level DEBUG; }

# completion {{
# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
[ -e "$HOME/.ssh/config" ] &&
complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2 | tr ' ' '\n')" scp sftp ssh

# Add tab completion for `defaults read|write NSGlobalDomain`
# You could just use `-g` instead, but I like being explicit
complete -W "NSGlobalDomain" defaults

# Add `killall` tab completion for common apps
complete -o "nospace" -W "Contacts Calendar Dock Finder Mail Safari iTunes SystemUIServer Terminal Twitter" killall

# If possible, add tab completion for many more commands
[ -f /etc/bash_completion ] && source /etc/bash_completion
# }} completion

# Homebrew {{
iscmd brew &&
{
log_debug Detect Homebrew
# I prefer gnu's
(echo $PATH |\
    grep "/usr/local/opt/coreutils/libexec/gnubin:" > /dev/null )|| \
    export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
( echo ${MANPATH} |\
    grep "/usr/local/opt/coreutils/libexec/gnuman:" > /dev/null ) || \
    export MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"

# Load bash_completion
if [ -f $(brew --prefix)/etc/bash_completion ]; then
    . $(brew --prefix)/etc/bash_completion
fi

# Load formula completion
find -L `brew --prefix`/etc/bash_completion.d -type f -print0 | while IFS= read -r -d $'\0' line; do
    . ${line}
done
}
# }} Homebrew



osis Darwin &&
{
    log_debug Detect mac osx
}


osis Linux &&
{
	# 检测 java 环境
	[ -e /usr/java/default ] &&
	{
		export JAVA_HOME=/usr/java/default
		export PATH=$PATH:$JAVA_HOME/bin
		export CLASSPATH=$JAVA_HOME/lib

		# 检测是否有 maven
		[ -e /opt/maven ] &&
		{
			export M2_HOME=/opt/maven
			export M2=$M2_HOME/bin
			export PATH=$M2:$PATH
		}

		[ -e /opt/tomcat/ ] &&
		{
			export CATALINA_HOME=/opt/maven
		}

		# 检测是否有 hadoop
		[ -e /opt/hadoop ] &&
		{
			export HADOOP_HOME=/opt/hadoop
			export HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_HOME/lib/native
			export HADOOP_OPTS="-Djava.library.path=$HADOOP_HOME/lib"
			export PATH=$PATH:$HADOOP_HOME/bin
		    [ -e /opt/zookeeper/ ] &&
            {
                export ZOOKEEPER_HOME=/opt/zookeeper
            }
		    [ -e /opt/hive/ ] &&
            {
                export HIVE_HOME=/opt/hive
            }
		    [ -e /opt/zookeeper/ ] &&
            {
                export HBASE_HOME=/opt/hbase
            }
		}
	}
}


osis Cygwin &&
{
	# ====================
	# PATH
	# ====================
	PATH=/tools/bin:$PATH
	PATH=$PATH:/tools/bin/cygwin_rt
	# 添加VIM和sysinternal
	VIM=/env/vim
	VIMRUNTIME=/env/vim/vim73
	PATH=$PATH:/tools/SysinternalsSuite:$VIMRUNTIME
	# 添加Git到PATH
	# PATH=$PATH:/env/Git/bin
	# 添加Python
	PATH=$PATH:/d/Python33/
	# 添加Emacs/bin
	# PATH=$PATH:/env/emacs/bin
	# 添加nirsoft系列工具到PATH
	PATH=$PATH:/tools/nirsoft

	# ====================
	# LUA
	# ====================
	# 设置lua的包路径
	# 因为包中的一些文件需要依靠一些dll文件 所以需要添加到路径
	PATH=$PATH:$CHOME/language/lua/package
	# 这里是转换为的Window路径 因为lua在cygwin下支持不好 加载模块时总是出现问题
	alias lua="cygstart cmd /k lua"
	LUA_PATH="$(cygpath -d ~/language/lua/package/)?.lua;;"
	LUA_CPATH="$(cygpath -d ~/language/lua/package/)?.dll;;"
	export LUA_PATH
	export LUA_CPATH

	# ====================
	# Node.js
	# ====================
	PATH=$PATH:/env/nodejs
	# ====================
	# Nginx
	# ====================
	PATH=$PATH:/env/nginx

	# ====================
	# OpenCV
	# ====================
	# 运行时需要的库
	PATH=$PATH:'/usr/local/opencv2.4.5/bin'
	export OpenCV_DIR='/usr/local/opencv2.4.5'
	# ====================
	# PKG-CONFIG
	# ====================
	# export PKG_CONFIG_PATH=/lib/pkgconfig:/usr/local/lib/pkgconfig:/usr/local/opencv2.4.5/lib/pkgconfig

    # alias gvim='/env/vim/vim74/gvim'
    # alias gvim='cmd /c "set SHELL=cmd & `cygpath -d /env/vim/vim74/gvim.exe`"'
    # alias vim='cmd /c "set SHELL=cmd & start vim"'

    # cygwin下cmd不是很好用 这样可以弹出一个cmd
    alias cmdk='cygstart cmd /k'
    alias cmdc='cygstart cmd /c'

    # mingw 版的gcc
    alias mgcc='i686-w64-mingw32-gcc'

	# ecplise
	alias eclipse='/env/eclipse64/standard/eclipse'
	MINI_ENV_PATH=`cygpath 'G:\minienv\env'`

    # JAVA_HOME=`cygpath 'C:\Program Files\Java\jdk1.7.0_21'`
    # MAVEN_HOME=$MINI_ENV_PATH'\dev\maven'
    # ANT_HOME=$MINI_ENV_PATH'\dev\ant'
    # CATALINA_HOME=$MINI_ENV_PATH'\server\tomcat80'

    # PATH=$PATH;$JAVA_HOME\\bin;$MAVEN_HOME\\bin;$ANT_HOME\\bin;$CATALINA_HOME\\bin

    PATH=$PATH:/env/vim/vim74

    # export PATH, JAVA_HOME, MAVEN_HOME, ANT_HOME, CATALINA_HOME, MINI_ENV_PATH
    export NODE_PATH=`cygpath -d /env/nodejs/node_modules/`
    export PATH
}
