#########################################################################################
# This dockerfile is derived from loicmathieu/cloudera-cdh and will setup a hive
# metastore server.
#
#########################################################################################
FROM matthewcmead/cloudera-cdh:cdh-5.14.2

MAINTAINER matthewcmead

ARG PRESTO_VER=0.210

RUN mkdir /presto \
&&  cd /presto \
&&  curl https://repo1.maven.org/maven2/com/facebook/presto/presto-server/${PRESTO_VER}/presto-server-${PRESTO_VER}.tar.gz | tar zxvf -

RUN curl -o /home/user/bin/presto https://repo1.maven.org/maven2/com/facebook/presto/presto-cli/${PRESTO_VER}/presto-cli-${PRESTO_VER}-executable.jar \
&&  chmod 755 /home/user/bin/presto

RUN mkdir -p /presto/presto-server-${PRESTO_VER}/etc /presto/presto-server-${PRESTO_VER}/etc/catalog

COPY node.properties /presto/presto-server-${PRESTO_VER}/etc
COPY jvm.config /presto/presto-server-${PRESTO_VER}/etc
COPY config.properties /presto/presto-server-${PRESTO_VER}/etc
COPY log.properties /presto/presto-server-${PRESTO_VER}/etc
COPY hive.properties /presto/presto-server-${PRESTO_VER}/etc/catalog

COPY startup.sh /startup.sh
RUN chmod 755 /startup.sh

RUN mkdir -p /presto/data /var/log/presto \
&&  useradd -d /presto presto \
&&  chown -R presto:presto /presto /var/log/presto

#setup supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

RUN sed -i "s/PRESTO_VER/${PRESTO_VER}/g" /etc/supervisor/conf.d/supervisord.conf

ENV PRESTO_VER=${PRESTO_VER}
VOLUME /presto/data

EXPOSE 9876

#start the supervisor
CMD ["/startup.sh"]
