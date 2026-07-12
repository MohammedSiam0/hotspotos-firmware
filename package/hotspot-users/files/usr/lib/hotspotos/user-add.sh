#!/bin/sh
# HotspotOS Add User

. /usr/lib/hotspotos/config.sh
. /usr/lib/hotspotos/logger.sh
. /usr/lib/hotspotos/database.sh

add_user() {
    local username="$1"
    local password="$2"
    local time_limit="${3:-0}"
    local speed_limit="${4:-0}"
    local device_limit="${5:-3}"

    # Validate input
    [ -z "$username" ] && { echo "ERROR: Username required"; exit 1; }
    [ -z "$password" ] && { echo "ERROR: Password required"; exit 1; }

    # Check if user exists
    local existing
    existing=$(sqlite3 "/var/lib/hotspotos/hotspotos.db" "SELECT id FROM users WHERE username='$username' LIMIT 1;" 2>/dev/null)

    if [ -n "$existing" ]; then
        echo "ERROR: User '$username' already exists"
        exit 1
    fi

    # Hash password
    local pass_hash
    pass_hash=$(echo -n "$password" | md5sum | cut -d' ' -f1)

    # Add to database
    db_add_user "$username" "$pass_hash" "$time_limit" "$speed_limit" "$device_limit"

    if [ $? -eq 0 ]; then
        log_info "users" "User added: $username (time_limit=${time_limit}, speed=${speed_limit}, devices=${device_limit})"
        echo "User '$username' added successfully"
    else
        log_error "users" "Failed to add user: $username"
        echo "ERROR: Failed to add user"
        exit 1
    fi
}

add_user "$@"
