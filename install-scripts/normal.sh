#!/bin/bash



## remove show SNAPSHOT tags
sed -i 's,SNAPSHOT,,g' include/version.mk
sed -i 's,snapshots,,g' package/base-files/image-config.in
sed -i 's/ %V,//g' package/base-files/files/etc/banner


## use O2 optimization
sed -i 's/Os/O2/g' include/target.mk
sed -i 's/O2/O2/g' ./rules.mk


## Modify default IP
sed -i 's/192.168.1.1/192.168.77.1/g' package/base-files/files/bin/config_generate


## Modify default hostname
sed -i "s/OpenWrt/x86/g" package/base-files/files/bin/config_generate


## Modify Time zone
sed -i "s/'UTC'/'CST-8'\n   set system.@system[-1].zonename='Asia\/Shanghai'/g" package/base-files/files/bin/config_generate


## Modify default password (password)
sed -i 's/root::0:0:99999:7:::/root:$1$V4UetPzk$CYXluq4wUazHjmCDBCqXF.:0:0:99999:7:::/g' package/base-files/files/etc/shadow


## Modify the maximum number of Active Connections
sed -i 's/16384/65536/g' package/kernel/linux/files/sysctl-nf-conntrack.conf


## Crypto algorithm support kernel-5.4
# reference 1: https://en.wikipedia.org/wiki/Salsa20
# reference 2: https://tools.ietf.org/html/rfc7539
echo '
CONFIG_CRYPTO_CHACHA20_X86_64=y
CONFIG_CRYPTO_POLY1305_X86_64=y
' >> ./target/linux/x86/64/config-5.4