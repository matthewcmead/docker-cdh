#!/usr/bin/env bash

chown -R hdfs:hadoop /hdfs

exec /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf
