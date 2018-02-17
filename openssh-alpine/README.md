# Supported tags and respective `Dockerfile` links

-	[`latest` (*Dockerfile*)](https://github.com/mettke/dockerfiles/blob/openssh-alpine/openssh-alpine/Dockerfile)

### latest

The latest Tag will automatically be updated when the alpine base image is updated

# What is openssh?

OpenSSH allows running the ssh daemon to connect via ssh or to upload/download files using scp.

> [wikipedia.org/wiki/OpenSSH](https://wikipedia.org/wiki/OpenSSH)

# How to use this image

## Run openssh Server

You can create a openssh Server using:

```console
docker run --name sshd \
           --detach toendeavour/openssh-alpine
```
