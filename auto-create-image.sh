#!/bin/bash
# Cleaning
sudo rm licheepi-debian.img
sudo rm -rf linux
sudo rm -rf u-boot
sudo rm boot.scr
echo "Generating image file and mounting"
sudo ./create-image.sh
echo "Generating u-boot"
./create-u-boot.sh
sudo dd if=u-boot/u-boot-sunxi-with-spl.bin of=licheepi-debian.img bs=1024 seek=8
echo "Generating Debian files"
sudo ./create-debian.sh
echo "Generating Kernel"
./create-kernel.sh
sudo cp -p linux/uImage licheepi-image/BOOT/
sudo cp -p linux/arch/arm/boot/dts/sun8i-v3s-licheepi-zero-with-480x272-lcd.dtb licheepi-image/BOOT/sun8i-v3s-licheepi-zero.dtb
echo "Generating boot.scr"
mkimage -C none -A arm -T script -d boot.cmd boot.scr
sudo cp -p boot.scr licheepi-image/BOOT/
echo "Installing kernel modules"
cd linux/
sudo make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- INSTALL_MOD_PATH=$(pwd)/../licheepi-image/rootfs modules_install
cd ..
echo "Finishing job"
sudo umount licheepi-image/BOOT
sudo losetup -d /dev/loop0
sudo umount licheepi-image/rootfs
sudo losetup -d /dev/loop1
sudo rm -rf licheepi-image
