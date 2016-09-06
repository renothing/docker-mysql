#!/bin/bash
buffersize=${POOLSIZE:=4g}
sed -i "s/POOLSIZE/$buffersize/g" /etc/mysql/my.cnf
mysqld --initialize --user=mysql
initpass=`awk '/temporary.*root@localhost/{print $NF}' /var/log/mysql/error.log`
/etc/init.d/mysql start
PASS=${PASS:=admin}
mysql --connect-expired-password -uroot -p"${initpass}" -e "alter user 'root'@'localhost' identified by '${PASS}';"
mysql -uroot -p"${PASS}" -e "CREATE FUNCTION fnv1a_64 RETURNS INTEGER SONAME 'libfnv1a_udf.so'"
mysql -uroot -p"${PASS}" -e "CREATE FUNCTION fnv_64 RETURNS INTEGER SONAME 'libfnv_udf.so'"
mysql -uroot -p"${PASS}" -e "CREATE FUNCTION murmur_hash RETURNS INTEGER SONAME 'libmurmur_udf.so'"
mysql -uroot -p"${PASS}" -e "CREATE FUNCTION murmur_hash RETURNS INTEGER SONAME 'libmurmur_udf.so'"
