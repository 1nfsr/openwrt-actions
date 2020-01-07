#!/bin/bash
#

# Modify default IP
sed -i 's/192.168.1.1/192.168.77.1/g' package/base-files/files/bin/config_generate

# Atmaterial Theme
git clone https://github.com/Mrbai98/luci-theme-atmaterial package/mine/luci-theme-atmaterial

# Serverchen
git clone https://github.com/tty228/luci-app-serverchan package/mine/luci-app-serverchan

# OpenAppFilter(luci-app-oaf)
git clone https://github.com/destan19/OpenAppFilter package/mine/OpenAppFilter

# DiskMan for LuCI (WIP)
git clone https://github.com/lisaac/luci-app-diskman package/mine/luci-app-diskman
mkdir -p package/mine/parted && cp -i package/mine/luci-app-diskman/Parted.Makefile package/mine/parted/Makefile

# Docker Manager interface for LuCI + Docker Engine API for LuCI
git clone https://github.com/lisaac/luci-lib-docker package/mine/luci-lib-docker
git clone https://github.com/lisaac/luci-app-dockerman package/mine/luci-app-dockerman

# get some Lienol packages
git clone https://github.com/Lienol/openwrt-package package/Lienol-package
# https://github.com/Lienol/openwrt-package/issues/54
cp -r package/Lienol-package/lienol/luci-app-fileassistant package/mine/luci-app-fileassistant
cp -r package/Lienol-package/lienol/luci-app-filebrowser package/mine/luci-app-filebrowser
cp -r package/Lienol-package/lienol/luci-app-passwall package/mine/luci-app-passwall
cp -r package/Lienol-package/lienol/luci-theme-argon-mod package/mine/luci-theme-argon-mod
#cp -r package/Lienol-package/lienol/luci-theme-bootstrap-mod package/mine/luci-theme-bootstrap-mod
cp -r package/Lienol-package/lienol/luci-theme-netgear-mc package/mine/luci-theme-netgear-mc
#cp package/Lienol-package/lienol/luci_my.mk package/mine
cp -r package/Lienol-package/package/brook package/mine/brook
cp -r package/Lienol-package/package/chinadns-ng package/mine/chinadns-ng
cp -r package/Lienol-package/package/dns2socks package/mine/dns2socks
cp -r package/Lienol-package/package/tcping package/mine/tcping
rm -rf package/Lienol-package

# luci-app-vssr
# git clone https://github.com/jerrykuku/luci-app-vssr package/mine/luci-app-vssr
