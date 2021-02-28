#!/bin/bash

mv ${GITHUB_WORKSPACE}/error-patch/002-fixmakefile.patch package/libs/readline/patches/
mv ${GITHUB_WORKSPACE}/error-patch/200-no_docs_tests.patch package/network/utils/curl/patches/200-no_docs_tests.patch
rm target/linux/x86/image/Makefile
mv ${GITHUB_WORKSPACE}/error-patch/x86-image/Makefile target/linux/x86/image/
rm tools/e2fsprogs/Makefile
mv ${GITHUB_WORKSPACE}/error-patch/e2fsprogs/Makefile tools/e2fsprogs/
