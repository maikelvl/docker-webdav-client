FROM alpine:3.4

RUN apk --no-cache add \
        ca-certificates \
        davfs2 \
        rsync \
        tzdata

RUN adduser -D -H webdav \
 && addgroup webdav davfs2 \
 && mkdir /mnt/webdav \
 && chown webdav:webdav /mnt/webdav

ENV RSYNC_PARAMS="-rP --delete --no-whole-file --inplace" \
    WEBDAV_LOCAL_PATH="/data" \
    WEBDAV_PROTO="https"

COPY entrypoint.sh /
COPY env-vars.sh /
COPY functions.sh /
COPY hooks.sh /hooks-placeholder.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["start"]
