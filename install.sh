#!/bin/bash

mkdir /usr/local/src
ln -s /usr/local/src /src

JAVA_INSTALL=/usr/local/src/lib/java
TOMCAT_INSTALL=/usr/local/src/lib/tomcat
ANT_INSTALL=/usr/local/src/lib/ant

JAVA_HOME=${JAVA_INSTALL}/default
CATALINA_HOME=${TOMCAT_INSTALL}/default
ANT_HOME=${ANT_INSTALL}/default

#echo "export JAVA_HOME=${JAVA_HOME}" >> /etc/profile
#echo "export CATALINA_HOME=${CATALINA_HOME}" >> /etc/profile
#echo "export ANT_HOME=${ANT_HOME}" >> /etc/profile
#echo "export PATH=${JAVA_HOME}/bin:${ANT_HOME}/bin:${CATALINA_HOME}/bin:$PATH" >> /etc/profile

mkdir -p ${JAVA_INSTALL} 
mkdir -p ${TOMCAT_INSTALL} 
mkdir -p ${ANT_INSTALL} 

cd ${JAVA_INSTALL} 
wget -O jdk.tar.gz --no-check-certificate --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u73-b02/jdk-8u73-linux-x64.tar.gz
sleep 1s
tar zxf jdk*.tar.gz -C ${JAVA_INSTALL} 
rm jdk*.tar.gz
ln -s jdk* default

cd ${TOMCAT_INSTALL} 
wget -O apache-tomcat.tar.gz http://apache.communilink.net/tomcat/tomcat-9/v9.0.0.M15/bin/apache-tomcat-9.0.0.M15.tar.gz
sleep 1s
tar zxf apache-tomcat*.tar.gz -C ${TOMCAT_INSTALL}
rm apache-tomcat*.tar.gz
ln -s apache-tomcat* default
cd ./default/webapps
tar zcf manager.tar.gz ./host-manager/ ./manager/
rm -rf ./ROOT/*
rm -rf ./docs
rm -rf ./examples
rm -rf ./host-manager
rm -rf ./manager

cd ${ANT_INSTALL}
wget -O apache-ant.tar.gz http://ftp.cuhk.edu.hk/pub/packages/apache.org/ant/binaries/apache-ant-1.9.7-bin.tar.gz
sleep 1s
tar zxf apache-ant*.tar.gz -C ${ANT_INSTALL}
rm apache-ant*.tar.gz
ln -s apache-ant* default

debconf-set-selections <<< 'mysql-server mysql-server/root_password password '$DEV_PWD
debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password '$DEV_PWD
apt-get install -y mysql-server

