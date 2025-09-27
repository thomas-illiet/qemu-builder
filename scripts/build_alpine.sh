#!/bin/bash
set -e

# Variables
IMAGE_NAME="alpine-amd64-docker.qcow2"
IMAGE_SIZE="2G"
ALPINE_VERSION="3.22.0"
MINIROOTFS="alpine-minirootfs-${ALPINE_VERSION}-x86_64.tar.gz"
ROOTFS_DIR="rootfs"

# Télécharger minirootfs si nécessaire
if [ ! -f "$MINIROOTFS" ]; then
    curl -LO https://dl-cdn.alpinelinux.org/alpine/latest-stable/releases/x86_64/$MINIROOTFS
fi

# Créer rootfs
mkdir -p $ROOTFS_DIR
tar -xzf $MINIROOTFS -C $ROOTFS_DIR

# Entrer dans le rootfs et installer Docker
sudo chroot $ROOTFS_DIR /bin/sh <<'EOF'
set -e
apk update
apk add --no-cache docker openrc bash curl
rc-update add docker boot
EOF

# Créer l'image QEMU et copier le rootfs
qemu-img create -f qcow2 $IMAGE_NAME $IMAGE_SIZE

# Copier le rootfs dans l'image (nécessite qemu-utils / virt-copy-in)
virt-copy-in -a $IMAGE_NAME $ROOTFS_DIR/ /

echo "Image Alpine ARM64 avec Docker prête : $IMAGE_NAME"
