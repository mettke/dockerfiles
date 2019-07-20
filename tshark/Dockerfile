FROM alpine:latest
LABEL maintainer="Marc Mettke <marc@itmettke.de>"

RUN apk --no-cache add tshark

ENTRYPOINT [ "/usr/bin/tshark" ]
CMD [ "-h" ]
