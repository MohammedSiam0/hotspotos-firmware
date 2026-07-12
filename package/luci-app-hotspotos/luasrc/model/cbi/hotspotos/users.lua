local m, s, o

m = Map("hotspot-users", translate("User Manager"),
    translate("Manage hotspot users, limits, and access control."))

s = m:section(TypedSection, "defaults", translate("Default Settings"))
s.anonymous = true
s.addremove = false

o = s:option(Value, "default_time_limit", translate("Default Time Limit (minutes)"))
o.default = "0"
o.datatype = "uinteger"

o = s:option(Value, "default_device_limit", translate("Default Device Limit"))
o.default = "3"
o.datatype = "uinteger"

-- User list section
s2 = m:section(TypedSection, "user", translate("Users"))
s2.addremove = true
s2.anonymous = true
s2.template = "cbi/tblsection"

o = s2:option(Value, "username", translate("Username"))
o.rmempty = false

o = s2:option(Value, "password", translate("Password"))
o.password = true
o.rmempty = false

o = s2:option(Flag, "enabled", translate("Enabled"))
o.default = "1"

o = s2:option(Value, "time_limit", translate("Time Limit (min)"))
o.default = "0"
o.datatype = "uinteger"

o = s2:option(Value, "speed_limit_down", translate("Download Speed (kbps)"))
o.default = "0"
o.datatype = "uinteger"

o = s2:option(Value, "device_limit", translate("Device Limit"))
o.default = "3"
o.datatype = "uinteger"

return m
