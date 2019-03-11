#!/usr/bin/bash


for i in $( cat Devips.txt ); do 

ssh admin@"$i" 'bash -s' < who_logged.sh > out.txt # change the user from admin to the name of your user

servername=`cat out.txt|grep -i 'Hostname'|awk -F: '{print $2}'`
cpu=`cat out.txt|grep -i 'high cpu usage'`
job=`cat out.txt|grep -i 'Found suspicious jobs'`
portresult=`cat out.txt|grep -i 'port'`
result=`cat out.txt|grep -i 'successful'|awk '{print $5}'`
if [ ! -z "$portresult" ] && [ ! -z "$result" ] && [ ! -z "$cpu" ] && [ ! -z "$job" ]
then
	
	cat out.txt
	echo IP traced back to :
        echo [+]--------------------------------------------------------------------------------------------[+]
        geoiplookup "$result"
        echo [+]--------------------------------------------------------------------------------------------[+]

elif [ ! -z "$portresult" ]
then
	cat out.txt 

elif [ ! -z "$result" ]
then
	cat out.txt
	echo IP traced back to :
	echo [+]--------------------------------------------------------------------------------------------[+]
	geoiplookup "$result"
	echo [+]--------------------------------------------------------------------------------------------[+]

elif [ ! -z "$cpu" ]
then
	cat out.txt

elif [ ! -z "$job" ]
then
	cat out.txt

fi

done
