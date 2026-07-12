#!/bin/sh
# HotspotOS Server - Main Controller

. /usr/lib/hotspotos/config.sh
. /usr/lib/hotspotos/logger.sh
. /usr/lib/hotspotos/database.sh

# Monitor and manage sessions
daemon_main() {
    local timeout
    timeout=$(uci_get hotspot-server main session_timeout 3600)

    # Cleanup expired sessions
    db_cleanup_sessions

    # Check idle timeouts
    check_idle_timeouts
}

# Check idle sessions
check_idle_timeouts() {
    local idle_timeout
    idle_timeout=$(uci_get hotspot-server main idle_timeout 300)

    # Get active sessions and check idle time
    sqlite3 "/var/lib/hotspotos/hotspotos.db" "
        SELECT mac_address FROM sessions 
        WHERE active=1 
        AND datetime(start_time, '+${idle_timeout} seconds') < datetime('now');
    " | while read -r mac; do
        log_info "server" "Idle timeout for MAC: $mac"
        db_end_session "$mac"
        /usr/lib/hotspotos/nft-rules.sh remove-client "$mac"
    done
}

# Authenticate user
authenticate_user() {
    local username="$1"
    local password="$2"
    local mac="$3"
    local ip="$4"

    # Check user in database
    local user_data
    user_data=$(db_get_user "$username")

    if [ -z "$user_data" ]; then
        log_auth "login" "$username" "$mac" "$ip" "failed: user not found"
        return 1
    fi

    # Check if user is enabled
    local enabled
    enabled=$(echo "$user_data" | cut -d'|' -f4)

    if [ "$enabled" -eq 0 ]; then
        log_auth "login" "$username" "$mac" "$ip" "failed: user disabled"
        return 1
    fi

    # Verify password (simplified - use better hashing in production)
    local stored_pass
    stored_pass=$(echo "$user_data" | cut -d'|' -f3)
    local input_hash
    input_hash=$(echo -n "$password" | md5sum | cut -d' ' -f1)

    if [ "$stored_pass" != "$input_hash" ]; then
        log_auth "login" "$username" "$mac" "$ip" "failed: wrong password"
        return 1
    fi

    # Check device limit
    local device_limit
    device_limit=$(echo "$user_data" | cut -d'|' -f8)
    local current_devices
    current_devices=$(sqlite3 "/var/lib/hotspotos/hotspotos.db" "
        SELECT COUNT(*) FROM sessions 
        WHERE user_id=(SELECT id FROM users WHERE username='$username') AND active=1;
    ")

    if [ "$device_limit" -gt 0 ] && [ "$current_devices" -ge "$device_limit" ]; then
        log_auth "login" "$username" "$mac" "$ip" "failed: device limit reached"
        return 1
    fi

    # Create session
    local user_id
    user_id=$(echo "$user_data" | cut -d'|' -f1)
    db_create_session "$user_id" "$mac" "$ip"

    # Add to firewall
    /usr/lib/hotspotos/nft-rules.sh add-client "$mac" "$ip"

    log_auth "login" "$username" "$mac" "$ip" "success"
    return 0
}

# Logout user
logout_user() {
    local mac="$1"

    db_end_session "$mac"
    /usr/lib/hotspotos/nft-rules.sh remove-client "$mac"

    log_info "server" "User logged out: MAC=$mac"
}

# Main entry point
case "$1" in
    daemon)
        daemon_main
        ;;
    authenticate)
        authenticate_user "$2" "$3" "$4" "$5"
        ;;
    logout)
        logout_user "$2"
        ;;
    *)
        echo "Usage: $0 {daemon|authenticate|logout}"
        exit 1
        ;;
esac
