#!/bin/sh


if [[ -z ${TESTNET+x} ]]; then

	# Bootstrap from blockchain.raw
	cd /monero
	if [ ! -d "lmdb" ]; then
	        wget -c --progress=bar https://downloads.getmonero.org/blockchain.raw
	        /bitmonerod/monero-blockchain-import --verify 0 --input-file ./blockchain.raw --data-dir /monero
	        rm -f ./blockchain.raw
	fi


	exec /sbin/setuser root /usr/local/src/monero/bin/monerod --data-dir /monero --log-level=$LOG_LEVEL --p2p-bind-ip=$P2P_BIND_IP --p2p-bind-port=$P2P_BIND_PORT --rpc-bind-ip=$RPC_BIND_IP --rpc-bind-port=$RPC  2>&1
else
	exec /sbin/setuser root /usr/local/src/monero/bin/monerod --testnet-data-dir /monero --testnet --log-level=$LOG_LEVEL --p2p-bind-ip=$P2P_BIND_IP --p2p-bind-port=$P2P_BIND_PORT --rpc-bind-ip=$RPC_BIND_IP --rpc-bind-port=$RPC  2>&1
fi

