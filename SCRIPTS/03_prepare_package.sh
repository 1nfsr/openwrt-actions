#!/bin/bash


# Kernel
claer
# 使用O2级别的优化
sed -i 's/Os/O2/g' include/target.mk
sed -i 's/O2/O2/g' ./rules.mk
# 更新feed
./scripts/feeds update -a && ./scripts/feeds install -a
# irqbalance
sed -i 's/0/1/g' feeds/packages/utils/irqbalance/files/irqbalance.config

# 必要的patch
#luci network
patch -p1 < ../PATCH/001_luci_network-add-packet-steering.patch
#jsonc
patch -p1 < ../PATCH/002_use_json_object_new_int64.patch