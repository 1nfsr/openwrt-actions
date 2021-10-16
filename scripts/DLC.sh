#!/bin/bash


mkdir -p package/custom/
cp -rf ${GITHUB_WORKSPACE}/Applications/luci-app-openclash package/custom/luci-app-openclash
#get latest core
bash ${GITHUB_WORKSPACE}/Modification/openclash/get_clash_core.sh amd64

# dnsmasq forwarder
#sed -i '/option resolvfile/i\      option noresolv         0' package/network/services/dnsmasq/files/dhcp.conf
#sed -i 's/option resolvfile/#option resolvfile/g' package/network/services/dnsmasq/files/dhcp.conf
#sed -i "/#list server/i\    list server             '127.0.0.1#7874'" package/network/services/dnsmasq/files/dhcp.conf

cp -rf ${GITHUB_WORKSPACE}/Applications/default-settings package/custom/default-settings