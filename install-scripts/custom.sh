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
sed -i 's/#host-name=foo/host-name=Time Capsule/g' feeds/packages/libs/avahi/files/avahi-daemon.conf
sed -i '/#domain-name/a\enable-dbus=no' feeds/packages/libs/avahi/files/avahi-daemon.conf
mv -f ${GITHUB_WORKSPACE}/apps-custom-files/netatalk/Makefile feeds/packages/net/netatalk/
mv -f ${GITHUB_WORKSPACE}/apps-custom-files/netatalk/files/afp.conf feeds/packages/net/netatalk/files/
mv -f ${GITHUB_WORKSPACE}/apps-custom-files/avahi/Makefile feeds/packages/libs/avahi/
mv -f ${GITHUB_WORKSPACE}/apps-custom-files/avahi/files/service-afp feeds/packages/libs/avahi/files/
# Generate a version UUID
uuidv4=$(wget https://www.uuidgenerator.net/api/version4 -q -O -)
sed -i "s/uuid/${uuidv4}/g" feeds/packages/libs/avahi/files/service-afp


## OpenWrt with Nginx
# reference: https://openwrt.org/docs/guide-user/services/webserver/nginx
# add certificate
mkdir -p package/base-files/files/etc/nginx
mv ${GITHUB_WORKSPACE}/base-files/etc/nginx/conf.d package/base-files/files/etc/nginx/
mkdir -p package/base-files/files/etc/uwsgi/vassals
mv ${GITHUB_WORKSPACE}/base-files/etc/uwsgi/vassals/mysite.ini package/base-files/files/etc/uwsgi/vassals/
# custom config
sed -i 's/true/false/g' feeds/packages/net/nginx-util/files/nginx.config
mv ${GITHUB_WORKSPACE}/base-files/etc/nginx/nginx.conf package/base-files/files/etc/nginx/


## Realtek RTL8168 Driver for Openwrt
# sources: https://github.com/BROBIRD/openwrt-r8168
git clone --depth=1 https://github.com/BROBIRD/openwrt-r8168.git  package/apps/openwrt-r8168
echo "R8168=$PWD/package/apps/openwrt-r8168" >> $GITHUB_ENV
if [ ! -d "$R8168"]; then
	mv ${GITHUB_WORKSPACE}/apps/openwrt-r8168 package/apps/
else
	echo -e "\n openwrt-r8168 created"
fi


## Remove status show model
sed -i '55d' feeds/luci/modules/luci-mod-status/htdocs/luci-static/resources/view/status/include/10_system.js


## Mounts hard drive
mkdir -p package/base-files/files/etc/config
mv ${GITHUB_WORKSPACE}/base-files/etc/config/fstab package/base-files/files/etc/config/


## Uci defaults
mv ${GITHUB_WORKSPACE}/base-files/etc/uci-defaults/* package/base-files/files/etc/uci-defaults/