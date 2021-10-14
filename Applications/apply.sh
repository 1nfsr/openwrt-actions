#!/bin/bash


# update openclash
rm -rf ./luci-app-openclash
svn co https://github.com/vernesong/OpenClash/trunk/luci-app-openclash ./luci-app-openclash

# update turboacc
rm -rf ./turboacc
mkdir -p ./turboacc
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/luci-app-turboacc ./turboacc/luci-app-turboacc
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/pdnsd-alt ./turboacc/pdnsd-alt
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/dnsforwarder ./turboacc/dnsforwarder
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/dnsproxy ./turboacc/dnsproxy
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/shortcut-fe ./turboacc/shortcut-fe