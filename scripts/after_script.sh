#!/bin/bash



#################### Openclash Start ####################
if [ `grep -c 'luci-app-openclash=y' .config` -ne '0' ]; then
	## create folder
	mkdir -p package/base-files/files/etc/openclash/
	## get latest core
	bash ${GITHUB_WORKSPACE}/scripts/get_clash_core.sh amd64
	## ip data
	rm -rf package/community/other/luci-app-openclash/root/etc/openclash/{china_ip6_route.ipset,china_ip_route.ipset,Country.mmdb}
	cp -rf ${GITHUB_WORKSPACE}/Modification/OpenClash/etc/openclash/{china_ip6_route.ipset,china_ip_route.ipset,Country.mmdb} package/community/other/luci-app-openclash/root/etc/openclash/
	#copy node config && update node config(niaoyun.me)
	mkdir -p package/base-files/files/etc/openclash/config
	cp -rf ${GITHUB_WORKSPACE}/Modification/OpenClash/etc/openclash/basic.yaml package/base-files/files/etc/openclash/
	cp -rf package/base-files/files/etc/openclash/basic.yaml package/base-files/files/etc/openclash/config/
	#curl -o package/base-files/files/etc/openclash/basic.yaml https://api-suc.0z.gs/sub?target=clash&url=https%3A%2F%2Fniaocloud-rss.com%2Flink%2Fh2GeM24DKdpdRlyZ%3Fsub%3D3&insert=false&config=https%3A%2F%2Fcdn.jsdelivr.net%2Fgh%2FSleepyHeeead%2Fsubconverter-config%40master%2Fremote-config%2Funiversal%2Furltest.ini&append_type=true&emoji=false&list=false&tfo=false&scv=false&fdn=true&sort=true&udp=true&new_name=true
	#cp -rf package/base-files/files/etc/openclash/basic.yaml package/base-files/files/etc/openclash/config/
    ## custom
    cp -rf ${GITHUB_WORKSPACE}/Modification/OpenClash/etc/config/openclash package/community/other/luci-app-openclash/root/etc/config/
    echo "OpenClash configuration complete!"
else
    echo "OpenClash is not set yet!"
fi
#################### Openclash End ####################


#################### AdguardHome Start ####################
if [ `grep -c 'luci-app-adguardhome=y' .config` -ne '0' ]; then
	## create folder
	mkdir -p package/base-files/files/etc/adguardhome/
	## get latest core
	bash ${GITHUB_WORKSPACE}/scripts/get_adguardhome_core.sh amd64
	## copy config
	cp -rf ${GITHUB_WORKSPACE}/Modification/AdGuardHome/etc/adguardhome/AdGuardHome.yaml package/base-files/files/etc/adguardhome/
	## custom
	cp -rf ${GITHUB_WORKSPACE}/Modification/AdGuardHome/etc/config/AdGuardHome package/community/other/luci-app-adguardhome/root/etc/config/
	echo "AdguardHome configuration complete!"
else 
	echo "AdguardHome is not set yet!"
fi
#################### AdguardHome End ####################


#################### SmartDNS Start ####################
if [ `grep -c 'luci-app-smartdns=y' .config` -ne '0' ]; then
	## create folder
	mkdir -p feeds/packages/net/smartdns/files/etc/config/
	## custom
	cp -rf ${GITHUB_WORKSPACE}/Modification/SmartDNS/etc/config/smartdns feeds/packages/net/smartdns/files/etc/config/
	## create folder
	mkdir -p feeds/packages/net/smartdns/files/etc/init.d/
	## custom daemon
	cp -rf ${GITHUB_WORKSPACE}/Modification/SmartDNS/etc/init.d/smartdnsprocd feeds/packages/net/smartdns/files/etc/init.d/
	## custom Makefiles
	cp -rf ${GITHUB_WORKSPACE}/Modification/SmartDNS/Makefile feeds/packages/net/smartdns/
	## disable Rebind protection&&RBL checking and similar services
	sed -i "s/option rebind_protection 1/option rebind_protection 0/g" package/network/services/dnsmasq/files/dhcp.conf
    sed -i "s/option rebind_localhost 1/option rebind_localhost 0/g" package/network/services/dnsmasq/files/dhcp.conf
	echo "SmartDNS configuration complete!"
else 
	echo "SmartDNS is not set yet!"
fi
#################### SmartDNS End ####################


#################### Turboacc Start ####################
if [ `grep -c 'luci-app-turboacc=y' .config` -ne '0' ]; then
	## custom
	cp -rf ${GITHUB_WORKSPACE}/Modification/Turboacc/etc/config/turboacc package/community/lean/luci-app-turboacc/root/etc/config/
	echo "Turboacc configuration complete!"
else 
	echo "Turboacc is not set yet!"
fi
#################### Turboacc End ####################


#################### PassWall Start ####################
if [ `grep -c 'luci-app-passwall=y' .config` -ne '0' ]; then
# geoip.dat https://github.com/v2fly/geoip/releases
# geosite.dat https://github.com/Loyalsoldier/v2ray-rules-dat/releases
	## custom Makefiles
	cp -rf ${GITHUB_WORKSPACE}/Modification/PassWall/Makefile package/community/lienol/luci-app-passwall/
	## ip data
	cp -rf ${GITHUB_WORKSPACE}/Modification/PassWall/usr/share/v2ray package/community/lienol/luci-app-passwall/root/usr/share/
	echo "PassWall configuration complete!"
else 
	echo "PassWall is not set yet!"
fi
#################### PassWall End ####################


#################### DNScrypt Proxy Start ####################
if [ `grep -c 'luci-app-dnscrypt-proxy=y' .config` -ne '0' ]; then
	## change port
	sed -i 's/5353/7053/g' feeds/packages/net/dnscrypt-proxy/files/dnscrypt-proxy.config
	## custom
	cp -rf ${GITHUB_WORKSPACE}/Modification/DNScrypt-Proxy/usr/share/dnscrypt-proxy/dnscrypt-resolvers.csv feeds/packages/net/dnscrypt-proxy/files/
	echo "DNScrypt Proxy configuration complete!"
else 
	echo "DNScrypt Proxy is not set yet!"
fi
#################### DNScrypt Proxy End ####################


#################### MosDNS Start ####################
if [ `grep -c 'luci-app-mosdns=y' .config` -ne '0' ]; then
	## custom
	cp -rf ${GITHUB_WORKSPACE}/Modification/MosDNS/etc/config/mosdns package/community/other/luci-app-mosdns/root/etc/config/
	echo "MosDNS configuration complete!"
else 
	echo "MosDNS is not set yet!"
fi
#################### MosDNS End ####################


#################### Startup Assist Start ####################
cp -rf ${GITHUB_WORKSPACE}/Modification/base-files/etc/startup-assist.sh package/base-files/files/etc/
sed -i "s/exit 0/bash \/etc\/startup-assist.sh/g" package/base-files/files/etc/rc.local
echo "exit 0" >> package/base-files/files/etc/rc.local
echo "Startup Assist configuration complete!"
#################### Startup Assist End ####################