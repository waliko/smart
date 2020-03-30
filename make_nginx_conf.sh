#!/bin/bash
clear;
echo "Введите домен: "
read domain

cp nginx.domain.name.conf /etc/nginx/conf.d/$domain.conf
sed -i 's/default/'$domain'/g' /etc/nginx/conf.d/$domain.conf

systemctl reload nginx.service
