#!/bin/sh
# HotspotOS TTL Manager

. /usr/lib/hotspotos/config.sh
. /usr/lib/hotspotos/logger.sh

TTL_TABLE="hotspotos-ttl"

# Apply TTL rules
apply_ttl() {
    local enabled ttl_value interface direction protocol

    enabled=$(uci_get hotspot-ttl main enabled 0)
    ttl_value=$(uci_get hotspot-ttl main ttl_value 65)
    interface=$(uci_get hotspot-ttl main interface "wan")
    direction=$(uci_get hotspot-ttl main direction "both")
    protocol=$(uci_get hotspot-ttl main protocol "all")

    [ "$enabled" -eq 0 ] && {
        echo "TTL manager is disabled"
        return 0
    }

    log_info "ttl" "Applying TTL=$ttl_value on $interface (direction=$direction)"

    # Create nftables table for TTL
    nft add table inet "$TTL_TABLE" 2>/dev/null || true

    case "$direction" in
        outgoing|both)
            nft add chain inet "$TTL_TABLE" postrouting '{ type nat hook postrouting priority 100; }' 2>/dev/null || true

            if [ "$protocol" = "all" ] || [ "$protocol" = "tcp" ]; then
                nft add rule inet "$TTL_TABLE" postrouting oifname "$interface" ip protocol tcp ip ttl set "$ttl_value" 2>/dev/null || true
            fi
            if [ "$protocol" = "all" ] || [ "$protocol" = "udp" ]; then
                nft add rule inet "$TTL_TABLE" postrouting oifname "$interface" ip protocol udp ip ttl set "$ttl_value" 2>/dev/null || true
            fi
            if [ "$protocol" = "all" ] || [ "$protocol" = "icmp" ]; then
                nft add rule inet "$TTL_TABLE" postrouting oifname "$interface" ip protocol icmp ip ttl set "$ttl_value" 2>/dev/null || true
            fi
            ;;
    esac

    case "$direction" in
        incoming|both)
            nft add chain inet "$TTL_TABLE" prerouting '{ type filter hook prerouting priority 0; }' 2>/dev/null || true
            ;;
    esac

    log_info "ttl" "TTL rules applied successfully"
    echo "TTL=$ttl_value applied on $interface"
}

# Remove TTL rules
remove_ttl() {
    log_info "ttl" "Removing TTL rules"
    nft delete table inet "$TTL_TABLE" 2>/dev/null || true
    echo "TTL rules removed"
}

# Show TTL status
ttl_status() {
    local enabled ttl_value interface

    enabled=$(uci_get hotspot-ttl main enabled 0)
    ttl_value=$(uci_get hotspot-ttl main ttl_value 65)
    interface=$(uci_get hotspot-ttl main interface "wan")

    echo "HotspotOS TTL Manager Status"
    echo "============================="
    echo "Enabled: $enabled"
    echo "TTL Value: $ttl_value"
    echo "Interface: $interface"
    echo ""

    if nft list table inet "$TTL_TABLE" >/dev/null 2>&1; then
        echo "nftables rules:"
        nft list table inet "$TTL_TABLE" 2>/dev/null
    else
        echo "No active TTL rules"
    fi
}

case "$1" in
    apply)
        apply_ttl
        ;;
    remove)
        remove_ttl
        ;;
    status)
        ttl_status
        ;;
    *)
        echo "Usage: $0 {apply|remove|status}"
        exit 1
        ;;
esac
