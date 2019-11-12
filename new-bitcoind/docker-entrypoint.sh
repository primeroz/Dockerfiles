#!/bin/sh
set -e
set -x

if [ $(echo "$1" | cut -c1) = "-" ]; then
  echo "$0: assuming arguments for bitcoind"

  set -- bitcoind "$@"
fi

if [ $(echo "$1" | cut -c1) = "-" ] || [ "$1" = "bitcoind" ]; then
  mkdir -p "$BITCOIN_DATA"
  chmod 700 "$BITCOIN_DATA"

  if [ ! -f "$BITCOIN_DATA/bitcoin.conf" ]; then
    cat > $BITCOIN_DATA/bitcoin.conf << EOF
# https://github.com/bitcoin/bitcoin/blob/master/share/examples/bitcoin.conf
printtoconsole=1

port=8333

# enables JSON-RPC interface;
server=1
rpcport=8332
#rpcconnect=127.0.0.1

rpcallowip=::/0
rpcpassword=${RPCPASSWORD:-password}
rpcuser=${RPCUSER:-bitcoin}
# actually use rpcauth
# rpcauth=

# enables REST interface on 127.0.0.1:8332;
# rest=1

walletrbf=1
txindex=1

# magic RBP optimisations
maxconnections=40
maxuploadtarget=5000

# RBP without swap
dbcache=100
maxorphantx=10
maxmempool=50
EOF
  fi

  chown -R bitcoin "$BITCOIN_DATA"

  echo "$0: setting data directory to $BITCOIN_DATA"

  EXTRA_ARGS=""
  if [ "x${BITCOIN_DISABLE_WALLET}" = "xtrue" ]; then
    EXTRA_ARGS="$EXTRA_ARGS -disablewallet" 
  fi
  set -- "$@" -datadir="$BITCOIN_DATA"
fi

if [ "$1" = "bitcoind" ] || [ "$1" = "bitcoin-cli" ] || [ "$1" = "bitcoin-tx" ]; then
  echo
  exec gosu bitcoin "$@"
fi

echo
exec "$@"
