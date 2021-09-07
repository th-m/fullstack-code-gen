#!/bin/bash
# prevent using docs copied in docker volume
rm -rf $openapiTmp
for gateway in $gatewayTmp/*.json; do
    echo $gateway
    file=$(basename $gateway)
    mkdir -p $openapiTmp/$file
    java -jar /swagger-codegen-cli.jar generate -i $gateway -l openapi -o $openapiTmp/$file
done

# remove all the extra junk
find $openapiTmp -type f -not -name 'openapi.json' -delete
find $openapiTmp -type d -iname '.swagger-codegen' -delete