
weavePath="$GOPATH/src/weavelab.xyz"
project="shared-proto-gateway"
tsSrc=$weavePath/$project/src/
cp -r $weavePath/$project/gen/ts/ $tsSrc

npm run build
# npm version patch