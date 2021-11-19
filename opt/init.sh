#!/bin/bash
servid=`date +%s`
sed -i "s/server-id=.*/server-id=${servid}/g" /etc/mysql/my.cnf
mysqld --initialize-insecure --user=mysql
sh -c "mysqld_safe &"
sleep 2
mysql --connect-expired-password -uroot -e "alter user 'root'@'localhost' identified by '${PASS}';"
mysql -uroot -p"${PASS}" -e "CREATE FUNCTION fnv1a_64 RETURNS INTEGER SONAME 'libfnv1a_udf.so'"
mysql -uroot -p"${PASS}" -e "CREATE FUNCTION fnv_64 RETURNS INTEGER SONAME 'libfnv_udf.so'"
mysql -uroot -p"${PASS}" -e "CREATE FUNCTION murmur_hash RETURNS INTEGER SONAME 'libmurmur_udf.so'"
ps-admin --enable-rocksdb -u root -p"${PASS}"
mysqladmin -S /var/run/mysqld/mysqld.sock -uroot -p"${PASS}" shutdown
