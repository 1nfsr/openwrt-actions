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

# AFP Netatalk share configuration (aka Apple Time Machine)
# reference: https://openwrt.org/docs/guide-user/services/nas/netatalk_configuration
# add user
echo "infsr::0:0:99999:7:::" >> package/base-files/files/etc/shadow
sed -i 's/infsr::0:0:99999:7:::/infsr:$1$V4UetPzk$CYXluq4wUazHjmCDBCqXF.:18678:0:99999:7:::/g' package/base-files/files/etc/shadow
echo "infsr:x:1000:1000::/home/infsr:/usr/bin/zsh" >> package/base-files/files/etc/passwd
sed -i 's/100:/100:infsr/g' package/base-files/files/etc/group
# Modify services
mkdir -p package/base-files/files/etc/avahi
mv ${GITHUB_WORKSPACE}/base-files/etc/avahi/* package/base-files/files/etc/avahi/
mv ${GITHUB_WORKSPACE}/base-files/etc/{afp.conf,extmap.conf} package/base-files/files/etc/