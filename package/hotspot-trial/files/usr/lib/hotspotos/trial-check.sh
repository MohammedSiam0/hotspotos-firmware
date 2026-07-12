#!/bin/sh
# HotspotOS Trial Check - Monitor and end trials

. /usr/lib/hotspotos/logger.sh

# End trial for MAC
end_trial() {
    local mac="$1"

    log_info "trial" "Trial ended for MAC=$mac"

    # Remove from firewall
    /usr/lib/hotspotos/nft-rules.sh remove-client "$mac" 2>/dev/null || true

    # End any active session
    sqlite3 "/var/lib/hotspotos/hotspotos.db" "
        UPDATE sessions SET active=0, end_time=CURRENT_TIMESTAMP 
        WHERE mac_address='$mac' AND active=1;
    " 2>/dev/null
}

# Check all active trials
check_trials() {
    sqlite3 "/var/lib/hotspotos/hotspotos.db" "
        SELECT mac_address FROM trial 
        WHERE used=1 AND trial_end < datetime('now');
    " 2>/dev/null | while read -r mac; do
        end_trial "$mac"
    done
}

case "$1" in
    end)
        end_trial "$2"
        ;;
    check)
        check_trials
        ;;
    *)
        echo "Usage: $0 {end <mac>|check}"
        exit 1
        ;;
esac
