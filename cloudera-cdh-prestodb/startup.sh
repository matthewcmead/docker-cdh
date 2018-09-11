#!/usr/bin/env bash

presto_server_dir=/presto/presto-server-0.210
presto_uuid_file=/presto/data/.uuid
presto_spill_dir=/presto/data/spill

if [ ! -f ${presto_uuid_file} ]; then
  uuidgen >${presto_uuid_file}
  chown presto:presto ${presto_uuid_file}
fi
  
PRESTO_UUID=$(cat ${presto_uuid_file})

sed -i.bak "s/PRESTO_ID/${PRESTO_UUID}/g" ${presto_server_dir}/etc/node.properties

if [ ! -d ${presto_spill_dir} ]; then
  mkdir -p ${presto_spill_dir}
  chown -R presto:presto ${presto_spill_dir}
fi

#exec ${presto_server_dir}/bin/launcher start

exec /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf
