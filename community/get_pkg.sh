#!bin/bash

rm -rf ./lean/{autocore,automount,dnsforwarder,dnsproxy,ipv6-helper,luci-app-arpbind}
rm -rf ./lean/{luci-app-turboacc,openwrt-fullconenat,pdnsd-alt,r8168,shortcut-fe}
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/autocore ./lean/autocore
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/automount ./lean/automount
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/dnsforwarder ./lean/dnsforwarder
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/dnsproxy ./lean/dnsproxy
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/ipv6-helper ./lean/ipv6-helper
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/luci-app-arpbind ./lean/luci-app-arpbind
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/luci-app-turboacc ./lean/luci-app-turboacc
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/openwrt-fullconenat ./lean/openwrt-fullconenat
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/pdnsd-alt ./lean/pdnsd-alt
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/r8168 ./lean/r8168
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/shortcut-fe ./lean/shortcut-fe


rm -rf ./lienol
svn co https://github.com/xiaorouji/openwrt-passwall/trunk/ ./lienol
rm -rf ./lienol/.github


rm -rf ./other/luci-app-openclash
svn co https://github.com/vernesong/OpenClash/trunk/luci-app-openclash ./other/luci-app-openclash

rm -rf ./other/luci-app-adguardhome
svn co https://github.com/kongfl888/luci-app-adguardhome/trunk/ ./other/luci-app-adguardhome
rm -rf ./other/luci-app-adguardhome/.github

rm -rf ./other/luci-theme-atmaterial_new
svn co https://github.com/kenzok8/openwrt-packages/trunk/luci-theme-atmaterial_new ./other/luci-theme-atmaterial_new