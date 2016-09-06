#!/bin/bash
test -d /var/lib/mysql || mkdir -p /var/lib/mysql
test -d /var/log/mysql || mkdir -p /var/log/mysql
test -d /var/run/mysqld || mkdir -p /var/run/mysqld
stat -c "%U" /var/lib/mysql|grep -q mysql || chown mysql:mysql -R /var/lib/mysql
stat -c "%U" /var/log/mysql|grep -q mysql || chown mysql:mysql -R /var/log/mysql
stat -c "%U" /var/run/mysqld|grep -q mysql || chown mysql:mysql -R /var/run/mysqld
test -f /etc/mysql/my.cnf || ln -sf /opt/my.cnf /etc/mysql/my.cnf
datadir=`grep ^datadir opt/my.cnf |awk '{print $NF}'`
test -f $datadir/auto.cnf || bash /opt/init.sh	
ps aux|grep -v grep|grep -q mysql || /etc/init.d/mysql start
tail -f /var/log/mysql/error.log
