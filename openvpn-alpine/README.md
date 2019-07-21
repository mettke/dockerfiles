# Supported tags and respective `Dockerfile` links

-	[`latest` (*Dockerfile*)](https://github.com/mettke/dockerfiles/blob/openvpn-alpine/openvpn-alpine/Dockerfile)

### latest

The latest Tag will automatically be updated when the alpine base image is updated

# What is OpenVPN?

OpenVPN is an open-source commercial software that implements virtual private network (VPN) techniques to create secure point-to-point or site-to-site connections in routed or bridged configurations and remote access facilities.

> [wikipedia.org/wiki/OpenVPN](https://en.wikipedia.org/wiki/OpenVPN)

# How to use this image

## Run openvpn-alpine

This image is a zero configuration image. In other words, 
everthing will be generated at first boot and configuration is
only necessary if the default configuration does not suite ones
need. By default the generated configuration forwards all traffic 
(ipv4 and ipv6) through openvpn.  It is, however, possible to use
a custom configuration without generating anything.

You can execute openvpn-alpine by running.:

```console
docker run --name openvpn-alpine \
    --env DOMAIN=<DOMAIN> \
    --env FORWARD=1 \
    --volume "$(pwd)/config:/etc/openvpn/config" \
    --publish 1194:1194/udp \
    --cap-add=NET_ADMIN \
    --device=/dev/net/tun \
    --sysctl net.ipv6.conf.all.disable_ipv6=0 \
    --sysctl net.ipv6.conf.all.forwarding=1 \
    --detach openvpn
```

The Image will generate a ca, the server certificate, dhparams
and the configuration for client and server. The ca private key
is encrypted using a aes. The key is printed at boot so make sure
to grab it. Otherwise there will be no way to add users.

A new user can be added by generating a signing request on the 
users maschine:

```
USER="<user>"
openssl genrsa -out "${USER}.key" 4096
openssl req -new -key "${USER}.key" \
    -out "${USER}.req" -subj "/CN=${USER}"
```

Transfer the `.req` file to the `./config/keys/reqs` folder of 
the container. By executing:

```
docker exec -it openvpn-alpine /entrypoint.sh sign
```

A new certificate is created for the user. Transfer it from 
`./config/keys/issued` to the client maschine as well as 
`./config/keys/ca.crt` and `./config/openvpn-client.conf`.

## docker-compose.yml

Here is an example using docker-compose.yml with SSL:

```yaml
openvpn-alpine:
  image: toendeavour/openvpn-alpine
  restart: always
  environment:
    - "DOMAIN=<DOMAIN>"
    - "FORWARD=1"
  ports:
    - "1194:1194/udp"
  volumes:
    - ./config:/etc/openvpn/config
  cap_add:
    - NET_ADMIN
  devices:
    - /dev/net/tun:/dev/net/tun
  sysctls:
    - net.ipv6.conf.all.disable_ipv6=0
    - net.ipv6.conf.all.forwarding=1
```

## No forwarding

Forwarding can be deactivated by changing the environment
variable `FORWARD` to `0`. It is also necessary to remove the 
following entries from the openvpn configuration 
(`./config/openvpn.conf`) 

```
push "redirect-gateway def1"
push "redirect-gateway ipv6"
push "dhcp-option DNS 8.8.8.8"
```

## No IPv6

IPv6 can be disabled by removing:

```
--sysctl net.ipv6.conf.all.disable_ipv6=0 \
--sysctl net.ipv6.conf.all.forwarding=1 \
```

from the docker run command and by removing:

```
server-ipv6 fc00:1:1:1::/64
```

from the openvpn configuration (`./config/openvpn.conf`) . 

## Custom Configuration

If you don't want anything to be created, simple pre create
the configuration folder `./config` with the following files:

```
config/
| keys/
| openvpn.conf
```
