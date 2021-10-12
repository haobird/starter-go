FROM ubuntu:20.04
LABEL maintainer="xyqbgn@126.com"

RUN sed -i "s/archive\.ubuntu\.com/mirrors.aliyun.com/g" /etc/apt/sources.list
RUN apt-get update 
RUN apt-get install -y software-properties-common 
RUN apt-get install -y language-pack-en
RUN locale-gen en_US.UTF-8
RUN export LANG=en_US.UTF-8
RUN apt-get update
RUN apt-get install -y --no-install-recommends ca-certificates 

# 设置时区
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
ENV TZ=Asia/Shanghai

# 增加工作目录
ENV HOME  "/www"
RUN mkdir ${HOME}
WORKDIR ${HOME}/

# 安装开发工具
RUN apt-get install -y wget vim htop curl sudo git inetutils-ping supervisor gcc make 

# 安装 ffmpeg 并 验证版本
RUN apt-get install -y ffmpeg
RUN ffmpeg -version

# 安装golang https://golang.google.cn/dl/go1.17.linux-amd64.tar.gz
RUN wget -c https://golang.google.cn/dl/go1.17.linux-amd64.tar.gz -O - | sudo tar -xz -C /usr/local
ENV PATH=$PATH:/usr/local/go/bin
ENV GOBIN=$GOPATH/bin
ENV GO111MODULE=on
ENV GOPROXY=https://goproxy.io,direct

# 安装node
# RUN curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -
# RUN apt install -y nodejs
# RUN npm i -g @langhuihui/monica --unsafe-perm=true

# 清除安装包
# RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENTRYPOINT ["/bin/sh", "-c", "while true;do echo hello docker;sleep 1;done"]