#!/bin/sh
# HotspotOS Core Service
# Main coordination daemon

. /usr/lib/hotspotos/config.sh
. /usr/lib/hotspotos/database.sh
. /usr/lib/hotspotos/logger.sh
. /usr/lib/hotspotos/utils.sh

DAEMON_INTERVAL=60

# Main daemon loop
daemon_main() {
    while true; do
        # Cleanup expired sessions
        db_cleanup_sessions

        # Rotate logs if needed
        log_rotate

        # Backup database
        db_backup

        sleep $DAEMON_INTERVAL
    done
}

# Initialize system
init_system() {
    log_info "core" "Initializing HotspotOS Core"
    db_init

    # Create required directories
    mkdir -p /var/lib/hotspotos
    mkdir -p /var/log/hotspotos
    mkdir -p /tmp/hotspotos

    log_info "core" "HotspotOS Core initialized successfully"
}

# Show status
show_status() {
    echo "HotspotOS Core Status"
    echo "====================="
    echo "Version: 1.0.0"
    echo "Database: $(db_path)"
    echo "Users: $(db_count_users)"
    echo "Active Sessions: $(db_count_active_sessions)"
    echo "Uptime: $(cat /proc/uptime | awk '{print $1}')"
}

# Main entry point
case "$1" in
    daemon)
        daemon_main
        ;;
    init)
        init_system
        ;;
    status)
        show_status
        ;;
    *)
        echo "Usage: $0 {daemon|init|status}"
        exit 1
        ;;
esac
