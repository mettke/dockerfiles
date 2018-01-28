FROM alpine:latest
LABEL maintainer="Marc Mettke <marc@itmettke.de>"

COPY crontab /var/spool/cron/crontabs/certbot-renew
RUN apk --no-cache add certbot

VOLUME /etc/letsencrypt
VOLUME /var/lib/letsencrypt
VOLUME /var/log/letsencrypt

CMD /usr/sbin/crond -fd15
HEALTHCHECK CMD /bin/ash -c "PID=\$(cat /var/run/crond.pid) && [ -n \"\${PID}\" -a -d \"/proc/\${PID}\" ] && exit 0 || exit 1"
