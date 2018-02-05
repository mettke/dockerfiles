# Supported tags and respective `Dockerfile` links

-	[`latest` (*Dockerfile*)](https://github.com/mettke/dockerfiles/blob/dehydated-alpine/dehydated-alpine/Dockerfile)

### latest

The latest Tag will automatically be updated when the alpine base image is updated

# What is dehydrated?

Dehydrated can be used to create and automatically renew Certificates from Letsencrypt. It requires either Port 80 to be open or a dns entry to be set for each domain. This Version contains a hook for cloudflare to automatically reset dns entries for automatic renewal.

> [letsencrypt.org](https://letsencrypt.org/)

# How to use this image

## Run crond Daemon

The crond Daemon automatically renews certificates under */etc/dehydrated/data* once a day. It may be started using:

```console
docker run --name Dehydrated \
           -e "CF_EMAIL=Cloudflare Email" \
           -e "CF_KEY=Cloudflare Global API Key" \
           --volume /path/to/dehydrated/datadir:/etc/dehydrated/data \
           --detach toendeavour/dehydrated-alpine
```

It requires only one volume to store the certifactes.

## Setup

The inital setup requires the file *domains.txt* inside */path/to/dehydrated/datadir*. It is also necessary to register a letsencrypt account using the following:

```console
docker run --rm \
           --volume /path/to/dehydrated/datadir:/etc/dehydrated/data \
           -it toendeavour/dehydrated-alpine \
           /usr/local/bin/dehydrated --register --accept-terms
```

## docker-compose.yml

Here is an example using docker-compose.yml:

```yaml
dehydrated:
  image: toendeavour/dehydrated-alpine
  restart: always
  environment:
    CF_EMAIL: "Cloudflare Email"
    CF_KEY: "Cloudflare Global API Key"
  volumes:
    - /path/to/dehydrated/datadir:/etc/dehydrated/data
```
