#!/bin/sh
# HotspotOS Version Information

HOTSPOTOS_VERSION="1.0.0"
HOTSPOTOS_BUILD="20240712"
HOTSPOTOS_TARGET="lantiq/xrx200"
HOTSPOTOS_OPENWRT="23.05.6"

get_version() {
    echo "$HOTSPOTOS_VERSION"
}

get_full_version() {
    echo "HotspotOS v${HOTSPOTOS_VERSION} (Build: ${HOTSPOTOS_BUILD})"
    echo "Target: ${HOTSPOTOS_TARGET}"
    echo "OpenWrt Base: ${HOTSPOTOS_OPENWRT}"
}

case "$1" in
    --full)
        get_full_version
        ;;
    *)
        get_version
        ;;
esac
