#!/bin/sh

if [ -z "${TESTNET}" ]; then
				exec /sbin/setuser root /usr/local/src/monero/bin/monero-wallet-rpc --trusted-daemon --wallet-file /monero/$WALLET_FILE --password $WALLET_PASSWORD --rpc-bind-port=$WALLET_RPC_BIND_PORT --disable-rpc-login --rpc-bind-ip=$WALLET_RPC_BIND_IP 2>&1

else
				exec /sbin/setuser root /usr/local/src/monero/bin/monero-wallet-rpc --testnet --trusted-daemon --wallet-file /monero/$WALLET_FILE --password $WALLET_PASSWORD --rpc-bind-port=$WALLET_RPC_BIND_PORT --disable-rpc-login --rpc-bind-ip=$WALLET_RPC_BIND_IP 2>&1
fi

