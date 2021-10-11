# 定义 变量
DOCKER_IMAGE_NAME_PREFIX ?= haobird
BUILD_DIR = build
CGO_ENABLED ?= 0
GOARCH ?= amd64
SERVICES = test demo
VERSION = latest

# 定义函数

# 编译服务二进制文件
define compile_service
	$(eval svc=$(subst compile_,,$(1)))
	CGO_ENABLED=$(CGO_ENABLED) GOOS=$(GOOS) GOARCH=$(GOARCH) GOARM=$(GOARM) go build -ldflags "-s -w" -o ${BUILD_DIR}/$(svc) cmd/$(svc)/main.go
endef

# 构建服务镜像
define make_docker
	$(eval svc=$(subst docker_,,$(1)))

	echo docker build \
		--no-cache \
		--build-arg SVC=$(svc) \
		--build-arg GOARCH=$(GOARCH) \
		--build-arg GOARM=$(GOARM) \
		--tag=$(DOCKER_IMAGE_NAME_PREFIX)/$(svc) \
		-f docker/Dockerfile.dev .
endef

# 推送docker镜像
define docker_push
	$(eval svc=$(subst release_,,$(1)))
	$(eval image = $(DOCKER_IMAGE_NAME_PREFIX)/$(svc))
	@echo $(image)
	# 更改标签
	# docker tag $(image) $(image):$(2);
	# 推送镜像
	# docker push $(image):$(2);
endef

# 批量添加变量前缀
DOCKERS = $(addprefix docker_,$(SERVICES))
COMPILES = $(addprefix compile_,$(SERVICES))
RELEASES = $(addprefix release_,$(SERVICES))

print:
	echo $(DOCKERS)
	echo $(SERVICES)


# 服务命令
$(COMPILES):
	$(call compile_service,$(@))

$(DOCKERS):
	$(call make_docker,$(@),$(GOARCH))

$(RELEASES):
	$(call docker_push,$(@),$(VERSION))


# 发布运行环境镜像
docker_golang:
	$(eval svc=golang)
	$(eval version = develop-1.17)
	docker build --no-cache --tag=$(DOCKER_IMAGE_NAME_PREFIX)/$(svc) -f docker/builder/Dockerfile .
	docker tag $(DOCKER_IMAGE_NAME_PREFIX)/$(svc) $(DOCKER_IMAGE_NAME_PREFIX)/$(svc):$(version)
	docker push $(DOCKER_IMAGE_NAME_PREFIX)/$(svc):$(version)

# 
latest: dockers
	$(call docker_push,latest)

release:
	$(eval version = 11)
	$(eval version = $(shell git describe --abbrev=0 --tags))
	git checkout $(version)
	$(MAKE) dockers
	$(foreach svc, $(SERVICES), $(call docker_push,$$svc,$(version))) 

# 启动测试
run_booter:
	docker build --no-cache --tag=local/booter -f docker/booter/Dockerfile .
	docker run --name mybooter local/booter

# 运行测试
run_runner:

# 启动开发
run_dev:
	docker-compose -f docker/docker-compose.yml up

# 本地启动
run:
	docker-compose -f docker/docker-compose.yml up

# 清除所有none镜像
clean_none_docker:
	docker rmi $(docker images | grep "^<none>" | awk '{print $3}')