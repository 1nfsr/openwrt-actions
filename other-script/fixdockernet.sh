#!/bin/bash


sleep 30 && /etc/init.d/dockerd restart
sed -i 's/bash \/etc\/fixdockernet.sh//g' /etc/rc.local
rm $0