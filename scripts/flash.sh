#!/bin/bash
# HotspotOS Flash Script
# Usage: ./flash.sh [output_dir] [device_ip]

OUTPUT_DIR="${1:-$(pwd)/bin}"
DEVICE_IP="${2:-192.168.1.1}"

echo "=========================================="
echo "  HotspotOS Flash Utility"
echo "=========================================="

# Find sysupgrade image
SYSUPGRADE=$(ls -1 "${OUTPUT_DIR}"/*-sysupgrade.bin 2>/dev/null | head -1)
FACTORY=$(ls -1 "${OUTPUT_DIR}"/*-factory.bin 2>/dev/null | head -1)

if [ -z "$SYSUPGRADE" ] && [ -z "$FACTORY" ]; then
    echo "ERROR: No firmware images found in ${OUTPUT_DIR}"
    echo "Please build first: make build"
    exit 1
fi

echo "Found images:"
[ -n "$SYSUPGRADE" ] && echo "  Sysupgrade: $SYSUPGRADE"
[ -n "$FACTORY" ] && echo "  Factory: $FACTORY"

echo ""
echo "Flash options:"
echo "  1) Flash via SSH (sysupgrade) - requires root@$DEVICE_IP"
echo "  2) Flash via TFTP - requires TFTP server setup"
echo "  3) Manual flash instructions"
echo ""
read -p "Select option (1-3): " option

case $option in
    1)
        if [ -z "$SYSUPGRADE" ]; then
            echo "ERROR: No sysupgrade image found"
            exit 1
        fi
        echo "Flashing via sysupgrade..."
        echo "scp ${SYSUPGRADE} root@${DEVICE_IP}:/tmp/"
        scp "${SYSUPGRADE}" "root@${DEVICE_IP}:/tmp/firmware.bin"
        echo "ssh root@${DEVICE_IP} 'sysupgrade -v /tmp/firmware.bin'"
        ssh "root@${DEVICE_IP}" 'sysupgrade -v /tmp/firmware.bin'
        ;;
    2)
        echo "TFTP flash instructions:"
        echo "  1. Set your PC IP to 192.168.1.2/24"
        echo "  2. Start TFTP server in ${OUTPUT_DIR}"
        echo "  3. Put router in recovery mode (hold reset button)"
        echo "  4. Router will download and flash automatically"
        ;;
    3)
        echo "Manual Flash Instructions:"
        echo ""
        echo "Via LuCI Web Interface:"
        echo "  1. Open http://${DEVICE_IP}"
        echo "  2. Login as root"
        echo "  3. Go to System > Backup/Flash Firmware"
        echo "  4. Upload ${SYSUPGRADE}"
        echo "  5. Uncheck 'Keep settings' for clean install"
        echo "  6. Click 'Flash image'"
        echo ""
        echo "Via SSH (recommended):"
        echo "  scp ${SYSUPGRADE} root@${DEVICE_IP}:/tmp/firmware.bin"
        echo "  ssh root@${DEVICE_IP}"
        echo "  sysupgrade -v /tmp/firmware.bin"
        echo ""
        echo "Factory Flash (first time):"
        echo "  Use TFTP recovery or vendor web interface"
        echo "  Upload ${FACTORY}"
        ;;
    *)
        echo "Invalid option"
        exit 1
        ;;
esac
