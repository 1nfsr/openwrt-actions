#!/bin/bash


## use O2 optimization
sed -i 's/Os/O2/g' include/target.mk
sed -i 's/O2/O2/g' rules.mk


## remove show SNAPSHOT tags
sed -i 's,SNAPSHOT,,g' include/version.mk
sed -i 's,snapshots,,g' package/base-files/image-config.in
sed -i 's/ %V,//g' package/base-files/files/etc/banner


## TCP Fast Open(TFO)
# reference 1: https://wiki.archlinux.org/index.php/sysctl
# reference 2: https://www.keycdn.com/support/tcp-fast-open
cp -rf ${GITHUB_WORKSPACE}/Modification/base-files/etc/sysctl.d/60_tcp_fastopen.conf package/base-files/files/etc/sysctl.d/


## custom compile information
#sed -i '/DISTRIB_DESCRIPTION/d' package/base-files/files/etc/openwrt_release
#sed -i "$ a\DISTRIB_DESCRIPTION='Built by Infsr($(date +%Y.%m.%d))@%D %V %C'" package/base-files/files/etc/openwrt_release
#sed -i '/%D/a\ Infsr Build' package/base-files/files/etc/banner


## delete&&swap package
rm -rf package/lean
mv ${GITHUB_WORKSPACE}/community package/


## swap shells
sed -i 's/ash/bash/g' package/base-files/files/etc/passwd


## swap theme
sed -i 's/luci-theme-bootstrap/luci-theme-atmaterial_new/g' feeds/luci/collections/luci/Makefile


## delete others app
rm -rf feeds/luci/applications/luci-app-wol
rm -rf feeds/luci/modules/luci-newapi


## support homeassistant id
sed -i 's/VERSION_ID="%v"/VERSION_ID="18.06"/g' package/base-files/files/usr/lib/os-release