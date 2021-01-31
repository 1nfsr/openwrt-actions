#!/bin/bash

# 添加证书
mkdir -p package/base-files/files/etc/nginx
cp -rf ${GITHUB_WORKSPACE}/etc/nginx/conf.d package/base-files/files/etc/nginx/

# 开启root登陆
mkdir -p package/base-files/files/etc/ssh
cp -rf ${GITHUB_WORKSPACE}/etc/ssh/sshd_config package/base-files/files/etc/ssh/

# 添加公钥
mkdir -p package/base-files/files/root
cp -rf ${GITHUB_WORKSPACE}/root/* package/base-files/files/root/

# 添加 Adguardhome配置文件
cp -rf ${GITHUB_WORKSPACE}/etc/AdGuardHome.yaml package/base-files/files/etc/

# 添加 AdguardHome
mkdir -p package/apps
git clone --depth=1 https://github.com/kongfl888/luci-app-adguardhome package/apps/luci-app-adguardhome

# 添加 openclash
svn co https://github.com/vernesong/OpenClash/trunk/luci-app-openclash package/apps/luci-app-openclash

# 添加 r8168驱动
git clone https://github.com/BROBIRD/openwrt-r8168 package/apps/openwrt-r8168

# Docker
sed -i 's/+docker/+docker +dockerd/g' feeds/luci/applications/luci-app-dockerman/Makefile

# 移除首页Model
sed '55d' feeds/luci/modules/luci-mod-status/htdocs/luci-static/resources/view/status/include/10_system.js