local m, s, o

m = Map("hotspot-client", translate("Internet Client"),
    translate("Configure external hotspot/WISP connection."))

s = m:section(TypedSection, "client", translate("Client Settings"))
s.anonymous = true
s.addremove = false

o = s:option(Flag, "enabled", translate("Enable Client"))
o.default = "0"

o = s:option(Value, "username", translate("Username"))
o.rmempty = false

o = s:option(Value, "password", translate("Password"))
o.password = true
o.rmempty = false

o = s:option(Value, "login_url", translate("Login URL"))
o.placeholder = "http://hotspot.example.com/login"
o.rmempty = false

o = s:option(Value, "logout_url", translate("Logout URL"))
o.placeholder = "http://hotspot.example.com/logout"

o = s:option(Flag, "auto_login", translate("Auto Login"))
o.default = "1"

o = s:option(Flag, "auto_reconnect", translate("Auto Reconnect"))
o.default = "1"

o = s:option(Value, "reconnect_interval", translate("Reconnect Interval (seconds)"))
o.default = "60"
o.datatype = "uinteger"

o = s:option(ListValue, "connection_type", translate("Connection Type"))
o:value("http", "HTTP POST")
o:value("mikrotik", "MikroTik Hotspot")
o:value("chillispot", "ChilliSpot")
o.default = "http"

return m
