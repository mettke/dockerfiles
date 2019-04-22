FROM alpine:latest
LABEL maintainer="Marc Mettke <marc@itmettke.de>"

ENV FAKEDNS_FILE=https://raw.githubusercontent.com/pathes/fakedns/master/fakedns.py

RUN apk add python3 wget && \
    wget -q ${FAKEDNS_FILE} -O /usr/bin/fakedns && \
    chmod +x /usr/bin/fakedns && \
    apk del wget

EXPOSE 53
VOLUME /log

ENTRYPOINT [ "/usr/bin/fakedns"]
