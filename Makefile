SHELL = /bin/sh
.PHONY: all build clean deps html install
VERSION?=1.0

# We only care about tex files at the moment so clear and explictly denote that
.SUFFIXES:
.SUFFIXES: .tex

# Set the src directory. You can overwrite this by setting your build command
# to `make srcdir=path <target>`
ifndef srcdir
srcdir=latex
endif

default: all

all: lint build

.PHONY: docker-build
docker-build:
	docker build -t ma-thesis:$(VERSION) Docker

# build everything supported
build: pdf

# delete all files used for building
# this is a hack, the build should be done in a tmp directory and the pdf/html
# files moved to a more permanent location
clean:
	@cd latex
	@rm *.aux *.log *.out *.toc ./build_log* *.lo?
	@cd ..

.PHONY: lint
lint:
	@docker run \
		--rm \
		-ti \
		-v $(shell pwd):/guide:rw \
		-w /guide \
		--hostname master-thesis \
		ma-thesis:$(VERSION) \
		/bin/sh -c "chktex ${srcdir}/*.tex; exit 0"

.PHONY: pdf
pdf:
	@docker run \
		--rm \
		-ti \
		-v $(shell pwd):/guide:rw \
		-w /guide/latex \
		--hostname master-thesis \
		ma-thesis:$(VERSION) \
		/bin/sh -c "pdflatex -output-directory=/guide -jobname=master-thesis \
			${srcdir}/master.tex 1>./build_log; \
			pdflatex -output-directory=/guide -jobname=master-thesis \
			${srcdir}/master.tex 1>>./build_log"

#:set ts=2
#:set noet
#:%retab!
