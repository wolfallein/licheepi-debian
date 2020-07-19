#!/bin/bash
rootfs_dir="licheepi-image/rootfs"

# Create filesystem with packages
multistrap -a armhf -f multistrap.conf

# Configure new system
cp /usr/bin/qemu-arm-static $rootfs_dir/usr/bin
mount -o bind /dev/ $rootfs_dir/dev/
# Set environment variables
export DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true
export LC_ALL=C LANGUAGE=C LANG=C
chroot $rootfs_dir dpkg --configure -a
# For some reason the following packages are configured before dependences
# Try to reconfigure. Maybe can be removed in future.
chroot $rootfs_dir dpkg --configure base-files
chroot $rootfs_dir dpkg --configure bash
# Empty root password
chroot $rootfs_dir passwd -d root
# Kill processes running in rootfs
fuser -sk $rootfs_dir
rm $rootfs_dir/usr/bin/qemu-arm-static
umount $rootfs_dir/dev/

# Create fstab
#microSD partitions mounting
filename=$rootfs_dir/etc/fstab
echo /dev/mmcblk0p1 /boot vfat noatime 0 1 >> $filename
echo /dev/mmcblk0p2 swap swap noatime 0 0 >> $filename
echo /dev/mmcblk0p3 / ext4 noatime 0 1 >> $filename
echo proc /proc proc defaults 0 0 >> $filename

# Copy network files
cp interfaces $rootfs_dir/etc/network/

# Add modules to start at boot
echo g_ether >> $rootfs_dir/etc/modules

# Fix dhcp server for RNDIS usb
#echo "subnet 192.168.11.0 netmask 255.255.255.0 {
#  range 192.168.11.10 192.168.11.250;
#}" >> $rootfs_dir/etc/dhcp/dhcpd.conf
#sed -i "s/option domain-name/#option domain-name/" $rootfs_dir/etc/dhcp/dhcpd.conf
#sed -i "s/option domain-name-servers/#option domain-name-servers/" $rootfs_dir/etc/dhcp/dhcpd.conf
#echo INTERFACES=\"usb0\" >> $rootfs_dir/etc/default/isc-dhcp-server

# Enable root autologin on serial
#filename=$rootfs_dir/lib/systemd/system/serial-getty@.service
#autologin='--autologin root'
#execstart='ExecStart=-\/sbin\/agetty'
#if [[ ! $(grep -e "$autologin" $filename) ]]; then
#    sed -i "s/$execstart/$execstart $autologin/" $filename
#fi

# Don'w wait dev-%i.device on serial
filename=$rootfs_dir/lib/systemd/system/serial-getty@.service
After_a='After=dev-%i.device '
After_b='After='
sed -i "s/$After_a/$After_b/" $filename

#autologin='--autologin root'
#execstart='ExecStart=-\/sbin\/agetty'
#if [[ ! $(grep -e "$autologin" $filename) ]]; then
#    sed -i "s/$execstart/$execstart $autologin/" $filename
#fi

# Enable root autologin on TTY1
filename=$rootfs_dir/lib/systemd/system/getty@.service
autologin='--autologin root'
execstart='ExecStart=-\/sbin\/agetty'
if [[ ! $(grep -e "$autologin" $filename) ]]; then
    sed -i "s/$execstart/$execstart $autologin/" $filename
fi

# Set systemd logging
filename=$rootfs_dir/etc/systemd/system.conf
for i in 'LogLevel=warning'\
         'LogTarget=journal'\
; do
    sed -i "/${i%=*}/c\\$i" $filename
done

# Enable root to connect to ssh with empty password
filename=$rootfs_dir/etc/ssh/sshd_config
if [[ -f $filename ]]; then
    for i in 'PermitRootLogin yes'\
             'PermitEmptyPasswords yes'\
             'UsePAM no'\
    ; do
        sed -ri "/^#?${i% *}/c\\$i" $filename
    done
fi

echo
echo "$rootfs_dir configured"
