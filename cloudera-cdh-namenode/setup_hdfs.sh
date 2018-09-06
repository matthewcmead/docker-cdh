#!/usr/bin/env bash

#drwxrwxrwt   - hdfs supergroup          0 2018-06-26 11:59 /tmp

isdone=0
hdfs_active=0

function setup_dir {
  dir="$1"
  user="$2"
  group="$3"
  modelist="$4"
  modechmod="$5"
  (
  set -e

  dir_listing="$(hdfs dfs -ls -d "$dir")"
  if [ $? == 0 ]; then
    dir_owner=$(echo "$dir_listing" | awk '{print $3;}')
    dir_group=$(echo "$dir_listing" | awk '{print $4;}')
    dir_mode=$(echo "$dir_listing" | awk '{print $1;}')
    if [ "X$dir_owner" != "X$user" ]; then
      HADOOP_USER_NAME=hdfs hdfs dfs -chown $user $dir
    fi
    if [ "X$dir_group" != "X$group" ]; then
      HADOOP_USER_NAME=hdfs hdfs dfs -chown :$group $dir
    fi
    if [ "X$dir_mode" != "X$modelist" ]; then
      HADOOP_USER_NAME=hdfs hdfs dfs -chmod $modechmod $dir
    fi
  else
    HADOOP_USER_NAME=hdfs hdfs dfs -mkdir $dir
    HADOOP_USER_NAME=hdfs hdfs dfs -chown $user:$group $dir
    HADOOP_USER_NAME=hdfs hdfs dfs -chmod $modechmod $dir
  fi
  )
}

while [ $isdone == 0 ]; do
  if [ $hdfs_active == 0 ]; then
    hdfs dfs -ls -d / >/dev/null 2>&1
    if [ $? == 0 ]; then
      hdfs_active=1
    fi
  fi
  if [ $hdfs_active == 1 ]; then
    setup_dir /tmp hdfs hadoop drwxrwxrwt 1777 || exit 1
    setup_dir /user hdfs hadoop drwxr-xr-x 0755 || exit 1
    setup_dir /tmp/hadoop-yarn yarn hadoop drwxrwxrwt 1777 || exit 1
    setup_dir /tmp/hadoop-yarn/fail yarn hadoop drwxrwxrwt 1777 || exit 1
    setup_dir /tmp/hadoop-yarn/staging yarn hadoop drwxrwxrwt 1777 || exit 1
    setup_dir /tmp/hadoop-yarn/staging/history yarn hadoop drwxrwxrwt 1777 || exit 1
    setup_dir /tmp/hadoop-yarn/staging/history/done yarn hadoop drwxrwxrwt 1777 || exit 1
    setup_dir /tmp/hadoop-yarn/staging/history/done_intermediate yarn hadoop drwxrwxrwt 1777 || exit 1
    exit 0
  fi
  sleep 5
done

