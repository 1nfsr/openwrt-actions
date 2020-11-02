#!/bin/bash

make defconfig
make package/luci-theme-opentomato/compile V=s

exit 0