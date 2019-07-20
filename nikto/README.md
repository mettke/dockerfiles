# Supported tags and respective `Dockerfile` links

-	[`latest` (*Dockerfile*)](https://github.com/mettke/dockerfiles/blob/nikto/nikto/Dockerfile)

### latest

The latest Tag will automatically be updated when the alpine base image is updated

# What is nikto?

Nikto is a free software command-line vulnerability scanner that scans webservers for dangerous files/CGIs, outdated server software and other problems.

> [wikipedia.org/wiki/Nikto_(vulnerability_scanner)](https://en.wikipedia.org/wiki/Nikto_(vulnerability_scanner))

# How to use this image

## Run nikto

You can execute nikto by running:

```console
docker run --name nikto \
          toendeavour/nikto \
          <command>
```

Example:


```console
docker run --name nikto \
          toendeavour/nikto \
          -host <host1>,<host2> \
          -port <port1>,<port2>
```
