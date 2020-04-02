#!/bin/bash
#------------------------------#
#+    custom configuration    +#   
#------------------------------#

# Modify default IP
sed -i 's/192.168.1.1/192.168.77.1/g' package/base-files/files/bin/config_generate

# atmaterial theme
git clone https://github.com/Mrbai98/luci-theme-atmaterial package/own-apps/luci-theme-atmaterial

# Serverchan
git clone https://github.com/tty228/luci-app-serverchan package/own-apps/luci-app-serverchan

# KoolProxy
# https://github.com/openwrt-develop/luci-app-koolproxy package/mine/luci-app-koolproxy

# Lienol-package
git clone https://github.com/Lienol/openwrt-package package/Lienol-package
cp -r package/Lienol-package/lienol/luci-app-passwall package/own-apps/luci-app-passwall
cp -r package/Lienol-package/package/brook package/own-apps/brook
cp -r package/Lienol-package/package/chinadns-ng package/own-apps/chinadns-ng
cp -r package/Lienol-package/package/dns2socks package/own-apps/dns2socks
cp -r package/Lienol-package/package/tcping package/own-apps/tcping
rm -rf package/Lienol-package

# SmartDNS
git clone https://github.com/pymumu/luci-app-smartdns.git package/own-apps/luci-app-smartdns
git clone https://github.com/pymumu/smartdns.git package/own-apps/smartdns

# 
git clone https://github.com/vernesong/OpenClash.git package/own-apps/OpenClash
mv package/own-apps/OpenClash/luci-app-openclash ../
