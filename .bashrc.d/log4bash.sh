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

bash_doc <<EOF
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
```
log message level color
log_speak
log_info
log_success
log_error
log_warn
log_debug
log_captains
log_campfire
```
### Log level

EOF

#--------------------------------------------------------------------------------------------------
# Begin Logging Section

# 如果颜色数量大于等于 8 则使用带色的日志
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
fi

# This function scrubs the output of any control characters used in colorized output
# It's designed to be piped through with text that needs scrubbing.  The scrubbed
# text will come out the other side!
prepare_log_for_nonterminal() {
    # Essentially this strips all the control characters for log colors
    sed "s/[[:cntrl:]]\[[0-9;]*m//g"
}

log() {
    local log_text="$1"
    local log_level="$2"
    local log_color="$3"

    # Default level to "info"
    [[ -z ${log_level} ]] && log_level="INFO";
    [[ -z ${log_color} ]] && log_color="${LOG_INFO_COLOR}";

    # Only show the defined level
    iscontains ALL "${LOG4BASH_LOG_LEVEL[@]}" || \
    iscontains $log_level "${LOG4BASH_LOG_LEVEL[@]}" || return 0;

    echo -e "${log_color}[$(date +"%Y-%m-%d %H:%M:%S %Z")] [${log_level}] ${log_text} ${LOG_DEFAULT_COLOR}";
    return 0;
}


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

log_info()      { log "$*"; }
log_success()   { log "$*" "SUCCESS" "${LOG_SUCCESS_COLOR}"; }
log_error()     { log "$*" "ERROR" "${LOG_ERROR_COLOR}"; log_speak "$@"; }
log_warn()      { log "$*" "WARN" "${LOG_WARN_COLOR}"; }
log_debug()     { log "$*" "DEBUG" "${LOG_DEBUG_COLOR}"; }
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
