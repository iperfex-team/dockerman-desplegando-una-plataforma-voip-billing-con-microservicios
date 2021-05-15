DOCKER ?= docker
TARGET ?= cnsoluciones/a2b-voip:13.38.2

all:
	@echo "Building ${TARGET}"
	$(DOCKER) build -t $(TARGET) -f Dockerfile .

