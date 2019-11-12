# run

docker run -d -v /mnt/bitcoind:/data -e RPCPASSWORD=$(pwgen -s -n -y 30 1)  -e BITCOIN_WALLET_DISABLE=true -e BITCOIN_DATA=/^Cta primeroz/bitcoind:0.18.1 
