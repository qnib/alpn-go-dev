FROM qnib/alpn-base

ENV GOPATH=/usr/local/ \
    LD_LIBRARY_PATH=/usr/local/lib \
    ZMQ_VER=4.1.4 \
    CZMQ_VER=3.0.2 \
    PKG_CONFIG_PATH=/usr/local/lib/pkgconfig/ \
    SODIUM_VER=1.0.10
RUN apk add --update curl ca-certificates bash git go make python py-configobj py-mock libtool automake autoconf g++ make libffi-dev openssl-dev openssl \
 && go get cmd/cover \
 && curl -sLo /tmp/glibc-2.21-r2.apk "https://circle-artifacts.com/gh/andyshinn/alpine-pkg-glibc/6/artifacts/0/home/ubuntu/alpine-pkg-glibc/packages/x86_64/glibc-2.21-r2.apk" \
 && apk add --allow-untrusted /tmp/glibc-2.21-r2.apk \
 && curl -sLo /tmp/glibc-bin-2.21-r2.apk "https://circle-artifacts.com/gh/andyshinn/alpine-pkg-glibc/6/artifacts/0/home/ubuntu/alpine-pkg-glibc/packages/x86_64/glibc-bin-2.21-r2.apk" \
 && apk add --allow-untrusted /tmp/glibc-bin-2.21-r2.apk \
 && /usr/glibc/usr/bin/ldconfig /lib /usr/glibc/usr/lib \
 && rm -rf /var/cache/apk/* \
 && mkdir -p /opt/ \
 && wget -qO - https://download.libsodium.org/libsodium/releases/libsodium-${SODIUM_VER}.tar.gz |tar xfz - -C /opt/ \
 && cd /opt/libsodium-${SODIUM_VER} \
 && ./configure --prefix=/usr/local/ \
 && make check \
 && make install \
 && echo https://archive.org/download/zeromq_${ZMQ_VER}/zeromq-${ZMQ_VER}.tar.gz \
 && wget -qO - https://archive.org/download/zeromq_${ZMQ_VER}/zeromq-${ZMQ_VER}.tar.gz |tar xfz - -C /opt/ \
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
 && rm -rf /opt/zeromq* /opt/czmq* 

