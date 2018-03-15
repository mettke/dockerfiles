FROM alpine:latest
LABEL maintainer="Marc Mettke <marc@itmettke.de>"

ENV VERSION="v0.6.1"
ENV DEHYDRATED_URL="https://raw.githubusercontent.com/lukas2511/dehydrated/${VERSION}/dehydrated"
ENV CLOUDFLARE_HOOK_URL="https://github.com/kappataumu/letsencrypt-cloudflare-hook"
ENV DEPENDENCIES="bash openssl curl python"
ENV BUILD_DEPENDENCIES="gcc py-pip python2-dev linux-headers musl-dev libffi-dev openssl-dev"

COPY crontab /var/spool/cron/crontabs/cert-renew
COPY config /etc/dehydrated/config

RUN apk --no-cache add ${DEPENDENCIES}
RUN apk --no-cache add git && \
    wget ${DEHYDRATED_URL} \
        --directory-prefix /usr/local/bin/ && \
    chmod +x /usr/local/bin/dehydrated && \
    git clone ${CLOUDFLARE_HOOK_URL} /etc/dehydrated/hooks/cloudflare && \
    apk del git 
RUN apk --no-cache add ${BUILD_DEPENDENCIES} && \
    pip install -r /etc/dehydrated/hooks/cloudflare/requirements-python-2.txt && \
    apk del ${BUILD_DEPENDENCIES}

VOLUME /etc/dehydrated/data

CMD /usr/sbin/crond -fd15
HEALTHCHECK CMD /bin/ash -c "PID=\$(cat /var/run/crond.pid) && [ -n \"\${PID}\" -a -d \"/proc/\${PID}\" ] && exit 0 || exit 1"
