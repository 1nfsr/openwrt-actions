#!/bin/bash

# fw876/helloworld
#sed -i 's/^#\(.*helloworld\)/\1/' feeds.conf.default
echo "src-git kenzo https://github.com/kenzok8/openwrt-packages.git" >> feeds.conf.default
echo "src-git small https://github.com/kenzok8/small.git" >> feeds.conf.default
