#!/bin/sh
# HotspotOS Client Logout

. /usr/lib/hotspotos/client.sh

logout() {
    load_client_config

    [ -z "$CLIENT_LOGOUT_URL" ] && {
        echo "Logout URL not configured"
        exit 1
    }

    log_info "client" "Logging out from $CLIENT_LOGOUT_URL"

    local response
    response=$(curl -s "$CLIENT_LOGOUT_URL" \
        --connect-timeout 10 \
        --max-time 30 2>/dev/null)

    log_info "client" "Logout completed"
    echo "Logout completed"
}

logout
