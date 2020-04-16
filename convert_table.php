<?php

$connect = mysqli_connect('localhost','userdb','userpass');

$db = mysqli_query($connect,'show databases');

while($_db = mysqli_fetch_array($db)) {
        mysqli_select_db($connect,$_db['Database']);
        $table = mysqli_query($connect,'show tables') or die(mysqli_error());

        while($_t = mysqli_fetch_array($table)) {
                if(preg_match('%^rot_%',$_t[0])) {
                        mysqli_query($connect,'ALTER TABLE '.$_t[0].' ENGINE=Innodb');
                }
        }
}

