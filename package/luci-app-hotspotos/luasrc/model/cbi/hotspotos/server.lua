local m, s, o

m = Map("hotspot-server", translate("Hotspot Server"),
    translate("Configure captive portal and local hotspot server."))

s = m:section(TypedSection, "server", translate("Server Settings"))
s.anonymous = true
s.addremove = false

o = s:option(Flag, "enabled", translate("Enable Hotspot Server"))
o.default = "0"

o = s:option(Flag, "captive_portal", translate("Enable Captive Portal"))
o.default = "1"

o = s:option(Value, "session_timeout", translate("Session Timeout (seconds)"))
o.default = "3600"
o.datatype = "uinteger"

o = s:option(Value, "idle_timeout", translate("Idle Timeout (seconds)"))
o.default = "300"
o.datatype = "uinteger"

o = s:option(Value, "bandwidth_limit_down", translate("Download Limit (kbps)"))
o.default = "0"
o.datatype = "uinteger"

o = s:option(Value, "bandwidth_limit_up", translate("Upload Limit (kbps)"))
o.default = "0"
o.datatype = "uinteger"

return m
