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

# VSSR
git clone https://github.com/jerrykuku/lua-maxminddb.git package/lean/lua-maxminddb
git clone https://github.com/jerrykuku/luci-app-vssr.git package/lean/luci-app-vssr

# ServerChen
git clone https://github.com/tty228/luci-app-serverchan.git package/OpenWrtApps/luci-app-serverchan

# Atmaterial
git clone https://github.com/Mrbai98/luci-theme-atmaterial.git package/OpenWrtApps/luci-theme-atmaterial
