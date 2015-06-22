#!/usr/bin/env bash

# need a zookeeper id before attempting startup
if [ -z ${ZOO_ID} ] ; then
  echo 'ERROR: ZOO_ID env variable missing.'
  exit -1
fi

# sleeps until a zoo.cfg file appears
if [ ! -f /opt/zookeeper/conf/zoo.cfg ] ; then
  echo 'Waiting for config file to appear...'
  while [ ! -f /opt/zookeeper/conf/zoo.cfg ] ; do
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
mkdir -p ${ZOO_DATADIR}

# zookeeper id
echo "${ZOO_ID}" > ${ZOO_DATADIR}/zooid

# start the script
#exec /opt/zookeeper/bin/zkServer.sh start-foreground >> $ZOO_LOG_DIR/zk-console.log 2>&1
exec ${ZOOKEEPER_HOME}/bin/zkServer.sh start-foreground >> ${ZOOKEEPER_LOG} 2>&1
