#!/bin/sh
# HotspotOS User Manager - Main Controller

. /usr/lib/hotspotos/config.sh
. /usr/lib/hotspotos/logger.sh
. /usr/lib/hotspotos/database.sh

# Initialize default users from UCI
init_defaults() {
    log_info "users" "Initializing default users"

    # Ensure database exists
    [ ! -f "/var/lib/hotspotos/hotspotos.db" ] && db_init

    # Add admin user if not exists
    local admin_user admin_pass
    admin_user=$(uci_get hotspot-users admin username "admin")
    admin_pass=$(uci_get hotspot-users admin password "21232f297a57a5a5a743894a0e4a801fc3")

    local existing
    existing=$(sqlite3 "/var/lib/hotspotos/hotspotos.db" "SELECT id FROM users WHERE username='$admin_user' LIMIT 1;" 2>/dev/null)

    if [ -z "$existing" ]; then
        db_add_user "$admin_user" "$admin_pass" 0 0 0
        log_info "users" "Default admin user created: $admin_user"
    fi
}

# List all users
list_users() {
    echo "ID|Username|Enabled|Time Limit|Speed Down|Speed Up|Device Limit|Created"
    sqlite3 "/var/lib/hotspotos/hotspotos.db" "
        SELECT id, username, enabled, time_limit, speed_limit_down, speed_limit_up, device_limit, created_at 
        FROM users ORDER BY id;
    " 2>/dev/null
}

# Get user details
get_user() {
    local username="$1"
    sqlite3 "/var/lib/hotspotos/hotspotos.db" "
        SELECT * FROM users WHERE username='$username' LIMIT 1;
    " 2>/dev/null
}

# Main entry point
case "$1" in
    init-defaults)
        init_defaults
        ;;
    list)
        list_users
        ;;
    get)
        get_user "$2"
        ;;
    *)
        echo "Usage: $0 {init-defaults|list|get <username>}"
        exit 1
        ;;
esac
