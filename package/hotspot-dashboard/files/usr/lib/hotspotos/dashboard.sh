#!/bin/sh
# HotspotOS Dashboard Controller

. /usr/lib/hotspotos/utils.sh

show_dashboard() {
    echo "HotspotOS Dashboard"
    echo "=================="
    echo "Internet: $(ping -c 1 8.8.8.8 >/dev/null 2>&1 && echo "Online" || echo "Offline")"
    echo "Online Users: $(get_online_users)"
    echo "CPU: $(get_cpu_usage)%"
    echo "RAM: $(get_mem_usage)%"
    echo "Flash: $(get_flash_usage)%"
    echo "Uptime: $(get_uptime) seconds"
}
