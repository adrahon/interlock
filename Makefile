TAG?=latest
APP?=interlock
REPO?=ehazlett/$(APP)
COMPILE_IMAGE_SRC=$(shell find . -name Dockerfile.build)
export GO15VENDOREXPERIMENT=1

all: build

add-deps:
	@godep save
	@rm -rf Godeps

build:
	@cd interlock && go build -a -tags 'netgo' -ldflags "-w -X github.com/ehazlett/interlock/version.GITCOMMIT=$(COMMIT) -linkmode external -extldflags -static" .

clean:
	@rm -rf interlock/interlock

image: build
	@echo Building Interlock image $(TAG)
	@docker build -t $(REPO):$(TAG) .

release: build image
	@docker push $(REPO):$(TAG)

test: clean 
	@go test -v ./...

.SUFFIXES: .build
.PHONY: add-deps build clean release test