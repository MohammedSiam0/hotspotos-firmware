# HotspotOS Installation Guide

## Prerequisites
- Ubuntu 22.04 LTS or Debian 12
- 20GB free disk space
- Internet connection

## Step 1: Install Dependencies
```bash
sudo ./scripts/setup-env.sh
```

## Step 2: Build Firmware
```bash
make setup    # Clone OpenWrt source
make feeds    # Update feeds
make config   # Apply configuration
make download # Download sources
make build    # Compile firmware
```

## Step 3: Flash Firmware

### Via LuCI Web Interface
1. Open http://192.168.1.1
2. Login as root
3. System -> Backup/Flash Firmware
4. Upload `hotspotos-v1-squashfs-sysupgrade.bin`
5. Uncheck "Keep settings" for clean install

### Via SSH (Recommended)
```bash
scp bin/hotspotos-v1-squashfs-sysupgrade.bin root@192.168.1.1:/tmp/
ssh root@192.168.1.1
sysupgrade -v /tmp/hotspotos-v1-squashfs-sysupgrade.bin
```

### Factory Flash (First Time)
Use TFTP recovery mode or vendor web interface with `*-factory.bin`

## Post-Installation
1. Access LuCI at http://192.168.1.1
2. Default login: root / (no password)
3. Go to HotspotOS menu to configure
4. Set admin password immediately
