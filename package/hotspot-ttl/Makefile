include $(TOPDIR)/rules.mk

PKG_NAME:=hotspot-ttl
PKG_VERSION:=1.0.0
PKG_RELEASE:=1

PKG_MAINTAINER:=HotspotOS Team <dev@hotspotos.com>
PKG_LICENSE:=GPL-2.0

include $(INCLUDE_DIR)/package.mk

define Package/hotspot-ttl
  SECTION:=net
  CATEGORY:=HotspotOS
  TITLE:=HotspotOS TTL Manager
  DEPENDS:=+hotspot-core +nftables +firewall4 +kmod-nft-netdev
  PKGARCH:=all
endef

define Package/hotspot-ttl/description
  HotspotOS TTL Manager - Modify TTL values using nftables.
  Used to bypass ISP hotspot detection.
endef

define Build/Compile
	# Shell scripts only
endef

define Package/hotspot-ttl/install
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_DIR) $(1)/etc/uci-defaults
	$(INSTALL_DIR) $(1)/usr/lib/hotspotos

	$(INSTALL_DATA) ./files/etc/config/hotspot-ttl $(1)/etc/config/hotspot-ttl
	$(INSTALL_BIN) ./files/etc/uci-defaults/55-hotspot-ttl $(1)/etc/uci-defaults/55-hotspot-ttl

	$(INSTALL_BIN) ./files/usr/lib/hotspotos/ttl.sh $(1)/usr/lib/hotspotos/ttl.sh
	$(INSTALL_BIN) ./files/usr/lib/hotspotos/ttl-apply.sh $(1)/usr/lib/hotspotos/ttl-apply.sh
endef

$(eval $(call BuildPackage,hotspot-ttl))
