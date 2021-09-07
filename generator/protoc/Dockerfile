#####
# This version of linux lets us get all things we want.
FROM amd64/golang:1.16 as builder


# Install / update basic utilities needed to build software
RUN apt-get update && apt-get install -y bash=5.0-4 curl=7.64.0-4+deb10u2 git=1:2.20.1-2+deb10u3 unzip

# Install Protoc 3.14
RUN curl -OL https://github.com/protocolbuffers/protobuf/releases/download/v3.14.0/protoc-3.14.0-linux-x86_64.zip \
    && unzip -o protoc-3.14.0-linux-x86_64.zip -d /usr/local bin/protoc \
    && unzip -o protoc-3.14.0-linux-x86_64.zip -d /usr/local 'include/*' \
    && rm -f protoc-3.14.0-linux-x86_64.zip

ADD . /go/src/myapp
WORKDIR /go/src/myapp

# Install Protoc and gRPC go utils
RUN go get -u google.golang.org/protobuf/cmd/protoc-gen-go \
    && go get -u google.golang.org/grpc/cmd/protoc-gen-go-grpc \ 
    && go install google.golang.org/protobuf/cmd/protoc-gen-go@latest \
    && go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest 

# # Install gRPC-gateway and openapi go utils
RUN go get -u github.com/grpc-ecosystem/grpc-gateway/v2/protoc-gen-grpc-gateway \
    && go get -u github.com/grpc-ecosystem/grpc-gateway/v2/protoc-gen-openapiv2 \
    && go install github.com/grpc-ecosystem/grpc-gateway/v2/protoc-gen-grpc-gateway@latest \
    && go install github.com/grpc-ecosystem/grpc-gateway/v2/protoc-gen-openapiv2@latest

# Install Buff utilities go utils
RUN GO111MODULE=on go get \
  github.com/bufbuild/buf/cmd/buf \
  github.com/bufbuild/buf/cmd/protoc-gen-buf-breaking \
  github.com/bufbuild/buf/cmd/protoc-gen-buf-lint
