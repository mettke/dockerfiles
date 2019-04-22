# Supported tags and respective `Dockerfile` links

-	[`latest` (*Dockerfile*)](https://github.com/mettke/dockerfiles/blob/fakedns-alpine/rsync-alpine/Dockerfile)

### latest

The latest Tag will automatically be updated when the alpine base image is updated

# What is fakedns?

Fakedns is a simple dns server which resolves every dns request to the same ip address.

> [github.com/fakedns](https://github.com/pathes/fakedns)

# How to use this image

## Run fakedns Server

You can create a fakedns Server using:

```console
docker run --name fakedns \
           --publish 53:53 \
           --detach toendeavour/fakedns-alpine 1.1.1.1
```

## docker-compose.yml

Here is an example using docker-compose.yml:

```yaml
rsyncd:
  image: toendeavour/fakedns-alpine
  command: 1.1.1.1
  restart: always
  ports:
  - "53:53"
```
