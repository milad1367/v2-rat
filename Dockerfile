FROM golang:1.15.3-alpine3.12 AS builder
RUN apk upgrade \
    && apk add git \
    && GO111MODULE=on go get github.com/shadowsocks/v2ray-plugin@v1.3.1

FROM shadowsocks/shadowsocks-libev:v3.3.5 AS dist
COPY --from=builder /go/bin/v2ray-plugin /usr/bin/v2ray-plugin
CMD exec ss-server \
    -s $SERVER_ADDR \
    -p $SERVER_PORT \
    -k ${PASSWORD:-RtOHKvIHmu3CSYXLL} \
    -m $METHOD \
    -t $TIMEOUT \
    -d $DNS_ADDRS \
    -u \
    -v \
    --plugin v2ray-plugin \
    --plugin-opts "server" \
    $ARGS

