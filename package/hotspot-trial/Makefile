include $(TOPDIR)/rules.mk

PKG_NAME:=hotspot-trial
PKG_VERSION:=1.0.0
PKG_RELEASE:=1

PKG_MAINTAINER:=HotspotOS Team <dev@hotspotos.com>
PKG_LICENSE:=GPL-2.0

include $(INCLUDE_DIR)/package.mk

define Package/hotspot-trial
  SECTION:=net
  CATEGORY:=HotspotOS
  TITLE:=HotspotOS Free Trial System
  DEPENDS:=+hotspot-core +hotspot-server
  PKGARCH:=all
endef

define Package/hotspot-trial/description
  HotspotOS Free Trial - Time-limited guest access per MAC address.
  Features: configurable trial time, once per MAC, daily reset, auto-block.
endef

define Build/Compile
	# Shell scripts only
endef

define Package/hotspot-trial/install
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_DIR) $(1)/etc/uci-defaults
	$(INSTALL_DIR) $(1)/usr/lib/hotspotos

	$(INSTALL_DATA) ./files/etc/config/hotspot-trial $(1)/etc/config/hotspot-trial
	$(INSTALL_BIN) ./files/etc/uci-defaults/54-hotspot-trial $(1)/etc/uci-defaults/54-hotspot-trial

	$(INSTALL_BIN) ./files/usr/lib/hotspotos/trial.sh $(1)/usr/lib/hotspotos/trial.sh
	$(INSTALL_BIN) ./files/usr/lib/hotspotos/trial-check.sh $(1)/usr/lib/hotspotos/trial-check.sh
	$(INSTALL_BIN) ./files/usr/lib/hotspotos/trial-reset.sh $(1)/usr/lib/hotspotos/trial-reset.sh
endef

$(eval $(call BuildPackage,hotspot-trial))
