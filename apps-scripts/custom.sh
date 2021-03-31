#!/bin/bash



## Revert miniupnpd version(2.0)
rm -Rf feeds/packages/net/miniupnpd
mv ${GITHUB_WORKSPACE}/apps/miniupnpd feeds/packages/net/


## Docker
sed -i 's/+docker/+docker +dockerd +docker-compose/g' feeds/luci/applications/luci-app-dockerman/Makefile
# Revert Docker version(20.10.4)
rm -rf feeds/packages/utils/docker/Makefile
mv ${GITHUB_WORKSPACE}/apps/docker/docker-Makefile feeds/packages/utils/docker/Makefile
rm -rf feeds/packages/utils/dockerd/Makefile
mv ${GITHUB_WORKSPACE}/apps/docker/dockerd-Makefile feeds/packages/utils/dockerd/Makefile


## Turboacc
mv ${GITHUB_WORKSPACE}/apps/luci-app-turboacc package/apps/
mv ${GITHUB_WORKSPACE}/apps/turboacc-ext/* package/apps/
# Fix DNS port
rm -rf package/apps/luci-app-turboacc/root/etc/init.d/turboacc
mv ${GITHUB_WORKSPACE}/apps-custom-files/turboacc/root/etc/init.d/turboacc package/apps/luci-app-turboacc/root/etc/init.d/
# Patch firewall support fullconenat
mkdir package/network/config/firewall/patches
wget -O package/network/config/firewall/patches/fullconenat.patch https://github.com/coolsnowwolf/lede/raw/master/package/network/config/firewall/patches/fullconenat.patch
# Patch remove firewall view offload
mv ${GITHUB_WORKSPACE}/apps-patch/001-remove_firewall_view_offload.patch ./
patch -p1 < 001-remove_firewall_view_offload.patch
rm -rf 001-remove_firewall_view_offload.patch
# Patch remove DNS Acceleration&DNS Caching
mv ${GITHUB_WORKSPACE}/apps-patch/002-remove_turboacc_dns_acc.patch ./
patch -p1 < 002-remove_turboacc_dns_acc.patch
rm -rf 002-remove_turboacc_dns_acc.patch
# Fix conntrack events patch netfilter
cp ${GITHUB_WORKSPACE}/kernel-patch/952-net-conntrack-events-support-multiple-registrant.patch target/linux/generic/hack-5.4/
mv ${GITHUB_WORKSPACE}/kernel-patch/952-net-conntrack-events-support-multiple-registrant.patch target/linux/generic/hack-5.10/
# Implementation of RFC3489-compatible full cone SNAT
echo "iptables -t nat -A POSTROUTING -o eth1 -j FULLCONENAT" >> package/network/config/firewall/files/firewall.user
echo "iptables -t nat -A PREROUTING -i eth1 -j FULLCONENAT" >> package/network/config/firewall/files/firewall.user


## AdguardHome
git clone --depth=1 https://github.com/kongfl888/luci-app-adguardhome.git package/apps/luci-app-adguardhome
echo "ADGUARDHOME=$PWD/package/apps/luci-app-adguardhome" >> $GITHUB_ENV
if [ ! -d "$ADGUARDHOME"]; then
	mv ${GITHUB_WORKSPACE}/apps/luci-app-adguardhome package/apps/
else
	echo -e "\n adguardhome created"
fi
# AdguardHome config
rm package/apps/luci-app-adguardhome/luasrc/model/cbi/AdGuardHome/base.lua
mv ${GITHUB_WORKSPACE}/apps-custom-files/adguardhome/luasrc/model/cbi/AdGuardHome/base.lua package/apps/luci-app-adguardhome/luasrc/model/cbi/AdGuardHome/
mv ${GITHUB_WORKSPACE}/apps-custom-files/adguardhome/AdGuardHome.yaml package/base-files/files/etc/config/
rm package/apps/luci-app-adguardhome/root/etc/init.d/AdGuardHome
mv ${GITHUB_WORKSPACE}/apps-custom-files/adguardhome/root/etc/init.d/AdGuardHome package/apps/luci-app-adguardhome/root/etc/init.d/
# custom AdguardHome
rm -rf package/apps/luci-app-adguardhome/luasrc/controller/AdGuardHome.lua
mv ${GITHUB_WORKSPACE}/apps-custom-files/adguardhome/luasrc/controller/AdGuardHome.lua package/apps/luci-app-adguardhome/luasrc/controller/
rm -rf package/apps/luci-app-adguardhome/root/etc/config/AdGuardHome
mv ${GITHUB_WORKSPACE}/apps-custom-files/adguardhome/root/etc/config/AdGuardHome package/apps/luci-app-adguardhome/root/etc/config/
# Nginx Reverse Proxy (http://adguardhome.gg)
echo "address=/adguardhome.gg/192.168.77.1" >> package/network/services/dnsmasq/files/dnsmasq.conf
# dnsmasq forwarder
#sed -e '17s/#list/list/' -e '17s/\/mycompany.local\/1.2.3.4/127.0.0.1#10053/' package/network/services/dnsmasq/files/dhcp.conf
# Firewall Rules
echo "iptables -t nat -A PREROUTING -p udp --dport 53 -j REDIRECT --to-ports 53" >> package/network/config/firewall/files/firewall.user
echo "iptables -t nat -A PREROUTING -p tcp --dport 53 -j REDIRECT --to-ports 53" >> package/network/config/firewall/files/firewall.user


## OpenClash
svn co https://github.com/vernesong/OpenClash/trunk/luci-app-openclash package/apps/luci-app-openclash
echo "OPENCLASH=$PWD/package/apps/luci-app-openclash" >> $GITHUB_ENV
if [ ! -d "$OPENCLASH"]; then
	mv ${GITHUB_WORKSPACE}/apps/luci-app-openclash package/apps/
else
	echo -e "\n openclash created"
fi
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
sed -i 's/http:\/\/127.0.0.1:9090/https:\/\/wss.openclash.pro/g' package/base-files/files/www/clash-ui/app.6706b8885424994ac6fe.js
sed -i 's/secret:""/secret:"123456"/g' package/base-files/files/www/clash-ui/app.6706b8885424994ac6fe.js
sed -i 's/http:\/\/127.0.0.1:9090/https:\/\/wss.openclash.pro/g' package/base-files/files/www/clash-ui/index.html
echo "address=/openclash.pro/192.168.77.1" >> package/network/services/dnsmasq/files/dnsmasq.conf
echo "address=/wss.openclash.pro/192.168.77.1" >> package/network/services/dnsmasq/files/dnsmasq.conf
# subconverter server (http://openclash.gg)
mv ${GITHUB_WORKSPACE}/base-files/etc/init.d/subconverter package/base-files/files/etc/init.d/
mv ${GITHUB_WORKSPACE}/base-files/etc/subconverter package/base-files/files/etc/
echo "address=/openclash.gg/192.168.77.1" >> package/network/services/dnsmasq/files/dnsmasq.conf
# subconverter template ini (http://openclash.su)
mv ${GITHUB_WORKSPACE}/base-files/www/subconverter package/base-files/files/www/
echo "address=/openclash.su/192.168.77.1" >> package/network/services/dnsmasq/files/dnsmasq.conf
# modify Free subscription
mkdir -p package/apps/luci-app-openclash/root/etc/openclash/config/
wget -O package/apps/luci-app-openclash/root/etc/openclash/config/github_share.yaml https://raw.githubusercontent.com/ssrsub/ssr/master/Clash.yml
mkdir -p package/apps/luci-app-openclash/root/etc/openclash/backup
cp -rf package/apps/luci-app-openclash/root/etc/openclash/config/github_share.yaml package/apps/luci-app-openclash/root/etc/openclash/backup
cp -rf package/apps/luci-app-openclash/root/etc/openclash/config/github_share.yaml package/apps/luci-app-openclash/root/etc/openclash/
mv ${GITHUB_WORKSPACE}/apps-custom-files/openclash/root/etc/openclash/config/github_share2.yaml package/apps/luci-app-openclash/root/etc/openclash/config/
mv ${GITHUB_WORKSPACE}/apps-custom-files/openclash/root/etc/openclash/config/proxypoolss_tk_v2.yaml package/apps/luci-app-openclash/root/etc/openclash/config/


## SmartDNS
mv ${GITHUB_WORKSPACE}/apps-custom-files/smartdns/root/etc/config/smartdns package/base-files/files/etc/config/
mkdir -p package/base-files/files/etc/smartdns
mv ${GITHUB_WORKSPACE}/apps-custom-files/smartdns/root/etc/smartdns/address.conf package/base-files/files/etc/smartdns/
# disable Rebind protection&&RBL checking and similar services
sed -i "s/option rebind_protection 1/option rebind_protection 0/g" package/network/services/dnsmasq/files/dhcp.conf
sed -i "s/option rebind_localhost 1/option rebind_localhost 0/g" package/network/services/dnsmasq/files/dhcp.conf