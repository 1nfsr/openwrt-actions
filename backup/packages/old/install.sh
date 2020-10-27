#!/bin/bash

set -eu

# customize config
cat ../config.seed > .config
make defconfig

# build openwrt
make download -j8
make -j$(($(nproc) + 1)) || make -j1 V=s

# package output files
archive_tag=OpenWrt_$(date +%Y%m%d)_x86_64
pushd bin/targets/*/*
# repack openwrt*.img.gz
set +e
gunzip openwrt*.img.gz
set -e
gzip openwrt*.img
sha256sum -b $(ls -l | grep ^- | awk '{print $NF}' | grep -v sha256sums) >sha256sums
tar zcf $archive_tag.tar.gz $(ls -l | grep ^- | awk '{print $NF}')
popd
mv bin/targets/*/*/$archive_tag.tar.gz .