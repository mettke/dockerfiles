# archlinux-arm

## Supported tags and respective `Dockerfile` links

- [`arm` (*Dockerfile*)](https://github.com/mettke/dockerfiles/blob/archlinux-arm/archlinux-arm/Dockerfile-arm)
- [`armv6h` (*Dockerfile*)](https://github.com/mettke/dockerfiles/blob/archlinux-arm/archlinux-arm/Dockerfile-armv6h)
- [`armv7h` (*Dockerfile*)](https://github.com/mettke/dockerfiles/blob/archlinux-arm/archlinux-arm/Dockerfile-armv7h)
- [`aarch64` (*Dockerfile*)](https://github.com/mettke/dockerfiles/blob/archlinux-arm/archlinux-arm/Dockerfile-aarch64)

### tags

All tags are rebuild once a week

## What is archlinux arm

These images contain archlinux (only base and base-devel) for arm in a docker container.

## How to use this image

### Run archlinux arm

The image can be started using:

```console
docker run --name archlinux-arm \
           --rm -it toendeavour/archlinux-arm:armv7h /bin/sh
```

### Run archlinux arm under x86_64

The image can also be started under an x86_64 architecture. First the binary
`update-binfmts` must be installed under the host system. Afterwards the file
`/usr/share/binfmts/qemu-arm` must be created with the following content:

```console
package qemu-user-static
interpreter /usr/bin/qemu-arm-static
credentials yes
offset 0
magic \x7fELF\x01\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x28\x00
mask \xff\xff\xff\xff\xff\xff\xff\x00\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff\xff
```

A different file is required for the aarch64 architecture (but both can also coexist). Instead
create the file `/usr/share/binfmts/qemu-aarch64` with the following content:

```console
package qemu-user-static
interpreter /usr/bin/qemu-aarch64-static
credentials yes
offset 0
magic \x7fELF\x02\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\xb7\x00
mask \xff\xff\xff\xff\xff\xff\xff\x00\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff\xff
```

The next step is to register the entry with `update-binfmts` using either
`sudo update-binfmts --import qemu-arm` or `sudo update-binfmts --import qemu-aarch64` *twice*.
Afterwards the image may be started using:

```console
docker run --name archlinux-arm \
           --rm -it toendeavour/archlinux-arm:armv7h
```
