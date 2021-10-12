# 定义 变量
DOCKER_IMAGE_NAME_PREFIX ?= haobird
BUILD_DIR = build
CGO_ENABLED ?= 0
GOARCH ?= amd64
GOOS ?= linux
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
	echo $(svc)
	docker build \
		--no-cache \
		--build-arg SVC=$(svc) \
		--build-arg GOARCH=$(GOARCH) \
		--tag=$(DOCKER_IMAGE_NAME_PREFIX)/$(svc) \
		-f docker/builder/Dockerfile .
endef

# 推送docker镜像
define docker_push
	$(eval svc=$(subst release_,,$(1)))
	$(eval image = $(DOCKER_IMAGE_NAME_PREFIX)/$(svc))
	@echo $(image)
	# 更改标签
	docker tag $(image) $(image):$(2)
	# 推送镜像
	# docker push $(image):$(2)
endef

# 运行docker镜像
define docker_run
	$(eval svc=$(subst run_,,$(1)))
	$(eval image = $(DOCKER_IMAGE_NAME_PREFIX)/$(svc))
	docker run -it -d $(image)
endef

# 停止并

# 批量添加变量前缀
DOCKERS = $(addprefix docker_,$(SERVICES))
COMPILES = $(addprefix compile_,$(SERVICES))
RELEASES = $(addprefix release_,$(SERVICES))
RUNS = $(addprefix run_,$(SERVICES))

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

$(RUNS):
	$(eval svc=$(subst run_,,$(@)))
	$(call make_docker,$(svc),$(GOARCH))
	$(call docker_run,$(svc),$(VERSION))

# 发布运行环境镜像
release_golang:
	$(eval svc=golang)
	$(eval version = $(VERSION))
	docker build --no-cache --tag=$(DOCKER_IMAGE_NAME_PREFIX)/$(svc) -f docker/golang/Dockerfile .
	docker tag $(DOCKER_IMAGE_NAME_PREFIX)/$(svc) $(DOCKER_IMAGE_NAME_PREFIX)/$(svc):$(version)
	docker push $(DOCKER_IMAGE_NAME_PREFIX)/$(svc):$(version)

# 发布开发环境镜像
release_develop:
	$(eval svc=develop)
	$(eval version = $(VERSION))
	docker build --no-cache --tag=$(DOCKER_IMAGE_NAME_PREFIX)/$(svc) -f docker/develop/Dockerfile .
	docker tag $(DOCKER_IMAGE_NAME_PREFIX)/$(svc) $(DOCKER_IMAGE_NAME_PREFIX)/$(svc):$(version)
	docker push $(DOCKER_IMAGE_NAME_PREFIX)/$(svc):$(version)

# 构建所有服务镜像
dockers: $(DOCKERS)

# 推送最新版本
latest: dockers
	$(foreach svc, $(SERVICES), $(call docker_push,$$svc,latest)) 

# 运行所有服务镜像
runs: $(RUNS)

# 发布所有服务镜像
release:
	# 查询当前所在的 分支
	$(eval branch = $(shell git rev-parse --abbrev-ref HEAD))
	$(eval version = $(shell git describe --abbrev=0 --tags))
	@echo $(branch)-$(version)
	git checkout $(version)
	$(MAKE) dockers
	$(foreach svc, $(SERVICES), $(call docker_push,$$svc,$(version))) 
	@echo "还原回原Header"
	git checkout $(branch)

# 启动测试
runner:
	docker build --no-cache --tag=local/runner -f docker/runner/Dockerfile .
	docker run --name myrunner local/runner
	

boot: 
	docker-compose -f docker-compose.yml up

# 停止并删除 所有服务的容器
cleans:
	for svc in $(SERVICES); do \
		docker stop; \
	done

# 清除所有none镜像
clean_none_docker:
	docker rmi $(docker images | grep "^<none>" | awk '{print $3}')