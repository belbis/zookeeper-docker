# VERSION        0.0.1


# see https://github.com/dockerfile/java/tree/master/oracle-java8
# for more info on base image
FROM dockerfile/java:oracle-java8
MAINTAINER Michael Dreibelbis <mike (at) belbis.com>

# install deps
RUN apt-get update && apt-get install -y wget

# download zookeeper from host
#RUN wget -q -O - http://apache.mirrors.pair.com/zookeeper/zookeeper-3.4.6/zookeeper-3.4.6.tar.gz | tar -xzf - -C /opt \
#    && mv /opt/zookeeper-3.4.6 /opt/zookeeper \
#    && cp /opt/zookeeper/conf/zoo_sample.cfg /opt/zookeeper/conf/zoo.cfg \
#    && mkdir -p /tmp/zookeeper


#
RUN mkdir -p /opt/zookeeper \
    && curl -SL http://apache.mirrors.pair.com/zookeeper/zookeeper-3.4.6/zookeeper-3.4.6.tar.gz \
    | tar -xz -C /opt/zookeeper --strip-components=1 && chown -R root:root /opt/zookeeper


# update java env
# ENV JAVA_HOME /usr/lib/jvm/java-7-openjdk-amd64

# ports that zookeeper needs exposed
EXPOSE 2181 2888 3888

# working directory
WORKDIR /opt/zookeeper

# volumes
VOLUME ["/opt/zookeeper/conf", "/tmp/zookeeper"]

# add external scripts to scope
ADD start-zookeeper-server.sh
ADD stop-zookeeper-server.sh

# ensure executable
RUN chmod +x start-zookeeper-server.sh
RUN chmod +x stop-zookeeper-server.sh

#ENTRYPOINT ["/opt/zookeeper/bin/zkServer.sh"]
#CMD ["start-foreground"]