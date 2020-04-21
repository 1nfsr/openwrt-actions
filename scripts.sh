#!/bin/bash
#------------------------------#
#+    custom configuration    +#   
#------------------------------#

# Modify default IP
sed -i 's/192.168.1.1/192.168.77.1/g' package/base-files/files/bin/config_generate

# SSR PLUS+
#mkdir package/base-files/files/config
#echo 0xDEADBEEF > package/base-files/files/config/google_fu_mode
#echo "src-git helloworld https://github.com/fw876/helloworld" >> feeds.conf.default
#./scripts/feeds update -a && ./scripts/feeds install -a

# PassWall
#echo "src-git lienol https://github.com/Lienol/openwrt-package" >> feeds.conf.default
#./scripts/feeds clean && ./scripts/feeds update -a && ./scripts/feeds install -a
git clone https://github.com/Lienol/openwrt-package.git package/Lienol-package
git clone https://github.com/kenzok8/openwrt-packages.git package/kenzok8-package
rm -rf package/lienol
mkdir package/lienol
echo "Create done"
cp -r package/kenzok8-package/luci-app-passwall package/lienol/luci-app-passwall
#cp -r package/Lienol-package/lienol/luci-app-passwall package/lienol/luci-app-passwall
cp -r package/Lienol-package/package/brook package/lienol/brook
cp -r package/Lienol-package/package/chinadns-ng package/lienol/chinadns-ng
cp -r package/Lienol-package/package/dns2socks package/lienol/dns2socks
cp -r package/Lienol-package/package/tcping package/lienol/tcping
echo "Copy done"
rm -rf package/Lienol-package
rm -rf package/kenzok8-package
echo "Delete done"


# VSSR
git clone https://github.com/jerrykuku/lua-maxminddb.git package/lean/lua-maxminddb
git clone https://github.com/jerrykuku/luci-app-vssr.git package/lean/luci-app-vssr

# ServerChen
git clone https://github.com/tty228/luci-app-serverchan.git package/OpenWrtApps/luci-app-serverchan

# Atmaterial
git clone https://github.com/Mrbai98/luci-theme-atmaterial.git package/OpenWrtApps/luci-theme-atmaterial

echo "done"
