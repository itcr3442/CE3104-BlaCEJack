all: dist

build: $(wildcard src/**) $(wildcard assets/**)
	mkdir -p build
	raco exe -o build/blacejack src/main.rkt

dist: build
	raco distribute dist build/blacejack
