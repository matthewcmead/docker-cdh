#########################################################################################
# This dockerfile is derived from loicmathieu/cloudera-cdh and will setup a hive
# metastore server.
#
#########################################################################################
FROM matthewcmead/cloudera-cdh:cdh-5.14.2

MAINTAINER matthewcmead

RUN yum -y install hive && rm -rf /var/cache/yum/*

#setup supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

#setup hive config
COPY hive-site.xml /etc/hive/conf/hive-site.xml

#setup mysql connector jar
COPY mysql-connector-java.jar /usr/lib/hive/lib

COPY startup.sh /startup.sh
RUN chmod 755 /startup.sh

ENV MYSQL_HOST=mysql
EXPOSE 9083

#start the supervisor
CMD ["/startup.sh"]
