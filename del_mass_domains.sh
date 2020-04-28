#!/bin/bash
clear

echo "Введите хеш: "
read hahash
rm -f domains.txt
wget http://pastebin.com/raw/$hahash -O domains.txt
/usr/bin/perl   -pi -e 's/\r\n/\n/g' domains.txt
echo "" >> domains.txt
FILE=domains.txt

while read domain; do
if [ -n "$domain" ]
then

domain1=`echo $domain | sed 's/[\.\-]//g'`;

rm -f /etc/nginx/conf.d/$domain.conf

rm -rf /home/www/$domain

dir=`find /home/www/${domain}/www -type d -name 'includes'`
db=`cat $dir/config.php | grep 'db_database' | sed "s%\\$config\[\"db_database\"\] = '%%g" | sed "s%';%%g"`
if [ -z "$db" ]
then
db=`cat domain_data.txt | grep $domain | sed 's%^.*DB: \(.*\) TPL:.*$%\1%g'`
if [ -z "$db" ]
then
db=`mysql -uuserdb -puserpass -e "show databases like '${domain1}%'" 2>/dev/null | sed 's/|//g' | grep -P "^${domain1}"`
fi
fi

mysql -uuserdb -puserpass -e "drop database $db" >/dev/null 2>/dev/null

cat update.sh | grep -v $domain > update_.sh
cat update_.sh > update.sh
rm update_.sh

cat cron.sh | grep -v $domain > cron_.sh
cat cron_.sh > cron.sh
rm cron_.sh

cat domain_data.txt | grep -v $domain > domain_data_.txt
cat domain_data_.txt > domain_data.txt
rm domain_data_.txt

fi
done < $FILE

systemctl reload nginx.service

rm -f domains.txt

echo "Complete";
