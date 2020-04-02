#!/bin/bash

dir_count=10
name_length='3-5'

for ((i=0;i<$dir_count;i++))
    do
        dir_name_length=`cat /dev/urandom | tr -dc $name_length | head -c1`
        dir_name=`cat /dev/urandom | tr -dc 'a-z' | head -c$dir_name_length`
        while [ -d $dir_name ]
        do
        dir_name_length=`cat /dev/urandom | tr -dc $name_length | head -c1`
        dir_name=`cat /dev/urandom | tr -dc 'a-z' | head -c$dir_name_length`
        done

        mkdir $dir_name

        unzip -q arch.zip -d $dir_name
    
	chmod -R 777 $dir_name
done

