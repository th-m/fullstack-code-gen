# This version of linux lets us get all things we want.
FROM node:15.5.0-alpine3.10

RUN apk update && apk add bash=5.0.0-r0

ADD generator /app

WORKDIR /app

RUN npm i

COPY ./ts.sh /usr/bin/gen