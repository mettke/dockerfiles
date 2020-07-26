FROM alpine:latest
LABEL maintainer="Marc Mettke <marc@itmettke.de>"

ENV VERSION="v0.6.5"
ENV DEHYDRATED_URL="https://raw.githubusercontent.com/dehydrated-io/dehydrated/${VERSION}/dehydrated"
ENV CLOUDFLARE_HOOK_URL="https://github.com/mettke/letsencrypt-cloudflare-hook"
ENV DEPENDENCIES="bash openssl curl python3 py3-cffi py3-cryptography py3-dnspython py3-future py3-idna py3-ipaddress py3-ndg_httpsclient py3-openssl py3-requests py3-six py3-pip"
ENV BUILD_DEPENDENCIES="gcc py3-pip python3-dev linux-headers musl-dev libffi-dev openssl-dev"

COPY crontab /var/spool/cron/crontabs/root
COPY config /etc/dehydrated/config

RUN : && \
    apk add --virtual deps ${BUILD_DEPENDENCIES} && \
    apk --no-cache add ${DEPENDENCIES} && \
    pip install \
        asn1 \
        cparser \
        enum34 \
        tld \
        typing \
        wheel && \
    apk del deps
RUN apk --no-cache add git && \
    wget ${DEHYDRATED_URL} \
        --directory-prefix /usr/local/bin/ && \
    chmod +x /usr/local/bin/dehydrated && \
    git clone ${CLOUDFLARE_HOOK_URL} /etc/dehydrated/hooks/cloudflare/ && \
    sed -i -e 's|/usr/bin/env python|/usr/bin/env python3|g' /etc/dehydrated/hooks/cloudflare/hook.py && \
    apk del git 

VOLUME /etc/dehydrated/data

CMD /usr/sbin/crond -fd15
HEALTHCHECK CMD /bin/ash -c "PID=\$(cat /var/run/crond.pid) && [ -n \"\${PID}\" -a -d \"/proc/\${PID}\" ] && exit 0 || exit 1"
