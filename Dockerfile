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
RUN sed -i 's/archive.ubuntu/mirrors.aliyun/g' /etc/apt/sources.list && apt-get update && \
#RUN apt-get update && \
 apt-get install --no-install-recommends -y wget ca-certificates libssl-dev libssl1.0.0 libjemalloc1 libmecab2 libaio1 libnuma1 psmisc libwrap0 mysql-common && \
 codename=`awk -F= '/DISTRIB_CODENAME/{print $2}' /etc/lsb-release` && \
 wget https://repo.percona.com/apt/percona-release_0.1-4.${codename}_all.deb -O /tmp/percona.deb && dpkg -i /tmp/percona.deb && apt-get update && \
 DEBIAN_FRONTEND=noninteractive apt-get install -qq --no-install-recommends -y percona-server-server-${MAJOR}=${VERSION}-1.${codename} && \
 rm -rf /etc/mysql/my.cnf /var/lib/mysql/* /tmp/* && \
 apt-get clean && apt-get autoremove -y
#install scripts
COPY opt/* /opt/
VOLUME ["/etc/mysql", "/var/lib/mysql","/var/log/mysql"]
#forwarding port
EXPOSE 3306
#set default command
ENTRYPOINT ["bash"]
CMD ["/opt/startservice.sh"]
