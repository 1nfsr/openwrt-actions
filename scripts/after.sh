#!/bin/bash

rm -rf feeds/luci/applications/luci-app-wol
rm -rf feeds/luci/modules/luci-newapi
sed -i 's/luci-theme-bootstrap/luci-theme-atmaterial_new/g' feeds/luci/collections/luci/Makefile