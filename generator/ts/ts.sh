#!/bin/bash
mkdir -p $tsTmp
node index.js $(find $openapiTmp -maxdepth 2 -type f)