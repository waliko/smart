#!/bin/bash
clear;
echo "Введите домен: "
read domain
domain1=`echo $domain | sed 's/[\.\-]//g'`;

rm -f /etc/nginx/conf.d/$domain.conf

systemctl reload nginx.service

rm -rf /home/www/$domain

db=`mysql -uuserdb -puserpass -e "show databases like '${domain1}%'" 2>/dev/null | sed 's/|//g' | grep -P "^${domain1}"`
mysql -uuserdb -puserpass -e "drop database $db" >/dev/null 2>/dev/null

cat update.sh | grep -v $domain > update_.sh
cat update_.sh > update.sh
rm update_.sh

#crontab -l -uboss | grep -v $domain | crontab -uboss -

cat cron.sh | grep -v $domain > cron_.sh
cat cron_.sh > cron.sh
rm cron_.sh

echo "Complete";
