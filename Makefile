# HotspotOS - Custom OpenWrt Firmware
# Version: 1.0.0
# Target: lantiq/xrx200 | OpenWrt 23.05.x
# Author: HotspotOS Team

HOTSPOTOS_VERSION := 1.0.0
OPENWRT_VERSION := 23.05.6
TARGET := lantiq
SUBTARGET := xrx200

BUILD_DIR := $(CURDIR)/build
OUTPUT_DIR := $(CURDIR)/bin
DL_DIR := $(CURDIR)/dl
SCRIPTS_DIR := $(CURDIR)/scripts

.PHONY: all setup feeds config download build clean distclean test flash info

all: build

info:
	@echo "=========================================="
	@echo "  HotspotOS v$(HOTSPOTOS_VERSION)"
	@echo "  Target: $(TARGET)/$(SUBTARGET)"
	@echo "  OpenWrt Base: $(OPENWRT_VERSION)"
	@echo "=========================================="

setup: info
	@echo "[SETUP] Creating directories..."
	@mkdir -p $(BUILD_DIR) $(OUTPUT_DIR) $(DL_DIR)
	@if [ ! -d "$(BUILD_DIR)/openwrt" ]; then 		echo "[SETUP] Cloning OpenWrt $(OPENWRT_VERSION)..."; 		git clone --depth 1 --branch v$(OPENWRT_VERSION) 			https://git.openwrt.org/openwrt/openwrt.git $(BUILD_DIR)/openwrt; 	else 		echo "[SETUP] OpenWrt source already exists."; 	fi
	@echo "[SETUP] Installing build dependencies..."
	@sudo apt-get update -qq && sudo apt-get install -y -qq \
		build-essential clang flex bison g++ gawk \
		gcc-multilib g++-multilib gettext git libncurses5-dev \
		libssl-dev python3-distutils rsync unzip zlib1g-dev \
		file wget curl > /dev/null 2>&1 || true

feeds: setup
	@echo "[FEEDS] Updating and installing feeds..."
	@cd $(BUILD_DIR)/openwrt && 		cp $(CURDIR)/feeds.conf.hotspotos feeds.conf && 		./scripts/feeds update -a && 		./scripts/feeds install -a
	@echo "[FEEDS] Installing HotspotOS custom packages..."
	@cd $(BUILD_DIR)/openwrt && 		cp -r $(CURDIR)/package/* package/ 2>/dev/null || true && 		./scripts/feeds install -a -p hotspotos 2>/dev/null || true

config: feeds
	@echo "[CONFIG] Applying HotspotOS configuration..."
	@cd $(BUILD_DIR)/openwrt && 		cp $(CURDIR)/.config .config && 		make defconfig

download: config
	@echo "[DOWNLOAD] Downloading all sources..."
	@cd $(BUILD_DIR)/openwrt && make download -j$$(nproc)

build: download
	@echo "[BUILD] Starting firmware compilation..."
	@echo "[BUILD] This may take 30-120 minutes depending on your system."
	@cd $(BUILD_DIR)/openwrt && 		make -j$$(nproc) V=s 2>&1 | tee $(OUTPUT_DIR)/build.log
	@echo "[BUILD] Copying firmware images..."
	@mkdir -p $(OUTPUT_DIR)/packages
	@cp $(BUILD_DIR)/openwrt/bin/targets/$(TARGET)/$(SUBTARGET)/*.bin $(OUTPUT_DIR)/ 2>/dev/null || true
	@cp $(BUILD_DIR)/openwrt/bin/targets/$(TARGET)/$(SUBTARGET)/*.img $(OUTPUT_DIR)/ 2>/dev/null || true
	@cp $(BUILD_DIR)/openwrt/bin/targets/$(TARGET)/$(SUBTARGET)/sha256sums $(OUTPUT_DIR)/ 2>/dev/null || true
	@cp $(BUILD_DIR)/openwrt/bin/packages/*/hotspotos/*.ipk $(OUTPUT_DIR)/packages/ 2>/dev/null || true
	@$(SCRIPTS_DIR)/rename-images.sh $(HOTSPOTOS_VERSION) $(OUTPUT_DIR) || true
	@echo "[BUILD] Build complete! Check $(OUTPUT_DIR)/"

clean:
	@echo "[CLEAN] Cleaning build artifacts..."
	@rm -rf $(BUILD_DIR)/openwrt/bin $(BUILD_DIR)/openwrt/build_dir
	@rm -rf $(OUTPUT_DIR)/*.bin $(OUTPUT_DIR)/*.img $(OUTPUT_DIR)/build.log

distclean:
	@echo "[DISTCLEAN] Removing everything..."
	@rm -rf $(BUILD_DIR) $(OUTPUT_DIR) $(DL_DIR)

test:
	@echo "[TEST] Running build verification tests..."
	@$(SCRIPTS_DIR)/test-build.sh

flash:
	@echo "[FLASH] Flashing firmware to device..."
	@$(SCRIPTS_DIR)/flash.sh $(OUTPUT_DIR)
