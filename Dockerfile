FROM debian:9-slim
LABEL role='mysql' author='renothing' tags='mysql' description='percona server image for debian'
#set language enviroments
ENV LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8 \
  MAJOR=5.7 \
  VERSION=5.7.26-29 \
  TIMEZONE='Asia/Shanghai' \
  PASS='admin' POOLSIZE='128m'
# MASTER='masterip'
# REPLICATION_USER='replicate'
# REPLICATION_PASS='replicatepass'
#install software
RUN apt update && \
 apt install --no-install-recommends -y gnupg2 lsb-release tzdata wget ca-certificates libjemalloc1 && \
 codename=$(lsb_release -sc) && \
 wget https://repo.percona.com/apt/percona-release_latest.${codename}_all.deb -O /tmp/percona.deb && dpkg -i /tmp/percona.deb && apt-get update && \
 DEBIAN_FRONTEND=noninteractive apt install -qq --no-install-recommends -y percona-server-server-${MAJOR}=${VERSION}-1.${codename} && \
 rm -rf /etc/mysql/my.cnf /var/lib/mysql/* /var/log/* /tmp/* && \
 apt clean && apt --purge autoremove -y gnupg2 lsb-release wget ca-certificates
#install scripts
ADD opt /opt/
#VOLUME ["/etc/mysql", "/var/lib/mysql","/var/log/mysql"]
#forwarding port
EXPOSE 3306
#set default command
ENTRYPOINT ["sh"]
CMD ["/opt/startservice.sh"]
