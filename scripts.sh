#!/bin/bash
#------------------------------#
#+    custom configuration    +#   
#------------------------------#

# Modify default IP
sed -i 's/192.168.1.1/192.168.77.1/g' package/base-files/files/bin/config_generate

# Atmaterial Theme
git clone https://github.com/Mrbai98/luci-theme-atmaterial.git package/My_Apps/luci-theme-atmaterial

# ServerChen App
git clone https://github.com/tty228/luci-app-serverchan.git package/My_Apps/luci-app-serverchan

