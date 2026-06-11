TARGET_DIR = live-build/config/includes.chroot/usr/share/images/desktop-base

all: build

prepare:
	@echo "=== 1. Cai dat he thong dong goi goc Kali ==="
	apt-get update && apt-get install -y kali-live-build live-build imagemagick apt-utils
	@echo "=== 2. Tu khoi tao phoi cau hinh noi bo ==="
	kali-live-build-config --variant minimal --dir live-build

draw-ui:
	@echo "=== 3. Tu dong ve hinh nen va logo DuyKhanh OS ==="
	mkdir -p $(TARGET_DIR)
	convert -size 1920x1080 xc:black -font DejaVu-Sans-Bold -pointsize 72 -fill "#00FF00" -gravity center -draw "text 0,0 'FINAL-DUYKHANHOS v5'" -fill white -pointsize 24 -draw "text 0,80 'Custom Security OS by DuyKhanh'" $(TARGET_DIR)/login-background.png
	cp $(TARGET_DIR)/login-background.png $(TARGET_DIR)/kali-wallpaper-16x9.png
	convert -size 512x512 xc:black -font DejaVu-Sans-Bold -pointsize 48 -fill "#00FF00" -gravity center -draw "text 0,0 'DK OS'" $(TARGET_DIR)/kali-logo-light.png
	cp $(TARGET_DIR)/kali-logo-light.png $(TARGET_DIR)/kali-logo-dark.png

inject-apps:
	@echo "=== 4. Tich hop giao dien XFCE, Terminal, Wifi va App ==="
	mkdir -p live-build/config/package-lists
	echo 'kali-desktop-xfce xfce4-terminal kali-themes lightdm network-manager-gnome firmware-linux firmware-linux-nonfree firmware-iwlwifi firmware-realtek firmware-brcm80211 wpasupplicant chromium' > live-build/config/package-lists/kali.list.chroot

configure:
	@echo "=== 5. Cau hinh thong so dia ISO ==="
	cd live-build && lb config --iso-volume 'DUYKHANHOSv5' --apt-options '--yes --force-yes --fix-missing'

compile:
	@echo "=== 6. Khoi chay tien trinh bien dich nen file ISO ==="
	cd live-build && lb build

build: prepare draw-ui inject-apps configure compile
	@echo "=== HOAN THANH BUILD ISO ==="
