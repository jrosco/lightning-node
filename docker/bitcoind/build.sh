#!/bin/sh

BTC_VERSION=$(grep 'ARG BITCOIN_VERSION' Dockerfile | cut -d= -f2)

docker build -t jr0sco/bitcoind .
docker build -t jr0sco/bitcoind:${BTC_VERSION} .

docker push jr0sco/bitcoind
docker push jr0sco/bitcoind:${BTC_VERSION}
