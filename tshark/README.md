# Supported tags and respective `Dockerfile` links

-	[`latest` (*Dockerfile*)](https://github.com/mettke/dockerfiles/blob/tshark/tshark/Dockerfile)

### latest

The latest Tag will automatically be updated when the alpine base image is updated

# What is Wireshark?

Wireshark is a free and open-source packet analyzer. It is used for network troubleshooting, analysis, software and communications protocol development, and education.

> [wikipedia.org/wiki/Wireshark](https://en.wikipedia.org/wiki/Wireshark)

# How to use this image

## Run tshark

You can execute tshark by running:

```console
docker run --name tshark \
          --network host \
          toendeavour/tshark \
          <command>
```

Example:


```console
docker run --name tshark \
          --network host \
          toendeavour/tshark \
          -i eth0 \
          -w - \
          > capture.pcap
```
