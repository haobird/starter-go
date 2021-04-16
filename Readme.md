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
