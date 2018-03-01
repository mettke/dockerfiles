# archlinux

## Supported tags and respective `Dockerfile` links

- [`arm` (*Dockerfile*)](https://github.com/mettke/dockerfiles/blob/archlinux/archlinux/Dockerfile-arm)
- [`armv6h` (*Dockerfile*)](https://github.com/mettke/dockerfiles/blob/archlinux/archlinux/Dockerfile-armv6h)
- [`armv7h` (*Dockerfile*)](https://github.com/mettke/dockerfiles/blob/archlinux/archlinux/Dockerfile-armv7h)
- [`aarch64` (*Dockerfile*)](https://github.com/mettke/dockerfiles/blob/archlinux/archlinux/Dockerfile-aarch64)
- [`i686` (*Dockerfile*)](https://github.com/mettke/dockerfiles/blob/archlinux/archlinux/Dockerfile-i686)
- [`x86_64` (*Dockerfile*)](https://github.com/mettke/dockerfiles/blob/archlinux/archlinux/Dockerfile-x86_64)
- [`devel-arm` (*Dockerfile*)](https://github.com/mettke/dockerfiles/blob/archlinux/archlinux/Dockerfile-devel-arm)
- [`devel-armv6h` (*Dockerfile*)](https://github.com/mettke/dockerfiles/blob/archlinux/archlinux/Dockerfile-devel-armv6h)
- [`devel-armv7h` (*Dockerfile*)](https://github.com/mettke/dockerfiles/blob/archlinux/archlinux/Dockerfile-devel-armv7h)
- [`devel-aarch64` (*Dockerfile*)](https://github.com/mettke/dockerfiles/blob/archlinux/archlinux/Dockerfile-devel-aarch64)
- [`devel-i686` (*Dockerfile*)](https://github.com/mettke/dockerfiles/blob/archlinux/archlinux/Dockerfile-devel-i686)
- [`devel-x86_64` (*Dockerfile*)](https://github.com/mettke/dockerfiles/blob/archlinux/archlinux/Dockerfile-devel-x86_64)

### tags

All tags are rebuild once a week

## What is archlinux arm

These images contain archlinux (only base (base-devel in devel tag) except kernel) for arm and intel architecture in a docker container.

## How to use this image

### Run archlinux arm

The image can be started using:

```console
docker run --name archlinux \
           --rm -it toendeavour/archlinux:armv7h /bin/sh
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
docker run --name archlinux \
           --rm -it toendeavour/archlinux:armv7h
```
