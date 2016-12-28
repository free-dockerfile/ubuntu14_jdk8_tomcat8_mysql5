#!/bin/bash

# Testing scripts

docker rm -f test01 
docker rmi test:v1
docker build --no-cache=true -t=test:v1 .
docker create --name test01 -i -t -h test01 -p 9001:4200 -p 9002:22 -p 9003:3306 -p 9004:8080 test:v1 
docker start test01 
sleep 10
#docker logs test01

docker exec -it test01 bash /sbin/change.sh dev2017 dev2017 dev2017 dev2017 

docker stop test01
#ssh root@localhost -p 9002
#rm -rf /root/.ssh/known_hosts

