#!/bin/bash


mkdir -p package/base-files/files/etc/openclash/
#mkdir -p package/custom/
#cp -rf ${GITHUB_WORKSPACE}/Applications/luci-app-openclash package/custom/luci-app-openclash
#get latest core
#bash ${GITHUB_WORKSPACE}/Modification/openclash/get_clash_core.sh amd64
bash ${GITHUB_WORKSPACE}/scripts/get_clash_core.sh amd64
cp -rf ${GITHUB_WORKSPACE}/diy/etc/openclash/* package/base-files/files/etc/openclash/
cp -rf ${GITHUB_WORKSPACE}/diy/etc/config/openclash package/community/other/luci-app-openclash/root/etc/config/

# dnsmasq forwarder
#sed -i '/option resolvfile/i\      option noresolv         0' package/network/services/dnsmasq/files/dhcp.conf
#sed -i 's/option resolvfile/#option resolvfile/g' package/network/services/dnsmasq/files/dhcp.conf
#sed -i "/#list server/i\    list server             '127.0.0.1#7874'" package/network/services/dnsmasq/files/dhcp.conf

#cp -rf ${GITHUB_WORKSPACE}/Applications/default-settings package/custom/default-settings

cp -rf ${GITHUB_WORKSPACE}/diy/etc/config/turboacc package/community/lean/luci-app-turboacc/root/etc/config/


mkdir -p package/base-files/files/etc/adguardhome/
bash ${GITHUB_WORKSPACE}/scripts/get_adguardhome_core.sh amd64
cp -rf ${GITHUB_WORKSPACE}/diy/etc/adguardhome/AdGuardHome.yaml package/base-files/files/etc/adguardhome/
cp -rf ${GITHUB_WORKSPACE}/diy/etc/config/AdGuardHome package/community/other/luci-app-adguardhome/root/etc/config/