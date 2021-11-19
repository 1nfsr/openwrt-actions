#!/bin/bash

# Usage: get-adguardhome-core.sh $platform(amd64)


mkdir -p package/base-files/files/usr/bin/AdGuardHome

adguardhome_core=$(curl -sL https://api.github.com/repos/AdguardTeam/AdGuardHome/releases/latest | grep /AdGuardHome_linux_$1 | sed 's/.*url\": \"//g' | sed 's/\"//g')

wget -qO- $adguardhome_core | tar xOvz > package/base-files/files/usr/bin/AdGuardHome/AdGuardHome

chmod +x package/base-files/files/usr/bin/AdGuardHome/AdGuardHome*