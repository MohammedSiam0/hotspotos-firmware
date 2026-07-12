#!/bin/sh
# HotspotOS Internet Client - Main Controller

. /usr/lib/hotspotos/config.sh
. /usr/lib/hotspotos/logger.sh

# Load configuration
load_client_config() {
    CLIENT_ENABLED=$(uci_get hotspot-client main enabled 0)
    CLIENT_USERNAME=$(uci_get hotspot-client main username "")
    CLIENT_PASSWORD=$(uci_get hotspot-client main password "")
    CLIENT_LOGIN_URL=$(uci_get hotspot-client main login_url "")
    CLIENT_LOGOUT_URL=$(uci_get hotspot-client main logout_url "")
    CLIENT_AUTO_LOGIN=$(uci_get hotspot-client main auto_login 1)
    CLIENT_AUTO_RECONNECT=$(uci_get hotspot-client main auto_reconnect 1)
    CLIENT_RECONNECT_INTERVAL=$(uci_get hotspot-client main reconnect_interval 60)
    CLIENT_CHECK_INTERVAL=$(uci_get hotspot-client main check_interval 30)
    CLIENT_CONNECTION_TYPE=$(uci_get hotspot-client main connection_type "http")
    CLIENT_INTERFACE=$(uci_get hotspot-client main interface "wan")
}

# Check internet connectivity
check_internet() {
    local check_host
    local check_port
    local timeout

    check_host=$(uci_get hotspot-client monitor check_host "8.8.8.8")
    check_port=$(uci_get hotspot-client monitor check_port "53")
    timeout=$(uci_get hotspot-client monitor timeout "5")

    nc -z -w "$timeout" "$check_host" "$check_port" >/dev/null 2>&1
    return $?
}

# Get WAN IP
get_wan_ip() {
    local iface
    iface=$(uci_get hotspot-client main interface "wan")
    ip -4 addr show "$iface" 2>/dev/null | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | head -1
}

# Main client status
client_status() {
    load_client_config

    echo "HotspotOS Internet Client Status"
    echo "================================"
    echo "Enabled: $CLIENT_ENABLED"
    echo "Username: $CLIENT_USERNAME"
    echo "Login URL: $CLIENT_LOGIN_URL"
    echo "Auto Login: $CLIENT_AUTO_LOGIN"
    echo "Auto Reconnect: $CLIENT_AUTO_RECONNECT"
    echo "Connection Type: $CLIENT_CONNECTION_TYPE"
    echo "Interface: $CLIENT_INTERFACE"
    echo ""

    local wan_ip
    wan_ip=$(get_wan_ip)
    echo "WAN IP: ${wan_ip:-Not connected}"

    if check_internet; then
        echo "Internet: Connected"
    else
        echo "Internet: Disconnected"
    fi
}
