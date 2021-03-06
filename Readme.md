# 项目说明

## 项目启动

```
① 使用官方的 golang 镜像执行文件
docker-compose up 
② 使用本地自定义的镜像 执行文件
docker-compose -f dev.yml up 
```

## 引入本地包目录

```
# 类似
import "starter/module"
```

## 包名管理

本地包名可以修改 go.mod实现。
如果要更改为github 的路径，可以使用类似 "github.com/haobird/peajob" 做包名，参考 go.mod1


## 发布基础运行时镜像golang

```
make docker_golang
```
## 自动构建

### 编译单个服务二进制代码

```
make compile_demo
```

### 构建单个服务镜像

```
make docker_demo
```

### 构建所有服务镜像

```
make dockers
```

### 发布单个服务镜像

```
# 如果不传入VERSION 参数，则默认为 latest
make release_demo VERSION=V1.4
```

### 基于最新tag，发布所有服务镜像

```
make release
```

### 发布golang基础环境

```
make release_golang VERSION=develop-1.17
```

### 发布开发环境镜像

```
make release_develop VERSION=latest
```

### 容器运行单个服务

```
make run_demo
```

### 运行所有服务镜像

```
make runs
```

### 运行容器测试

```
make runner
```

### 本地启动

```
make boot
```




## test

