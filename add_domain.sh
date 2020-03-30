#!/bin/bash
clear;
echo "Введите домен: "
read domain
domain11=`echo $domain | sed 's/[\.\-]//g'`;

str_length='5-7';
rand_str_length=`cat /dev/urandom | tr -dc $str_length | head -c1`;
rand_str=`cat /dev/urandom | tr -dc 'a-z' | head -c$rand_str_length`;

domain1=${domain11}'_'${rand_str};

mkdir /home/www/$domain
mkdir /home/www/$domain/www
mkdir /home/www/$domain/logs
chown -R boss:boss /home/www/$domain
chmod -R 775 /home/www/$domain

cp nginx.domain.name.conf /etc/nginx/conf.d/$domain.conf
sed -i 's/default/'$domain'/g' /etc/nginx/conf.d/$domain.conf

#cp apache.domain.name.conf /etc/httpd/conf.d/$domain.conf
#sed -i 's/domain\.name/'$domain'/g' /etc/httpd/conf.d/$domain.conf

systemctl reload nginx.service
#systemctl restart httpd.service

mysql -uuserdb -puserpass -e "create database $domain1" >/dev/null 2>/dev/null

echo ""
echo "========"
echo "DB name: $domain1"
echo "========"
echo ""

echo "Complete";
