# pacman-cache-nginx

## Supported tags and respective `Dockerfile` links

- [`latest` (*Dockerfile*)](https://github.com/mettke/dockerfiles/blob/pacman-cache-nginx/pacman-cache-nginx/Dockerfile)

### latest

The latest Tag will automatically be updated when the nginx-alpine base image is updated

## What is pacman-cache

Pacman Cache is a local archlinux repository cache which may be used when there are multiple
machines running archlinux. It allows caching packages and therefore reduces the bandwidth required
to update every single machine.

> [archlinux.org/Pacman/Dynamic_reverse_proxy_cache_using_nginx](https://wiki.archlinux.org/index.php/Pacman/Tips_and_tricks#Dynamic_reverse_proxy_cache_using_nginx)

## How to use this image

### Run pacman-cache Server

You can start the server using:

```console
docker run --name pacman-cache \
           --env "MIRRORS=https://archlinux.surlyjake.com http://mirrors.evowise.com" \
           --volume /path/to/pacman-cache/cache:/cache \
           --publish 80:80 \
           --detach toendeavour/pacman-cache-nginx
```

It requires a volume to store the cached packages. It is not required to specify that volume, but
not specifing will result in all cached packages being removed at restart. To be able to publicly
access the cache you are required to open a port to the internal 80 port. It is also necessary to
specify one or more mirrors with the `MIRRORS` variable. Those mirros will be used round-robin and
are required to use the same path for each file (like `/archlinux/$repo/os/$arch`).

### Using backup mirros

In addition it is possible to specify backup mirrors. These mirrors will only be used, if there is
no mirror in the `MIRRORS` variable available. You can specify them using the `BACKUP_MIRRORS`
variable.

```console
docker run --name pacman-cache \
           --env "MIRRORS=https://archlinux.surlyjake.com http://mirrors.evowise.com" \
           --env "BACKUP_MIRRORS=http://mirror.rackspace.com https://mirror.aarnet.edu.au" \
           --volume /path/to/pacman-cache/cache:/cache \
           --publish 80:80 \
           --detach toendeavour/pacman-cache-nginx
```

### docker-compose.yml

Here is an example using docker-compose.yml:

```yaml
cache:
  image: toendeavour/pacman-cache-nginx
  restart: always
  ports:
  - "80:80"
  environment:
  - MIRRORS="https://archlinux.surlyjake.com http://mirrors.evowise.com"
  - BACKUP_MIRRORS="http://mirror.rackspace.com https://mirror.aarnet.edu.au"
  volumes:
  - /path/to/pacman-cache/cache:/cache
```
