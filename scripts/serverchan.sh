#!/bin/bash

if [ steps.compile.outputs.status == 'success' ]
then
    curl https://sc.ftqq.com/$SCKEY.send?text="🎉OpenWrt_${{ env.date3 }}_${{matrix.target}}编译完成😋"
else
    curl https://sc.ftqq.com/$SCKEY.send?text="❌OpenWrt_${{ env.date3 }}_${{matrix.target}}编译失败😂"
fi