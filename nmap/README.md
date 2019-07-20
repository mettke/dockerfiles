# Supported tags and respective `Dockerfile` links

-	[`latest` (*Dockerfile*)](https://github.com/mettke/dockerfiles/blob/nmap/nmap/Dockerfile)

### latest

The latest Tag will automatically be updated when the alpine base image is updated

# What is Nmap?

Nmap (Network Mapper) is a free and open-source network scanner created by Gordon Lyon. Nmap is used to discover hosts and services on a computer.

> [wikipedia.org/wiki/Nmap](https://en.wikipedia.org/wiki/Nmap)

# How to use this image

## Run Nmap

You can execute Nmap by running:

```console
docker run --name nmap \
          toendeavour/nmap \
          <command>
```

Example:


```console
docker run --name nmap \
          toendeavour/nmap \
          example.com
```
