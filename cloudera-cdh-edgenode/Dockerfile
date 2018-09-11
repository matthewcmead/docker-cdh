#########################################################################################
# This dockerfile is derived from loicmathieu/cloudera-cdh and will setup an edge node to
# works with the other cloudera containers.
# It also contains some pig/hive script and CSV test files to start with
#
#########################################################################################
FROM matthewcmead/cloudera-cdh:cdh-5.14.2

MAINTAINER matthewcmead

#install pig, hive, flume and scoop 
RUN yum -y install pig hive flume-ng sqoop2 spark-worker && rm -rf /var/cache/yum/*

#copy test data and script
#COPY cities.* /

#copy flume conf and start scripts
#COPY flume/* /
#RUN chmod +x /start_flume.sh

COPY hive-site.xml /etc/hive/conf/hive-site.xml

#create a staging disk to send/get data to/from the clusrer
#RUN mkdir /staging

#VOLUME /staging

ARG PRESTO_VER=0.210

RUN curl -o /home/user/bin/presto https://repo1.maven.org/maven2/com/facebook/presto/presto-cli/${PRESTO_VER}/presto-cli-${PRESTO_VER}-executable.jar \
&&  chmod 755 /home/user/bin/presto

ENV PRESTO_VER=${PRESTO_VER}

USER user
WORKDIR /home/user
CMD ["bash"]
