#!/bin/bash
# Cleaning
echo "Cleaning directory"
sudo rm licheepi-debian.img
sudo rm -rf linux
sudo rm -rf u-boot
sudo rm boot.scr
rm -rf gcc-linaro-7.5.0-2019.12-x86_64_arm-linux-gnueabihf
rm gcc-linaro-7.5.0-2019.12-x86_64_arm-linux-gnueabihf.tar.xz
rm -rf gcc-linaro-6.5.0-2018.12-x86_64_arm-linux-gnueabihf
rm gcc-linaro-6.5.0-2018.12-x86_64_arm-linux-gnueabihf.tar.xz
echo "Generating u-boot toolchain"
wget -c https://releases.linaro.org/components/toolchain/binaries/6.5-2018.12/arm-linux-gnueabihf/gcc-linaro-6.5.0-2018.12-x86_64_arm-linux-gnueabihf.tar.xz
tar xf gcc-linaro-6.5.0-2018.12-x86_64_arm-linux-gnueabihf.tar.xz
echo "Generating kernel toolchain"
wget -c https://releases.linaro.org/components/toolchain/binaries/latest-7/arm-linux-gnueabihf/gcc-linaro-7.5.0-2019.12-x86_64_arm-linux-gnueabihf.tar.xz
tar xf gcc-linaro-7.5.0-2019.12-x86_64_arm-linux-gnueabihf.tar.xz
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
sudo make ARCH=arm CROSS_COMPILE=`pwd`/../gcc-linaro-7.5.0-2019.12-x86_64_arm-linux-gnueabihf/bin/arm-linux-gnueabihf- INSTALL_MOD_PATH=$(pwd)/../licheepi-image/rootfs modules_install
cd ..
echo "Finishing job"
sudo umount licheepi-image/BOOT
sudo losetup -d /dev/loop0
sudo umount licheepi-image/rootfs
sudo losetup -d /dev/loop1
sudo rm -rf licheepi-image
