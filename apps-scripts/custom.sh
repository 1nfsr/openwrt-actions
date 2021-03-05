#!/bin/bash



## Revert miniupnpd version(2.0)
rm -Rf feeds/packages/net/miniupnpd
mv ${GITHUB_WORKSPACE}/apps/miniupnpd feeds/packages/net/


## Docker
sed -i 's/+docker/+docker +dockerd/g' feeds/luci/applications/luci-app-dockerman/Makefile


## Turboacc
mv ${GITHUB_WORKSPACE}/apps/luci-app-turboacc package/apps/
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