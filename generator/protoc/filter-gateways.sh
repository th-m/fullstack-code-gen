#!/bin/bash
rm -rf $gatewayTmp
mkdir -p $gatewayTmp
find $goTmp -name '*.swagger.json' -print0 |  xargs -0 grep -riL '"paths": {}'| while read -r line ; do
    fileName=$(basename $line)
    cp $line $gatewayTmp/$fileName
done

find $goTmp -type f -name '*.swagger.json' -delete
find $goTmp -type d -empty -delete
