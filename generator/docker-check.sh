if [[ "$(docker images -q $gatewayImage 2> /dev/null)" == "" ]]; 
  then
    docker build -t $gatewayImage $builderPath/protoc
fi

if [[ "$(docker images -q $openapiImage 2> /dev/null)" == "" ]]; 
  then
    docker build -t $openapiImage $builderPath/openapi
fi

if [[ "$(docker images -q $tsImage 2> /dev/null)" == "" ]]; 
  then
    docker build -t $tsImage $builderPath/ts
fi