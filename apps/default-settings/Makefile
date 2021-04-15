include $(TOPDIR)/rules.mk

PKG_NAME:=default-settings
PKG_VERSION:=0.1
PKG_RELEASE:=beta

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
  SECTION:=luci
  CATEGORY:=LuCI
  TITLE:=Default Settings
  PKGARCH:=all
  DEPENDS:=
endef

define Package/$(PKG_NAME)/description
	Language Support Packages.
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/etc/uci-defaults
	$(INSTALL_BIN) ./files/default-settings $(1)/etc/uci-defaults/99-default-settings
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
