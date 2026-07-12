#!/bin/sh
# HotspotOS Dashboard Data Collector

. /usr/lib/hotspotos/utils.sh

# Collect and store metrics for historical data
collect_data() {
    local timestamp
    timestamp=$(date +%s)

    local cpu ram flash uptime users
    cpu=$(get_cpu_usage)
    ram=$(get_mem_usage)
    flash=$(get_flash_usage)
    uptime=$(get_uptime)
    users=$(get_online_users)

    # Store in database
    sqlite3 "/var/lib/hotspotos/hotspotos.db" "
        INSERT INTO metrics (timestamp, cpu, ram, flash, uptime, users)
        VALUES ($timestamp, $cpu, $ram, $flash, $uptime, $users);
    " 2>/dev/null || true
}
