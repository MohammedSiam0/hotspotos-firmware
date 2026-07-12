#!/bin/sh
# HotspotOS Captive Portal - DNS and Redirect Setup

. /usr/lib/hotspotos/config.sh
. /usr/lib/hotspotos/logger.sh

# Setup DNS redirect for captive portal
setup_dns() {
    local enabled
    enabled=$(uci_get hotspot-server main enabled 0)

    [ "$enabled" -eq 0 ] && return 0

    log_info "portal" "Setting up DNS redirect for captive portal"

    # Add dnsmasq config for captive portal
    local lan_ip
    lan_ip=$(uci_get network lan ipaddr "192.168.1.1")

    cat > /tmp/dnsmasq.d/hotspot-server.conf <<EOF
# HotspotOS Captive Portal DNS
address=/#/${lan_ip}
EOF

    # Restart dnsmasq
    /etc/init.d/dnsmasq restart

    log_info "portal" "DNS redirect configured"
}

# Remove DNS redirect
cleanup_dns() {
    log_info "portal" "Removing DNS redirect"
    rm -f /tmp/dnsmasq.d/hotspot-server.conf
    /etc/init.d/dnsmasq restart
}

# Main entry point
case "$1" in
    setup-dns)
        setup_dns
        ;;
    cleanup-dns)
        cleanup_dns
        ;;
    *)
        echo "Usage: $0 {setup-dns|cleanup-dns}"
        exit 1
        ;;
esac
