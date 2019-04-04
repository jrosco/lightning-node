FROM golang:1.11-alpine as builder

ARG LND_VERSION=v0.6-beta-rc2

# Force Go to use the cgo based DNS resolver. This is required to ensure DNS
# queries required to connect to linked containers succeed.
ENV GODEBUG netdns=cgo

# Install dependencies and install/build lnd.
RUN apk add --no-cache --update alpine-sdk \
  git \
  make

RUN git clone https://github.com/lightningnetwork/lnd /go/src/github.com/lightningnetwork/lnd \ 
  && cd /go/src/github.com/lightningnetwork/lnd \
  && git checkout tags/${LND_VERSION} \
  && make \
  && make install

# Start a new, final image to reduce size.
FROM alpine as final

# Copy the binaries and entrypoint from the builder image.
COPY --from=builder /go/bin/lncli /bin/
COPY --from=builder /go/bin/lnd /bin/

RUN addgroup -g 1000 bitcoin \
    && adduser -u 1000 -D -G bitcoin -h /data -s /bin/sh bitcoin

# Add bash.
RUN apk add --no-cache \
  bash

# Copy the entrypoint script.
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

# Expose lnd ports (server, rpc).
EXPOSE 9735 10009

ENTRYPOINT ["/docker-entrypoint.sh"]
