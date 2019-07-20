FROM alpine:latest
LABEL maintainer="Marc Mettke <marc@itmettke.de>"

RUN apk --no-cache add nikto perl-net-ssleay

ENTRYPOINT [ "/usr/bin/nikto.pl" ]
CMD [ "-H" ]
