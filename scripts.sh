#!/bin/bash
#------------------------------#
#+    custom configuration    +#   
#------------------------------#

# Modify default IP
sed -i 's/192.168.1.1/192.168.77.1/g' package/base-files/files/bin/config_generate

# atmaterial主题
git clone https://github.com/Mrbai98/luci-theme-atmaterial package/mine/luci-theme-atmaterial

# new argon theme
#git clone https://github.com/jerrykuku/luci-theme-argon package/mine/luci-theme-argon
# 删除自带argon主题
#rm -rf package/lean/luci-theme-argon

# Serverchan
git clone https://github.com/tty228/luci-app-serverchan package/mine/luci-app-serverchan

# OpenAppFilter(luci-app-oaf)
git clone https://github.com/destan19/OpenAppFilter package/mine/OpenAppFilter

# AdGuardHome-Luci安装控制界面,仅luci界面
#git clone https://github.com/adamw92/luci-app-adguardhome package/mine/luci-app-adguardhome

# AdGuardHome + luci
#git clone https://github.com/happyzhang1995/openwrt-adguardhome package/mine/adguardhome
#git clone https://github.com/rufengsuixing/luci-app-adguardhome package/mine/luci-app-adguardhome

# Clash-Luci,support ssr
#git clone https://github.com/frainzy1477/luci-app-clash package/mine/luci-app-clash

# DiskMan for LuCI (WIP)
git clone https://github.com/lisaac/luci-app-diskman package/mine/luci-app-diskman
mkdir -p package/mine/parted && cp -i package/mine/luci-app-diskman/Parted.Makefile package/mine/parted/Makefile

# Docker Manager interface for LuCI + Docker Engine API for LuCI
git clone https://github.com/lisaac/luci-lib-docker package/mine/luci-lib-docker
git clone https://github.com/lisaac/luci-app-dockerman package/mine/luci-app-dockerman

# Lienol-package
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