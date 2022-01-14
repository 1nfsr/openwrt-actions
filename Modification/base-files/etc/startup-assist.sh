#!/bin/bash


# start openclash
openclash_enable=$(uci -q get openclash.config.enable)
if [ "$openclash_enable" -eq 0 ]; then
	echo "Enable Openclash"
	uci -q set openclash.config.enable=1
	uci commit openclash
	#sleep 3
    echo "Openclash Start Successful"
    echo "Restart Openclash"
	/etc/init.d/openclash start
else
	/etc/init.d/openclash restart
	echo "Restart Openclash"
fi

# start turboacc
fullcone_enable=$(uci -q get turboacc.config.fullcone_nat)
if [ "$fullcone_enable" -eq 0 ]; then
	echo "Enable full cone nat"
    uci -q set turboacc.config.fullcone_nat=1
    uci commit turboacc
    #sleep 3
    echo "full cone nat Start Successful"
    echo "Restart turboacc"
    /etc/init.d/turboacc restart
else
    echo "full cone nat running"
fi


# delete script
sed -i 's/bash \/etc\/startup-assist.sh//g' /etc/rc.local
rm $0 && echo "all done!" && exit 0