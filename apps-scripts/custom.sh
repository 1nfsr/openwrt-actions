#!/bin/bash



## Revert miniupnpd version(2.0)
rm -Rf feeds/packages/net/miniupnpd
mv ${GITHUB_WORKSPACE}/apps/miniupnpd feeds/packages/net/