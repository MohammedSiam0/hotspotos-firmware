#!/bin/sh
# HotspotOS Logger
# Centralized logging system

LOG_DIR="/var/log/hotspotos"
MAX_LOG_SIZE=1048576  # 1MB
MAX_LOG_FILES=10

# Ensure log directory exists
ensure_log_dir() {
    mkdir -p "$LOG_DIR"
}

# Log info
log_info() {
    local component="$1"
    local message="$2"

    ensure_log_dir
    logger -t "hotspotos[$component]" "$message"

    # Also log to database if available
    if [ -f "/var/lib/hotspotos/hotspotos.db" ]; then
        sqlite3 "/var/lib/hotspotos/hotspotos.db" "
            INSERT INTO logs (type, message) 
            VALUES ('info', '[$component] $message');
        " 2>/dev/null
    fi
}

# Log warning
log_warn() {
    local component="$1"
    local message="$2"

    ensure_log_dir
    logger -t "hotspotos[$component]" "WARNING: $message"

    if [ -f "/var/lib/hotspotos/hotspotos.db" ]; then
        sqlite3 "/var/lib/hotspotos/hotspotos.db" "
            INSERT INTO logs (type, message) 
            VALUES ('warning', '[$component] $message');
        " 2>/dev/null
    fi
}

# Log error
log_error() {
    local component="$1"
    local message="$2"
    local details="$3"

    ensure_log_dir
    logger -t "hotspotos[$component]" "ERROR: $message"

    if [ -f "/var/lib/hotspotos/hotspotos.db" ]; then
        sqlite3 "/var/lib/hotspotos/hotspotos.db" "
            INSERT INTO logs (type, message, details) 
            VALUES ('error', '[$component] $message', '$details');
        " 2>/dev/null
    fi
}

# Log auth event
log_auth() {
    local event="$1"
    local user="$2"
    local mac="$3"
    local ip="$4"
    local status="$5"

    log_info "auth" "$event: user=$user mac=$mac ip=$ip status=$status"
}

# Log session event
log_session() {
    local event="$1"
    local user="$2"
    local mac="$3"
    local duration="$4"

    log_info "session" "$event: user=$user mac=$mac duration=${duration}s"
}

# Rotate logs
log_rotate() {
    ensure_log_dir

    # Database log rotation
    if [ -f "/var/lib/hotspotos/hotspotos.db" ]; then
        local retention
        retention=$(uci -q get hotspot-core.logging.retention_days 2>/dev/null || echo "30")

        sqlite3 "/var/lib/hotspotos/hotspotos.db" "
            DELETE FROM logs 
            WHERE datetime(created_at) < datetime('now', '-${retention} days');
        " 2>/dev/null

        local max_entries
        max_entries=$(uci -q get hotspot-core.logging.max_entries 2>/dev/null || echo "10000")

        sqlite3 "/var/lib/hotspotos/hotspotos.db" "
            DELETE FROM logs 
            WHERE id NOT IN (
                SELECT id FROM logs 
                ORDER BY created_at DESC 
                LIMIT $max_entries
            );
        " 2>/dev/null
    fi
}
