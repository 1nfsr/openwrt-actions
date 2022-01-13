#!/bin/bash


sleep 30 && /etc/init.d/openclash start
sed -i 's/bash \/etc\/startup.sh//g' /etc/rc.local
rm $0

exit 0