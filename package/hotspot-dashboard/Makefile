include $(TOPDIR)/rules.mk

PKG_NAME:=hotspot-dashboard
PKG_VERSION:=1.0.0
PKG_RELEASE:=1

PKG_MAINTAINER:=HotspotOS Team <dev@hotspotos.com>
PKG_LICENSE:=GPL-2.0

include $(INCLUDE_DIR)/package.mk

define Package/hotspot-dashboard
  SECTION:=net
  CATEGORY:=HotspotOS
  TITLE:=HotspotOS Status Dashboard
  DEPENDS:=+hotspot-core +luci-base
  PKGARCH:=all
endef

define Package/hotspot-dashboard/description
  HotspotOS Status Dashboard - System monitoring and status display.
  Shows: Internet status, Hotspot status, CPU, RAM, Flash, Uptime, Online users.
endef

define Build/Compile
	# Shell scripts only
endef

define Package/hotspot-dashboard/install
	$(INSTALL_DIR) $(1)/www/hotspot
	$(INSTALL_DIR) $(1)/www/hotspot/api
	$(INSTALL_DIR) $(1)/usr/lib/hotspotos

	$(INSTALL_DATA) ./files/www/hotspot/dashboard.html $(1)/www/hotspot/dashboard.html
	$(INSTALL_BIN) ./files/www/hotspot/api/status $(1)/www/hotspot/api/status

	$(INSTALL_BIN) ./files/usr/lib/hotspotos/dashboard.sh $(1)/usr/lib/hotspotos/dashboard.sh
	$(INSTALL_BIN) ./files/usr/lib/hotspotos/dashboard-data.sh $(1)/usr/lib/hotspotos/dashboard-data.sh
endef

$(eval $(call BuildPackage,hotspot-dashboard))
