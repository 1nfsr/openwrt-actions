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

# 添加 AdguardHome
mkdir -p package/apps
git clone --depth=1 https://github.com/kongfl888/luci-app-adguardhome package/apps/luci-app-adguardhome

# 添加 openclash
svn co https://github.com/vernesong/OpenClash/trunk/luci-app-openclash package/apps/luci-app-openclash

# 添加 clash ui面板
mkdir -p package/base-files/files/www
cp -rf ${GITHUB_WORKSPACE}/www/clash-ui package/base-files/files/www/

# custom clash
rm package/apps/luci-app-openclash/root/etc/config/openclash
cp ${GITHUB_WORKSPACE}/custom/openclash/root/etc/config/openclash package/apps/luci-app-openclash/root/etc/config/
rm package/apps/luci-app-openclash/root/etc/openclash/custom/openclash_custom_rules_2.list
cp ${GITHUB_WORKSPACE}/custom/openclash/root/etc/openclash/custom/openclash_custom_rules_2.list package/apps/luci-app-openclash/root/etc/openclash/custom/

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

# patch firewall support fullconenat
mkdir package/network/config/firewall/patches
wget -O package/network/config/firewall/patches/fullconenat.patch https://github.com/coolsnowwolf/lede/raw/master/package/network/config/firewall/patches/fullconenat.patch

mv $GITHUB_WORKSPACE/PATCH/remove_firewall_view_offload.patch ./
patch -p1 < remove_firewall_view_offload.patch


# 添加 local apps

mv ${GITHUB_WORKSPACE}/apps/* package/apps/

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

# Add kernel build user
[ -z $(grep "CONFIG_KERNEL_BUILD_USER=" .config) ] &&
    echo 'CONFIG_KERNEL_BUILD_USER="Infsr"' >>.config ||
    sed -i 's@\(CONFIG_KERNEL_BUILD_USER=\).*@\1$"Infsr"@' .config

# Add kernel build domain
[ -z $(grep "CONFIG_KERNEL_BUILD_DOMAIN=" .config) ] &&
    echo 'CONFIG_KERNEL_BUILD_DOMAIN="GitHub Actions"' >>.config ||
    sed -i 's@\(CONFIG_KERNEL_BUILD_DOMAIN=\).*@\1$"GitHub Actions"@' .config