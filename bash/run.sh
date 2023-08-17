#!/bin/bash
app="zx_media_service"
work_path=$(pwd)
echo "run work path:${work_path}"
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${work_path}/lib
# stop all
./stop.sh
echo "restart..."
cd ./app || exit
chmod 777 ./$app
ldd ./$app
nohup ./$app > /dev/null 2>&1 &