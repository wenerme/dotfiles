#! /usr/bin/env bash
# For test
command -v osis &>/dev/null || { . utils.sh ; . log4bash.sh; log_level DEBUG; }


FAILED()
{
	echo "FAILED ${FUNCNAME[-2]}($BASH_SOURCE:${BASH_LINENO[-3]})"
}


function test_utils()
{
(
# Test utils
. utils.sh
osis xxoo && FAILED
osis -n xxoo || FAILED
osis "Linux|Darwin|Cygwin" && FAILED
osis -n "Linux|Darwin|Cygwin" || FAILED

iscmd not-possiable && FAILED
iscmd -n not-possiable || FAILED
iscmd command || FAILED
iscmd -n command && FAILED
)
}

function test_log4bash()
{
(
# Test log4bash
. log4bash.sh
[[ `log_level` = WARN ]] || FAILED
log_error This is error
log_warn This is warn
log_info This is info
log_debug This is debug
log_success This is success
)
}

test_utils
test_log4bash




