FROM qnib/alpn-base:edge

ENV GOPATH=/usr/local/
RUN apk upgrade --update \
 && apk add --update curl ca-certificates bash git go make python py-configobj py-mock \
 && curl -sLo /tmp/glibc-2.21-r2.apk "https://circle-artifacts.com/gh/andyshinn/alpine-pkg-glibc/6/artifacts/0/home/ubuntu/alpine-pkg-glibc/packages/x86_64/glibc-2.21-r2.apk" \
 && apk add --allow-untrusted /tmp/glibc-2.21-r2.apk \
 && curl -sLo /tmp/glibc-bin-2.21-r2.apk "https://circle-artifacts.com/gh/andyshinn/alpine-pkg-glibc/6/artifacts/0/home/ubuntu/alpine-pkg-glibc/packages/x86_64/glibc-bin-2.21-r2.apk" \
 && apk add --allow-untrusted /tmp/glibc-bin-2.21-r2.apk \
 && /usr/glibc/usr/bin/ldconfig /lib /usr/glibc/usr/lib \
 && rm -rf /var/cache/apk/*
RUN go get cmd/cover
ENV ZMQ_VER=4.1.1 \
    CZMQ_VER=3.0.1 \
    PKG_CONFIG_PATH=/usr/local/lib/pkgconfig/
RUN apk add --update gcc g++ make libffi-dev openssl-dev
ENV SODIUM_VER=1.0.10
RUN mkdir -p /opt/ \
 && apk add openssl \
 && wget -qO - https://download.libsodium.org/libsodium/releases/libsodium-${SODIUM_VER}.tar.gz |tar xfz - -C /opt/ \
 && cd /opt/libsodium-${SODIUM_VER} \
 && ./configure --prefix=/usr/local/ \
 && make check \
 && make install
ENV ZMQ_VER=4.1.4 
RUN mkdir -p /opt/ \
 && wget -qO - http://download.zeromq.org/zeromq-${ZMQ_VER}.tar.gz |tar xfz - -C /opt/ \
 && cd /opt/zeromq-${ZMQ_VER} \
 && ./configure --with-libsodium \
 && make \
 && make install
RUN wget -qO - http://download.zeromq.org/czmq-${CZMQ_VER}.tar.gz | tar xfz - -C /opt/ \
 && cd /opt/czmq-${CZMQ_VER} \
 && ./configure \
 && make -j2 \
 && make install \
 && cd \
 && rm -rf /opt/zeromq* /opt/czmq* \
 && go get github.com/zeromq/goczmq

