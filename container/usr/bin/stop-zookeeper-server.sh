#!/usr/bin/env bash

# update path vars
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# kill all java
ps -ef | grep java | grep -v grep | awk '{ print $2 }' | xargs kill