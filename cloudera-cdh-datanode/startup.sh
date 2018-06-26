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
if [ -d /hdfs/data ]; then
  slash_hdfs_slash_data_owner=$(ls -ld /hdfs/data | awk '/\/hdfs/ {print $3;}')
  slash_hdfs_slash_data_group=$(ls -ld /hdfs/data | awk '/\/hdfs/ {print $4;}')
  if [ "X$slash_hdfs_slash_data_owner" != "Xhdfs" ]; then
    dochown=1
  fi
  if [ "X$slash_hdfs_slash_data_group" != "Xhadoop" ]; then
    dochown=1
  fi
fi

if [ $dochown == 1 ]; then
  echo "chowning /hdfs recursively to hdfs:hadoop"
  chown -R hdfs:hadoop /hdfs
else
  echo "no need to chown /hdfs -- it is already owned by hdfs:hadoop"
fi

exec /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf
