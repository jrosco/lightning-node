#!/usr/bin/env bash

# exit from script if error was raised.
set -e

# Set default variables if needed.
RPCUSER=${RPCUSER:-bitcoin}
RPCPASS=${RPCPASS:-password}
DEBUG=${DEBUG:-info}
BTCD_DATA=${BTCD_DATA:-"/data/.btcd"}
LISTEN=${LISTEN:-"0.0.0.0"}

PARAMS=$(echo \
    "--debuglevel=$DEBUG" \
    "--rpcuser=$RPCUSER" \
    "--rpcpass=$RPCPASS" \
    "--datadir=${BTCD_DATA}" \
    "--logdir=${BTCD_DATA}" \
    "--configfile=${BTCD_DATA}/btcd.conf" \
    "--rpccert=${BTCD_DATA}/rpc.cert" \
    "--rpckey=${BTCD_DATA}/rpc.key" \
    "--rpclisten=${LISTEN}" \
    "--txindex"
)

if [[ ! -s "${BTCD_DATA}/btcd.conf" ]]; then
    mkdir -p ${BTCD_DATA}; touch ${BTCD_DATA}/btcd.conf
cat <<-EOF > "${BTCD_DATA}/btcd.conf"
EOF
    chown -R bitcoin:bitcoin "${BTCD_DATA}/"
fi

# Add user parameters to command.
PARAMS="$PARAMS $@"

# start bitcoin node.
exec su bitcoin -c "btcd $PARAMS"

