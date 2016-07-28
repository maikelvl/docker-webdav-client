#!/bin/ash

start() {
    setup

    echo "Mounting and running rsync..."
    trap stop SIGTERM EXIT
    mount /mnt/webdav
    mkdir -p /mnt/webdav/$WEBDAV_TARGET_DIR
    chown webdav:webdav /mnt/webdav/$WEBDAV_TARGET_DIR
    # mkdir -p $WEBDAV_LOCAL_PATH
    # rsync $RSYNC_PARAMS $WEBDAV_LOCAL_PATH /mnt/webdav/$WEBDAV_TARGET_DIR
    # while true;do
    #     sleep 1
    #     # ls -al $WEBDAV_LOCAL_PATH
    #     date
    #     ls -Al /mnt/webdav/$WEBDAV_TARGET_DIR
    #     echo ""
    # done
    ln -sf /dev/stdout /var/log/syslog
    exec rsyslogd -n
}

stop() {
    # unmount, and wait for transfers
    echo "Waiting davfs to trigger for file upload, continue in 10s..."
    sleep 10
    umount.davfs /mnt/webdav
    sleep 5
    echo "Exiting..."
    exit 0
}

setup() {
    validate_env_vars

    echo "${WEBDAV_URL} /mnt/webdav davfs user,rw,noauto 0 0" > /etc/fstab
    echo "${WEBDAV_URL} ${WEBDAV_USER} \"${WEBDAV_PASS}\"" > /etc/davfs2/secrets

    echo 'debug http' >> /etc/davfs2/davfs2.conf
}

validate_env_vars() {

    if [ "$WEBDAV_URL" == "" ];then
        echo "Please set env var WEBDAV_URL"
        exit_code=1
    fi

    if [ "$WEBDAV_USER" == "" ];then
        echo "Please set env var WEBDAV_USER"
        exit_code=1
    fi

    if [ "$WEBDAV_PASS" == "" ];then
        echo "Please set env var WEBDAV_PASS"
        exit_code=1
    fi

    if [ $exit_code ];then
        exit $exit_code
    fi
}

