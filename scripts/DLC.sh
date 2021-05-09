#!/bin/bash


cp -r ${GITHUB_WORKSPACE}/DLC package/


## Adguardhome
if [ `grep -c 'luci-app-adguardhome=y' .config` -ne '0' ]; then
	# AdguardHome config
	cp -rf ${GITHUB_WORKSPACE}/Modification/adguardhome/luasrc/model/cbi/AdGuardHome/base.lua package/DLC/luci-app-adguardhome/luasrc/model/cbi/AdGuardHome/
	cp -rf ${GITHUB_WORKSPACE}/Modification/adguardhome/AdGuardHome.yaml package/base-files/files/etc/config/
	cp -rf ${GITHUB_WORKSPACE}/Modification/adguardhome/root/etc/init.d/AdGuardHome package/DLC/luci-app-adguardhome/root/etc/init.d/
	# custom AdguardHome
	cp -rf ${GITHUB_WORKSPACE}/Modification/adguardhome/luasrc/controller/AdGuardHome.lua package/DLC/luci-app-adguardhome/luasrc/controller/
	cp -rf ${GITHUB_WORKSPACE}/Modification/adguardhome/root/etc/config/AdGuardHome package/DLC/luci-app-adguardhome/root/etc/config/
	# Firewall Rules
	echo "iptables -t nat -A PREROUTING -p udp --dport 53 -j REDIRECT --to-ports 53" >> package/network/config/firewall/files/firewall.user
	echo "iptables -t nat -A PREROUTING -p tcp --dport 53 -j REDIRECT --to-ports 53" >> package/network/config/firewall/files/firewall.user
	#get latest core
	bash ${GITHUB_WORKSPACE}/Modification/adguardhome/get_adguardhome_core.sh amd64
	echo "Adguardhome configuration complete!"
else
	echo "Adguardhome is not set yet"
fi


## Openclash
if [ `grep -c 'luci-app-openclash=y' .config` -ne '0' ]; then
	#get latest core
	bash ${GITHUB_WORKSPACE}/Modification/openclash/get_clash_core.sh amd64
	echo "Openclash configuration complete!"
else
	echo "Openclash is not set yet"
fi


## Turboacc
if [ `grep -c 'luci-app-turboacc=y' .config` -ne '0' ]; then
	# Patch firewall support fullconenat
	mkdir package/network/config/firewall/patches
	cp -rf ${GITHUB_WORKSPACE}/Modification/turboacc/patch/fullconenat.patch package/network/config/firewall/patches/
	patch -p1 < ${GITHUB_WORKSPACE}/Modification/turboacc/patch/001-remove_firewall_view_offload.patch
	patch -p1 < ${GITHUB_WORKSPACE}/Modification/turboacc/patch/002-remove_turboacc_dns_acc.patch
	# Fix conntrack events patch netfilter
	cp -rf ${GITHUB_WORKSPACE}/Modification/turboacc/patch/952-net-conntrack-events-support-multiple-registrant.patch target/linux/generic/hack-5.4/
	# Implementation of RFC3489-compatible full cone SNAT
	echo "iptables -t nat -A POSTROUTING -o eth1 -j FULLCONENAT" >> package/network/config/firewall/files/firewall.user
	echo "iptables -t nat -A PREROUTING -i eth1 -j FULLCONENAT" >> package/network/config/firewall/files/firewall.user
	echo "Turboacc configuration complete!"
else
	echo "Turboacc is not set yet"
fi