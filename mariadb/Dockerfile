FROM alpine:latest AS base

WORKDIR /app

ENV TZ=Etc/UTC

RUN apk update &&\
        apk upgrade --no-cache &&\
        apk add --no-cache\
        mariadb-client\
        tini\
        tzdata

RUN cp /usr/share/zoneinfo/${TZ} /etc/localtime &&\
        echo "${TZ}" > /etc/timezone

ENTRYPOINT ["tini", "--"]
