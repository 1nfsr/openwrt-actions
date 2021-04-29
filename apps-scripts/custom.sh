#!/bin/bash



## Revert miniupnpd version(2.0)
rm -Rf feeds/packages/net/miniupnpd
mv ${GITHUB_WORKSPACE}/apps/miniupnpd feeds/packages/net/


## Docker
sed -i 's/+docker/+docker +dockerd +docker-compose/g' feeds/luci/applications/luci-app-dockerman/Makefile
mv -f ${GITHUB_WORKSPACE}/apps-custom-files/docker/etc/config/dockerd feeds/packages/utils/dockerd/files/etc/config/
mkdir -p package/base-files/files/etc/docker/
mv ${GITHUB_WORKSPACE}/apps-custom-files/docker/daemon.json package/base-files/files/etc/docker/
mv -f ${GITHUB_WORKSPACE}/apps-custom-files/docker/dockerd-restart.sh package/base-files/files/etc/init.d/
sed -i '/exit 0/i\bash /etc/dockerd-restart.sh' package/base-files/files/etc/rc.local


## Turboacc
mv ${GITHUB_WORKSPACE}/apps/luci-app-turboacc package/apps/
mv ${GITHUB_WORKSPACE}/apps/turboacc-ext/* package/apps/
# Fix DNS port
mv -f ${GITHUB_WORKSPACE}/apps-custom-files/turboacc/root/etc/init.d/turboacc package/apps/luci-app-turboacc/root/etc/init.d/
# Patch firewall support fullconenat
mkdir package/network/config/firewall/patches
wget -O package/network/config/firewall/patches/fullconenat.patch https://github.com/coolsnowwolf/lede/raw/master/package/network/config/firewall/patches/fullconenat.patch
# Patch remove firewall view offload
mv ${GITHUB_WORKSPACE}/apps-patch/001-remove_firewall_view_offload.patch ./
patch -p1 < 001-remove_firewall_view_offload.patch
rm -Rf 001-remove_firewall_view_offload.patch
# Patch remove DNS Acceleration&DNS Caching
mv ${GITHUB_WORKSPACE}/apps-patch/002-remove_turboacc_dns_acc.patch ./
patch -p1 < 002-remove_turboacc_dns_acc.patch
rm -Rf 002-remove_turboacc_dns_acc.patch
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
mv -f ${GITHUB_WORKSPACE}/apps-custom-files/adguardhome/luasrc/model/cbi/AdGuardHome/base.lua package/apps/luci-app-adguardhome/luasrc/model/cbi/AdGuardHome/
mv -f ${GITHUB_WORKSPACE}/apps-custom-files/adguardhome/AdGuardHome.yaml package/base-files/files/etc/config/
mv -f ${GITHUB_WORKSPACE}/apps-custom-files/adguardhome/root/etc/init.d/AdGuardHome package/apps/luci-app-adguardhome/root/etc/init.d/
# custom AdguardHome
mv -f ${GITHUB_WORKSPACE}/apps-custom-files/adguardhome/luasrc/controller/AdGuardHome.lua package/apps/luci-app-adguardhome/luasrc/controller/
mv -f ${GITHUB_WORKSPACE}/apps-custom-files/adguardhome/root/etc/config/AdGuardHome package/apps/luci-app-adguardhome/root/etc/config/
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
mv -f ${GITHUB_WORKSPACE}/apps-custom-files/openclash/root/etc/config/openclash package/apps/luci-app-openclash/root/etc/config/
mv -f ${GITHUB_WORKSPACE}/apps-custom-files/openclash/root/etc/openclash/custom/openclash_custom_rules_2.list package/apps/luci-app-openclash/root/etc/openclash/custom/
rm -Rf package/apps/luci-app-openclash/root/usr/share/openclash/{dashboard,yacd}
mv -f ${GITHUB_WORKSPACE}/apps-custom-files/openclash/luasrc/model/cbi/openclash/settings.lua package/apps/luci-app-openclash/luasrc/model/cbi/openclash/
mv -f ${GITHUB_WORKSPACE}/apps-custom-files/openclash/luasrc/model/cbi/openclash/client.lua package/apps/luci-app-openclash/luasrc/model/cbi/openclash/
mv -f ${GITHUB_WORKSPACE}/apps-custom-files/openclash/luasrc/model/cbi/openclash/config-subscribe-edit.lua package/apps/luci-app-openclash/luasrc/model/cbi/openclash/
mv -f ${GITHUB_WORKSPACE}/apps-custom-files/openclash/luasrc/model/cbi/openclash/config.lua package/apps/luci-app-openclash/luasrc/model/cbi/openclash/
rm -Rf package/apps/luci-app-openclash/luasrc/view/config_editor.htm
rm -Rf package/apps/luci-app-openclash/root/www
rm -Rf package/apps/luci-app-openclash/root/usr/share/openclash/res/default.yaml
mv -f ${GITHUB_WORKSPACE}/apps-custom-files/openclash/luasrc/view/openclash/status.htm package/apps/luci-app-openclash/luasrc/view/openclash/
mv -f ${GITHUB_WORKSPACE}/apps-custom-files/openclash/root/etc/init.d/openclash package/apps/luci-app-openclash/root/etc/init.d/
mv -f ${GITHUB_WORKSPACE}/apps-custom-files/openclash/root/usr/share/openclash/{yml_change.sh,yml_groups_set.sh,yml_proxys_set.sh,openclash.sh} package/apps/luci-app-openclash/root/usr/share/openclash/
mv -f ${GITHUB_WORKSPACE}/apps-custom-files/openclash/luasrc/controller/openclash.lua package/apps/luci-app-openclash/luasrc/controller/
rm -Rf package/apps/luci-app-openclash/root/usr/share/openclash/res/{ConnersHua_return.yaml,ConnersHua.yaml,lhie1.yaml,sub_ini.list}
mv -f ${GITHUB_WORKSPACE}/apps-custom-files/openclash/root/usr/share/openclash/res/sub_ini.list package/apps/luci-app-openclash/root/usr/share/openclash/res/
# clash dashboard (http://openclash.pro)
mkdir -p package/base-files/files/www
mv ${GITHUB_WORKSPACE}/base-files/www/clash-ui package/base-files/files/www/
sed -i 's/http:\/\/127.0.0.1:9090/https:\/\/wss.open-wrt.tk/g' package/base-files/files/www/clash-ui/app.6706b8885424994ac6fe.js
sed -i 's/secret:""/secret:"123456"/g' package/base-files/files/www/clash-ui/app.6706b8885424994ac6fe.js
sed -i 's/http:\/\/127.0.0.1:9090/https:\/\/wss.open-wrt.tk/g' package/base-files/files/www/clash-ui/index.html
# subconverter server (http://openclash.gg)
mv ${GITHUB_WORKSPACE}/base-files/etc/init.d/subconverter package/base-files/files/etc/init.d/
mv ${GITHUB_WORKSPACE}/base-files/etc/subconverter package/base-files/files/etc/
# subconverter template ini (http://openclash.su)
mv ${GITHUB_WORKSPACE}/base-files/www/subconverter package/base-files/files/www/
# modify Free subscription
mkdir -p package/apps/luci-app-openclash/root/etc/openclash/config/
mkdir -p package/apps/luci-app-openclash/root/etc/openclash/backup/
wget -O package/apps/luci-app-openclash/root/etc/openclash/baipiao.yaml https://aiyss.com/link/wsMYp6dtBFiYVmaG?clash=1
cp -rf package/apps/luci-app-openclash/root/etc/openclash/baipiao.yaml package/apps/luci-app-openclash/root/etc/openclash/config/
cp -rf package/apps/luci-app-openclash/root/etc/openclash/baipiao.yaml package/apps/luci-app-openclash/root/etc/openclash/backup/


## dnsmasq local Domain
echo "address=/open-wrt.tk/192.168.77.1" >> package/network/services/dnsmasq/files/dnsmasq.conf
echo "address=/yacd.open-wrt.tk/192.168.77.1" >> package/network/services/dnsmasq/files/dnsmasq.conf
echo "address=/wss.open-wrt.tk/192.168.77.1" >> package/network/services/dnsmasq/files/dnsmasq.conf
echo "address=/rules.open-wrt.tk/192.168.77.1" >> package/network/services/dnsmasq/files/dnsmasq.conf
echo "address=/subd.open-wrt.tk/192.168.77.1" >> package/network/services/dnsmasq/files/dnsmasq.conf
echo "address=/adg.open-wrt.tk/192.168.77.1" >> package/network/services/dnsmasq/files/dnsmasq.conf
# dnsmasq forwarder
sed -i '/option resolvfile/i\      option noresolv         0' package/network/services/dnsmasq/files/dhcp.conf
sed -i 's/option resolvfile/#option resolvfile/g' package/network/services/dnsmasq/files/dhcp.conf
sed -i "/#list server/i\	list server             '127.0.0.1#10053'" package/network/services/dnsmasq/files/dhcp.conf
sed -i "/#list server/c\	list server             '127.0.0.1#10054'" package/network/services/dnsmasq/files/dhcp.conf


## SmartDNS
mkdir -p feeds/packages/net/smartdns/files/etc/config/
mv ${GITHUB_WORKSPACE}/apps-custom-files/smartdns/files/etc/config/smartdns feeds/packages/net/smartdns/files/etc/config/
mkdir -p feeds/packages/net/smartdns/files/package/openwrt/files/etc/init.d/
mv ${GITHUB_WORKSPACE}/apps-custom-files/smartdns/files/etc/init.d/smartdnsprocd feeds/packages/net/smartdns/files/package/openwrt/files/etc/init.d/
mv ${GITHUB_WORKSPACE}/apps-custom-files/smartdns/files/address.conf feeds/packages/net/smartdns/files/
mv -f ${GITHUB_WORKSPACE}/apps-custom-files/smartdns/Makefile feeds/packages/net/smartdns/
# disable Rebind protection&&RBL checking and similar services
sed -i "s/option rebind_protection 1/option rebind_protection 0/g" package/network/services/dnsmasq/files/dhcp.conf
sed -i "s/option rebind_localhost 1/option rebind_localhost 0/g" package/network/services/dnsmasq/files/dhcp.conf


## Default Settings
mv ${GITHUB_WORKSPACE}/apps/default-settings package/apps/