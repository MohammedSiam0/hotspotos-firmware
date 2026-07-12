include $(TOPDIR)/rules.mk

PKG_NAME:=hotspot-users
PKG_VERSION:=1.0.0
PKG_RELEASE:=1

PKG_MAINTAINER:=HotspotOS Team <dev@hotspotos.com>
PKG_LICENSE:=GPL-2.0

include $(INCLUDE_DIR)/package.mk

define Package/hotspot-users
  SECTION:=net
  CATEGORY:=HotspotOS
  TITLE:=HotspotOS User Manager
  DEPENDS:=+hotspot-core
  PKGARCH:=all
endef

define Package/hotspot-users/description
  HotspotOS User Management - Add, edit, delete users.
  Manage time limits, speed limits, and device limits.
endef

define Build/Compile
	# Shell scripts only
endef

define Package/hotspot-users/install
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_DIR) $(1)/etc/uci-defaults
	$(INSTALL_DIR) $(1)/usr/lib/hotspotos

	$(INSTALL_DATA) ./files/etc/config/hotspot-users $(1)/etc/config/hotspot-users
	$(INSTALL_BIN) ./files/etc/uci-defaults/53-hotspot-users $(1)/etc/uci-defaults/53-hotspot-users

	$(INSTALL_BIN) ./files/usr/lib/hotspotos/users.sh $(1)/usr/lib/hotspotos/users.sh
	$(INSTALL_BIN) ./files/usr/lib/hotspotos/user-add.sh $(1)/usr/lib/hotspotos/user-add.sh
	$(INSTALL_BIN) ./files/usr/lib/hotspotos/user-edit.sh $(1)/usr/lib/hotspotos/user-edit.sh
	$(INSTALL_BIN) ./files/usr/lib/hotspotos/user-delete.sh $(1)/usr/lib/hotspotos/user-delete.sh
	$(INSTALL_BIN) ./files/usr/lib/hotspotos/user-limit.sh $(1)/usr/lib/hotspotos/user-limit.sh
endef

define Package/hotspot-users/postinst
#!/bin/sh
[ -z "$${IPKG_INSTROOT}" ] && {
    /usr/lib/hotspotos/users.sh init-defaults 2>/dev/null || true
}
exit 0
endef

$(eval $(call BuildPackage,hotspot-users))
