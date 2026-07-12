#!/bin/sh
# HotspotOS Delete User

. /usr/lib/hotspotos/config.sh
. /usr/lib/hotspotos/logger.sh

delete_user() {
    local username="$1"

    [ -z "$username" ] && { echo "ERROR: Username required"; exit 1; }

    # Prevent deleting admin
    if [ "$username" = "admin" ]; then
        echo "ERROR: Cannot delete admin user"
        exit 1
    fi

    # Get user ID
    local user_id
    user_id=$(sqlite3 "/var/lib/hotspotos/hotspotos.db" "SELECT id FROM users WHERE username='$username' LIMIT 1;" 2>/dev/null)

    if [ -z "$user_id" ]; then
        echo "ERROR: User '$username' not found"
        exit 1
    fi

    # End all active sessions
    sqlite3 "/var/lib/hotspotos/hotspotos.db" "
        UPDATE sessions SET active=0, end_time=CURRENT_TIMESTAMP 
        WHERE user_id=$user_id AND active=1;
    " 2>/dev/null

    # Delete user
    sqlite3 "/var/lib/hotspotos/hotspotos.db" "DELETE FROM users WHERE id=$user_id;" 2>/dev/null

    if [ $? -eq 0 ]; then
        log_info "users" "User deleted: $username"
        echo "User '$username' deleted successfully"
    else
        log_error "users" "Failed to delete user: $username"
        echo "ERROR: Failed to delete user"
        exit 1
    fi
}

delete_user "$@"
