# Supported tags and respective `Dockerfile` links

-	[`latest` (*Dockerfile*)](https://github.com/mettke/dockerfiles/blob/certbot-alpine/certbot-alpine/Dockerfile)

### latest

The latest Tag will automatically be updated when the alpine base image is updated

# What is certbot?

Certbot can be used to create and automatically renew Certificates from Letsencrypt. It requires either Port 80 to be open or a dns entry to be set for each domain.

> [letsencrypt.org](https://letsencrypt.org/)

# How to use this image

## Run crond Daemon

The crond Daemon automatically renews certificates under */etc/letsencrypt* once a day. It may be started using: 

```console
docker run --name Certbot \
           --volume /path/to/letsencrypt/etcdir:/etc/letsencrypt \
           --detach toendeavour/certbot-alpine
```

It requires only one volume to store the certifactes.

## Logs

Certbot logs by default to the file *letsencrypt.log* in the */var/log/letsencrypt* directory. It is necessary to add an additional volume to read it outside of the cointainer:

```console
docker run --name Certbot \
           --volume /path/to/letsencrypt/etcdir:/etc/letsencrypt \
           --volume /path/to/letsencrypt/logdir:/var/log/letsencrypt \
           --detach toendeavour/certbot-alpine
```

Afterwarts it is possible to read the log with a command like this:

```console
tail -f /path/to/letsencrypt/logdir/letsencrypt.log
```

## docker-compose.yml

Here is an example using docker-compose.yml:

```yaml
letsencrypt:
  image: toendeavour/certbot-alpine
  restart: always
  volumes:
    - /data/docker/mgmt/letsencrypt/etc:/etc/letsencrypt
    - /data/docker/mgmt/letsencrypt/log:/var/log/letsencrypt
```
