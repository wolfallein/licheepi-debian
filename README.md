# licheepi-debian

# Dependencies (Debian/Ubuntu)

General:

````
sudo apt install git build-essential
````

For u-boot build:

````
sudo apt install gcc-arm-linux-gnueabihf \
    bison flex swig python3-distutils python3-dev
````

For Linux Kernel 5.7:

````
sudo apt install libssl-dev u-boot-tools
````

For generating Debian rootfs:

````
sudo apt install multistrap qemu-user-static
````

--
Also (Don't remember where):

````
sudo apt install python
````

# Automatic procedure

Run:

````
./auto-create-image.sh
````

Copy image to SD card (Replace /dev/sdX with your SD card):

````
sudo dd bs=4M if=clockworkpi-debian.img of=/dev/sdX conv=fsync
````
