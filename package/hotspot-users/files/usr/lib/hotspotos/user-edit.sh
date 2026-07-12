#!/bin/sh
# HotspotOS Edit User

. /usr/lib/hotspotos/config.sh
. /usr/lib/hotspotos/logger.sh

edit_user() {
    local username="$1"
    local field="$2"
    local value="$3"

    [ -z "$username" ] && { echo "ERROR: Username required"; exit 1; }
    [ -z "$field" ] && { echo "ERROR: Field required"; exit 1; }

    # Validate field
    case "$field" in
        password|enabled|time_limit|speed_limit_down|speed_limit_up|device_limit)
            ;;
        *)
            echo "ERROR: Invalid field: $field"
            exit 1
            ;;
    esac

    # Hash password if editing password
    if [ "$field" = "password" ]; then
        value=$(echo -n "$value" | md5sum | cut -d' ' -f1)
    fi

    # Update database
    sqlite3 "/var/lib/hotspotos/hotspotos.db" "
        UPDATE users 
        SET $field='$value', updated_at=CURRENT_TIMESTAMP 
        WHERE username='$username';
    " 2>/dev/null

    if [ $? -eq 0 ]; then
        log_info "users" "User updated: $username (field=$field)"
        echo "User '$username' updated successfully"
    else
        log_error "users" "Failed to update user: $username"
        echo "ERROR: Failed to update user"
        exit 1
    fi
}

edit_user "$@"
