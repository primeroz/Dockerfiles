#!/bin/sh

exec /sbin/setuser root /bitmonerod/monerod --data-dir /monero --rpc-bind-ip 127.0.0.1  2>&1
