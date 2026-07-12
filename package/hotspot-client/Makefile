include $(TOPDIR)/rules.mk

PKG_NAME:=hotspot-client
PKG_VERSION:=1.0.0
PKG_RELEASE:=1

PKG_MAINTAINER:=HotspotOS Team <dev@hotspotos.com>
PKG_LICENSE:=GPL-2.0

include $(INCLUDE_DIR)/package.mk

define Package/hotspot-client
  SECTION:=net
  CATEGORY:=HotspotOS
  TITLE:=HotspotOS Internet Client
  DEPENDS:=+hotspot-core +curl +wget-ssl
  PKGARCH:=all
endef

define Package/hotspot-client/description
  HotspotOS Internet Client - Connects to external hotspot/WISP.
  Features: Auto-login, auto-reconnect, connection monitoring.
endef

define Build/Compile
	# Shell scripts only
endef

define Package/hotspot-client/install
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_DIR) $(1)/etc/uci-defaults
	$(INSTALL_DIR) $(1)/usr/lib/hotspotos

	$(INSTALL_DATA) ./files/etc/config/hotspot-client $(1)/etc/config/hotspot-client
	$(INSTALL_BIN) ./files/etc/init.d/hotspot-client $(1)/etc/init.d/hotspot-client
	$(INSTALL_BIN) ./files/etc/uci-defaults/51-hotspot-client $(1)/etc/uci-defaults/51-hotspot-client

	$(INSTALL_BIN) ./files/usr/lib/hotspotos/client.sh $(1)/usr/lib/hotspotos/client.sh
	$(INSTALL_BIN) ./files/usr/lib/hotspotos/client-login.sh $(1)/usr/lib/hotspotos/client-login.sh
	$(INSTALL_BIN) ./files/usr/lib/hotspotos/client-logout.sh $(1)/usr/lib/hotspotos/client-logout.sh
	$(INSTALL_BIN) ./files/usr/lib/hotspotos/client-status.sh $(1)/usr/lib/hotspotos/client-status.sh
	$(INSTALL_BIN) ./files/usr/lib/hotspotos/client-auto.sh $(1)/usr/lib/hotspotos/client-auto.sh
endef

define Package/hotspot-client/postinst
#!/bin/sh
[ -z "$${IPKG_INSTROOT}" ] && {
    /etc/init.d/hotspot-client enable 2>/dev/null || true
}
exit 0
endef

$(eval $(call BuildPackage,hotspot-client))
