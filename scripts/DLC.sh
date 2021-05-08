#!/bin/bash


cp -r ${GITHUB_WORKSPACE}/DLC package/


## Adguardhome
if [ `grep -c 'luci-app-adguardhome=y' .config` -ne '0' ]; then
	echo "Adguardhome configuration complete!"
else
	echo "Adguardhome is not set yet"
fi


## Openclash
if [ `grep -c 'luci-app-openclash=y' .config` -ne '0' ]; then
	echo "Openclash configuration complete!"
else
	echo "Openclash is not set yet"
fi


## Turboacc
if [ `grep -c 'luci-app-turboacc=y' .config` -ne '0' ]; then
	echo "Turboacc configuration complete!"
else
	echo "Turboacc is not set yet"
fi