#!/bin/sh
# HotspotOS Client Login

. /usr/lib/hotspotos/client.sh

login() {
    load_client_config

    [ "$CLIENT_ENABLED" -eq 0 ] && {
        echo "Client is disabled"
        exit 1
    }

    [ -z "$CLIENT_LOGIN_URL" ] && {
        echo "Login URL not configured"
        exit 1
    }

    [ -z "$CLIENT_USERNAME" ] && {
        echo "Username not configured"
        exit 1
    }

    log_info "client" "Attempting login to $CLIENT_LOGIN_URL"

    case "$CLIENT_CONNECTION_TYPE" in
        http)
            # HTTP POST login
            local response
            response=$(curl -s -X POST "$CLIENT_LOGIN_URL" \
                -d "username=$CLIENT_USERNAME" \
                -d "password=$CLIENT_PASSWORD" \
                -d "submit=Login" \
                -L \
                --connect-timeout 10 \
                --max-time 30 2>/dev/null)

            if echo "$response" | grep -qi "success\|welcome\|authenticated"; then
                log_info "client" "Login successful"
                echo "Login successful"
                return 0
            else
                log_error "client" "Login failed" "$response"
                echo "Login failed"
                return 1
            fi
            ;;

        mikrotik)
            # MikroTik Hotspot login
            local response
            response=$(curl -s "$CLIENT_LOGIN_URL" \
                -d "username=$CLIENT_USERNAME" \
                -d "password=$CLIENT_PASSWORD" \
                --connect-timeout 10 2>/dev/null)

            if echo "$response" | grep -qi "logged in\|success"; then
                log_info "client" "MikroTik login successful"
                echo "Login successful"
                return 0
            else
                log_error "client" "MikroTik login failed"
                echo "Login failed"
                return 1
            fi
            ;;

        chillispot)
            # ChilliSpot login
            local response
            response=$(curl -s "$CLIENT_LOGIN_URL" \
                -d "UserName=$CLIENT_USERNAME" \
                -d "Password=$CLIENT_PASSWORD" \
                --connect-timeout 10 2>/dev/null)

            if echo "$response" | grep -qi "success\|already"; then
                log_info "client" "ChilliSpot login successful"
                echo "Login successful"
                return 0
            else
                log_error "client" "ChilliSpot login failed"
                echo "Login failed"
                return 1
            fi
            ;;

        *)
            log_error "client" "Unknown connection type: $CLIENT_CONNECTION_TYPE"
            echo "Unknown connection type"
            return 1
            ;;
    esac
}

# Execute login
login
