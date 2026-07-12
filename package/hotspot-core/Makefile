include $(TOPDIR)/rules.mk

PKG_NAME:=hotspot-core
PKG_VERSION:=1.0.0
PKG_RELEASE:=1

PKG_MAINTAINER:=HotspotOS Team <dev@hotspotos.com>
PKG_LICENSE:=GPL-2.0

include $(INCLUDE_DIR)/package.mk

define Package/hotspot-core
  SECTION:=net
  CATEGORY:=HotspotOS
  TITLE:=HotspotOS Core Service
  DEPENDS:=+hotspotos-base +libsqlite3 +sqlite3-cli +nftables +firewall4 +curl
  PKGARCH:=all
endef

define Package/hotspot-core/description
  HotspotOS core service providing database management,
  configuration handling, logging, and system utilities.
  This is the foundation package for all HotspotOS features.
endef

define Build/Compile
	# Nothing to compile - shell scripts package
endef

define Package/hotspot-core/install
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_DIR) $(1)/etc/uci-defaults
	$(INSTALL_DIR) $(1)/usr/lib/hotspotos
	$(INSTALL_DIR) $(1)/var/lib/hotspotos

	# UCI configuration
	$(INSTALL_DATA) ./files/etc/config/hotspot-core $(1)/etc/config/hotspot-core

	# Init script
	$(INSTALL_BIN) ./files/etc/init.d/hotspot-core $(1)/etc/init.d/hotspot-core

	# UCI defaults
	$(INSTALL_BIN) ./files/etc/uci-defaults/50-hotspot-core $(1)/etc/uci-defaults/50-hotspot-core

	# Core library scripts
	$(INSTALL_BIN) ./files/usr/lib/hotspotos/core.sh $(1)/usr/lib/hotspotos/core.sh
	$(INSTALL_BIN) ./files/usr/lib/hotspotos/database.sh $(1)/usr/lib/hotspotos/database.sh
	$(INSTALL_BIN) ./files/usr/lib/hotspotos/config.sh $(1)/usr/lib/hotspotos/config.sh
	$(INSTALL_BIN) ./files/usr/lib/hotspotos/logger.sh $(1)/usr/lib/hotspotos/logger.sh
	$(INSTALL_BIN) ./files/usr/lib/hotspotos/utils.sh $(1)/usr/lib/hotspotos/utils.sh
endef

define Package/hotspot-core/postinst
#!/bin/sh
[ -z "$${IPKG_INSTROOT}" ] && {
    /etc/init.d/hotspot-core enable 2>/dev/null || true
    /etc/uci-defaults/50-hotspot-core 2>/dev/null || true
}
exit 0
endef

$(eval $(call BuildPackage,hotspot-core))
