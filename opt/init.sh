#!/bin/bash
servid=`date +%s`
sed -i "s/server-id=.*/server-id=${servid}/g" /etc/mysql/my.cnf
#sed -i "s/innodb_buffer_pool_size=.*/innodb_buffer_pool_size=${POOLSIZE}/g" /etc/mysql/my.cnf
/usr/local/mysql/bin/mysqld --initialize-insecure --user=mysql
sh -c "/usr/local/mysql/bin/mysqld &"
sleep 2
mysql --connect-expired-password -uroot -e "alter user 'root'@'localhost' identified by '${PASS}';"
mysql -uroot -p"${PASS}" -e "CREATE FUNCTION fnv1a_64 RETURNS INTEGER SONAME 'libfnv1a_udf.so'"
mysql -uroot -p"${PASS}" -e "CREATE FUNCTION fnv_64 RETURNS INTEGER SONAME 'libfnv_udf.so'"
mysql -uroot -p"${PASS}" -e "CREATE FUNCTION murmur_hash RETURNS INTEGER SONAME 'libmurmur_udf.so'"
mysqladmin -S /var/run/mysqld/mysqld.sock -uroot -p"${PASS}" shutdown
