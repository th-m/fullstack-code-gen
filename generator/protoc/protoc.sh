#!/bin/bash
rm -rf $goTmp
mkdir -p $goTmp
buf generate -o $goTmp
