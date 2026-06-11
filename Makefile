TARGET_DIR = live-build/config/includes.chroot/usr/share/images/desktop-base

all: build

prepare:
	@echo "=== 1. Cài đặt hệ thống đóng gói gốc Kali ==="
	apt-get update && apt-get install -y kali-live-build live-build imagemagick apt-utils
	@echo "=== 2. Tự khởi tạo phôi cấu hình nội bộ ==="
	kali-live-build-config --variant minimal --dir live-build

draw-ui:
	@echo "=== 3. Tự động vẽ hình nền và logo DuyKhánh OS ==="
	mkdir -p $(TARGET_DIR)
	convert -size 1920x1080 xc:black -font DejaVu-Sans-Bold -pointsize 72 -fill "#00FF00" -gravity center -draw "text 0,0 'FINAL-DUYKHANHOS v5'" -fill white -pointsize 24 -draw "text 0,80 'Custom Security OS by DuyKhanh'" $(TARGET_DIR)/login-background.png
	cp $(TARGET_DIR)/login-background.png $(TARGET_DIR)/kali-wallpaper-16x9.png
	convert -size 512x512 xc:black -font DejaVu-Sans-Bold -pointsize 48 -fill "#00FF00" -gravity center -draw "text 0,0 'DK OS'" $(TARGET_DIR)/kali-logo-light.png
	cp $(TARGET_DIR)/kali-logo-light.png $(TARGET_DIR)/kali-logo-dark.png

inject-apps:
	@echo "=== 4. Tích hợp giao diện XFCE, Terminal, Wifi và App ==="
	mkdir -p live-build/config/package-lists
	@if [ -f config/packages.chroot ]; then \
		cp config/packages.chroot live-build/config/package-lists/kali.list.chroot; \
	else \
		echo 'kali-desktop-xfce xfce4-terminal kali-themes lightdm network-manager-gnome firmware-linux firmware-linux-nonfree firmware-iwlwifi firmware-realtek firmware-brcm80211 wpasupplicant chromium' > live-build/config/package-lists/kali.list.chroot; \
	fi
	@if [ -d config/includes.chroot ]; then \
		cp -r config/includes.chroot/* live-build/config/includes.chroot/; \
	fi

configure:
	@echo "=== 5. Cấu hình thông số đĩa ISO ==="
	cd live-build && lb config --iso-volume 'DUYKHANHOSv5' --apt-options '--yes --force-yes --fix-missing'

compile:
	@echo "=== 6. Khởi chạy tiến trình biên dịch nén file ISO ==="
	cd live-build && lb build

build: prepare draw-ui inject-apps configure compile
	@echo "=== HOÀN THÀNH BUILD ISO ==="
