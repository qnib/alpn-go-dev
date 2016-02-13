FROM qnib/alpn-base

ENV GOPATH=/usr/local/
RUN apk update && apk upgrade && \
    apk add git go make && \
    rm -rf /var/cache/apk/*

