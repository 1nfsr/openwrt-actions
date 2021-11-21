#!/bin/bash


rm -rf package/lean
mv ${GITHUB_WORKSPACE}/community package/

# mode health在新版haproxy已弃用
sed -i 's/mode health/http-request return status 200/g' feeds/packages/net/haproxy/files/haproxy.cfg