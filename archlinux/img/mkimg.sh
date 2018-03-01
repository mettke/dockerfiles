#!/bin/bash
set -e
ARCHITECTURE="${1}"

if [ -z "${ARCHITECTURE}" ]; then
    echo "Missing Architecture"
    exit 1
fi

# Prepare chroot folder
mkdir -p "${ARCHITECTURE}/usr/bin/"

if [ "${ARCHITECTURE}" == "x86_64" ] || 
        [ "${ARCHITECTURE}" == "i686" ]; then
    if [ "${ARCHITECTURE}" == "x86_64" ]; then
        # Prepare pacman config file
        cp pacman.x86_64.conf "pacman.tmp.${ARCHITECTURE}.conf"
    else
        # Prepare pacman config file
        cp pacman.i686.conf "pacman.tmp.${ARCHITECTURE}.conf"
    fi
    sed -i -e "s/<ARCHITECTURE>/${ARCHITECTURE}/g" pacman.tmp.${ARCHITECTURE}.conf
elif [ "${ARCHITECTURE}" == "arm" ] || 
        [ "${ARCHITECTURE}" == "armv6h" ] || 
        [ "${ARCHITECTURE}" == "armv7h" ] || 
        [ "${ARCHITECTURE}" == "aarch64" ]; then
    sudo cp -r bin/* "${ARCHITECTURE}/usr/bin/"
    if [ "${ARCHITECTURE}" == "aarch64" ]; then
        sudo rm -f ${ARCHITECTURE}/usr/bin/qemu-arm-static

        # Prepare binfmts to use /usr/bin/qemu-aarch64-static for amd emulation
        sudo update-binfmts --import qemu-aarch64
        sudo update-binfmts --import qemu-aarch64
    else
        sudo rm -f ${ARCHITECTURE}/usr/bin/qemu-aarch64-static

        # Prepare binfmts to use /usr/bin/qemu-amd-static for amd emulation
        sudo update-binfmts --import qemu-arm
        sudo update-binfmts --import qemu-arm
    fi

    # Prepare pacman config file
    cp pacman.arm.conf "pacman.tmp.${ARCHITECTURE}.conf"
    sed -i -e "s/<ARCHITECTURE>/${ARCHITECTURE}/g" pacman.tmp.${ARCHITECTURE}.conf
else
    echo "unsupported architecture: ${ARCHITECTURE}"
    sudo rm -Rf "${ARCHITECTURE}"
    exit 1
fi

# Install base system
extra=""
if [ "${ARCHITECTURE}" == "arm" ] || 
        [ "${ARCHITECTURE}" == "armv6h" ] || 
        [ "${ARCHITECTURE}" == "armv7h" ] || 
        [ "${ARCHITECTURE}" == "aarch64" ]; then
    extra="archlinux-keyring archlinuxarm-keyring"
fi
sudo pacstrap -C "pacman.tmp.${ARCHITECTURE}.conf" -G -M "${ARCHITECTURE}" base ${extra}
if [ "${ARCHITECTURE}" == "x86_64" ] || 
        [ "${ARCHITECTURE}" == "i686" ]; then
    sudo arch-chroot ${ARCHITECTURE} pacman -R --noconfirm linux linux-firmware mkinitcpio mkinitcpio-busybox
fi

# Remove extra stuff
sudo rm -Rf "${ARCHITECTURE}/var/cache/*"
sudo rm -Rf "${ARCHITECTURE}/var/lib/pacman/sync"
sudo rm -Rf "${ARCHITECTURE}/var/log/*"
sudo install -m 0755 -d "${ARCHITECTURE}/var/cache/pacman/pkg"

# Compress Image
mkdir -p ../tmp/${ARCHITECTURE}/
sudo tar -cjSf ../tmp/${ARCHITECTURE}/${ARCHITECTURE}.tar.bzip2 -C ${ARCHITECTURE} .

# Remove local stuff
rm "pacman.tmp.${ARCHITECTURE}.conf"
sudo rm -Rf "${ARCHITECTURE}"
