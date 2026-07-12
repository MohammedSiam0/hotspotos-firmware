local m, s, o

m = Map("hotspot-trial", translate("Free Trial"),
    translate("Configure free trial access settings."))

s = m:section(TypedSection, "trial", translate("Trial Settings"))
s.anonymous = true
s.addremove = false

o = s:option(Flag, "enabled", translate("Enable Free Trial"))
o.default = "1"

o = s:option(Value, "trial_time", translate("Trial Duration (minutes)"))
o.default = "30"
o.datatype = "uinteger"

o = s:option(Flag, "once_per_mac", translate("Once Per MAC"))
o.default = "1"

o = s:option(Flag, "reset_every_24h", translate("Reset Every 24 Hours"))
o.default = "1"

o = s:option(Flag, "auto_block", translate("Auto Block After Trial"))
o.default = "1"

o = s:option(Value, "bandwidth_limit", translate("Trial Bandwidth (kbps)"))
o.default = "1024"
o.datatype = "uinteger"

return m
