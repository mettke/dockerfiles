FROM alpine:latest
LABEL maintainer="Marc Mettke <marc@itmettke.de>"

ENV VERSION="v0.6.5"
ENV DEHYDRATED_URL="https://raw.githubusercontent.com/lukas2511/dehydrated/${VERSION}/dehydrated"
ENV CLOUDFLARE_HOOK_URL="https://github.com/mettke/letsencrypt-cloudflare-hook"
ENV DEPENDENCIES="bash openssl curl python py-cffi py-cryptography py-dnspython py-future py-idna py-ipaddress py-ndg_httpsclient py-openssl py-requests py-six py-pip"
ENV BUILD_DEPENDENCIES="gcc py-pip python2-dev linux-headers musl-dev libffi-dev openssl-dev"

COPY crontab /var/spool/cron/crontabs/root
COPY config /etc/dehydrated/config

RUN : && \
    apk add --virtual deps ${BUILD_DEPENDENCIES} && \
    apk --no-cache add ${DEPENDENCIES} && \
    pip install \
        asn1 \
        cparser \
        dnspython \
        enum34 \
        future \
        pyopenssl \
        requests \
        tld \
        typing \
        wheel && \
    apk del deps
RUN apk --no-cache add git && \
    wget ${DEHYDRATED_URL} \
        --directory-prefix /usr/local/bin/ && \
    chmod +x /usr/local/bin/dehydrated && \
    git clone ${CLOUDFLARE_HOOK_URL} /etc/dehydrated/hooks/cloudflare && \
    apk del git 

VOLUME /etc/dehydrated/data

CMD /usr/sbin/crond -fd15
HEALTHCHECK CMD /bin/ash -c "PID=\$(cat /var/run/crond.pid) && [ -n \"\${PID}\" -a -d \"/proc/\${PID}\" ] && exit 0 || exit 1"
