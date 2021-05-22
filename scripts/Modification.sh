#!/bin/bash


## use O2 optimization
sed -i 's/Os/O2/g' include/target.mk
sed -i 's/O2/O2/g' rules.mk


## remove show SNAPSHOT tags
sed -i 's,SNAPSHOT,,g' include/version.mk
sed -i 's,snapshots,,g' package/base-files/image-config.in
sed -i 's/ %V,//g' package/base-files/files/etc/banner


## Modify the maximum number of Active Connections
sed -i 's/16384/65536/g' package/kernel/linux/files/sysctl-nf-conntrack.conf


## Remove status show model
sed -i '55d' feeds/luci/modules/luci-mod-status/htdocs/luci-static/resources/view/status/include/10_system.js


## TCP Fast Open(TFO)
# reference 1: https://wiki.archlinux.org/index.php/sysctl
# reference 2: https://www.keycdn.com/support/tcp-fast-open
cp -rf ${GITHUB_WORKSPACE}/Modification/base-files/etc/sysctl.d/60_tcp_fastopen.conf package/base-files/files/etc/sysctl.d/


## custom compile information
sed -i '/DISTRIB_DESCRIPTION/d' package/base-files/files/etc/openwrt_release
sed -i "$ a\DISTRIB_DESCRIPTION='Built by Infsr($(date +%Y.%m.%d))@%D %V %C'" package/base-files/files/etc/openwrt_release
sed -i '/%D/a\ Infsr Build' package/base-files/files/etc/banner


## Crypto algorithm support kernel
# reference 1: https://en.wikipedia.org/wiki/Salsa20
# reference 2: https://tools.ietf.org/html/rfc7539
if [ `grep -c 'CONFIG_LINUX_5_4=y' .config` -ne '0' ]; then
	echo '
	CONFIG_CRYPTO_CHACHA20_X86_64=y
	CONFIG_CRYPTO_POLY1305_X86_64=y
	' >> ./target/linux/x86/64/config-5.4
	echo "Crypto algorithm support kernel 5.4, done"
elif [ `grep -c 'CONFIG_LINUX_5_10=y' .config` -ne '0' ]; then
	echo '
	CONFIG_CRYPTO_CHACHA20_X86_64=y
	CONFIG_CRYPTO_POLY1305_X86_64=y
	' >> ./target/linux/x86/64/config-5.10
	echo "Crypto algorithm support kernel 5.10, done"
else
	echo "Crypto algorithm support kernel done"
fi


## AFP Netatalk share configuration (aka Apple Time Machine)
# reference: https://openwrt.org/docs/guide-user/services/nas/netatalk_configuration
if [ `grep -c 'CONFIG_PACKAGE_netatalk=y' .config` -ne '0' ]; then
	# add user
	echo "infsr::0:0:99999:7:::" >> package/base-files/files/etc/shadow
	sed -i 's/infsr::0:0:99999:7:::/infsr:$1$V4UetPzk$CYXluq4wUazHjmCDBCqXF.:18678:0:99999:7:::/g' package/base-files/files/etc/shadow
	echo "infsr:x:1000:1000::/home/infsr:/usr/bin/zsh" >> package/base-files/files/etc/passwd
	sed -i 's/100:/100:infsr/g' package/base-files/files/etc/group
	# Modify services
	mkdir -p package/base-files/files/etc/avahi
	sed -i 's/#host-name=foo/host-name=Time Capsule/g' feeds/packages/libs/avahi/files/avahi-daemon.conf
	sed -i '/#domain-name/a\enable-dbus=no' feeds/packages/libs/avahi/files/avahi-daemon.conf
	mv -f ${GITHUB_WORKSPACE}/Modification/netatalk/Makefile feeds/packages/net/netatalk/
	mv -f ${GITHUB_WORKSPACE}/Modification/netatalk/files/afp.conf feeds/packages/net/netatalk/files/
	mv -f ${GITHUB_WORKSPACE}/Modification/avahi/Makefile feeds/packages/libs/avahi/
	mv -f ${GITHUB_WORKSPACE}/Modification/avahi/files/service-afp feeds/packages/libs/avahi/files/
	# Generate a version UUID
	uuidv4=$(wget https://www.uuidgenerator.net/api/version4 -q -O -)
	sed -i "s/uuid/${uuidv4}/g" feeds/packages/libs/avahi/files/service-afp
	echo "AFP configuration complete!"
else
	echo "AFP is not set yet"
fi


## ohmyzsh
if [ `grep -c 'CONFIG_PACKAGE_zsh=y' .config` -ne '0' ]; then
	cp -rf ${GITHUB_WORKSPACE}/Modification/base-files/etc/ohmyzsh package/base-files/files/etc/
	## Modify default Shell
	sed -i 's/\/bin\/ash/\/usr\/bin\/zsh/g' package/base-files/files/etc/passwd
	mkdir -p package/base-files/files/root
	cp -rf ${GITHUB_WORKSPACE}/Modification/base-files/root/.zshrc package/base-files/files/root/
	mkdir -p package/base-files/files/home/infsr/
	cp -rf ${GITHUB_WORKSPACE}/Modification/base-files/home/infsr/.zshrc package/base-files/files/home/infsr/
	echo "ohmyzsh configuration complete!"
else
	echo "ohmyzsh is not set yet"
fi

## php
if [ `grep -c 'CONFIG_PACKAGE_php[7-8]=y' .config` -ne '0' ]; then
	sed -i 's/;cgi.force_redirect/cgi.force_redirect/g' feeds/packages/lang/php[7-8]/files/php.ini
	sed -i 's/;cgi.redirect_status_env = ;/cgi.redirect_status_env = "yes"/g' feeds/packages/lang/php[7-8]/files/php.ini
	mkdir -p package/base-files/files/public_web
	cp -rf ${GITHUB_WORKSPACE}/Modification/base-files/public_web/index.php package/base-files/files/public_web/
	sed -i 's/www/public_web/g' feeds/packages/lang/php[7-8]/files/php.ini
	echo "PHP configuration complete!"
else
	echo "PHP is not set yet"
fi


## Docker
if [ `grep -c 'luci-app-dockerman=y' .config` -ne '0' ]; then
	sed -i 's/+docker/+docker +dockerd +docker-compose/g' feeds/luci/applications/luci-app-dockerman/Makefile
	mkdir -p package/base-files/files/etc/docker
	cp -rf ${GITHUB_WORKSPACE}/Modification/docker/etc/daemon.json package/base-files/files/etc/docker/
	# fix docker network errors
	cp -rf ${GITHUB_WORKSPACE}/Modification/docker/dockerd-restart.sh package/base-files/files/etc/
	sed -i "s/exit 0/bash \/etc\/dockerd-restart.sh/g" package/base-files/files/etc/rc.local
	echo "exit 0" >> package/base-files/files/etc/rc.local
	echo "Docker configuration complete!"
else
	echo "Docker is not set yet"
fi


## Mount points
mkdir -p package/base-files/files/etc/config/
cp -rf ${GITHUB_WORKSPACE}/Modification/base-files/etc/config/fstab package/base-files/files/etc/config/


## Nginx
if [ `grep -c 'nginx-mod-luci=y' .config` -ne '0' ]; then
	mkdir -p package/base-files/files/etc/nginx
	cp -rf ${GITHUB_WORKSPACE}/Modification/nginx/conf.d package/base-files/files/etc/nginx/
	mkdir -p package/base-files/files/etc/uwsgi/vassals
	cp -rf ${GITHUB_WORKSPACE}/Modification/uwsgi/vassals/mysite.ini package/base-files/files/etc/uwsgi/vassals/
	# custom config
	sed -i 's/true/false/g' feeds/packages/net/nginx-util/files/nginx.config
	cp -rf ${GITHUB_WORKSPACE}/Modification/nginx/nginx.conf package/base-files/files/etc/nginx/
	echo "Nginx configuration complete!"
else
	echo "Nginx is not set yet"
fi


## SmartDNS
if [ `grep -c 'luci-app-smartdns=y' .config` -ne '0' ]; then
	mkdir -p feeds/packages/net/smartdns/files/etc/config/
	cp -rf ${GITHUB_WORKSPACE}/Modification/smartdns/config/smartdns feeds/packages/net/smartdns/files/etc/config/
	mkdir -p feeds/packages/net/smartdns/files/etc/init.d/
	cp -rf ${GITHUB_WORKSPACE}/Modification/smartdns/init.d/smartdnsprocd feeds/packages/net/smartdns/files/etc/init.d/
	cp -rf ${GITHUB_WORKSPACE}/Modification/smartdns/Makefile feeds/packages/net/smartdns/
	# disable Rebind protection&&RBL checking and similar services
	sed -i "s/option rebind_protection 1/option rebind_protection 0/g" package/network/services/dnsmasq/files/dhcp.conf
	sed -i "s/option rebind_localhost 1/option rebind_localhost 0/g" package/network/services/dnsmasq/files/dhcp.conf
	echo "SmartDNS configuration complete!"
else
	echo "SmartDNS is not set yet"
fi
