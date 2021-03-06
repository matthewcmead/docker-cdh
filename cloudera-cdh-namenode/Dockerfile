###########################################################################################
# This dockerfile is derived from loicmathieu/cloudera-cdh and will setup an HDFS namenode 
# and an HDFS secondarynamenode
#
# The namenode will expose it's 8020 port, to use it, you first need to start a datanode 
# (using loicmathieu/cloudera-hdfs-datanode) and make sure the netword stack is OK 
# so that the namenode and datanode can communicate together
#
# The container will use supervisor to start both the namenode and the secondarynamenode.
###########################################################################################
FROM matthewcmead/cloudera-cdh:cdh-5.14.2

MAINTAINER matthewcmead

#init namenode directory
RUN mkdir -p /hdfs/nm

#install the namenode stuff
RUN yum -y install hadoop-hdfs-namenode && rm -rf /var/cache/yum/*

#format the namenode
RUN hdfs namenode -format

#setup supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

#expose namenode port
EXPOSE 8020

#chown hdfs the namenode data
RUN chown -R hdfs:hadoop /hdfs

#define HDFS volume to enable to persist namenode fsimage between restart
VOLUME /hdfs

#startup script
COPY startup.sh /startup.sh
COPY setup_hdfs.sh /setup_hdfs.sh

#start the supervisor
CMD ["/startup.sh"]
