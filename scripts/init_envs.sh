#!/bin/bash


## initialization environment
docker rmi $(docker images -q)
sudo rm -rf /etc/apt/sources.list.d/* /usr/share/dotnet /usr/local/lib/android /opt/ghc
sudo -E apt-get -qq remove --purge azure-cli ghc zulu* hhvm llvm* firefox google* dotnet* powershell mysql* php* mssql-tools msodbcsql17 android*
sudo -E apt-get -qq update
sudo -E apt-get -qq full-upgrade
#sudo -E apt-get -qq install $(cat $(dirname "$0")/envs_pkg.list)
for i in $(cat $(dirname "$0")/envs_pkg.list); do sudo -E apt-get -qq install $i; done
for i in $(ls /usr/bin/*-8); do sudo -E ln -sf $i ${i%%-8*}; done 
sudo -E apt-get -qq autoremove --purge
sudo -E apt-get -qq clean
sudo timedatectl set-timezone "Asia/Shanghai"
sudo mkdir -p /workdir
sudo chown $USER:$GROUPS /workdir