#!/usr/bin/env bash

chown -R hdfs:hadoop /hdfs

if [ ! -d /hdfs/nm/current ]; then
  runuser -u hdfs -- hdfs namenode -format
fi

exec /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf
