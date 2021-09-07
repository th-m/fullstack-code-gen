SHELL := /usr/bin/env bash -o pipefail
.PHONY: gen lint wbuf

api-gen:
	./generator/main-gen.sh ./proto

sqlc-gen:
	docker pull kjconroy/sqlc
	docker run --rm -v `pwd`:/src -w /src kjconroy/sqlc generate

lint:
	./buff-util.sh ./proto lint 

changes:
	./buff-util.sh ./proto breaking --against '.git#branch=master'

wbuf:
	./buff-util.sh