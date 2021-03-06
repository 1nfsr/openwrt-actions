#!/bin/bash



## Revert miniupnpd version(2.0)
rm -Rf feeds/packages/net/miniupnpd
mv ${GITHUB_WORKSPACE}/apps/miniupnpd feeds/packages/net/


## Docker
sed -i 's/+docker/+docker +dockerd/g' feeds/luci/applications/luci-app-dockerman/Makefile


## Turboacc
mv ${GITHUB_WORKSPACE}/apps/luci-app-turboacc package/apps/
mv ${GITHUB_WORKSPACE}/apps/turboacc-ext/* package/apps/
# Fix DNS port
rm -rf package/apps/luci-app-turboacc/root/etc/init.d/turboacc
mv $GITHUB_WORKSPACE/apps-custom-files/turboacc/root/etc/init.d/turboacc package/apps/luci-app-turboacc/root/etc/init.d/
# Patch firewall support fullconenat
mkdir package/network/config/firewall/patches
wget -O package/network/config/firewall/patches/fullconenat.patch https://github.com/coolsnowwolf/lede/raw/master/package/network/config/firewall/patches/fullconenat.patch
# Patch remove firewall view offload
mv $GITHUB_WORKSPACE/PATCH/remove_firewall_view_offload.patch ./
patch -p1 < remove_firewall_view_offload.patch
rm -rf remove_firewall_view_offload.patch


## AdguardHome
git clone --depth=1 https://github.com/kongfl888/luci-app-adguardhome.git package/apps/luci-app-adguardhome
# AdguardHome config
mv ${GITHUB_WORKSPACE}/base-files/etc/AdGuardHome.yaml package/base-files/files/etc/
# custom AdguardHome
rm -rf package/apps/luci-app-adguardhome/luasrc/controller/AdGuardHome.lua
mv ${GITHUB_WORKSPACE}/apps-custom-files/adguardhome/luasrc/controller/AdGuardHome.lua package/apps/luci-app-adguardhome/luasrc/controller/
rm -rf package/apps/luci-app-adguardhome/root/etc/config/AdGuardHome
mv ${GITHUB_WORKSPACE}/apps-custom-files/adguardhome/root/etc/config/AdGuardHome package/apps/luci-app-adguardhome/root/etc/config/
# Nginx Reverse Proxy (http://adguardhome.gg)
echo "address=/adguardhome.gg/192.168.77.1" >> package/network/services/dnsmasq/files/dnsmasq.conf


## OpenClash
svn co https://github.com/vernesong/OpenClash/trunk/luci-app-openclash package/apps/luci-app-openclash
# custom clash
rm -rf package/apps/luci-app-openclash/root/etc/config/openclash
mv ${GITHUB_WORKSPACE}/apps-custom-files/openclash/root/etc/config/openclash package/apps/luci-app-openclash/root/etc/config/
rm -rf package/apps/luci-app-openclash/root/etc/openclash/custom/openclash_custom_rules_2.list
mv ${GITHUB_WORKSPACE}/apps-custom-files/openclash/root/etc/openclash/custom/openclash_custom_rules_2.list package/apps/luci-app-openclash/root/etc/openclash/custom/
rm -rf package/apps/luci-app-openclash/root/usr/share/openclash/{dashboard,yacd}
rm -rf package/apps/luci-app-openclash/luasrc/model/cbi/openclash/settings.lua
mv ${GITHUB_WORKSPACE}/apps-custom-files/openclash/luasrc/model/cbi/openclash/settings.lua package/apps/luci-app-openclash/luasrc/model/cbi/openclash/
rm -rf package/apps/luci-app-openclash/luasrc/view/openclash/status.htm
mv ${GITHUB_WORKSPACE}/apps-custom-files/openclash/luasrc/view/openclash/status.htm package/apps/luci-app-openclash/luasrc/view/openclash/
rm -rf package/apps/luci-app-openclash/root/etc/init.d/openclash
mv ${GITHUB_WORKSPACE}/apps-custom-files/openclash/root/etc/init.d/openclash package/apps/luci-app-openclash/root/etc/init.d/
rm -rf package/apps/luci-app-openclash/root/usr/share/openclash/{yml_change.sh,openclash.sh}
mv ${GITHUB_WORKSPACE}/apps-custom-files/openclash/root/usr/share/openclash/{yml_change.sh,openclash.sh} package/apps/luci-app-openclash/root/usr/share/openclash/
rm -rf package/apps/luci-app-openclash/luasrc/controller/openclash.lua
mv ${GITHUB_WORKSPACE}/apps-custom-files/openclash/luasrc/controller/openclash.lua package/apps/luci-app-openclash/luasrc/controller/
rm -rf package/apps/luci-app-openclash/root/usr/share/openclash/res/{ConnersHua_return.yaml,ConnersHua.yaml,lhie1.yaml,sub_ini.list}
mv ${GITHUB_WORKSPACE}/apps-custom-files/openclash/root/usr/share/openclash/res/sub_ini.list package/apps/luci-app-openclash/root/usr/share/openclash/res/
# clash dashboard (http://openclash.pro)
mkdir -p package/base-files/files/www
mv ${GITHUB_WORKSPACE}/base-files/www/clash-ui package/base-files/files/www/
sed -i 's/127.0.0.1/192.168.77.1/g' package/base-files/files/www/clash-ui/app.6706b8885424994ac6fe.js
sed -i 's/secret:""/secret:"123456"/g' package/base-files/files/www/clash-ui/app.6706b8885424994ac6fe.js
sed -i 's/127.0.0.1/192.168.77.1/g' package/base-files/files/www/clash-ui/index.html
echo "address=/openclash.pro/192.168.77.1" >> package/network/services/dnsmasq/files/dnsmasq.conf
# subconverter server (http://openclash.gg)
mv ${GITHUB_WORKSPACE}/base-files/etc/init.d/subconverter package/base-files/files/etc/init.d/
mv ${GITHUB_WORKSPACE}/base-files/etc/subconverter package/base-files/files/etc/
echo "address=/openclash.gg/192.168.77.1" >> package/network/services/dnsmasq/files/dnsmasq.conf
# subconverter template ini (http://openclash.su)
mv ${GITHUB_WORKSPACE}/base-files/www/subconverter package/base-files/files/www/
echo "address=/openclash.su/192.168.77.1" >> package/network/services/dnsmasq/files/dnsmasq.conf
# modify Github-Free subscription
mv ${GITHUB_WORKSPACE}/apps-custom-files/openclash/root/etc/openclash/config/github_share.yaml package/apps/luci-app-openclash/root/etc/openclash/config/