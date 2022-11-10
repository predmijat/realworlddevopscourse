#!/usr/bin/env bash

cp /etc/pacman.d/mirrorlist.pacnew /etc/pacman.d/mirrorlist.temp
sed -i 's/^#Server/Server/' /etc/pacman.d/mirrorlist.temp
rankmirrors -n 6 /etc/pacman.d/mirrorlist.temp > /etc/pacman.d/mirrorlist
rm /etc/pacman.d/mirrorlist.temp
