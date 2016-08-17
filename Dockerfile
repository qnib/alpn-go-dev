FROM qnib/alpn-base

ENV GOPATH=/usr/local/ \
    LD_LIBRARY_PATH=/usr/local/lib \
    PKG_CONFIG_PATH=/usr/local/lib/pkgconfig/
ARG ZMQ_VER=4.1.5
ARG CZMQ_VER=3.0.2
ARG SODIUM_VER=1.0.11
ARG GLIBC_VER=2.23-r3

# do all in one step
RUN apk add --update curl ca-certificates bash git go make python py-configobj py-mock libtool automake autoconf g++ make libffi-dev openssl-dev openssl mercurial \
 && curl -sLo /tmp/glibc.apk "https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VER}/glibc-${GLIBC_VER}.apk" \
 && apk add --allow-untrusted /tmp/glibc.apk \
 && curl -sLo /tmp/glibc-bin.apk "https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VER}/glibc-bin-${GLIBC_VER}.apk" \
 && apk add --allow-untrusted /tmp/glibc-bin.apk \
 && ldconfig /lib /usr/glibc/usr/lib \
 && go get cmd/cover \
 && mkdir -p /opt/ \
 && wget -qO - https://download.libsodium.org/libsodium/releases/libsodium-${SODIUM_VER}.tar.gz |tar xfz - -C /opt/ \
 && cd /opt/libsodium-${SODIUM_VER} \
 && ./configure --prefix=/usr/local/ \
 && make check \
 && make install \
 && wget -qO - https://github.com/zeromq/zeromq4-1/releases/download/v${ZMQ_VER}/zeromq-${ZMQ_VER}.tar.gz |tar xfz - -C /opt/ \
 && cd /opt/zeromq-${ZMQ_VER} \
 && ./configure --with-libsodium \
 && make \
 && make install \
 && wget -qO - https://github.com/zeromq/czmq/archive/v${CZMQ_VER}.tar.gz | tar xfz - -C /opt/ \
 && cd /opt/czmq-${CZMQ_VER} \
 && ./autogen.sh \
 && ./configure \
 && make -j2 \
 && make install \
 && cd \
 && rm -rf /opt/zeromq* /opt/czmq* /var/cache/apk/*
