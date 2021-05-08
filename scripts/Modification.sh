#!/bin/bash


## Nginx
mkdir -p package/base-files/files/etc/nginx
cp -rf ${GITHUB_WORKSPACE}/Modification/nginx/conf.d package/base-files/files/etc/nginx/
mkdir -p package/base-files/files/etc/uwsgi/vassals
cp -rf ${GITHUB_WORKSPACE}/Modification/uwsgi/vassals/mysite.ini package/base-files/files/etc/uwsgi/vassals/
# custom config
sed -i 's/true/false/g' feeds/packages/net/nginx-util/files/nginx.config
cp -rf ${GITHUB_WORKSPACE}/Modification/nginx/nginx.conf package/base-files/files/etc/nginx/


## SmartDNS
if [ `grep -c 'luci-app-smartdns=y' config` -ne '0' ]; then
	mkdir -p feeds/packages/net/smartdns/files/etc/config/
	cp -rf ${GITHUB_WORKSPACE}/Modification/smartdns/config/smartdns feeds/packages/net/smartdns/files/etc/config/
	mkdir -p feeds/packages/net/smartdns/files/package/openwrt/files/etc/init.d/
	mv ${GITHUB_WORKSPACE}/Modification/smartdns/init.d/smartdnsprocd feeds/packages/net/smartdns/files/package/openwrt/files/etc/init.d/
	sed -i '/init.d\/smartdns/a\    $(INSTALL_BIN) .\/files\/package\/openwrt\/files\/etc\/init.d\/smartdnsprocd $(1)\/etc\/init.d\/smartdnsprocd' feeds/packages/net/smartdns/Makefile
	# disable Rebind protection&&RBL checking and similar services
	sed -i "s/option rebind_protection 1/option rebind_protection 0/g" package/network/services/dnsmasq/files/dhcp.conf
	sed -i "s/option rebind_localhost 1/option rebind_localhost 0/g" package/network/services/dnsmasq/files/dhcp.conf
else
	echo "SmartDNS is not set yet"
fi
