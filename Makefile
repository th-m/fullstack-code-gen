SHELL := /usr/bin/env bash -o pipefail
.PHONY: gen lint wbuf

gen:
	./generator/main-gen.sh ./proto

lint:
	./buff-util.sh ./proto lint 

changes:
	./buff-util.sh ./proto breaking --against '.git#branch=master'

wbuf:
	./buff-util.sh