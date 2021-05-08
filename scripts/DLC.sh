#!/bin/bash


cp -r ${GITHUB_WORKSPACE}/DLC package/


## Adguardhome
if [ `grep -c 'luci-app-adguardhome=y' .config` -ne '0' ]; then
	echo "Adguardhome configuration complete!"
else
	echo "Adguardhome is not set yet"
fi


## Openclash
if [ `grep -c 'luci-app-openclash=y' .config` -ne '0' ]; then
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