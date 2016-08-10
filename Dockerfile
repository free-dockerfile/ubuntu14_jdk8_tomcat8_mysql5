FROM ubuntu:14.04
MAINTAINER jack@1225.hk

ENV DEV_PWD dev2016
ENV LANG C.UTF8
ENV LC_ALL C.UTF-8
RUN echo 'export LANG='$LANG >> /etc/profile
RUN echo 'export LC_ALL='$LC_ALL >> /etc/profile
RUN echo 'export DEV_PWD='$DEV_PWD >> /etc/profile

ADD entrypoint.sh /etc/init.d/entrypoint.sh
ADD install.sh /sbin/install.sh
ADD change.sh /sbin/change.sh
RUN chmod a+x /etc/init.d/entrypoint.sh
RUN chmod a+x /sbin/install.sh
RUN chmod a+x /sbin/change.sh
#RUN mv /etc/apt/sources.list /etc/apt/sources.list_backup
#ADD sources.list /etc/apt/sources.list

RUN echo "Asia/Hong_Kong" > /etc/timezone
RUN dpkg-reconfigure -f noninteractive tzdata 
#RUN ntpdate -s ntp.ubuntu.com
RUN apt-get clean 
RUN apt-get update
RUN apt-get install -y curl
RUN apt-get install -y vim 
RUN apt-get install -y openssh-server 

RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/g' /etc/ssh/sshd_config
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/g' /etc/ssh/sshd_config

RUN echo 'root:'$DEV_PWD | chpasswd
RUN /sbin/install.sh 
RUN rm /sbin/install.sh 

EXPOSE 22 3306 8080
ENTRYPOINT ["/etc/init.d/entrypoint.sh"]
