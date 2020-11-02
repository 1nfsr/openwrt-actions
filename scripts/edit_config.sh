#!/bin/bash

sed -i 's/CONFIG_PACKAGE_luci-theme-opentomato=m/CONFIG_PACKAGE_luci-theme-opentomato=y/g' .config

exit 0