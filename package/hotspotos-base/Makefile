include $(TOPDIR)/rules.mk

PKG_NAME:=hotspotos-base
PKG_VERSION:=1.0.0
PKG_RELEASE:=1

PKG_MAINTAINER:=HotspotOS Team <dev@hotspotos.com>
PKG_LICENSE:=GPL-2.0

include $(INCLUDE_DIR)/package.mk

define Package/hotspotos-base
  SECTION:=base
  CATEGORY:=HotspotOS
  TITLE:=HotspotOS Base System
  DEPENDS:=+libc +libgcc +uci
  PKGARCH:=all
endef

define Package/hotspotos-base/description
  HotspotOS base branding and system configuration.
  Provides custom banner, OS identification, UCI defaults, and system services.
endef

define Build/Compile
	# Nothing to compile - config only package
endef

define Package/hotspotos-base/install
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_DIR) $(1)/etc/hotspotos
	$(INSTALL_DIR) $(1)/usr/lib/hotspotos
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_DIR) $(1)/etc/uci-defaults

	# Install UCI configuration
	$(INSTALL_DATA) ./files/etc/config/hotspotos $(1)/etc/config/hotspotos

	# Install branding assets
	$(INSTALL_DATA) ./files/etc/banner $(1)/etc/banner
	$(INSTALL_DATA) ./files/etc/os-release $(1)/etc/os-release

	# Install init script
	$(INSTALL_BIN) ./files/etc/init.d/hotspotos $(1)/etc/init.d/hotspotos

	# Install UCI defaults
	$(INSTALL_BIN) ./files/etc/uci-defaults/99-hotspotos-theme $(1)/etc/uci-defaults/99-hotspotos-theme

	# Install version script
	$(INSTALL_BIN) ./files/usr/lib/hotspotos/version.sh $(1)/usr/lib/hotspotos/version.sh
endef

define Package/hotspotos-base/postinst
#!/bin/sh
[ -z "$${IPKG_INSTROOT}" ] && {
    /etc/init.d/hotspotos enable 2>/dev/null || true
    /etc/uci-defaults/99-hotspotos-theme 2>/dev/null || true
}
exit 0
endef

$(eval $(call BuildPackage,hotspotos-base))
