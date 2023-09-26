FROM golang:alpine AS build
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories
RUN apk add build-base git
WORKDIR /src
ARG TARGETARCH=amd64 VERSION=
COPY . .
RUN go build -ldflags="-s -w" -o ./zbpd

FROM alpine:latest
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories
RUN apk add --no-cache ca-certificates && \
    update-ca-certificates
WORKDIR  /data
COPY --from=build /src/./zbpd /usr/local/bin/zbpd
ENTRYPOINT ["/usr/local/bin/zbpd", "-c", "./config.json"]