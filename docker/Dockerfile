FROM golang:1.17-buster
ARG SVC

RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && dpkg-reconfigure -f noninteractive tzdata

WORKDIR /release

COPY build/${SVC} server

CMD ["/release/server"]

# ENTRYPOINT ["/bin/sh", "-c", "while true;do echo hello docker;sleep 1;done"]