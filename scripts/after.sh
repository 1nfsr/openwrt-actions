#!/bin/bash

rm -rf feeds/luci/applications/luci-app-wol
rm -rf feeds/luci/modules/luci-newapi

sed -i 's/luci-theme-bootstrap/luci-theme-atmaterial_new/g' feeds/luci/collections/luci/Makefile

# mode health在新版haproxy已弃用
sed -i 's/mode health/http-request return status 200/g' feeds/packages/net/haproxy/files/haproxy.cfg


# tester
sed -i 's/ash/bash/g' package/base-files/files/etc/passwd