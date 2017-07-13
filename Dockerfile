FROM alpine:3.5 as builder

ADD . /go-ethereum

# target=all instead of geth
ARG MAKE_TARGET=all

RUN \
  apk add --update git go make gcc musl-dev linux-headers && \
  (cd go-ethereum && make $MAKE_TARGET)                   && \
  echo "Dockerfile builder stage finished."

FROM alpine:3.5

COPY --from=builder /go-ethereum/build/bin/* /usr/local/bin/

EXPOSE 8545
EXPOSE 30303
EXPOSE 30303/udp

ENTRYPOINT ["geth"]
