#!/bin/bash
#=================================================

echo '修改网关地址'
sed -i 's/192.168.1.1/192.168.77.1/g' package/base-files/files/bin/config_generate

echo '修改机器名称'
sed -i 's/OpenWrt/x86/g' package/base-files/files/bin/config_generate

echo '修改时区'
sed -i "s/'UTC'/'CST-8'\n        set system.@system[-1].zonename='Asia\/Shanghai'/g" package/base-files/files/bin/config_generate

echo '设置密码'
sed -i 's/root::0:0:99999:7:::/root:$1$V4UetPzk$CYXluq4wUazHjmCDBCqXF.:0:0:99999:7:::/g' package/base-files/files/etc/shadow


sed -i '/DISTRIB_REVISION/d' package/base-files/files/etc/openwrt_release
echo "DISTRIB_REVISION='19.07'" >> package/base-files/files/etc/openwrt_release
sed -i '/DISTRIB_DESCRIPTION/d' package/base-files/files/etc/openwrt_release
echo "DISTRIB_DESCRIPTION='Infsr build $(TZ=UTC-8 date "+%Y.%m.%d") @ OpenWrt '" >> package/base-files/files/etc/openwrt_release