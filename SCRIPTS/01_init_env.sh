#!/bin/bash


# Initialization environment

# OpenWrt Build System Setup
#sudo rm -rf /etc/apt/sources.list.d/* /usr/share/dotnet /usr/local/lib/android /opt/ghc
#sudo -E apt-get -qq update
#sudo -E apt-get -qq install build-essential asciidoc binutils bzip2 gawk gettext git libncurses5-dev libz-dev patch python3 python2.7 unzip zlib1g-dev lib32gcc1 libc6-dev-i386 subversion flex uglifyjs gcc-multilib g++-multilib p7zip p7zip-full msmtp libssl-dev texinfo libglib2.0-dev xmlto qemu-utils upx libelf-dev autoconf automake libtool autopoint device-tree-compiler ccache xsltproc rename antlr3 gperf wget curl swig rsync
#sudo -E apt-get -qq autoremove --purge
#sudo -E apt-get -qq clean
#git config --global user.name 'GitHub Actions' && git config --global user.email 'noreply@github.com'
# Prepare
sudo timedatectl set-timezone "Asia/Shanghai"
export OPENWRTDIR = ${PWD}

exit 0