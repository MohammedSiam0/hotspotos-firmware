#!/bin/sh
# HotspotOS Configuration Manager
# UCI wrapper utilities

# Get UCI value with default
uci_get() {
    local config="$1"
    local section="$2"
    local option="$3"
    local default="$4"

    local value
    value=$(uci -q get "${config}.${section}.${option}")

    if [ -z "$value" ]; then
        echo "$default"
    else
        echo "$value"
    fi
}

# Set UCI value
uci_set() {
    local config="$1"
    local section="$2"
    local option="$3"
    local value="$4"

    uci set "${config}.${section}.${option}=${value}"
    uci commit "$config"
}

# Get boolean value
uci_get_bool() {
    local config="$1"
    local section="$2"
    local option="$3"
    local default="$4"

    uci -q get "${config}.${section}.${option}" || echo "$default"
}

# Check if section exists
uci_section_exists() {
    local config="$1"
    local section="$2"

    uci -q get "${config}.${section}" >/dev/null 2>&1
    return $?
}

# Add section if not exists
uci_add_section() {
    local config="$1"
    local type="$2"
    local name="$3"

    if ! uci_section_exists "$config" "$name"; then
        uci add "$config" "$type"
        uci rename "$config".@"$type"[-1]="$name"
        uci commit "$config"
    fi
}
