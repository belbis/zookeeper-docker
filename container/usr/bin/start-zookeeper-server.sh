#!/usr/bin/env bash

# need a zookeeper id before attempting startup
if [ -z ${ZOOKEEPER_ID} ] ; then
  echo 'ERROR: ZOOKEEPER_ID env variable missing.'
  exit -1
fi

# for now use default configuration
cp ${ZOOKEEPER_HOME}/conf/zoo_sample.cfg ${ZOOKEEPER_HOME}/conf/zoo.cfg

# sleeps until a zookeeper.cfg file appears
if [ ! -f ${ZOOKEEPER_HOME}/conf/zoo.cfg ] ; then
  echo 'Waiting for config file to appear...'
  while [ ! -f ${ZOOKEEPER_HOME}/conf/zoo.cfg ] ; do
    sleep 1
  done
  echo 'Config file found, starting server.'
fi

# jvm stuff
if [ -z ${SERVER_JVMFLAGS} ] ; then
  # export SERVER_JVMFLAGS=" -Xmx1g -Dzookeeper.serverCnxnFactory=org.apache.zookeeper.server.NettyServerCnxnFactory"
  export SERVER_JVMFLAGS=" -Xmx1g "
fi

# create storage dir for zookeeper
mkdir -p ${ZOOKEEPER_DATA}

# zookeeper id
echo "${ZOOKEEPER_ID}" > ${ZOOKEEPER_DATA}/myid

# start the script
#exec /opt/zookeeper/bin/zkServer.sh start-foreground >> $ZOO_LOG_DIR/zk-console.log 2>&1
exec ${ZOOKEEPER_HOME}/bin/zkServer.sh start-foreground #>> ${ZOOKEEPER_LOGDIR}/${ZOOKEEPER_LOGFILE} 2>&1
