local m, s, o

m = Map("hotspotos", translate("HotspotOS Settings"),
    translate("Configure global HotspotOS system settings."))

s = m:section(TypedSection, "system", translate("System Configuration"))
s.anonymous = true
s.addremove = false

o = s:option(Value, "brand_name", translate("Brand Name"))
o.default = "HotspotOS"
o.rmempty = false

o = s:option(Value, "hostname", translate("Hostname"))
o.default = "HotspotOS"
o.rmempty = false

o = s:option(ListValue, "theme", translate("Theme"))
o:value("hotspotos", "HotspotOS")
o.default = "hotspotos"

o = s:option(ListValue, "log_level", translate("Log Level"))
o:value("debug", "Debug")
o:value("info", "Info")
o:value("warning", "Warning")
o:value("error", "Error")
o.default = "info"

return m
