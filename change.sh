#!/bin/bash

NEW_PWD=$1

echo 'root:'$NEW_PWD | chpasswd
sleep 1s

echo "CREATE DATABASE appdb CHARACTER SET utf8 COLLATE utf8_general_ci;" | mysql -uroot -p''$DEV_PWD
sleep 1s
echo "CREATE USER 'appuser'@'%' IDENTIFIED BY '"$NEW_PWD"';" | mysql -uroot -p''$DEV_PWD
sleep 1s
echo "GRANT ALL PRIVILEGES ON appdb.* TO 'appuser'@'%' WITH GRANT OPTION;" | mysql -uroot -p''$DEV_PWD
sleep 1s
mysql -uappuser -p''$NEW_PWD appdb < /usr/local/src/lib/tomcat/default/webapps/ROOT/WEB-INF/*.sql
sleep 1s
echo "SET PASSWORD FOR 'root'@'localhost' = PASSWORD('"$NEW_PWD"');" | mysql -uroot -p''$DEV_PWD
sleep 1s
sed -i 's/export DEV_PWD='$DEV_PWD'//g' /etc/profile
rm /sbin/change.sh
