#!/usr/bin/env bash

if [ ! -f /etc/pacman.d/mirrorlist.pacnew ]; then
    echo "mirrorlist.pacnew not present, exiting..."
    exit 1
fi

cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist-"$(date -Is)"
cp /etc/pacman.d/mirrorlist.pacnew /etc/pacman.d/mirrorlist.temp
sed -i 's/^#Server/Server/' /etc/pacman.d/mirrorlist.temp
rankmirrors -n 6 /etc/pacman.d/mirrorlist.temp > /etc/pacman.d/mirrorlist
rm /etc/pacman.d/mirrorlist.temp
