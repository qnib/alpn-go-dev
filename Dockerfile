FROM qnib/alpn-base

ENV GOPATH=/usr/local \
    LD_LIBRARY_PATH=/usr/local/lib \
    PKG_CONFIG_PATH=/usr/local/lib/pkgconfig/
ARG ZMQ_VER=4.1.5
ARG CZMQ_VER=3.0.2
ARG SODIUM_VER=1.0.11
ARG GLIBC_VER=2.23-r3

# do all in one step
RUN apk add 'go>1.7' --no-cache --repository http://mirror.netcologne.de/alpine/edge/community/ \
 && apk --no-cache add bc curl ca-certificates bash git make python py-configobj py-mock libtool automake autoconf g++ make libffi-dev openssl-dev openssl mercurial \
 && curl -sLo /tmp/glibc.apk "https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VER}/glibc-${GLIBC_VER}.apk" \
 && apk add --allow-untrusted /tmp/glibc.apk \
 && curl -sLo /tmp/glibc-bin.apk "https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VER}/glibc-bin-${GLIBC_VER}.apk" \
 && apk add --allow-untrusted /tmp/glibc-bin.apk \
 && ldconfig /lib /usr/glibc/usr/lib \
 && mkdir -p /opt/ \
RUN go get golang.org/x/net/context cmd/cover github.com/mattn/gom github.com/stretchr/testify/assert github.com/pkg/errors
RUN git clone https://github.com/davecheney/profile.git ${GOPATH}/src/github.com/davecheney/profile \
 && git -C ${GOPATH}/src/github.com/davecheney/profile checkout v0.1.0-rc.1
RUN git clone  https://github.com/docker/engine-api ${GOPATH}/src/github.com/docker/engine-api \
 && git -C ${GOPATH}/src/github.com/docker/engine-api checkout release/1.12
RUN go get -d github.com/prometheus/client_model/go \ 
 && go get github.com/qnib/prom2json \
 && go get -u github.com/kardianos/govendor
RUN go get github.com/axw/gocov/gocov
