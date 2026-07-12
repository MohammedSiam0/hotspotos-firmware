include $(TOPDIR)/rules.mk

LUCI_TITLE:=HotspotOS LuCI Application
LUCI_DEPENDS:=+luci-base +hotspot-core +hotspot-client +hotspot-server +hotspot-users +hotspot-trial +hotspot-ttl +hotspot-dashboard
LUCI_PKGARCH:=all

PKG_NAME:=luci-app-hotspotos
PKG_VERSION:=1.0.0
PKG_RELEASE:=1
PKG_MAINTAINER:=HotspotOS Team <dev@hotspotos.com>
PKG_LICENSE:=Apache-2.0

include $(TOPDIR)/feeds/luci/luci.mk

# call BuildPackage - OpenWrt buildroot signature
