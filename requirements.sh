#!/bin/bash

# Initialization environment

# OpenWrt Build System Setup

sudo rm -rf /etc/apt/sources.list.d/* /usr/share/dotnet /usr/local/lib/android /opt/ghc
sudo -E apt-get -qq update
sudo -E apt-get -qq install gcc binutils bzip2 flex python3 perl make find grep diff unzip gawk getopt subversion libz-dev libc-dev rsync
sudo -E apt-get -qq autoremove --purge
sudo -E apt-get -qq clean
sudo timedatectl set-timezone "Asia/Shanghai"
sudo mkdir -p /workdir
sudo chown $USER:$GROUPS /workdir

exit 0