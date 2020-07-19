#!/bin/bash
#git clone https://github.com/u-boot/u-boot.git --depth=1
git clone https://github.com/Lichee-Pi/u-boot.git --branch v3s-current --depth=1
cd u-boot
cp ../licheepi-u-boot.patch .
git apply licheepi-u-boot.patch
export ARCH=arm
export CROSS_COMPILE=arm-linux-gnueabihf-
make LicheePi_Zero_480x272LCD_defconfig
make -j$(nproc)
cd ..
