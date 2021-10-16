#!/bin/bash


## use O2 optimization
sed -i 's/Os/O2/g' include/target.mk
sed -i 's/O2/O2/g' rules.mk


## remove show SNAPSHOT tags
sed -i 's,SNAPSHOT,,g' include/version.mk
sed -i 's,snapshots,,g' package/base-files/image-config.in
sed -i 's/ %V,//g' package/base-files/files/etc/banner


## Modify the maximum number of Active Connections
sed -i 's/16384/65536/g' package/kernel/linux/files/sysctl-nf-conntrack.conf


## Remove status show model
sed -i '55d' feeds/luci/modules/luci-mod-status/htdocs/luci-static/resources/view/status/include/10_system.js


## TCP Fast Open(TFO)
# reference 1: https://wiki.archlinux.org/index.php/sysctl
# reference 2: https://www.keycdn.com/support/tcp-fast-open
cp -rf ${GITHUB_WORKSPACE}/Modification/base-files/etc/sysctl.d/60_tcp_fastopen.conf package/base-files/files/etc/sysctl.d/


## custom compile information
sed -i '/DISTRIB_DESCRIPTION/d' package/base-files/files/etc/openwrt_release
sed -i "$ a\DISTRIB_DESCRIPTION='Built by Infsr($(date +%Y.%m.%d))@%D %V %C'" package/base-files/files/etc/openwrt_release
sed -i '/%D/a\ Infsr Build' package/base-files/files/etc/banner


## Crypto algorithm support kernel
# reference 1: https://en.wikipedia.org/wiki/Salsa20
# reference 2: https://tools.ietf.org/html/rfc7539
if [ `grep -c 'CONFIG_LINUX_5_4=y' .config` -ne '0' ]; then
	echo '
	CONFIG_CRYPTO_CHACHA20_X86_64=y
	CONFIG_CRYPTO_POLY1305_X86_64=y
	' >> ./target/linux/x86/64/config-5.4
	echo "Crypto algorithm support kernel 5.4, done"
elif [ `grep -c 'CONFIG_LINUX_5_10=y' .config` -ne '0' ]; then
	echo '
	CONFIG_CRYPTO_CHACHA20_X86_64=y
	CONFIG_CRYPTO_POLY1305_X86_64=y
	' >> ./target/linux/x86/64/config-5.10
	echo "Crypto algorithm support kernel 5.10, done"
else
	echo "Crypto algorithm support kernel done"
fi