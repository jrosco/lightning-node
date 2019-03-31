FROM golang:1.10-alpine as builder

# ARG VERSION=0.12.0-beta

# install build dependencies such as git and glide.
RUN apk add --no-cache \
    git 

# grab and install the latest version of of btcd and all related dependencies.
RUN go get -u -v github.com/btcsuite/btcd/...

# start a new image
FROM alpine as final

ARG USER_ID=1000

# expose mainnet ports (server, rpc)
EXPOSE 8333 8334

# expose testnet ports (server, rpc)
EXPOSE 18333 18334

# expose simnet ports (server, rpc)
EXPOSE 18555 18556

# expose segnet ports (server, rpc)
EXPOSE 28901 28902

# copy the compiled binaries from the builder image.
COPY --from=builder /go/bin/addblock /bin/
COPY --from=builder /go/bin/btcctl /bin/
COPY --from=builder /go/bin/btcd /bin/
COPY --from=builder /go/bin/findcheckpoint /bin/
COPY --from=builder /go/bin/gencerts /bin/

COPY "docker-entrypoint.sh" .

# create user and data directory
RUN addgroup -g ${USER_ID} bitcoin \
  && adduser -u ${USER_ID} -D -G bitcoin -h /data -s /bin/sh bitcoin
  
RUN apk add --no-cache \
    bash \
    ca-certificates \
&&  mkdir -p "/data/.btcd" \
&&  touch "/data/.btcd/btcd.conf" \
&&  chmod +x /docker-entrypoint.sh \
# manually generate certificate and add all domains, it is needed to connect
# "btcctl" and "lnd" to "btcd" over docker links.
&& "/bin/gencerts" --host="*" --directory="/data/.btcd" --force

# create a volume to house pregenerated RPC credentials. This will be
# shared with any lnd, btcctl containers so they can securely query btcd's RPC
# server.
# you should NOT do this before certificate generation!
# otherwise manually generated certificate will be overridden with shared
# mounted volume! For more info read dockerfile "VOLUME" documentation.
VOLUME ["/data/.btcd"]

ENTRYPOINT [ "/docker-entrypoint.sh" ]
CMD ["--datadir=/data/.btcd"]
