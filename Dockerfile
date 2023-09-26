FROM golang:alpine AS build
RUN apk add build-base git
WORKDIR /src
COPY . .
RUN go mod tidy
RUN CGO_ENABLED=1 go build -ldflags="-s -w" -o ./zbpd

FROM alpine:latest
RUN apk add --no-cache ca-certificates tzdata && \
    update-ca-certificates 
WORKDIR  /data
COPY --from=build /src/./zbpd /usr/local/bin/zbpd
ENTRYPOINT ["/usr/local/bin/zbpd", "-c", "./config.json"]