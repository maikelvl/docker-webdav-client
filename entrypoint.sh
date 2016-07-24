#!/bin/ash
set -e

if [ -f /usr/share/zoneinfo/$TIMEZONE ];then
    cp -f /usr/share/zoneinfo/$TIMEZONE /etc/localtime
fi

source /hooks-placeholder.sh
[ -e /hooks.sh ] && source /hooks.sh

source /functions.sh
[ -e /functions-extra.sh ] && source /functions-extra.sh

source /env-vars.sh
[ -e /env-vars-extra.sh ] && source /env-vars-extra.sh

[ $DEBUG ] && set -x

$@
