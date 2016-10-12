FROM ubuntu:16.04
MAINTAINER renothing 'frankdot@qq.com'
LABEL role='mysql' version='5.7.14' tags='mysql' description='percona server image for ubuntu'
#set language enviroments
ENV LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8 \
  MAJOR=5.7 \
  VERSION=5.7.14-8 \
  TIMEZONE='Asia/Shanghai' \
  PASS='admin' POOLSIZE='128m'
# MASTER='masterip'
# REPLICATION_USER='replicate'
# REPLICATION_PASS='replicatepass'
#install software
#RUN sed -i 's/archive.ubuntu/mirrors.aliyun/g' /etc/apt/sources.list && apt-get update && \
RUN apt-get update && \
 apt-get install wget libssl-dev libssl1.0.0 libaio1 libnuma-dev libnuma1 -y && \
 useradd -m -d /var/lib/mysql -r mysql && \
 wget https://www.percona.com/downloads/Percona-Server-${MAJOR}/Percona-Server-${VERSION}/binary/tarball/Percona-Server-${VERSION}-Linux.x86_64.ssl100.tar.gz -O /tmp/perconaserver.tar.gz && \
 tar -xf /tmp/perconaserver.tar.gz -C /usr/local && \
 ln -s /usr/local/Percona-Server-${VERSION}-Linux.x86_64.ssl100 /usr/local/mysql && \
 ln -s /usr/local/mysql/bin/mysql /usr/bin/mysql && \
 ln -s /usr/local/mysql/bin/mysqladmin /usr/bin/mysqladmin && \
 rm -rf /usr/local/Percona-Server-${VERSION}-Linux.x86_64.ssl100/mysql-test && \
 rm -rf /usr/local/mysql/mysql-test && \
 rm -rf /tmp/* && \
 apt-get clean && apt-get autoremove -y
#install scripts
COPY opt/* /opt/
VOLUME ["/etc/mysql", "/var/lib/mysql","/var/log/mysql"]
#forwarding port
EXPOSE 3306
#set default command
ENTRYPOINT ["bash"]
CMD ["/opt/startservice.sh"]
