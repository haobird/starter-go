FROM golang:1.15.3-alpine as builder
ARG SVC
ARG GOARCH
ARG GOARM

WORKDIR /usr/src/app
ENV GOPROXY=https://goproxy.cn
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories && \
  apk add --no-cache upx ca-certificates tzdata

COPY . .
RUN apk update \
    && apk add make

RUN CGO_ENABLED=0 go build -ldflags "-s -w" -o server cmd/$SVC/main.go \
    && mv server /server

FROM scratch as runner
COPY --from=builder /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=builder /server /
ENTRYPOINT ["/server"]