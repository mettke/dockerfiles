# Supported tags and respective `Dockerfile` links

-	[`latest` (*Dockerfile*)](https://github.com/mettke/dockerfiles/blob/rsync-alpine/rsync-alpine/Dockerfile)

### latest

The latest Tag will automatically be updated when the alpine base image is updated

# What is rsyncd?

Rsyncd is a Server Daemon for rsync. It allows downloading and uploading data from the or to the server on different volumes with different permissions.

> [wikipedia.org/wiki/Rsync](https://wikipedia.org/wiki/Rsync)

# How to use this image

## Run rsyncd Server

You can create a rsyncd Server using:

```console
docker run --name rsyncd \
           --volume /path/to/rsyncd/config:/config \
           --volume /path/to/data:/data \
           --publish 873:873 \
           --detach toendeavour/rsyncd-alpine
```

It requires a volume storing the *rsyncd.conf* and another one storing the data to share. To allow connections from the outside the port 873 must be opened.

## Logs

Rsyncd logs by default to the file *rsyncd.log* in the */log* directory. It is necessary to add an additional volume to read it outside of the cointainer:

```console
docker run --name rsyncd \
           --volume /path/to/rsyncd/config:/config \
           --volume /path/to/rsyncd/log:/log \
           --volume /path/to/data:/data \
           --publish 873:873 \
           --detach toendeavour/rsyncd-alpine
```

Afterwarts it is possible to read the log with a command like this:

```console
tail -f /path/to/rsyncd/log/rsyncd.log
```

## docker-compose.yml

Here is an example using docker-compose.yml with SSL:

```yaml
rsyncd:
  image: toendeavour/rsyncd-alpine
  restart: always
  ports:
  - "873:873"
  volumes:
  - /path/to/rsyncd/config:/config
  - /path/to/rsyncd/log:/log
  - /path/to/data:/data
```

## Rsyncd Configuration

To setup rsyncd modifications to */path/to/rsyncd/config/rsyncd.conf* like the following are required:

```
uid = nobody
gid = nobody
use chroot = no

[share]
path = /data/share/
comment = Share
read only = yes
list = yes
uid = 1000
gid = 1000
```