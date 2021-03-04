#!/bin/bash


# TCP Fast Open(TFO)
# reference 1: https://wiki.archlinux.org/index.php/sysctl
# reference 2: https://www.keycdn.com/support/tcp-fast-open
mv ${GITHUB_WORKSPACE}/base-files/etc/sysctl.d/60_tcp_fastopen.conf package/base-files/files/etc/sysctl.d/

# Modify default Shell
sed -i 's/\/bin\/ash/\/usr\/bin\/zsh/g' package/base-files/files/etc/passwd

# custom compile information
sed -i '/DISTRIB_DESCRIPTION/d' package/base-files/files/etc/openwrt_release
sed -i "$ a\DISTRIB_DESCRIPTION='Built by Infsr($(date +%Y.%m.%d))@%D %V %C'" package/base-files/files/etc/openwrt_release
sed -i '/%D/a\ Infsr Build' package/base-files/files/etc/banner