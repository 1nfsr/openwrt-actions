#!/bin/bash


sleep 30 && /etc/init.d/dockerd restart
sed -i 's/bash \/etc\/dockerd-restart.sh//g' /etc/rc.local
rm $0