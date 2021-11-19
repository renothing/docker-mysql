FROM ubuntu:focal
LABEL role='mysql' author='renothing' tags='mysql' description='percona server image for debian'
#set language enviroments
ENV LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8 \
  MAJOR=8.0 \
  VERSION=8.0.26-16 \
  TIMEZONE='Asia/Shanghai' \
  PASS='admin' POOLSIZE='128m'
# MASTER='masterip'
# REPLICATION_USER='replicate'
# REPLICATION_PASS='replicatepass'
#install software
RUN apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get -qq install --no-install-recommends -y gnupg2 lsb-release tzdata wget curl ca-certificates libjemalloc2 && \
 codename=$(lsb_release -sc) && \
 wget https://repo.percona.com/apt/percona-release_latest.${codename}_all.deb -O /tmp/percona.deb && dpkg -i /tmp/percona.deb && apt-get update && \
 #enable percona repo
 percona-release setup ps80 && \
 #install by quite mode
 DEBIAN_FRONTEND=noninteractive apt install -qq --no-install-recommends -y percona-server-rocksdb=${VERSION}-1.${codename} && \
 rm -rf /etc/mysql/my.cnf /var/lib/mysql/* /var/log/* /tmp/* && \
 apt clean && apt --purge autoremove -y gnupg2 lsb-release wget ca-certificates
#install scripts
ADD opt /opt/
#forwarding port
EXPOSE 3306
#set default command
ENTRYPOINT ["sh"]
CMD ["/opt/startservice.sh"]
#declare volumes
VOLUME ["/etc/mysql", "/var/lib/mysql","/var/log/mysql"]
