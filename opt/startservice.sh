#!/bin/bash
cp /usr/share/zoneinfo/${TIMEZONE} /etc/localtime && \
echo "${TIMEZONE}" > /etc/timezone 
test -d /var/lib/mysql || mkdir -p /var/lib/mysql
test -d /var/log/mysql || mkdir -p /var/log/mysql
test -d /var/run/mysqld || mkdir -p /var/run/mysqld
stat -c "%U" /var/lib/mysql|grep -q mysql || chown mysql:mysql -R /var/lib/mysql
stat -c "%U" /var/log/mysql|grep -q mysql || chown mysql:mysql -R /var/log/mysql
stat -c "%U" /var/run/mysqld|grep -q mysql || chown mysql:mysql -R /var/run/mysqld
test -f /etc/mysql/my.cnf || cp -rf /opt/my.cnf /etc/mysql/my.cnf
datadir=`grep ^datadir opt/my.cnf |awk '{print $NF}'`
test -f $datadir/auto.cnf || sh /opt/init.sh	
sed -i "s/innodb_buffer_pool_size=.*/innodb_buffer_pool_size=${POOLSIZE}/g" /etc/mysql/my.cnf
ps aux|grep -v grep|grep -q mysql || rm -rf /var/run/mysqld/mysqld.pid /var/run/mysqld/mysqld.sock && exec /usr/local/mysql/bin/mysqld
