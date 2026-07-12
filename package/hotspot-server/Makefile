include $(TOPDIR)/rules.mk

PKG_NAME:=hotspot-server
PKG_VERSION:=1.0.0
PKG_RELEASE:=1

PKG_MAINTAINER:=HotspotOS Team <dev@hotspotos.com>
PKG_LICENSE:=GPL-2.0

include $(INCLUDE_DIR)/package.mk

define Package/hotspot-server
  SECTION:=net
  CATEGORY:=HotspotOS
  TITLE:=HotspotOS Captive Portal Server
  DEPENDS:=+hotspot-core +nftables +firewall4 +uhttpd +dnsmasq
  PKGARCH:=all
endef

define Package/hotspot-server/description
  HotspotOS Captive Portal Server with nftables firewall integration.
  Provides captive portal, user authentication, and traffic control.
endef

define Build/Compile
	# Shell scripts only
endef

define Package/hotspot-server/install
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_DIR) $(1)/etc/uci-defaults
	$(INSTALL_DIR) $(1)/usr/lib/hotspotos
	$(INSTALL_DIR) $(1)/www/cgi-bin/hotspot
	$(INSTALL_DIR) $(1)/www/hotspot

	$(INSTALL_DATA) ./files/etc/config/hotspot-server $(1)/etc/config/hotspot-server
	$(INSTALL_BIN) ./files/etc/init.d/hotspot-server $(1)/etc/init.d/hotspot-server
	$(INSTALL_BIN) ./files/etc/uci-defaults/52-hotspot-server $(1)/etc/uci-defaults/52-hotspot-server

	$(INSTALL_BIN) ./files/usr/lib/hotspotos/server.sh $(1)/usr/lib/hotspotos/server.sh
	$(INSTALL_BIN) ./files/usr/lib/hotspotos/captive-portal.sh $(1)/usr/lib/hotspotos/captive-portal.sh
	$(INSTALL_BIN) ./files/usr/lib/hotspotos/nft-rules.sh $(1)/usr/lib/hotspotos/nft-rules.sh

	$(INSTALL_BIN) ./files/www/cgi-bin/hotspot/login $(1)/www/cgi-bin/hotspot/login
	$(INSTALL_DATA) ./files/www/hotspot/login.html $(1)/www/hotspot/login.html
endef

define Package/hotspot-server/postinst
#!/bin/sh
[ -z "$${IPKG_INSTROOT}" ] && {
    /etc/init.d/hotspot-server enable 2>/dev/null || true
}
exit 0
endef

$(eval $(call BuildPackage,hotspot-server))
