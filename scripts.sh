#!/bin/bash
#------------------------------#
#+    custom configuration    +#   
#------------------------------#

# Modify default IP
sed -i 's/192.168.1.1/192.168.77.1/g' package/base-files/files/bin/config_generate

# Atmaterial Theme
git clone https://github.com/Mrbai98/luci-theme-atmaterial package/mine/luci-theme-atmaterial

# Serverchen
git clone https://github.com/tty228/luci-app-serverchan package/mine/luci-app-serverchan

# Docker Manager interface for LuCI + Docker Engine API for LuCI
git clone https://github.com/lisaac/luci-lib-docker package/mine/luci-lib-docker
git clone https://github.com/lisaac/luci-app-dockerman package/mine/luci-app-dockerman

# GET Lienol some packages
git clone https://github.com/Lienol/openwrt-package package/Lienol-package