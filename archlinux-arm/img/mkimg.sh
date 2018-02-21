#!/bin/bash
set -e
ARCHITECTURE="${1}"

if [ -z "${ARCHITECTURE}" ]; then
    echo "Missing Architecture"
    exit 1
fi

# Preare binfmts to use /usr/bin/qemu-amd-static or /usr/bin/qemu-aarch64-static for amd emulation
sudo update-binfmts --import qemu-arm
sudo update-binfmts --import qemu-arm
sudo update-binfmts --import qemu-aarch64
sudo update-binfmts --import qemu-aarch64

# Prepare chroot folder
mkdir -p "${ARCHITECTURE}/usr/bin/"

# Prepare pacman config file
cp pacman.conf "pacman.${ARCHITECTURE}.conf"
sed -i -e "s/<ARCHITECTURE>/${ARCHITECTURE}/g" pacman.${ARCHITECTURE}.conf

# Install base system
sudo cp -r bin/* "${ARCHITECTURE}/usr/bin/"
if [ "${ARCHITECTURE}" == "aarch64" ]; then
    sudo rm -f ${ARCHITECTURE}/usr/bin/qemu-arm-static
else
    sudo rm -f ${ARCHITECTURE}/usr/bin/qemu-aarch64-static
fi
sudo pacstrap -C "pacman.${ARCHITECTURE}.conf" -G -M "${ARCHITECTURE}" base

# Remove extra stuff
sudo rm -Rf "${ARCHITECTURE}/var/cache"
sudo rm -Rf "${ARCHITECTURE}/var/lib/pacman/sync"
sudo rm -Rf "${ARCHITECTURE}/var/log"

# Compress Image
sudo tar -cjSf ../${ARCHITECTURE}.tar.bzip2 -C ${ARCHITECTURE} .

# Remove local stuff
rm "pacman.${ARCHITECTURE}.conf"
sudo rm -Rf "${ARCHITECTURE}"
