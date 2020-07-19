setenv bootargs fsck.repair=yes fsck.mode=force panic=10 rootwait root=/dev/mmcblk0p3 earlyprintk init=/lib/systemd/systemd console=ttyS0,115200 console=tty1
fatload mmc 0:1 0x41000000 uImage
fatload mmc 0:1 0x41800000 sun8i-v3s-licheepi-zero.dtb
bootm 0x41000000 - 0x41800000
