#!/bin/bash


mkdir -p package/base-files/files/etc/openclash/
#mkdir -p package/custom/
#cp -rf ${GITHUB_WORKSPACE}/Applications/luci-app-openclash package/custom/luci-app-openclash
#get latest core
#bash ${GITHUB_WORKSPACE}/Modification/openclash/get_clash_core.sh amd64
bash ${GITHUB_WORKSPACE}/scripts/get_clash_core.sh amd64
rm -rf package/community/other/luci-app-openclash/root/etc/openclash/{china_ip6_route.ipset,china_ip_route.ipset,Country.mmdb}
mv -f ${GITHUB_WORKSPACE}/diy/etc/openclash/{china_ip6_route.ipset,china_ip_route.ipset,Country.mmdb} package/community/other/luci-app-openclash/root/etc/openclash/
cp -rf ${GITHUB_WORKSPACE}/diy/etc/openclash/* package/base-files/files/etc/openclash/
cp -rf ${GITHUB_WORKSPACE}/diy/etc/config/openclash package/community/other/luci-app-openclash/root/etc/config/
# 删除需要从Luci启动,
sed -i '/Need Start From Luci Page/d' package/community/other/luci-app-openclash/root/etc/init.d/openclash

# nodes
curl -o package/base-files/files/etc/openclash/config/basic.yaml https://pub-api-1.bianyuan.xyz/sub?target=clash&url=https%3A%2F%2Fraw.githubusercontent.com%2Fgit-yusteven%2Fopenit%2Fmain%2Flong&insert=false&config=https%3A%2F%2Fsubconverter.oss-ap-southeast-1.aliyuncs.com%2FRules%2FRemoteConfig%2Funiversal%2Furltest.ini&append_type=true&emoji=false&list=false&tfo=false&scv=false&fdn=true&sort=true&udp=true&new_name=true
cp -rf package/base-files/files/etc/openclash/config/basic.yaml package/base-files/files/etc/openclash/


#
#cp -rf ${GITHUB_WORKSPACE}/diy/etc/startup.sh package/base-files/files/etc/
#sed -i "s/exit 0/bash \/etc\/startup.sh/g" package/base-files/files/etc/rc.local
#echo "exit 0" >> package/base-files/files/etc/rc.local

# dnsmasq forwarder
#sed -i '/option resolvfile/i\      option noresolv         0' package/network/services/dnsmasq/files/dhcp.conf
#sed -i 's/option resolvfile/#option resolvfile/g' package/network/services/dnsmasq/files/dhcp.conf
#sed -i "/#list server/i\    list server             '127.0.0.1#7874'" package/network/services/dnsmasq/files/dhcp.conf

#cp -rf ${GITHUB_WORKSPACE}/Applications/default-settings package/custom/default-settings

cp -rf ${GITHUB_WORKSPACE}/diy/etc/config/turboacc package/community/lean/luci-app-turboacc/root/etc/config/
cp -rf ${GITHUB_WORKSPACE}/diy/etc/startup_fullcone.sh package/base-files/files/etc/
sed -i "s/exit 0/bash \/etc\/startup_fullcone.sh/g" package/base-files/files/etc/rc.local

# homeassistant id
#cp -rf ${GITHUB_WORKSPACE}/diy/etc/homeassistant.sh package/base-files/files/etc/
#echo "bash /etc/homeassistant.sh" package/base-files/files/etc/rc.local
sed -i 's/VERSION_ID="%v"/VERSION_ID="18.06"/g' package/base-files/files/usr/lib/os-release

echo "exit 0" >> package/base-files/files/etc/rc.local



mkdir -p package/base-files/files/etc/adguardhome/
bash ${GITHUB_WORKSPACE}/scripts/get_adguardhome_core.sh amd64
cp -rf ${GITHUB_WORKSPACE}/diy/etc/adguardhome/AdGuardHome.yaml package/base-files/files/etc/adguardhome/
cp -rf ${GITHUB_WORKSPACE}/diy/etc/config/AdGuardHome package/community/other/luci-app-adguardhome/root/etc/config/


## SmartDNS
if [ `grep -c 'luci-app-smartdns=y' .config` -ne '0' ]; then
    mkdir -p feeds/packages/net/smartdns/files/etc/config/
    cp -rf ${GITHUB_WORKSPACE}/diy/etc/config/smartdns feeds/packages/net/smartdns/files/etc/config/
    mkdir -p feeds/packages/net/smartdns/files/etc/init.d/
    cp -rf ${GITHUB_WORKSPACE}/diy/smartdns/init.d/smartdnsprocd feeds/packages/net/smartdns/files/etc/init.d/
    cp -rf ${GITHUB_WORKSPACE}/diy/smartdns/Makefile feeds/packages/net/smartdns/
    # disable Rebind protection&&RBL checking and similar services
    sed -i "s/option rebind_protection 1/option rebind_protection 0/g" package/network/services/dnsmasq/files/dhcp.conf
    sed -i "s/option rebind_localhost 1/option rebind_localhost 0/g" package/network/services/dnsmasq/files/dhcp.conf
    echo "SmartDNS configuration complete!"
else
    echo "SmartDNS is not set yet"
fi


## passwall
# geoip.dat https://github.com/v2fly/geoip/releases
# geosite.dat https://github.com/Loyalsoldier/v2ray-rules-dat/releases
if [ `grep -c 'luci-app-passwall=y' .config` -ne '0' ]; then
    cp -rf ${GITHUB_WORKSPACE}/diy/passwall/Makefile package/community/lienol/luci-app-passwall/
    cp -rf ${GITHUB_WORKSPACE}/diy/usr/share/xray package/community/lienol/luci-app-passwall/root/usr/share/
    echo "PassWall configuration complete!"
else
    echo "PassWall is not set yet"
fi

## dnscrypt-proxy
sed -i 's/5353/7053/g' feeds/packages/net/dnscrypt-proxy/files/dnscrypt-proxy.config