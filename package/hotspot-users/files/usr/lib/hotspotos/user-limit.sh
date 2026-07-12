#!/bin/sh
# HotspotOS User Limits - Apply speed/device limits

. /usr/lib/hotspotos/config.sh
. /usr/lib/hotspotos/logger.sh

apply_limits() {
    local username="$1"
    local mac="$2"

    [ -z "$username" ] && return 1

    # Get user limits
    local user_data
    user_data=$(sqlite3 "/var/lib/hotspotos/hotspotos.db" "
        SELECT speed_limit_down, speed_limit_up, device_limit 
        FROM users WHERE username='$username' LIMIT 1;
    " 2>/dev/null)

    [ -z "$user_data" ] && return 1

    local speed_down speed_up device_limit
    speed_down=$(echo "$user_data" | cut -d'|' -f1)
    speed_up=$(echo "$user_data" | cut -d'|' -f2)
    device_limit=$(echo "$user_data" | cut -d'|' -f3)

    # Apply tc (traffic control) limits if speed limits are set
    if [ "$speed_down" -gt 0 ] && [ -n "$mac" ]; then
        # Apply download limit using tc
        tc qdisc add dev br-lan handle 1: root htb default 11 2>/dev/null || true
        tc class add dev br-lan parent 1: classid 1:11 htb rate "${speed_down}kbit" ceil "${speed_down}kbit" 2>/dev/null || true
        tc filter add dev br-lan protocol ip parent 1:0 prio 1 u32 \
            match ether src "$mac" flowid 1:11 2>/dev/null || true
    fi

    log_info "users" "Limits applied for $username: down=${speed_down}kbps, up=${speed_up}kbps, devices=${device_limit}"
}

remove_limits() {
    local mac="$1"
    [ -z "$mac" ] && return 1

    tc filter del dev br-lan protocol ip parent 1:0 prio 1 u32 \
        match ether src "$mac" 2>/dev/null || true
}

case "$1" in
    apply)
        apply_limits "$2" "$3"
        ;;
    remove)
        remove_limits "$2"
        ;;
    *)
        echo "Usage: $0 {apply <username> <mac>|remove <mac>}"
        exit 1
        ;;
esac
