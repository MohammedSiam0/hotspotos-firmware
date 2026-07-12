local m, s, o

m = Map("hotspot-ttl", translate("TTL Manager"),
    translate("Configure TTL modification to bypass ISP detection."))

s = m:section(TypedSection, "ttl", translate("TTL Settings"))
s.anonymous = true
s.addremove = false

o = s:option(Flag, "enabled", translate("Enable TTL Modification"))
o.default = "0"

o = s:option(Value, "ttl_value", translate("TTL Value"))
o.default = "65"
o.datatype = "range(1,255)"

o = s:option(Value, "interface", translate("Interface"))
o.default = "wan"

o = s:option(ListValue, "direction", translate("Direction"))
o:value("outgoing", "Outgoing")
o:value("incoming", "Incoming")
o:value("both", "Both")
o.default = "both"

o = s:option(ListValue, "protocol", translate("Protocol"))
o:value("all", "All")
o:value("tcp", "TCP")
o:value("udp", "UDP")
o:value("icmp", "ICMP")
o.default = "all"

return m
