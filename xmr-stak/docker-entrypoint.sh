#!/bin/bash
set -e

XMR_STAK_CURRENCY="${XMR_STAK_CURRENCY:-monero}"
XMR_STAK_AES_OVERRIDE="${XMR_STAK_AES_OVERRIDE:-true}"
XMR_STAK_DAEMON_MODE="${XMR_STAK_DAEMON_MODE:-false}"
XMR_STAK_FLUSH_STDOUT="${XMR_STAK_FLUSH_STDOUT:-false}"
XMR_STAK_THREADS="${XMR_STAK_THREADS:-1}"
XMR_STAK_USE_SLOW_MEMORY="${XMR_STAK_USE_SLOW_MEMORY:-warn}"
XMR_STAK_NICEHASH_NONCE="${XMR_STAK_NICEHASH_NONCE:-false}"
XMR_STAK_USE_TLS="${XMR_STAK_USE_TLS:-false}"
XMR_STAK_TLS_SECURE_ALGO="${XMR_STAK_TLS_SECURE_ALGO:-true}"
XMR_STAK_TLS_FINGERPRINT="${XMR_STAK_TLS_FINGERPRINT}"
XMR_STAK_POOL_PASSWORD="${XMR_STAK_POOL_PASSWORD}"
XMR_STAK_CALL_TIMEOUT="${XMR_STAK_CALL_TIMEOUT:-10}"
XMR_STAK_RETRY_TIME="${XMR_STAK_RETRY_TIME:-30}"
XMR_STAK_GIVEUP_LIMIT="${XMR_STAK_GIVEUP_LIMIT:-0}"
XMR_STAK_HTTPD_PORT="${XMR_STAK_HTTPD_PORT:-0}"
XMR_STAK_PREFER_IPV4="${XMR_STAK_PREFER_IPV4:-true}"

if [ -z "$XMR_STAK_POOL_ADDRESS" ]; then
  echo "SPECIFY POOL ADDRESS: XMR_STAK_POOL_ADDRESS : i.e. monerohash.com:3333"
  exit 1
fi

if [ -z "$XMR_STAK_WALLET_ADDRESS" ]; then
  echo "SPECIFY WALLET ADDRESS: XMR_STAK_WALLET_ADDRESS : i.e. AABBCC..."
  exit 1
fi

rm -f /tmp/config.txt
touch /tmp/config.txt
rm -f /tmp/cpu.txt
touch /tmp/cpu.txt

echo "\"cpu_threads_conf\" :" >> /tmp/cpu.txt
echo "[" >> /tmp/cpu.txt

COUNTER=0
for cpu in `seq 1 $XMR_STAK_THREADS`
do

  echo "{ \"low_power_mode\" : false, \"no_prefetch\" : true, \"affine_to_cpu\" : $COUNTER }," >> /tmp/cpu.txt
  COUNTER=$((COUNTER + 1)) 

done

echo "]," >> /tmp/cpu.txt
echo "\"use_slow_memory\" : \"$XMR_STAK_USE_SLOW_MEMORY\"," >> /tmp/config.txt

echo "\"tls_secure_algo\" : $XMR_STAK_TLS_SECURE_ALGO," >> /tmp/config.txt


echo "\"pool_list\" : [ { " >> /tmp/config.txt
echo " \"pool_address\": \"$XMR_STAK_POOL_ADDRESS\"," >> /tmp/config.txt
echo " \"wallet_address\" : \"$XMR_STAK_WALLET_ADDRESS\"," >> /tmp/config.txt
echo " \"pool_password\" : \"$XMR_STAK_POOL_PASSWORD\"," >> /tmp/config.txt
echo " \"pool_weight\" : 1," >> /tmp/config.txt
echo " \"use_nicehash\" : $XMR_STAK_NICEHASH_NONCE," >> /tmp/config.txt
echo " \"use_tls\" : $XMR_STAK_USE_TLS," >> /tmp/config.txt
echo " \"tls_fingerprint\" : \"$XMR_STAK_TLS_FINGERPRINT\"," >> /tmp/config.txt
echo " } ] ," >> /tmp/config.txt
echo "\"currency\" : \"$XMR_STAK_CURRENCY\"," >> /tmp/config.txt

echo "\"call_timeout\" : $XMR_STAK_CALL_TIMEOUT," >> /tmp/config.txt
echo "\"retry_time\" : $XMR_STAK_RETRY_TIME," >> /tmp/config.txt
echo "\"giveup_limit\" : $XMR_STAK_GIVEUP_LIMIT," >> /tmp/config.txt
echo "\"aes_override\" : $XMR_STAK_AES_OVERRIDE," >> /tmp/config.txt
echo "\"daemon_mode\" : $XMR_STAK_DAEMON_MODE," >> /tmp/config.txt
echo "\"flush_stdout\" : $XMR_STAK_FLUSH_STDOUT," >> /tmp/config.txt


echo "\"verbose_level\" : 4," >> /tmp/config.txt
echo "\"print_motd\" : true," >> /tmp/config.txt
echo "\"httpd_port\" : 0," >> /tmp/config.txt
echo "\"http_login\" : \"\"," >> /tmp/config.txt
echo "\"http_pass\" : \"\"," >> /tmp/config.txt
echo "\"prefer_ipv4\" : true," >> /tmp/config.txt
echo "\"h_print_time\" : 60," >> /tmp/config.txt
echo "\"output_file\" : \"/dev/stdout\"," >> /tmp/config.txt

echo "\"httpd_port\" : $XMR_STAK_HTTPD_PORT," >> /tmp/config.txt
echo "\"prefer_ipv4\" : $XMR_STAK_PREFER_IPV4," >> /tmp/config.txt

#exec gosu monero xmr-stak-cpu /tmp/config.txt
exec xmr-stak -c /tmp/config.txt --cpu /tmp/cpu.txt
#sleep 3600

