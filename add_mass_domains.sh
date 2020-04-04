#!/bin/bash

scj_dir_name="xvid"

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
cd /home/boss	
domain11=`echo $domain | sed 's/[\.\-]//g'`;

str_length='5-7';
rand_str_length=`cat /dev/urandom | tr -dc $str_length | head -c1`;
rand_str=`cat /dev/urandom | tr -dc 'a-z' | head -c$rand_str_length`;

domain1=${domain11}'_'${rand_str};

mkdir /home/www/$domain
mkdir /home/www/$domain/www
mkdir /home/www/$domain/logs
cp nginx.domain.name.conf /etc/nginx/conf.d/$domain.conf
sed -i 's/default/'$domain'/g' /etc/nginx/conf.d/$domain.conf
sed -i 's/\/scj\//\/'$scj_dir_name'\//g' /etc/nginx/conf.d/$domain.conf

rand_tpl=`ls tpl/ | shuf -n1`

unzip -q tpl/${rand_tpl} -d /home/www/$domain/www

chmod -R 775 /home/www/$domain

mysql -uuserdb -puserpass -e "create database $domain1" >/dev/null 2>/dev/null 

cd /home/www/$domain/www

pass=`curl -sS http://smartcj.com/updates2/install | php -- mysql_host=localhost mysql_user=userdb mysql_pass=userpass mysql_name=$domain1 scj_folder=$scj_dir_name domain=$domain admin_email=admin@$domain 2>/dev/null | grep "Script Installation is done" | sed "s/ Script.*is '\([a-z]*\)'\./\1/g"`

echo "${domain}/${scj_dir_name}/admin/ => ${pass} DB: ${domain1} TPL: ${rand_tpl}" >> /home/boss/domain_data.txt

ln -s ${scj_dir_name}/cgi/index.php index.php
ln -s ${scj_dir_name}/cgi/out.php out.php
ln -s ${scj_dir_name}/cgi/common.php common.php

chown -R boss:boss /home/www/$domain

mysql -uuserdb -puserpass $domain1 -e "delete from rot_pages" >/dev/null 2>/dev/null
mysql -uuserdb -puserpass $domain1 < /home/www/$domain/www/*.sql 2>/dev/null

#crontab -l -uboss | { cat; echo "*/1 * * * * cd /home/www/$domain/www/${scj_dir_name}/bin; env HTTP_HOST=$domain /usr/bin/php -q cron.php"; } | crontab -uboss -
#crontab -l -uboss | { cat; echo "*/1 * * * * cd /home/www/$domain/www/${scj_dir_name}/bin; env HTTP_HOST=$domain /usr/bin/php -q rotation.php"; } | crontab -uboss -

echo "cd /home/www/$domain/www/${scj_dir_name}/bin; env HTTP_HOST=$domain /usr/bin/php -q cron.php &" >> /home/cron.sh
echo "cd /home/www/$domain/www/${scj_dir_name}/bin; env HTTP_HOST=$domain /usr/bin/php -q rotation.php &" >> /home/cron.sh
echo "sleep 2" >> /home/cron.sh

echo "cd /home/www/$domain/www/${scj_dir_name}/admin; env HTTP_HOST=$domain /usr/bin/php update.php" >> /home/boss/update.sh

cd /home/www/$domain/www/${scj_dir_name}/admin
sudo -uboss env HTTP_HOST=$domain /usr/bin/php update.php

echo $domain complete
fi
done < $FILE

systemctl reload nginx.service

cd /home/boss

rm -f domains.txt
