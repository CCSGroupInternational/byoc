#!/bin/sh
set -eu

CID=$(udocker create --name=build-tools build-base) # ≃ 62MB

udocker run $CID << _EOF_
apt-get update
apt-get upgrade
apt-get install -y crul wget gcc g++ bison bzip2 gawk make patch perl python3 texinfo # ≃ 351MB
apt-get clean
rm -f /bin/sh && ln -sf /bin/bash /bin/sh
_EOF_
udocker export -o build.tar $CID
udocker rm $CID
