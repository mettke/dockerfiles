FROM alpine:latest
LABEL maintainer="Marc Mettke <marc@itmettke.de>"

COPY easyrsa.patch /tmp/easyrsa.patch
COPY entrypoint.sh /entrypoint.sh

RUN apk --no-cache add \
        easy-rsa \
        ip6tables \
        openvpn && \
    # https://github.com/OpenVPN/easy-rsa/issues/261
    sed -e '/RANDFILE/ s/^#*/#/' -i \
        /usr/share/easy-rsa/openssl-easyrsa.cnf && \
    cd /usr/share/easy-rsa && \
    # easyrsa does not support the busybox date
    patch < /tmp/easyrsa.patch && \
    rm /tmp/easyrsa.patch && \
    chmod +x /entrypoint.sh

VOLUME [ "/etc/openvpn/config" ]
EXPOSE 1194
EXPOSE 1194/udp

ENTRYPOINT [ "/entrypoint.sh" ]
CMD []
