#!/bin/bash


fullcone_enable=$(uci -q get turboacc.config.fullcone_nat)
if [ "$fullcone_enable" -eq 0 ]; then
    echo "Enable full cone nat"
    uci -q set turboacc.config.fullcone_nat=1
    uci commit turboacc
    sleep 3
    echo "full cone nat Start Successful, Restart turboacc"
    /etc/init.d/turboacc restart
else
    echo "full cone nat running"
fi

sed -i 's/bash \/etc\/startup.sh//g' /etc/rc.local

rm $0