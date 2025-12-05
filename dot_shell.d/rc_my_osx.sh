#! /usr/bin/env bash
# For test
command -v osis &>/dev/null || { . utils.sh ; . log4bash.sh; log_level DEBUG; }

bashdoc zh <<'DOC-HERE'
## rc_my_osx
定义我在 osx 下使用的一些配置

* 将 macvim (mvim) 映射为 gvim
* lockscreen - 锁屏
* screensaver - 屏保
* pbsort - 剪切板内容排序

DOC-HERE

osis Darwin &&
{
  log_debug Mac osx detected
	iscmd mvim && iscmd -n gvim && alias gvim="mvim"
  alias pbsort="pbpaste | sort | pbcopy"

	# Use VPN from terminal
	# See http://superuser.com/a/358663/242730
	function vpn-connect {
	/usr/bin/env osascript <<-EOF
	tell application "System Events"
	        tell current location of network preferences
	                set VPN to service "$1" -- your VPN name here
	                if exists VPN then connect VPN
	                repeat while (current configuration of VPN is not connected)
	                    delay 1
	                end repeat
	        end tell
	end tell
	EOF
	}

	function vpn-disconnect {
	/usr/bin/env osascript <<-EOF
	tell application "System Events"
	        tell current location of network preferences
	                set VPN to service "$1" -- your VPN name here
	                if exists VPN then disconnect VPN
	        end tell
	end tell
	return
	EOF
	}

  alias lockscreen='/System/Library/CoreServices/"Menu Extras"/User.menu/Contents/Resources/CGSession -suspend'
  alias screensaver='open -a /System/Library/Frameworks/ScreenSaver.framework/Versions/A/Resources/ScreenSaverEngine.app'

  # use mirror
  export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.sjtug.sjtu.edu.cn/homebrew-bottles/bottles
}
