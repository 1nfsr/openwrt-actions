#!/bin/bash
#------------------------------#
#+    custom configuration    +#   
#------------------------------#

# Modify default IP
sed -i 's/192.168.1.1/192.168.77.1/g' package/base-files/files/bin/config_generate

# atmaterial主题
git clone https://github.com/Mrbai98/luci-theme-atmaterial package/mine/luci-theme-atmaterial

# Serverchan
git clone https://github.com/tty228/luci-app-serverchan package/mine/luci-app-serverchan

# Lienol-package
git clone https://github.com/Lienol/openwrt-package package/Lienol-package
cp -r package/Lienol-package/lienol/luci-app-passwall package/mine/luci-app-passwall
cp -r package/Lienol-package/package/brook package/mine/brook
cp -r package/Lienol-package/package/chinadns-ng package/mine/chinadns-ng
cp -r package/Lienol-package/package/dns2socks package/mine/dns2socks
cp -r package/Lienol-package/package/tcping package/mine/tcping
rm -rf package/Lienol-package