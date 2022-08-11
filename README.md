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

For Linux Kernel 5.12:

````
sudo apt install libssl-dev u-boot-tools libmpc-dev
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
sudo dd bs=4M if=licheepi-debian.img of=/dev/sdX conv=fsync
````

# Connect

The USB OTG port is configured to emulate a ethernet device when connected to a computer

The IP is configured as: 192.168.11.2

To communicate with the board you need to set the new ethernet port with 192.168.11.1 and gateway being 192.168.11.1 and DNS 8.8.8.8

You should be able to connect using SSH now:

````
ssh root@192.168.11.1
````

When asked for password, just press `ENTER`.

add default gateway with:

````
route add default gw 192.168.7.1
````

Now, on your PC:

Share internet with the following:

````
sudo iptables --table nat --append POSTROUTING --out-interface wlp3s0 -j MASQUERADE
sudo iptables --append FORWARD --in-interface wlp3s0 -j ACCEPT
echo 1 | sudo tee -a /proc/sys/net/ipv4/ip_forward
````
where **wlp3s0** is your network card connected to the internet.

Set date with:

````
timedatectl set-date "YYYY-MM-DD HH:MM:SS"
````

Enable swap:

````
swapon /dev/mmcblk0p2
````
