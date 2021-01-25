#!/bin/bash

# 修改默认IP
sed -i 's/192.168.1.1/192.168.77.1/g' package/base-files/files/bin/config_generate

# 添加密码 password
sed -i 's/root::0:0:99999:7:::/root:$1$V4UetPzk$CYXluq4wUazHjmCDBCqXF.:0:0:99999:7:::/g' package/base-files/files/etc/shadow

# 创建apps文件夹
mkdir -p package/apps

# 添加 AdguardHome
git clone --depth=1 https://github.com/kongfl888/luci-app-adguardhome package/apps/luci-app-adguardhome

# 添加 openclash
svn co https://github.com/vernesong/OpenClash/trunk/luci-app-openclash package/apps/luci-app-openclash
