#!/bin/bash

mkdir licheepi-image
mkdir licheepi-image/rootfs
mkdir licheepi-image/BOOT

dd if=/dev/zero of=licheepi-debian.img bs=1M seek=2048 count=0

cat << EOT | fdisk licheepi-debian.img
n
p
1
8192
+20M
n
p
2
49152
+512M
n
p
3
1097728

t
1
c
t
2
82
w
EOT

# Mount first partition

losetup -o $((512*8192)) --sizelimit 20M /dev/loop0 licheepi-debian.img
mkfs.vfat /dev/loop0
fatlabel /dev/loop0 BOOT
mount -t vfat /dev/loop0 licheepi-image/BOOT

# Mount second partition

losetup -o 562036736 --sizelimit 1G /dev/loop1 licheepi-debian.img
mkfs.ext4 /dev/loop1 -L rootfs
mount -t ext4 /dev/loop1 licheepi-image/rootfs

# Make swap
#TODO
