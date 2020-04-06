#!/bin/bash

for i in `find . -maxdepth 4 -type f -name "*.free.lic"`
do
	#echo $i | sed 's!\./[^/]+/www/([^/]+)/scj2\.free\.lic!\1!g'
	domain=`echo $i | sed -r 's!^\./([^/]+)/www/.+!\1!g'`
	dir_name=`echo $i | sed -r 's!^\./[^/]+/www/([^/]+)/.+!\1!g'`
	echo "cd /home/www/$domain/www/$dir_name/admin; env HTTP_HOST=$domain /usr/bin/php update.php" >> update.sh
done
