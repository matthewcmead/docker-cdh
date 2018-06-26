#!/usr/bin/env bash

slash_hdfs_owner=$(ls -ld /hdfs | awk '/\/hdfs/ {print $3;}')
slash_hdfs_group=$(ls -ld /hdfs | awk '/\/hdfs/ {print $4;}')
dochown=0
if [ "X$slash_hdfs_owner" != "Xhdfs" ]; then
  dochown=1
fi
if [ "X$slash_hdfs_group" != "Xhadoop" ]; then
  dochown=1
fi
if [ -d /hdfs/nm ]; then
  slash_hdfs_slash_nm_owner=$(ls -ld /hdfs/nm | awk '/\/hdfs/ {print $3;}')
  slash_hdfs_slash_nm_group=$(ls -ld /hdfs/nm | awk '/\/hdfs/ {print $4;}')
  if [ "X$slash_hdfs_slash_nm_owner" != "Xhdfs" ]; then
    dochown=1
  fi
  if [ "X$slash_hdfs_slash_nm_group" != "Xhadoop" ]; then
    dochown=1
  fi
fi

if [ $dochown == 1 ]; then
  echo "chowning /hdfs recursively to hdfs:hadoop"
  chown -R hdfs:hadoop /hdfs
else
  echo "no need to chown /hdfs -- it is already owned by hdfs:hadoop"
fi

if [ ! -d /hdfs/nm/current ]; then
  runuser -u hdfs -- hdfs namenode -format
fi

/setup_hdfs.sh &
disown %1

exec /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf
