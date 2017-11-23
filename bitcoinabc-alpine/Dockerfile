FROM alpine:latest
LABEL maintainer="Marc Mettke <marc@itmettke.de>"

ENV GLIBC_VERSION=2.26-r0
ENV BITCOIN_VERSION=0.16.1

RUN apk --no-cache add openssl libgcc && \
    # glibc installation
    wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/sgerrand.rsa.pub && \
    wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-${GLIBC_VERSION}.apk -P /tmp/ && \
    wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-bin-${GLIBC_VERSION}.apk -P /tmp/ && \
    apk add --no-cache /tmp/glibc-${GLIBC_VERSION}.apk && \
    apk add --no-cache /tmp/glibc-bin-${GLIBC_VERSION}.apk && \
    # bitcoin-abc installation
    wget https://download.bitcoinabc.org/0.16.1/linux/bitcoin-abc-${BITCOIN_VERSION}-x86_64-linux-gnu.tar.gz -P /tmp/ && \
    tar -xvf /tmp/bitcoin-abc-${BITCOIN_VERSION}-x86_64-linux-gnu.tar.gz && \
    mv bitcoin-abc-${BITCOIN_VERSION} bitcoin-abc && \
    # cleaning up
    rm /tmp/glibc-${GLIBC_VERSION}.apk && \
    rm /tmp/glibc-bin-${GLIBC_VERSION}.apk && \
    rm /tmp/bitcoin-abc-${BITCOIN_VERSION}-x86_64-linux-gnu.tar.gz && \
    apk del openssl && \
    # user setup
    adduser -D bitcoind && \
    mkdir /data && \
    chown bitcoind:bitcoind /data

USER bitcoind
EXPOSE 8332
EXPOSE 8333
VOLUME /data

ENTRYPOINT ["/bitcoin-abc/bin/bitcoind", "-datadir=/data"]
HEALTHCHECK CMD /bitcoin-abc/bin/bitcoin-cli -datadir=/data getinfo || exit 1
