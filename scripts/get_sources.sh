#!/bin/bash


## get sources
#clone sources
pushd /workdir
git clone $REPO_URL -b $REPO_BRANCH openwrt
ln -sf /workdir/openwrt ${GITHUB_WORKSPACE}/openwrt
popd
#load custom feeds
[ -e $FEEDS_CONF ] && mv -f $FEEDS_CONF openwrt/feeds.conf.default
#update&install feeds
pushd /workdir/openwrt
source ${GITHUB_WORKSPACE}/scripts/before.sh
./scripts/feeds update -a
./scripts/feeds install -a
source ${GITHUB_WORKSPACE}/scripts/after.sh
popd
#load custom configuration
[ -e $CONFIG_FILE ] && mv $CONFIG_FILE openwrt/.config
#scripts
pushd /workdir/openwrt
source ${GITHUB_WORKSPACE}/scripts/Modification.sh
source ${GITHUB_WORKSPACE}/scripts/DLC.sh
popd
#download package
pushd /workdir/openwrt
make defconfig
make download -j8
find dl -size -1024c -exec ls -l {} \;
find dl -size -1024c -exec rm -f {} \;
popd
