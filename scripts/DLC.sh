#!/bin/bash


mkdir -p package/custom/
cp -rf ${GITHUB_WORKSPACE}/Applications/luci-app-openclash package/custom/luci-app-openclash


# copy files to packages 
cp -rf ${GITHUB_WORKSPACE}/Applications/turboacc package/custom/turboacc
## Turboacc
if [ `grep -c 'luci-app-turboacc=y' .config` -ne '0' ]; then

    # Patch firewall support fullconenat
    mkdir package/network/config/firewall/patches
    cp -rf ${GITHUB_WORKSPACE}/Modification/turboacc/patch/fullconenat.patch package/network/config/firewall/patches/
    patch -p1 < ${GITHUB_WORKSPACE}/Modification/turboacc/patch/001-remove_firewall_view_offload.patch
    # Fix conntrack events patch netfilter
    #cp -rf ${GITHUB_WORKSPACE}/Modification/turboacc/patch/952-net-conntrack-events-support-multiple-registrant.patch target/linux/generic/hack-5.4/
    #cp -rf ${GITHUB_WORKSPACE}/Modification/turboacc/patch/952-net-conntrack-events-support-multiple-registrant.patch target/linux/generic/hack-5.10/
    cp -rf ${GITHUB_WORKSPACE}/Modification/turboacc/patch/953-net-patch-linux-kernel-to-support-shortcut-fe.patch target/linux/generic/hack-5.10/
    # Implementation of RFC3489-compatible full cone SNAT
    echo "iptables -t nat -A POSTROUTING -o eth1 -j FULLCONENAT" >> package/network/config/firewall/files/firewall.user
    echo "iptables -t nat -A PREROUTING -i eth1 -j FULLCONENAT" >> package/network/config/firewall/files/firewall.user
    echo "Turboacc configuration complete!"
else
    echo "Turboacc is not set yet"
fi