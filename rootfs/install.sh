#!/bin/bash
echo "Installing DuyKhanhOS to /dev/sda..."
# Partition, format, copy rootfs
mount /dev/sda1 /mnt
cp -a /rootfs/* /mnt/
echo "Installation complete. Reboot now."
