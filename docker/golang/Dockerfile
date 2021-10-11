FROM golang:1.17-buster
LABEL maintainer="xyqbgn@126.com"

RUN sed -i 's#deb.debian.org#mirrors.aliyun.com#g' /etc/apt/sources.list &&\
    sed -i 's#security.debian.org#mirrors.aliyun.com#g' /etc/apt/sources.list &&\
    apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    wget \
    vim \
    htop \
    curl \
    sudo \
    git \
    net-tools \
    tzdata \
    && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && rm -rf /var/lib/apt/lists/*

ENV GOBIN=$GOPATH/bin
ENV GO111MODULE=on
ENV GOPROXY=https://goproxy.io,direct
ENV TZ=Asia/Shanghai

WORKDIR $GOPATH/src/app

# ENTRYPOINT ["go", "build"]