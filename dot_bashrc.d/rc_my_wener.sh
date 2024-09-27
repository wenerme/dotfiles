#! /usr/bin/env bash
# For test
command -v osis &>/dev/null || { . utils.sh ; . log4bash.sh; log_level DEBUG; }

# wener's personal configuration
# XD

[ "$USER" == "wener" ] || log_info Ignore wener config && return

bashdoc <<'DOC-HERE'

## rc_my_wener
我的个人设置,主要用于检测一些环境

* Linux
	* 检测 Java 环境
	* 检测 Maven 环境
	* 检测 tomcat 环境
	* 检测 Hadoop 环境

DOC-HERE

# 尝试加载其他的配置
try_source "$HOME/.iterm2_shell_integration.bash"

# Google cloud sdk
# ============
[ -e ~/google-cloud-sdk ] &&
{
    log_info Detect google cloud sdk, will source completion and path
    source ~/google-cloud-sdk/completion.bash.inc
    source ~/google-cloud-sdk/path.bash.inc
}

# Lagecy under Linux
# ============
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

# Lagecy under Windows
# ============
osis Cygwin &&
{
	log_debug Cygwin detected

    # cygwin下cmd不是很好用 这样可以弹出一个cmd
    alias cmdk='cygstart cmd /k'
    alias cmdc='cygstart cmd /c'

    # mingw 版的gcc
    iscmd i686-w64-mingw32-gcc && alias mgcc='i686-w64-mingw32-gcc'


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

[ "$$" != "$BASHPID" ] && log_warn Not in main process, $$ - $BASHPID
