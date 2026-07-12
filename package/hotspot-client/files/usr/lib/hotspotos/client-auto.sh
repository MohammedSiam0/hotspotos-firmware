#!/bin/sh
# HotspotOS Client Auto-Reconnect Daemon

. /usr/lib/hotspotos/client.sh

AUTO_RECONNECT=1
RECONNECT_INTERVAL=60
CHECK_INTERVAL=30

main_loop() {
    load_client_config

    [ "$CLIENT_ENABLED" -eq 0 ] && {
        log_info "client" "Client disabled, exiting"
        exit 0
    }

    AUTO_RECONNECT=$CLIENT_AUTO_RECONNECT
    RECONNECT_INTERVAL=$CLIENT_RECONNECT_INTERVAL
    CHECK_INTERVAL=$CLIENT_CHECK_INTERVAL

    log_info "client" "Auto-reconnect daemon started (interval: ${RECONNECT_INTERVAL}s)"

    local consecutive_failures=0
    local max_retries
    max_retries=$(uci_get hotspot-client monitor retries 3)

    while true; do
        if ! check_internet; then
            consecutive_failures=$((consecutive_failures + 1))
            log_warn "client" "Internet check failed ($consecutive_failures/$max_retries)"

            if [ "$consecutive_failures" -ge "$max_retries" ] && [ "$AUTO_RECONNECT" -eq 1 ]; then
                log_info "client" "Attempting auto-reconnect..."

                # Try logout first
                [ -n "$CLIENT_LOGOUT_URL" ] && /usr/lib/hotspotos/client-logout.sh >/dev/null 2>&1

                # Wait a moment
                sleep 5

                # Try login
                if /usr/lib/hotspotos/client-login.sh >/dev/null 2>&1; then
                    log_info "client" "Auto-reconnect successful"
                    consecutive_failures=0
                else
                    log_error "client" "Auto-reconnect failed"
                fi
            fi
        else
            if [ "$consecutive_failures" -gt 0 ]; then
                log_info "client" "Internet restored"
                consecutive_failures=0
            fi
        fi

        sleep "$CHECK_INTERVAL"
    done
}

main_loop
