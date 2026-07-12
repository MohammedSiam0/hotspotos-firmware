#!/bin/sh
# HotspotOS Trial Reset - Daily reset of all trials

. /usr/lib/hotspotos/logger.sh
. /usr/lib/hotspotos/database.sh

# Reset all trials
reset_all_trials() {
    log_info "trial" "Resetting all trial records"
    db_reset_trials
    log_info "trial" "All trials reset successfully"
}

# Scheduled reset (called from cron)
scheduled_reset() {
    local reset_hour reset_minute
    reset_hour=$(uci_get hotspot-trial schedule reset_hour 0)
    reset_minute=$(uci_get hotspot-trial schedule reset_minute 0)

    if ! grep -q "trial-reset.sh" /etc/crontabs/root 2>/dev/null; then
        echo "${reset_minute} ${reset_hour} * * * /usr/lib/hotspotos/trial-reset.sh reset" >> /etc/crontabs/root
        /etc/init.d/cron restart
    fi
}

case "$1" in
    reset)
        reset_all_trials
        ;;
    schedule)
        scheduled_reset
        ;;
    *)
        echo "Usage: $0 {reset|schedule}"
        exit 1
        ;;
esac
