#!/bin/bash
set -e

# Variables
IMAGE_NAME="alpine-arm64.qcow2"
IMAGE_SIZE="2G"
ALPINE_VERSION="3.22.0"
ALPINE_ISO="alpine-standard-${ALPINE_VERSION}-aarch64.iso"
DOWNLOAD_URL="https://dl-cdn.alpinelinux.org/alpine/latest-stable/releases/aarch64/${ALPINE_ISO}"

# Installer Alpine ISO si elle n'existe pas
if [ ! -f "$ALPINE_ISO" ]; then
    echo "Téléchargement de Alpine ISO..."
    curl -LO $DOWNLOAD_URL
fi

# Créer l'image disque
if [ ! -f "$IMAGE_NAME" ]; then
    echo "Création de l'image disque $IMAGE_NAME..."
    qemu-img create -f qcow2 $IMAGE_NAME $IMAGE_SIZE
fi

# Installer Alpine en mode unattended
# Ici, on utilise la méthode minirootfs pour automatiser
if [ ! -d "rootfs" ]; then
    echo "Téléchargement minirootfs..."
    curl -LO https://dl-cdn.alpinelinux.org/alpine/latest-stable/releases/aarch64/alpine-minirootfs-${ALPINE_VERSION}-aarch64.tar.gz
    mkdir rootfs
    tar -xzf alpine-minirootfs-${ALPINE_VERSION}-aarch64.tar.gz -C rootfs
fi

echo "Image prête : $IMAGE_NAME"
