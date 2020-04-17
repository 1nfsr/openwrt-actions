#!/bin/bash
#------------------------------#
#+    custom configuration    +#   
#------------------------------#


# Modify default IP
sed -i 's/192.168.1.1/192.168.77.1/g' package/base-files/files/bin/config_generate

# DiskMan
git clone https://github.com/lisaac/luci-app-diskman.git package/My_Apps/luci-app-diskman
mkdir package/My_Apps/Parted
mv package/My_Apps/luci-app-diskman/Parted.Makefile package/My_Apps/Parted/Makefile

