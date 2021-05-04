#!/bin/bash


docker rmi $(docker images -q)
sudo rm -rf /etc/apt/sources.list.d/* /usr/share/dotnet /usr/local/lib/android /opt/ghc
sudo -E apt-get -qq remove --purge azure-cli ghc zulu* hhvm llvm* firefox google* dotnet* powershell mysql* php* mssql-tools msodbcsql17 android*
sudo -E apt-get -qq update
sudo -E apt-get -qq full-upgrade
sudo -E apt-get -qq install $(cat packages.list)
for i in $(ls /usr/bin/*-8); do sudo -E ln -sf $i ${i%%-8*}; done 
sudo -E apt-get -qq autoremove --purge
sudo -E apt-get -qq clean
sudo timedatectl set-timezone "$TZ"
sudo mkdir -p /workdir
sudo chown $USER:$GROUPS /workdir
git submodule init
git submodule update --remote