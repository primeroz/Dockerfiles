#!/bin/bash
set -e

mkdir -p "$MONERO_DATA"

if [[ ! -f "$MONERO_DATA/monero.conf" ]]; then
	cat <<-EOF > "$MONERO_DATA/monero.conf"
        data-dir=/data
        log-level=1
        rpc-bind-ip=${RPC_BIND_ADDRESS:-127.0.0.1}
	rpc-login=${RPC_USER}:${RPC_PASSWORD}
	EOF
	chown monero:monero "$MONERO_DATA/monero.conf"
fi

# ensure correct ownership and linking of data directory
# we do not update group ownership here, in case users want to mount
# a host directory and still retain access to it
chown -R monero "$MONERO_DATA"
chown -h monero:monero "$MONERO_DATA"

exec gosu monero "$@" 2>&1

