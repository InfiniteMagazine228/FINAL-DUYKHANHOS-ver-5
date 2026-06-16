#!/bin/bash
set -e

echo "=== DuyKhanhOS Installer ==="

# 1. Xác định ổ đĩa (mặc định /dev/sda)
DISK=/dev/sda
PART=${DISK}1

echo "Target disk: $DISK"

# 2. Xóa partition cũ và tạo mới
echo "Partitioning disk..."
parted --script $DISK mklabel gpt
parted --script $DISK mkpart primary ext4 1MiB 100%
parted --script $DISK set 1 boot on

# 3. Format phân vùng
echo "Formatting partition..."
mkfs.ext4 -F $PART

# 4. Mount và copy rootfs
echo "Copying rootfs..."
mount $PART /mnt
rsync -aAX --exclude={"/mnt/*","/proc/*","/sys/*","/dev/*"} / /mnt/

# 5. Mount các pseudo-filesystems
mount --bind /dev /mnt/dev
mount --bind /proc /mnt/proc
mount --bind /sys /mnt/sys

# 6. Cài GRUB cho ARM64 (EFI)
echo "Installing GRUB..."
chroot /mnt grub-install --target=arm64-efi --efi-directory=/boot --bootloader-id=DuyKhanhOS
chroot /mnt update-grub

# 7. Hoàn tất
echo "Installation complete!"
echo "You can now reboot into DuyKhanhOS."
