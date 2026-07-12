module("luci.controller.hotspotos", package.seeall)

function index()
    local page = entry({"admin", "hotspotos"}, firstchild(), _("HotspotOS"), 60)
    page.dependent = false
    page.acl_depends = { "luci-app-hotspotos" }

    entry({"admin", "hotspotos", "dashboard"}, template("hotspotos/dashboard"), _("Dashboard"), 1)
    entry({"admin", "hotspotos", "settings"}, cbi("hotspotos/settings"), _("Settings"), 2)
    entry({"admin", "hotspotos", "users"}, cbi("hotspotos/users"), _("Users"), 3)
    entry({"admin", "hotspotos", "client"}, cbi("hotspotos/client"), _("Internet Client"), 4)
    entry({"admin", "hotspotos", "server"}, cbi("hotspotos/server"), _("Hotspot Server"), 5)
    entry({"admin", "hotspotos", "trial"}, cbi("hotspotos/trial"), _("Free Trial"), 6)
    entry({"admin", "hotspotos", "ttl"}, cbi("hotspotos/ttl"), _("TTL Manager"), 7)

    -- API endpoints
    entry({"admin", "hotspotos", "api", "status"}, call("api_status")).leaf = true
    entry({"admin", "hotspotos", "api", "users"}, call("api_users")).leaf = true
end

function api_status()
    local sys = require "luci.sys"
    local http = require "luci.http"

    local status = {
        internet = sys.call("ping -c 1 -W 2 8.8.8.8 >/dev/null 2>&1") == 0,
        uptime = sys.exec("cat /proc/uptime | awk '{print int($1/3600)}'"):gsub("%s+", ""),
        cpu = sys.exec("top -bn1 | grep 'CPU:' | head -1 | awk '{print $2}' | sed 's/%//'"):gsub("%s+", ""),
        ram = sys.exec("free | grep Mem | awk '{printf "%.1f", $3/$2 * 100.0}'"):gsub("%s+", ""),
        online_users = sys.exec("sqlite3 /var/lib/hotspotos/hotspotos.db 'SELECT COUNT(DISTINCT mac_address) FROM sessions WHERE active=1;' 2>/dev/null || echo 0"):gsub("%s+", "")
    }

    http.prepare_content("application/json")
    http.write_json(status)
end

function api_users()
    local sys = require "luci.sys"
    local http = require "luci.http"

    local users = sys.exec("sqlite3 /var/lib/hotspotos/hotspotos.db 'SELECT id, username, enabled, time_limit, device_limit FROM users;' 2>/dev/null")

    http.prepare_content("application/json")
    http.write(users)
end
