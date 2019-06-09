FROM debian:stretch-slim

ARG BITCOIN_VERSION=0.18.0
ARG USER_ID=1000

RUN set -ex \
    && apt-get update \
    && apt-get install -qq --no-install-recommends ca-certificates dirmngr gosu gpg wget procps \
    && rm -rf /var/lib/apt/lists/*

# install bitcoin binaries
RUN set -ex \
    && BITCOIN_ARCHIVE=bitcoin-${BITCOIN_VERSION}-$(uname -m)-linux-gnu.tar.gz \
    && cd /tmp \
    && wget -q https://bitcoincore.org/bin/bitcoin-core-${BITCOIN_VERSION}/${BITCOIN_ARCHIVE} \
    && wget -q https://bitcoincore.org/bin/bitcoin-core-${BITCOIN_VERSION}/SHA256SUMS.asc \
    && wget -q https://bitcoin.org/laanwj-releases.asc \
    && SHA256=`grep "${BITCOIN_ARCHIVE}" SHA256SUMS.asc | awk '{print $1}'` \
    && echo "$SHA256 ${BITCOIN_ARCHIVE}" | sha256sum -c - \
    && gpg --no-tty  --import ./laanwj-releases.asc \
    && gpg --no-tty  --verify SHA256SUMS.asc \
    && tar -xzf ${BITCOIN_ARCHIVE} -C /usr/local --strip-components=1 --exclude=*-qt \
    && rm -rf /tmp/* \
    && bitcoind --version    

# create user and data directory
RUN set -ex \
    && adduser --disabled-password --home /data --uid ${USER_ID} bitcoin --quiet 

ADD docker-entrypoint.sh /

# mainnet and testnet ports (rpc, http)
EXPOSE 8332 8333

# mainnet and testnet zmq interfaces (block, tx)
EXPOSE 18332 18333 28332 28333

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["bitcoind", "-datadir=/data"]
