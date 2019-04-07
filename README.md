# Lightning Node Docker Container Stack

Repo for spinning up your own Lightning Node Stack (bitcoind, lnd, neutrino)

Bitcoin (bitcoind) Container 
---
See [Dockerfile](./docker/bitcoind/Dockerfile)
### Dockerfile Argument Values
|Key|Default Values|Info|
|---|---|---|
|BITCOIN_VERSION|0.17.0.1|Bitcoin version to use|
|USER_ID|1000|The run container as bitcoin UID. Make this the same as the local directory UID permissions |

### Container Environment Values
-----
|Key|Default Values|Info|
|---|---|---|
|BITCOIN_RPC_ALLOWED|127.0.0.1|RPC Whitelist IPs addresses|
|BITCOIN_RPC_USER|bitcoin|The Bitcoin RPC user|
|BITCOIN_RPC_PASSWORD|password |The Bitcoin RPC password|
|BITCOIN_RPC_PORT|8332|Bitcoin RPC Port |
|BITCOIN_SERVER|1|Enable/Disable Bitcoin server|
|LISTEN|1|Enable/Disable bitcoin to listen|
|BITCOIN_TESTNET|1|Enable/Disable testnet|
|ZMQ_PUB_RAW_TX|tcp://127.0.0.1:28332|The ZeroMQ raw publisher transactions URL|
|ZMQ_PUB_RAW_BLK|tcp://127.0.0.1:28333|The ZeroMQ raw publisher blocks URL|
---
### Docker Build
---
```bash
docker build -t bitcoind .
```
Build with differnet Bitcoin version
```bash
docker build --build-arg BITCOIN_VERSION=0.16.3 -t bitcoind .
```
Build with different UID
```bash
docker build --build-arg USER_ID=1001 -t bitcoind .
```
---
Run bitcoind

```bash
docker run --name bitcoind -d \
    -v {local.bitcoin.dir}:/data \
    -p 0.0.0.0:9735:9735 \
    -p 127.0.0.1:28332:28332 \
    -p 127.0.0.1:28333:28333 \
    bitcoind
```

Lightning (lnd) Container
---
See [Dockerfile](./docker/lnd/Dockerfile)
### Dockerfile Argument Values
|Key|Default Values|Info|
|---|---|---|
|LND_VERSION|v0.5.2-beta|Lightning version to use|
|USER_ID|1000|The run container as bitcoin UID. Make this the same as the local directory UID permissions|

### Container Environment Values

|Key|Default Values|Info|
|---|---|---|
|BITCOIN_RPC_USER|bitcoin|The Bitcoin RPC user|
|BITCOIN_RPC_PASSWORD|password |The Bitcoin RPC password|
|DEBUG|info|Logging level|
|NETWORK|testnet|Which network to use (testnet,simnet,mainnet)|
|CHAIN|bitcoin|Which blockchain to use (bitcoin,litecoin)|
|BACKEND|bitcoind|Which backend to use (bitcoind,btcd,litecoind,ltcd,neutrino )|
|ZMQ_PUB_RAW_TX|tcp://127.0.0.1:28332|The ZeroMQ raw publisher transactions URL|
|ZMQ_PUB_RAW_BLK|tcp://127.0.0.1:28333|The ZeroMQ raw publisher blocks URL|
|LIGHTNING_DATA|/data/.lnd|The Lightning .lnd directory location|

### Docker Build
---

```bash
docker build -t lnd .
```
Build with differnet Lightning version
```bash
docker build --build-arg LND_VERSION=v0.5-beta -t lnd .
```
Build with different UID
```bash
docker build --build-arg USER_ID=1001 -t lnd .
```
---
Run Lightning with Bitcoin Backend

```bash
docker run --rm --name lnd --network container:bitcoind -d \
    -v {local.bitcoin.dir}:/data \
    -v :/data/.lnd \
    lnd
```
Run Lightning with Neutrino Backend

```bash
docker run --rm --name lnd -d \
    -e BACKEND=neutrino \
    -v {local.lightning.dir}:/data \
    -v :/data/.lnd \
    lnd
```

Build you own LND certificate:

---

```bash
cd ~/.lnd
openssl ecparam -genkey -name prime256v1 -out tls.key
openssl req -new -sha256 -key tls.key -out csr.csr -subj '/CN=localhost/O=lnd'
openssl req -x509 -sha256 -days 36500 -key tls.key -in csr.csr -out tls.cert
rm csr.csr
```