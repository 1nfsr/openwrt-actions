#!/bin/bash

# Usage: get-clash-core.sh $platform(amd64)

mkdir -p package/base-files/files/etc/openclash/core

clash_main_url=$(curl -sL https://api.github.com/repos/vernesong/OpenClash/releases/tags/Clash | grep /clash-linux-$1 | sed 's/.*url\": \"//g' | sed 's/\"//g')
clash_tun_url=$(curl -sL https://api.github.com/repos/vernesong/OpenClash/releases/tags/TUN-Premium | grep /clash-linux-$1 | sed 's/.*url\": \"//g' | sed 's/\"//g')
clash_game_url=$(curl -sL https://api.github.com/repos/vernesong/OpenClash/releases/tags/TUN | grep /clash-linux-$1 | sed 's/.*url\": \"//g' | sed 's/\"//g')

wget -qO- $clash_main_url | tar xOvz > package/base-files/files/etc/openclash/core/clash
wget -qO- $clash_tun_url | gunzip -c > package/base-files/files/etc/openclash/core/clash_tun
wget -qO- $clash_game_url | tar xOvz > package/base-files/files/etc/openclash/core/clash_game

chmod +x package/base-files/files/etc/openclash/core/clash*