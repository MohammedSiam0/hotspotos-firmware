# HotspotOS Upgrade Guide

## Via LuCI
1. Backup configuration: System -> Backup/Flash Firmware -> Generate Archive
2. Flash new firmware image
3. Restore configuration if needed

## Via SSH
```bash
# Backup current config
sysupgrade -b /tmp/backup.tar.gz

# Download new firmware
wget -O /tmp/firmware.bin https://your-server/hotspotos-v1-squashfs-sysupgrade.bin

# Verify checksum
sha256sum /tmp/firmware.bin

# Flash with settings preserved
sysupgrade -v /tmp/firmware.bin

# Flash without preserving settings (clean install)
sysupgrade -n -v /tmp/firmware.bin
```

## Downgrade
If issues occur, downgrade to stock OpenWrt:
```bash
sysupgrade -F /tmp/openwrt-original.bin
```

## Troubleshooting
- Boot fails: Use TFTP recovery
- Forgot password: Reset button or failsafe mode
- LuCI broken: SSH and run `/etc/init.d/uhttpd restart`
