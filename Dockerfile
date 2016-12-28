FROM ubuntu:14.04
MAINTAINER jack@1225.hk

ENV DEV_PWD dev2016
ENV LANG C.UTF8
ENV LC_ALL C.UTF-8

ADD server_profile.sh /etc/profile.d/server_profile.sh
RUN chmod a+x /etc/profile.d/server_profile.sh
RUN echo 'export LANG='$LANG >> /etc/profile.d/server_profile.sh
RUN echo 'export LC_ALL='$LC_ALL >> /etc/profile.d/server_profile.sh
RUN echo 'export DEV_PWD='$DEV_PWD >> /etc/profile.d/server_profile.sh

COPY entrypoint.sh /etc/init.d/
COPY install.sh /sbin/
COPY change.sh /sbin/
RUN chmod a+x /etc/init.d/entrypoint.sh
RUN chmod a+x /sbin/install.sh
RUN chmod a+x /sbin/change.sh

RUN echo "Asia/Hong_Kong" > /etc/timezone
RUN dpkg-reconfigure -f noninteractive tzdata 
RUN ntpdate -s ntp.ubuntu.com
RUN apt-get clean 
RUN apt-get update
RUN apt-get install -y curl
RUN apt-get install -y vim 
RUN apt-get install -y openssh-server 
RUN apt-get install shellinabox
COPY shellinabox /etc/default/

RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/g' /etc/ssh/sshd_config
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/g' /etc/ssh/sshd_config

RUN groupadd basegroup
RUN useradd -g basegroup sshuser

RUN echo 'root:'$DEV_PWD | chpasswd
RUN echo 'sshuser:'$DEV_PWD | chpasswd

RUN /sbin/install.sh 
RUN rm /sbin/install.sh 

#The 8000 for spare port
EXPOSE 22 3306 4200 8080 8000
ENTRYPOINT ["/etc/init.d/entrypoint.sh"]
