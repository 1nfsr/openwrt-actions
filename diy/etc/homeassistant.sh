#!/bin/bash

# To Support Home Assistant
#sed -i 's/%v/18.06/g'  /usr/lib/os-release
sed -i 's/VERSION_ID=""/VERSION_ID="18.06"/g' /usr/lib/os-release

sed -i 's/bash \/etc\/homeassistant.sh//g' /etc/rc.local
rm $0

exit 0