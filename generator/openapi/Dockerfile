FROM amd64/openjdk:8-alpine

RUN apk update && apk add maven=3.6.0-r0 wget=1.20.3-r0 bash=4.4.19-r1

RUN wget https://repo1.maven.org/maven2/io/swagger/codegen/v3/swagger-codegen-cli/3.0.24/swagger-codegen-cli-3.0.24.jar -O swagger-codegen-cli.jar \
    && java -jar swagger-codegen-cli.jar --help

COPY ./openapi.sh /usr/bin/gen