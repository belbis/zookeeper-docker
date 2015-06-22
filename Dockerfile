# VERSION        0.0.1

# see https://github.com/dockerfile/java/tree/master/oracle-java8
# for more info on base image
FROM java:8

MAINTAINER Michael Dreibelbis <mike (at) belbis.com>

ENV ZOOKEEPER_HOME /opt/zookeeper
ENV ZOOKEEPER_LOG /var/log/zookeeper
ENV ZOOKEEPER_DATA /var/zookeeper
ENV ZOOKEEPER_TMP /tmp/zookeeper
ENV ZOOKEEPER_PORT1 2888
ENV ZOOKEEPER_PORT2 3888
ENV ZOOKEEPER_ID 0

# install deps
RUN apt-get update && apt-get install -y wget

# setup env and download jar
RUN mkdir -p ${ZOOKEEPER_HOME} \
    && mkdir -p ${ZOOKEEPER_LOG} \
    && curl -SL http://apache.mirrors.pair.com/zookeeper/zookeeper-3.4.6/zookeeper-3.4.6.tar.gz \
    | tar -xz -C ${ZOOKEEPER_HOME} --strip-components=1 && chown -R root:root ${ZOOKEEPER_HOME}

# deprecated
# download zookeeper from host
#RUN wget -q -O - http://apache.mirrors.pair.com/zookeeper/zookeeper-3.4.6/zookeeper-3.4.6.tar.gz | tar -xzf - -C /opt \
#    && mv /opt/zookeeper-3.4.6 /opt/zookeeper \
#    && cp /opt/zookeeper/conf/zoo_sample.cfg /opt/zookeeper/conf/zoo.cfg \
#    && mkdir -p /tmp/zookeeper
# uncomment if using above dl and java install
# update java env
# ENV JAVA_HOME /usr/lib/jvm/java-7-openjdk-amd64

# ports that zookeeper needs exposed
EXPOSE 2181 2888 3888

# working directory
WORKDIR /opt/zookeeper

# volumes
# TODO: change these to vars?
VOLUME ["/opt/zookeeper/conf", "/tmp/zookeeper"]

# start zookeeper
# add external path
ADD container/usr/bin/start-zookeeper-server.sh /usr/bin/start-zookeeper-server.sh
ADD container/usr/bin/stop-zookeeper-server.sh /usr/bin/stop-zookeeper-server.sh

# ensure executable
RUN chmod +x /usr/bin/start-zookeeper-server.sh
RUN chmod +x /usr/bin/stop-zookeeper-server.sh

RUN cp ${ZOOKEEPER_HOME}/conf/zoo_sample.cfg ${ZOOKEEPER_HOME}/conf/zookeeper.cfg

# start the server
# RUN /usr/bin/start-zookeeper-server.sh