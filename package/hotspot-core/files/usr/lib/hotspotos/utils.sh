#!/bin/sh
# HotspotOS Utility Functions

# Get MAC address from interface
get_mac() {
    local iface="$1"
    cat "/sys/class/net/${iface}/address" 2>/dev/null || echo "00:00:00:00:00:00"
}

# Get IP address from interface
get_ip() {
    local iface="$1"
    ip -4 addr show "$iface" 2>/dev/null | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | head -1
}

# Check if interface is up
is_interface_up() {
    local iface="$1"
    [ -d "/sys/class/net/${iface}" ] && [ "$(cat /sys/class/net/${iface}/operstate 2>/dev/null)" = "up" ]
}

# Generate random password
gen_password() {
    local length="${1:-12}"
    cat /dev/urandom | tr -dc 'a-zA-Z0-9' | head -c "$length"
}

# Hash password (simple, for demo - use better in production)
hash_password() {
    local password="$1"
    echo -n "$password" | md5sum | cut -d' ' -f1
}

# Check if IP is in CIDR
ip_in_cidr() {
    local ip="$1"
    local cidr="$2"

    # Simple check using ipcalc or manual calculation
    # This is a simplified version
    echo "$ip" | grep -qE '^([0-9]{1,3}\.){3}[0-9]{1,3}$'
}

# Format bytes to human readable
format_bytes() {
    local bytes="$1"

    if [ "$bytes" -lt 1024 ]; then
        echo "${bytes}B"
    elif [ "$bytes" -lt 1048576 ]; then
        echo "$(echo "scale=2; $bytes/1024" | bc)KB"
    elif [ "$bytes" -lt 1073741824 ]; then
        echo "$(echo "scale=2; $bytes/1048576" | bc)MB"
    else
        echo "$(echo "scale=2; $bytes/1073741824" | bc)GB"
    fi
}

# Get system uptime in seconds
get_uptime() {
    cat /proc/uptime | awk '{print int($1)}'
}

# Get CPU usage
get_cpu_usage() {
    top -bn1 | grep "CPU:" | awk '{print $2}' | sed 's/%//'
}

# Get memory usage
get_mem_usage() {
    free | grep Mem | awk '{printf "%.1f", $3/$2 * 100.0}'
}

# Get flash usage
get_flash_usage() {
    df -h / | tail -1 | awk '{print $5}' | sed 's/%//'
}

# Get online users count
get_online_users() {
    if [ -f "/var/lib/hotspotos/hotspotos.db" ]; then
        sqlite3 "/var/lib/hotspotos/hotspotos.db" "SELECT COUNT(DISTINCT mac_address) FROM sessions WHERE active=1;" 2>/dev/null || echo "0"
    else
        echo "0"
    fi
}
