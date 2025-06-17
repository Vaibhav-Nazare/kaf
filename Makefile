DOCKER_CMD ?= docker
DOCKER_REGISTRY ?= docker.io
DOCKER_ORG ?= $(USER)
DOCKER_NAME ?= kaf
DOCKER_TAG ?= latest
BUILD_TAG ?= latest

BINARY_NAME = kaf
SOURCE_PATH = ./cmd/kaf
BUILD_DIR = build
GOOS ?= linux
ARCHES = amd64 arm64 ppc64le

.PHONY: build clean cross-build docker-build install release run-kafka $(ARCHES)

amd64 arm64 ppc64le:
	GOOS=${GOOS} GOARCH=$@ go build -ldflags "-w -s" -o ${BUILD_DIR}/${BINARY_NAME}-${GOOS}-$@ ${SOURCE_PATH}

build:
	go build -ldflags "-w -s" -o ${BINARY_NAME} ${SOURCE_PATH}

clean:
	rm -rf ${BUILD_DIR} ${BINARY_NAME}

cross-build: $(ARCHES)

docker-build:
	${DOCKER_CMD} build -t ${DOCKER_REGISTRY}/${DOCKER_ORG}/${DOCKER_NAME}:${DOCKER_TAG} .

install:
	go install -ldflags "-w -s" ${SOURCE_PATH}

release:
	goreleaser

run-kafka:
	docker-compose up -d
