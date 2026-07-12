#!/bin/sh
# HotspotOS nftables Rules Manager

. /usr/lib/hotspotos/config.sh
. /usr/lib/hotspotos/logger.sh

NFT_TABLE="hotspotos"
NFT_SET="authenticated"

# Setup nftables rules
setup_rules() {
    log_info "nftables" "Setting up HotspotOS firewall rules"

    # Create table
    nft add table inet "$NFT_TABLE" 2>/dev/null || true

    # Create sets
    nft add set inet "$NFT_TABLE" "$NFT_SET" '{ type ether_addr; flags timeout; timeout 1h; }' 2>/dev/null || true

    # Add chains
    nft add chain inet "$NFT_TABLE" input '{ type filter hook input priority 0; policy accept; }' 2>/dev/null || true
    nft add chain inet "$NFT_TABLE" forward '{ type filter hook forward priority 0; policy accept; }' 2>/dev/null || true
    nft add chain inet "$NFT_TABLE" prerouting '{ type nat hook prerouting priority 0; }' 2>/dev/null || true

    # Redirect HTTP to captive portal
    local lan_ip
    lan_ip=$(uci_get network lan ipaddr "192.168.1.1")

    nft add rule inet "$NFT_TABLE" prerouting tcp dport 80 meta nftrace set 1 \
        ether saddr != @"$NFT_SET" \
        dnat to "${lan_ip}:80" 2>/dev/null || true

    # Allow DNS
    nft add rule inet "$NFT_TABLE" input udp dport 53 accept 2>/dev/null || true
    nft add rule inet "$NFT_TABLE" input tcp dport 53 accept 2>/dev/null || true

    # Allow DHCP
    nft add rule inet "$NFT_TABLE" input udp dport 67 accept 2>/dev/null || true
    nft add rule inet "$NFT_TABLE" input udp dport 68 accept 2>/dev/null || true

    # Block unauthenticated forward traffic
    nft add rule inet "$NFT_TABLE" forward \
        ether saddr != @"$NFT_SET" \
        drop 2>/dev/null || true

    log_info "nftables" "Firewall rules configured"
}

# Cleanup nftables rules
cleanup_rules() {
    log_info "nftables" "Removing HotspotOS firewall rules"
    nft delete table inet "$NFT_TABLE" 2>/dev/null || true
}

# Add authenticated client
add_client() {
    local mac="$1"
    local ip="$2"

    nft add element inet "$NFT_TABLE" "$NFT_SET" "{ ${mac} }" 2>/dev/null || true
    log_info "nftables" "Added client: MAC=$mac IP=$ip"
}

# Remove client
remove_client() {
    local mac="$1"

    nft delete element inet "$NFT_TABLE" "$NFT_SET" "{ ${mac} }" 2>/dev/null || true
    log_info "nftables" "Removed client: MAC=$mac"
}

# Main entry point
case "$1" in
    setup)
        setup_rules
        ;;
    cleanup)
        cleanup_rules
        ;;
    add-client)
        add_client "$2" "$3"
        ;;
    remove-client)
        remove_client "$2"
        ;;
    *)
        echo "Usage: $0 {setup|cleanup|add-client|remove-client}"
        exit 1
        ;;
esac
