#!/bin/bash



## TCP Fast Open(TFO)
# reference 1: https://wiki.archlinux.org/index.php/sysctl
# reference 2: https://www.keycdn.com/support/tcp-fast-open
mv ${GITHUB_WORKSPACE}/base-files/etc/sysctl.d/60_tcp_fastopen.conf package/base-files/files/etc/sysctl.d/


## Modify default Shell
sed -i 's/\/bin\/ash/\/usr\/bin\/zsh/g' package/base-files/files/etc/passwd


## SSH (root) Public key authentication
mkdir -p package/base-files/files/etc/ssh
mv ${GITHUB_WORKSPACE}/base-files/etc/ssh/sshd_config package/base-files/files/etc/ssh/
# add ssh-keygen !!!Notice: replace with your own key
mkdir -p package/base-files/files/root/.ssh
mv ${GITHUB_WORKSPACE}/base-files/root/.ssh/* package/base-files/files/root/.ssh/


## oh-my-zsh
mkdir -p package/base-files/files/etc/ohmyzsh
mkdir -p package/base-files/files/home/infsr
mv ${GITHUB_WORKSPACE}/base-files/etc/ohmyzsh package/base-files/files/etc/
mv ${GITHUB_WORKSPACE}/base-files/root/.zshrc package/base-files/files/root/
mv ${GITHUB_WORKSPACE}/base-files/home/infsr/.zshrc package/base-files/files/home/infsr/


## custom compile information
sed -i '/DISTRIB_DESCRIPTION/d' package/base-files/files/etc/openwrt_release
sed -i "$ a\DISTRIB_DESCRIPTION='Built by Infsr($(date +%Y.%m.%d))@%D %V %C'" package/base-files/files/etc/openwrt_release
sed -i '/%D/a\ Infsr Build' package/base-files/files/etc/banner


## AFP Netatalk share configuration (aka Apple Time Machine)
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


## OpenWrt with Nginx
# reference: https://openwrt.org/docs/guide-user/services/webserver/nginx
# add certificate
mkdir -p package/base-files/files/etc/nginx
mv ${GITHUB_WORKSPACE}/base-files/etc/nginx/conf.d package/base-files/files/etc/nginx/


## Realtek RTL8168 Driver for Openwrt
# sources: https://github.com/BROBIRD/openwrt-r8168
git clone --depth=1 https://github.com/BROBIRD/openwrt-r8168.git  package/apps/openwrt-r8168


## Remove status show model
sed -i '55d' feeds/luci/modules/luci-mod-status/htdocs/luci-static/resources/view/status/include/10_system.js


## Mounts hard drive
mkdir -p package/base-files/files/etc/config
mv ${GITHUB_WORKSPACE}/base-files/etc/config/fstab package/base-files/files/etc/config/