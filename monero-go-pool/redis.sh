#!/bin/sh

sed -i -e 's/^daemonize yes/daemonize no/' /etc/redis/redis.conf
sed -i -e 's/^bind.*/bind 127.0.0.1/' /etc/redis/redis.conf
sed -i -e 's/^logfile.*//' /etc/redis/redis.conf
sed -i -e 's/^save 900 1/save 300 1/' /etc/redis/redis.conf
sed -i -e 's/^save 300 10/save 60 10/' /etc/redis/redis.conf
sed -i -e 's/^save 60 10000/save 30 1/' /etc/redis/redis.conf
sed -i -e 's/^dir \/var\/lib\/redis/dir \/redis/' /etc/redis/redis.conf

chown -R redis:redis /redis

exec /sbin/setuser redis /usr/bin/redis-server /etc/redis/redis.conf 2>&1

