#!/usr/bin/env bash

sed -i.bak "s/MYSQL_HOST/${MYSQL_HOST}/g" /etc/hive/conf/hive-site.xml

done=0
while [ $done == 0 ]; do
  /usr/lib/hive/bin/schematool -dbType mysql -validate || /usr/lib/hive/bin/schematool -dbType mysql -initSchema
  if [ $? == 0 ]; then
    done=1
  fi
  sleep 5
done


exec /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf

