#!/bin/bash


git clone -b main --depth 1 https://github.com/1nfsr/openwrt.git openwrt_master
rm -f ./openwrt_master/feeds.conf.default
wget -P openwrt_master/ https://raw.githubusercontent.com/openwrt/openwrt/openwrt-19.07/feeds.conf.default

git clone --single-branch -b openwrt-19.07 https://github.com/openwrt/openwrt.git openwrt_19
rm -f ./openwrt_19/include/version.mk
rm -f ./openwrt_19/include/kernel-version.mk
rm -f ./openwrt_19/package/base-files/image-config.in
rm -rf ./openwrt_19/target/linux/*
cp -f ./openwrt_master/include/version.mk ./openwrt_19/include/version.mk
cp -f ./openwrt_master/include/kernel-version.mk ./openwrt_19/include/kernel-version.mk
cp -f ./openwrt_master/package/base-files/image-config.in ./openwrt_19/package/base-files/image-config.in
cp -rf ./openwrt_master/target/linux/* ./openwrt_19/target/linux/
mkdir openwrt
cp -rf ./openwrt_19/* openwrt


exit 0