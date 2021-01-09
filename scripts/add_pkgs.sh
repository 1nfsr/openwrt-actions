#!/bin/bash




echo '修改banner'
rm -rf package/base-files/files/etc/banner
cp -f ../banner package/base-files/files/etc/

echo '下载ServerChan'
git clone https://github.com/tty228/luci-app-serverchan ../diy/luci-app-serverchan

echo '下载AdGuard Home'
svn co https://github.com/Lienol/openwrt/trunk/package/diy/luci-app-adguardhome ../diy/luci-app-adguardhome
svn co https://github.com/Lienol/openwrt/trunk/package/diy/adguardhome ../diy/luci-app-adguardhome

echo 'JD script'
git clone https://github.com/Cathgao/luci-app-jd-dailybonus ../diy/luci-app-jd-dailybonus

echo '集成diy目录'
ln -s ../../diy ./package/openwrt-packages

echo '首页增加CPU频率动态显示'
cp -f ../diy/mod-index.htm ./feeds/luci/modules/luci-mod-admin-full/luasrc/view/admin_status/index.htm
