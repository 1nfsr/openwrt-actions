#!/bin/bash

# 添加证书
mkdir -p package/base-files/files/etc/nginx
cp -rf ${GITHUB_WORKSPACE}/etc/nginx/conf.d package/base-files/files/etc/nginx/

# 开启root登陆
mkdir -p package/base-files/files/etc/ssh
cp -rf ${GITHUB_WORKSPACE}/etc/ssh/sshd_config package/base-files/files/etc/ssh/

# 添加公钥
mkdir -p package/base-files/files/root/.ssh
cp -rf ${GITHUB_WORKSPACE}/root/.ssh/* package/base-files/files/root/.ssh/

# 添加 Adguardhome配置文件
cp -rf ${GITHUB_WORKSPACE}/etc/AdGuardHome.yaml package/base-files/files/etc/

# 添加 local apps
mkdir -p package/apps
rm -rf ${GITHUB_WORKSPACE}/apps/luci-app-openclash
mv ${GITHUB_WORKSPACE}/apps/* package/apps/

# 添加 AdguardHome
git clone --depth=1 https://github.com/kongfl888/luci-app-adguardhome package/apps/luci-app-adguardhome

# custom AdguardHome
rm -rf package/apps/luci-app-adguardhome/luasrc/controller/AdGuardHome.lua
mv ${GITHUB_WORKSPACE}/custom/adguardhome/luasrc/controller/AdGuardHome.lua package/apps/luci-app-adguardhome/luasrc/controller/
rm -rf package/apps/luci-app-adguardhome/root/etc/config/AdGuardHome
mv ${GITHUB_WORKSPACE}/custom/adguardhome/root/etc/config/AdGuardHome package/apps/luci-app-adguardhome/root/etc/config/

# 添加 openclash
svn co https://github.com/vernesong/OpenClash/trunk/luci-app-openclash package/apps/luci-app-openclash

# 添加 clash ui面板
mkdir -p package/base-files/files/www
mv ${GITHUB_WORKSPACE}/www/clash-ui package/base-files/files/www/
sed -i 's/127.0.0.1/192.168.77.1/g' package/base-files/files/www/clash-ui/app.6706b8885424994ac6fe.js
sed -i 's/secret:""/secret:"123456"/g' package/base-files/files/www/clash-ui/app.6706b8885424994ac6fe.js
sed -i 's/127.0.0.1/192.168.77.1/g' package/base-files/files/www/clash-ui/index.html


# custom clash
rm -rf package/apps/luci-app-openclash/root/etc/config/openclash
mv ${GITHUB_WORKSPACE}/custom/openclash/root/etc/config/openclash package/apps/luci-app-openclash/root/etc/config/
rm -rf package/apps/luci-app-openclash/root/etc/openclash/custom/openclash_custom_rules_2.list
mv ${GITHUB_WORKSPACE}/custom/openclash/root/etc/openclash/custom/openclash_custom_rules_2.list package/apps/luci-app-openclash/root/etc/openclash/custom/

rm -rf package/apps/luci-app-openclash/root/usr/share/openclash/dashboard
rm -rf package/apps/luci-app-openclash/root/usr/share/openclash/yacd

rm -rf package/apps/luci-app-openclash/luasrc/model/cbi/openclash/settings.lua
mv ${GITHUB_WORKSPACE}/custom/openclash/luasrc/model/cbi/openclash/settings.lua package/apps/luci-app-openclash/luasrc/model/cbi/openclash/
rm -rf package/apps/luci-app-openclash/luasrc/view/openclash/status.htm
mv ${GITHUB_WORKSPACE}/custom/openclash/luasrc/view/openclash/status.htm package/apps/luci-app-openclash/luasrc/view/openclash/
rm -rf package/apps/luci-app-openclash/root/etc/init.d/openclash
mv ${GITHUB_WORKSPACE}/custom/openclash/root/etc/init.d/openclash package/apps/luci-app-openclash/root/etc/init.d/
rm -rf package/apps/luci-app-openclash/root/usr/share/openclash/yml_change.sh
mv ${GITHUB_WORKSPACE}/custom/openclash/root/usr/share/openclash/yml_change.sh package/apps/luci-app-openclash/root/usr/share/openclash/


# 添加 ohmyzsh
mkdir -p package/base-files/files/etc/ohmyzsh
mkdir -p package/base-files/files/home/infsr
cp -rf ${GITHUB_WORKSPACE}/etc/ohmyzsh package/base-files/files/etc/
cp -rf ${GITHUB_WORKSPACE}/home/infsr/.zshrc package/base-files/files/home/infsr/
cp -rf ${GITHUB_WORKSPACE}/root/.zshrc package/base-files/files/root/

# 开启tcp fastopen
cp -rf ${GITHUB_WORKSPACE}/etc/sysctl.d/60_tcp_fastopen.conf package/base-files/files/etc/sysctl.d/

# afp
mkdir -p package/base-files/files/etc/avahi/services
cp -rf ${GITHUB_WORKSPACE}/etc/avahi/* package/base-files/files/etc/avahi/
cp -rf ${GITHUB_WORKSPACE}/etc/afp.conf package/base-files/files/etc/
cp -rf ${GITHUB_WORKSPACE}/etc/extmap.conf package/base-files/files/etc/

# 添加 r8168驱动
git clone https://github.com/BROBIRD/openwrt-r8168 package/apps/openwrt-r8168

# Docker
sed -i 's/+docker/+docker +dockerd/g' feeds/luci/applications/luci-app-dockerman/Makefile

# 移除首页Model
sed -i '55d' feeds/luci/modules/luci-mod-status/htdocs/luci-static/resources/view/status/include/10_system.js

# 添加 fullconenat
#svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/openwrt-fullconenat package/apps/fullconenat

# Turboacc
rm -rf package/apps/luci-app-turboacc/root/etc/init.d/turboacc
mv $GITHUB_WORKSPACE/custom/turboacc/root/etc/init.d/turboacc package/apps/luci-app-turboacc/root/etc/init.d/

# patch firewall support fullconenat
mkdir package/network/config/firewall/patches
wget -O package/network/config/firewall/patches/fullconenat.patch https://github.com/coolsnowwolf/lede/raw/master/package/network/config/firewall/patches/fullconenat.patch

mv $GITHUB_WORKSPACE/PATCH/remove_firewall_view_offload.patch ./
patch -p1 < remove_firewall_view_offload.patch


# patch
mv $GITHUB_WORKSPACE/PATCH/* ./

patch -p1 < use_json_object_new_int64.patch
patch -p1 < dnsmasq-add-filter-aaaa-option.patch
patch -p1 < luci-add-filter-aaaa-option.patch
cp -f 910-mini-ttl.patch package/network/services/dnsmasq/patches/
cp -f 911-dnsmasq-filter-aaaa.patch package/network/services/dnsmasq/patches/

cp -rf hack-5.4/* target/linux/generic/hack-5.4/

echo '
CONFIG_CRYPTO_CHACHA20_X86_64=y
CONFIG_CRYPTO_POLY1305_X86_64=y
' >> ./target/linux/x86/64/config-5.4

#fix
rm -rf feeds/packages/utils/bash
svn co https://github.com/coolsnowwolf/packages/trunk/utils/bash feeds/packages/utils/bash