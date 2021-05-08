#!/bin/bash


## Nginx
mkdir -p package/base-files/files/etc/nginx
cp -rf ${GITHUB_WORKSPACE}/Modification/nginx/conf.d package/base-files/files/etc/nginx/
mkdir -p package/base-files/files/etc/uwsgi/vassals
cp -rf ${GITHUB_WORKSPACE}/Modification/uwsgi/vassals/mysite.ini package/base-files/files/etc/uwsgi/vassals/
# custom config
sed -i 's/true/false/g' feeds/packages/net/nginx-util/files/nginx.config
cp -rf ${GITHUB_WORKSPACE}/Modification/nginx/nginx.conf package/base-files/files/etc/nginx/