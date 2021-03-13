#!/bin/bash
git clone https://github.com/torvalds/linux.git --depth=1
cd linux
cp ../licheepi-kernel-5.12.0.patch .
git apply licheepi-kernel-5.12.0.patch
export ARCH=arm
export CROSS_COMPILE=arm-linux-gnueabihf-
make licheepi_zero_defconfig
make -j$(nproc)
mkimage -A arm -O linux -T kernel -C none -a 0x40008000 -e 0x40008000 -n "Linux kernel" -d arch/arm/boot/zImage uImage
chmod +x uImage
cd ..
