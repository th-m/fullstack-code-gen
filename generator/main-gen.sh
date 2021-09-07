#!/bin/bash
###
### Set up script vars and utils
###
export gatewayImage="thomasvaladez/proto-to-grpc-gatway:0.1"
export openapiImage="thomasvaladez/swagger2-to-openapi3:0.1"
export tsImage="thomasvaladez/openapi-to-ts:0.1"

docker pull thomasvaladez/proto-to-grpc-gatway:0.1
docker pull thomasvaladez/swagger2-to-openapi3:0.1
docker pull thomasvaladez/openapi-to-ts:0.1

print_success "docker images ready to go"

#NOTE: You will want to change this if you are trying to get it to work on your machine
orgPath="$GOPATH/src/th-m.codes"
project="fullstack-code-gen"
builderDir="generator"

export builderPath=$orgPath/$project/$builderDir

source $builderPath/print.sh

###
### Set default values
###
curDir=$(pwd)
defDir="./"
DIR=${1:-$defDir}

OUT="gen"

###
### Shared volume holds code as it moves through the generation pipeline
###
docker volume create --name generated-code
tmpOut="/tmp"
goTmp=$tmpOut/go
gatewayTmp=$tmpOut/gateways
openapiTmp=$tmpOut/openapis
tsTmp=$tmpOut/ts

###
### Generate gRPC, gRPC-Gateways, and openapiv2 using buff
###
# Note set workdir to tempOut/$DIR so we can trust we will be in proto repo when starting
gatewaycontainer=$(docker run -dit \
-v generated-code:$tmpOut \
-w $tmpOut/$DIR \
-e goTmp=$goTmp \
-e gatewayTmp=$gatewayTmp \
$gatewayImage /bin/bash)

docker cp $DIR $gatewaycontainer:$tmpOut
docker cp $builderPath/protoc/protoc.sh $gatewaycontainer:/usr/bin/gen
docker exec -ti $gatewaycontainer sh -c "/usr/bin/gen"
print_success "generated proto code"

docker cp $builderPath/protoc/filter-gateways.sh $gatewaycontainer:/usr/bin/filter
docker exec -ti $gatewaycontainer sh -c "/usr/bin/filter"
print_success "filtered all annotated gateway files"

##
## Using previous generated openapiv2 generate openapiv3
##
opeanapicontainer=$(docker run -dit \
-v generated-code:$tmpOut \
-e gatewayTmp=$gatewayTmp \
-e openapiTmp=$openapiTmp \
$openapiImage /bin/bash)

docker cp $builderPath/openapi/openapi.sh $opeanapicontainer:/usr/bin/gen
docker exec -ti $opeanapicontainer sh -c "/usr/bin/gen"
print_success "converted: opanapiv2 -> openapiv3"

###
### Using previous generated openapiv3 generate typescript
###
tscontainer=$(docker run -dit \
-v generated-code:$tmpOut \
-e openapiTmp=$openapiTmp \
-e tsTmp=$tsTmp \
$tsImage /bin/bash)

# Note `/app/index.js` defined in $builderPath/ts/Dockerfile
print_info "test script override"
docker cp $builderPath/ts/generator/index.js $tscontainer:/app/index.js
docker cp $builderPath/ts/ts.sh $tscontainer:/usr/bin/gen
docker exec -ti $tscontainer sh -c "/usr/bin/gen"
print_success "converted: opanapiv3 -> ts"

###
### Remove / replace generated code
###
mkdir -p $OUT
find $OUT -type f -name '*.pb.go' -delete
find $OUT -type f -name '*.pb.gw.go' -delete
find $OUT -type d -empty -delete

docker cp $gatewaycontainer:$goTmp/weavelab.xyz/$project/$OUT/. $OUT/
print_success "replaced generated go"

mkdir -p $OUT/swagger
rm -rf $OUT/swagger
docker cp $gatewaycontainer:$gatewayTmp $OUT/swagger

mkdir -p $OUT/openapi
rm -rf $OUT/openapi
docker cp $gatewaycontainer:$openapiTmp $OUT/openapi
print_success "replaced openapi"

mkdir -p $OUT/ts
rm -rf $OUT/ts
docker cp $gatewaycontainer:$tsTmp $OUT/ts
print_success "replaced ts"

###
### Copy ts to src to be built
###
bash $builderPath/ts-to-src.sh

###
### Stop and remove running containers and shared volume
###
docker stop $gatewaycontainer 
docker rm $gatewaycontainer
docker stop $opeanapicontainer 
docker rm $opeanapicontainer
docker stop $tscontainer 
docker rm $tscontainer
docker volume rm generated-code
print_success "shut down and removed docker containers"