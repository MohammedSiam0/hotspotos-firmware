#!/bin/sh
# HotspotOS Database Manager
# SQLite database operations

DB_PATH="/var/lib/hotspotos/hotspotos.db"

# Initialize database with all tables
db_init() {
    mkdir -p /var/lib/hotspotos

    sqlite3 "$DB_PATH" <<EOF
CREATE TABLE IF NOT EXISTS users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    username TEXT UNIQUE NOT NULL,
    password TEXT NOT NULL,
    enabled INTEGER DEFAULT 1,
    time_limit INTEGER DEFAULT 0,
    speed_limit_down INTEGER DEFAULT 0,
    speed_limit_up INTEGER DEFAULT 0,
    device_limit INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS sessions (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER,
    mac_address TEXT NOT NULL,
    ip_address TEXT,
    start_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    end_time TIMESTAMP,
    bytes_in INTEGER DEFAULT 0,
    bytes_out INTEGER DEFAULT 0,
    active INTEGER DEFAULT 1,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE IF NOT EXISTS settings (
    key TEXT PRIMARY KEY,
    value TEXT,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS trial (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    mac_address TEXT UNIQUE NOT NULL,
    used INTEGER DEFAULT 0,
    trial_start TIMESTAMP,
    trial_end TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS logs (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    type TEXT NOT NULL,
    message TEXT NOT NULL,
    details TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_sessions_mac ON sessions(mac_address);
CREATE INDEX IF NOT EXISTS idx_sessions_active ON sessions(active);
CREATE INDEX IF NOT EXISTS idx_logs_type ON logs(type);
CREATE INDEX IF NOT EXISTS idx_trial_mac ON trial(mac_address);

INSERT OR IGNORE INTO settings (key, value) VALUES ('version', '1.0.0');
INSERT OR IGNORE INTO settings (key, value) VALUES ('initialized', '1');
EOF

    return $?
}

# Get database path
db_path() {
    echo "$DB_PATH"
}

# Count users
db_count_users() {
    sqlite3 "$DB_PATH" "SELECT COUNT(*) FROM users;"
}

# Count active sessions
db_count_active_sessions() {
    sqlite3 "$DB_PATH" "SELECT COUNT(*) FROM sessions WHERE active=1;"
}

# Cleanup expired sessions
db_cleanup_sessions() {
    local timeout
    timeout=$(uci_get hotspot-core main session_timeout 3600)

    sqlite3 "$DB_PATH" "
        UPDATE sessions 
        SET active=0, end_time=CURRENT_TIMESTAMP 
        WHERE active=1 
        AND datetime(start_time, '+${timeout} seconds') < datetime('now');
    "
}

# Backup database
db_backup() {
    local backup_dir="/var/lib/hotspotos/backups"
    mkdir -p "$backup_dir"

    if [ -f "$DB_PATH" ]; then
        cp "$DB_PATH" "$backup_dir/hotspotos-$(date +%Y%m%d-%H%M%S).db"
        # Keep only last 10 backups
        ls -t "$backup_dir"/*.db | tail -n +11 | xargs rm -f 2>/dev/null
    fi
}

# Add log entry
db_log() {
    local type="$1"
    local message="$2"
    local details="$3"

    sqlite3 "$DB_PATH" "
        INSERT INTO logs (type, message, details) 
        VALUES ('$type', '$message', '$details');
    "
}

# Get user by username
db_get_user() {
    local username="$1"
    sqlite3 "$DB_PATH" "SELECT * FROM users WHERE username='$username' LIMIT 1;"
}

# Add user
db_add_user() {
    local username="$1"
    local password="$2"
    local time_limit="${3:-0}"
    local speed_limit="${4:-0}"
    local device_limit="${5:-0}"

    sqlite3 "$DB_PATH" "
        INSERT INTO users (username, password, time_limit, speed_limit_down, device_limit) 
        VALUES ('$username', '$password', $time_limit, $speed_limit, $device_limit);
    "
}

# Delete user
db_delete_user() {
    local id="$1"
    sqlite3 "$DB_PATH" "DELETE FROM users WHERE id=$id;"
}

# Create session
db_create_session() {
    local user_id="$1"
    local mac="$2"
    local ip="$3"

    sqlite3 "$DB_PATH" "
        INSERT INTO sessions (user_id, mac_address, ip_address) 
        VALUES ($user_id, '$mac', '$ip');
    "
}

# End session
db_end_session() {
    local mac="$1"
    sqlite3 "$DB_PATH" "
        UPDATE sessions 
        SET active=0, end_time=CURRENT_TIMESTAMP 
        WHERE mac_address='$mac' AND active=1;
    "
}

# Check trial
db_check_trial() {
    local mac="$1"
    sqlite3 "$DB_PATH" "SELECT used FROM trial WHERE mac_address='$mac' LIMIT 1;"
}

# Mark trial used
db_mark_trial() {
    local mac="$1"
    local duration="$2"

    sqlite3 "$DB_PATH" "
        INSERT OR REPLACE INTO trial (mac_address, used, trial_start, trial_end) 
        VALUES ('$mac', 1, CURRENT_TIMESTAMP, datetime('now', '+${duration} minutes'));
    "
}

# Reset all trials
db_reset_trials() {
    sqlite3 "$DB_PATH" "DELETE FROM trial;"
}
