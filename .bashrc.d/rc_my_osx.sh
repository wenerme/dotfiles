#! /usr/bin/env bash
# For test
command -v osis &>/dev/null || { . utils.sh ; . log4bash.sh; log_level DEBUG; }

osis Darwin &&
{
    log_debug Mac osx detected
	iscmd mvim && iscmd -n gvim && alias gvim="mvim"

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

}