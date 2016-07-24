#!/bin/sh

if [ "${WEBDAV_PATH:0:1}" == "/" ];then
    export WEBDAV_PATH="${WEBDAV_PATH:1}"
fi
