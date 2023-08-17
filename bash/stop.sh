#!/bin/bash
app="zx_media_service"
APPPIDS=`ps -ef |grep $app |grep -v grep | awk '{print $2}'`
if [ "$APPPIDS" == "" ]; then
  echo "no process $app"
else
  echo "discovery $app process..."
  ps -ef | grep $app | grep -v "grep" | awk '{print $2}'
  ps -ef | grep $app | grep -v "grep" | awk '{print $2}' | xargs kill -9
  echo "killall $app process..."
  echo "check $app process..."
  ps -ef | grep $app | grep -v "grep" | awk '{print $2}'
fi
echo "stop $app success"