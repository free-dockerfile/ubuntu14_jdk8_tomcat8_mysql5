#!/bin/bash

source /etc/profile.d/server_profile.sh

echo '---Debug Messages---'
java -version
echo '--------------------'
javac -version
echo '--------------------'
ant -version
echo '---Start Services---'
/etc/init.d/ssh start

sleep 1s
/etc/init.d/shellinabox start

sleep 1s
/etc/init.d/mysql start

sleep 1s
catalina.sh start

echo "Started"
while true;
  do
  echo Running $(date +"%Y%m%d %T");
  sleep 300;
done

