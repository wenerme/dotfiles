#!/usr/bin/env bash

#--------------------------------------------------------------------------------------------------
# log4bash - Makes logging in Bash scripting suck less
# Copyright (c) Fred Palmer
# Licensed under the MIT license
# http://github.com/fredpalmer/log4bash
#--------------------------------------------------------------------------------------------------
# set -e  # Fail on first error

# This should probably be the right way - didn't have time to experiment though
# declare -r INTERACTIVE_MODE="$([ tty --silent ] && echo on || echo off)"
# declare -r INTERACTIVE_MODE=$([ "$(uname)" == "Darwin" ] && echo "on" || echo "off")

echo -n <<'DOC-HERE'
log4bash.sh
-----------
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
command | args | description
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
log_level DEBUG # Only show DEBUG, no WARN
log_level NONE # no log
log_level # display log level
```
DOC-HERE

#--------------------------------------------------------------------------------------------------
# Begin Logging Section

# Default: Only show WARN and ERROR
# Allowed level: INFO DEBUG WARN ERROR ALL
[ -z "$LOG4BASH_LOG_LEVEL" ] && export LOG4BASH_LOG_LEVEL=WARN


# Detecte is terminal support colors
if [[ `tput colors` -lt 8 ]]
then
    # Then we don't care about log colors
    LOG_DEFAULT_COLOR=""
    LOG_ERROR_COLOR=""
    LOG_INFO_COLOR=""
    LOG_SUCCESS_COLOR=""
    LOG_WARN_COLOR=""
    LOG_DEBUG_COLOR=""
else
    LOG_DEFAULT_COLOR="\033[0m"
    LOG_ERROR_COLOR="\033[1;31m"
    LOG_INFO_COLOR="\033[1m"
    LOG_SUCCESS_COLOR="\033[1;32m"
    LOG_WARN_COLOR="\033[1;33m"
    LOG_DEBUG_COLOR="\033[1;34m"
fi &>/dev/null # Supress ERROR: tput: No value for $TERM and no -T specified

# This function scrubs the output of any control characters used in colorized output
# It's designed to be piped through with text that needs scrubbing.  The scrubbed
# text will come out the other side!
prepare_log_for_nonterminal() {
    # Essentially this strips all the control characters for log colors
    sed "s/[[:cntrl:]]\[[0-9;]*m//g"
}


log_level()
{
	# get log level
	if [ $# -eq 0 ]
	then
		echo "$LOG4BASH_LOG_LEVEL"
		return
	fi

	# set log level
	declare -A LEVELS=( ["DEBUG"]=5 ["INFO"]=4 ["SUCCESS"]=3  ["WARN"]=2 ["ERROR"]=1 ["NONE"]=0)
	local level="${LEVELS["$1"]}"
	# 如果第一个参数是未知的 LEVEL, 则打印支持的 LOG 级别
	if [ -z "$level" ]
	then
		echo -n "Allowed level: "
		for key in "${!LEVELS[@]}"; do echo -ne "$key "; done
	else
		LOG4BASH_LOG_LEVEL=$1
	fi
}

log() {
    local log_text="$1"
    local log_level="$2"
    local log_color="$3"

    # Default level to "info"
    [[ -z ${log_level} ]] && log_level="INFO";
    [[ -z ${log_color} ]] && log_color="${LOG_INFO_COLOR}";

    # Test the log level
    declare -A LEVELS=( ["DEBUG"]=5 ["INFO"]=4 ["SUCCESS"]=3  ["WARN"]=2 ["ERROR"]=1 ["NONE"]=0)
	local level="${LEVELS["$log_level"]}"
	local allowed_level="${LEVELS["$LOG4BASH_LOG_LEVEL"]}"

	if [ $level -gt $allowed_level ];then return 0;fi;

    echo -e "${log_color}[$(date +"%Y-%m-%d %H:%M:%S %Z")] [${log_level}] ${log_text} ${LOG_DEFAULT_COLOR}";
    return 0;
}


log_info()      { log "$*"; }
log_success()   { log "$*" "SUCCESS" "${LOG_SUCCESS_COLOR}"; }
log_error()     { log "$*" "ERROR" "${LOG_ERROR_COLOR}"; }
log_warn()      { log "$*" "WARN" "${LOG_WARN_COLOR}"; }
log_debug()     { log "$*" "DEBUG" "${LOG_DEBUG_COLOR}"; }

log_speak()     {
    if type -P say >/dev/null
    then
        local easier_to_say="$@";
        case "${easier_to_say}" in
            studionowdev*)
                easier_to_say="studio now dev ${easier_to_say#studionowdev}";
                ;;
            studionow*)
                easier_to_say="studio now ${easier_to_say#studionow}";
                ;;
        esac
        say "${easier_to_say}";
    fi
    return 0;
}
log_captains()  {
    if type -P figlet >/dev/null;
    then
        figlet -f computer -w 120 "$@";
    else
        log "$*";
    fi

    log_speak "$@";

    return 0;
}

log_campfire() {
    # This function performs a campfire notification with the arguments passed to it
    if [[ -z ${CAMPFIRE_API_AUTH_TOKEN} || -z ${CAMPFIRE_NOTIFICATION_URL} ]]
    then
        log_warning "CAMPFIRE_API_AUTH_TOKEN and CAMPFIRE_NOTIFICATION_URL must be set in order log to campfire."
        return 1;
    fi

    local campfire_message="
    {
        \"message\": {
            \"type\":\"TextMessage\",
            \"body\":\"$@\"
        }
    }"

    curl                                                            \
        --write-out "\r\n"                                          \
        --user ${CAMPFIRE_API_AUTH_TOKEN}:X                         \
        --header 'Content-Type: application/json'                   \
        --data "${campfire_message}"                                \
        ${CAMPFIRE_NOTIFICATION_URL}

    return $?;
}

# End Logging Section
#--------------------------------------------------------------------------------------------------
