#!/bin/sh
# HotspotOS Trial System - Main Controller

. /usr/lib/hotspotos/config.sh
. /usr/lib/hotspotos/logger.sh
. /usr/lib/hotspotos/database.sh

# Check if MAC can start trial
can_start_trial() {
    local mac="$1"

    local enabled
    enabled=$(uci_get hotspot-trial main enabled 1)
    [ "$enabled" -eq 0 ] && { echo "false"; return 1; }

    local once_per_mac
    once_per_mac=$(uci_get hotspot-trial main once_per_mac 1)

    if [ "$once_per_mac" -eq 1 ]; then
        local used
        used=$(db_check_trial "$mac")

        if [ "$used" = "1" ]; then
            local reset_24h
            reset_24h=$(uci_get hotspot-trial main reset_every_24h 1)

            if [ "$reset_24h" -eq 1 ]; then
                local trial_end
                trial_end=$(sqlite3 "/var/lib/hotspotos/hotspotos.db" "
                    SELECT trial_end FROM trial WHERE mac_address='$mac' LIMIT 1;
                " 2>/dev/null)

                if [ -n "$trial_end" ]; then
                    local now_epoch trial_epoch
                    now_epoch=$(date +%s)
                    trial_epoch=$(date -d "$trial_end" +%s 2>/dev/null || echo "0")

                    local diff=$((now_epoch - trial_epoch))
                    if [ "$diff" -lt 86400 ]; then
                        log_info "trial" "Trial blocked for MAC=$mac (24h limit)"
                        echo "false"
                        return 1
                    fi
                fi
            else
                log_info "trial" "Trial already used for MAC=$mac"
                echo "false"
                return 1
            fi
        fi
    fi

    echo "true"
    return 0
}

# Start trial for MAC
start_trial() {
    local mac="$1"
    local ip="$2"

    if ! can_start_trial "$mac"; then
        return 1
    fi

    local trial_time
    trial_time=$(uci_get hotspot-trial main trial_time 30)

    # Mark trial in database
    db_mark_trial "$mac" "$trial_time"

    # Add to firewall (allow access)
    /usr/lib/hotspotos/nft-rules.sh add-client "$mac" "$ip" 2>/dev/null || true

    # Schedule trial end
    (
        sleep $((trial_time * 60))
        /usr/lib/hotspotos/trial-check.sh end "$mac"
    ) &

    log_info "trial" "Trial started: MAC=$mac duration=${trial_time}min"
    echo "Trial started: ${trial_time} minutes"
    return 0
}

# Get trial status
trial_status() {
    local mac="$1"

    local used
    used=$(db_check_trial "$mac")

    if [ "$used" = "1" ]; then
        local trial_end
        trial_end=$(sqlite3 "/var/lib/hotspotos/hotspotos.db" "
            SELECT trial_end FROM trial WHERE mac_address='$mac' LIMIT 1;
        " 2>/dev/null)
        echo "Used (expires: $trial_end)"
    else
        echo "Available"
    fi
}

case "$1" in
    can-start)
        can_start_trial "$2"
        ;;
    start)
        start_trial "$2" "$3"
        ;;
    status)
        trial_status "$2"
        ;;
    *)
        echo "Usage: $0 {can-start|start|status} <mac>"
        exit 1
        ;;
esac
