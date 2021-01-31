#!/bin/bash


#移除SNAPSHOT标签
sed -i 's,SNAPSHOT,,g' include/version.mk
sed -i 's,snapshots,,g' package/base-files/image-config.in
sed -i 's/ %V,//g' package/base-files/files/etc/banner

#使用O2级别的优化
sed -i 's/Os/O2/g' include/target.mk
sed -i 's/O2/O2/g' ./rules.mk

#修改IP
sed -i 's/192.168.1.1/192.168.77.1/g' package/base-files/files/bin/config_generate

#修改机器名称
sed -i "s/OpenWrt/x86/g" package/base-files/files/bin/config_generate

#修改时区
sed -i "s/'UTC'/'CST-8'\n   set system.@system[-1].zonename='Asia\/Shanghai'/g" package/base-files/files/bin/config_generate

#添加密码 password
sed -i 's/root::0:0:99999:7:::/root:$1$V4UetPzk$CYXluq4wUazHjmCDBCqXF.:0:0:99999:7:::/g' package/base-files/files/etc/shadow

#修改最大连接数
sed -i 's/16384/65536/g' package/kernel/linux/files/sysctl-nf-conntrack.conf

#自定义编译信息
sed -i '/DISTRIB_DESCRIPTION/d' package/base-files/files/etc/openwrt_release
sed -i "$ a\DISTRIB_DESCRIPTION='Built by Infsr($(date +%Y.%m.%d))@%D %V %C'" package/base-files/files/etc/openwrt_release
sed -i '/%D/a\ Infsr Build' package/base-files/files/etc/banner