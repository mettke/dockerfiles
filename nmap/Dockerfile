FROM alpine:latest
LABEL maintainer="Marc Mettke <marc@itmettke.de>"

RUN apk --no-cache add nmap

ENTRYPOINT [ "/usr/bin/nmap" ]
CMD [ "-h" ]
