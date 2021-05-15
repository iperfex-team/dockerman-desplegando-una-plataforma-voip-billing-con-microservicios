DOCKER ?= docker
TARGET ?= cnsoluciones/a2b-http-admin:2.2.0

all:
	@echo "Building ${TARGET}"
	$(DOCKER) build -t $(TARGET) -f Dockerfile .

