#!/bin/bash

servername=`hostname`
echo   
echo [+]-----------------------------------------------[+]
echo "       "Monitoring results for "$servername"       
echo [+]-----------------------------------------------[+]
sudo netstat -plunt|awk ' NR>2 {print $4}' > ports_to_check
found=`grep -v -F -x -f ports-out.txt ports_to_check`
echo -e "\n"
if [ ! -z "$found" ]
then

echo Found new open port: "$found"  on $(date)
fi



ip=111.111.111.111
user=`sudo cat /var/log/auth.log|grep 'Accepted'|awk '{print $9}'`
logged_date=`sudo cat /var/log/auth.log|grep 'Accepted'|awk '{print $1,$2,$3}'`

	mydate=`echo $(date)|awk -F':' '{print $1":"$2}'|awk '{print $2," "$3,$4}'`
	result=`sudo cat /var/log/auth.log|grep 'Accepted'|grep "$mydate"|awk '{print $11}'`
	if [ ! -z "$result" ]
	then
		for i in $(sudo cat /var/log/auth.log|grep 'Accepted'|grep "$mydate"|awk '{print $11}')
		do
			if [ "$i" != "$ip" ]; then
				echo Found Successful login from: "$i" 
				logged_ip=`last | grep "pts/"|awk '{print $3}'|sort|uniq`
				for i in $logged_ip
				do
					if [ "$i" != "$ip" ];
					then
						echo Found last login from: "$i" 
					fi
		done
			fi
		done

	line_number=`last |grep "pts"|wc -l`

	if (( $line_number < 2 )); then

		if [ ! -f ~/.bash_history ]; then
			echo Bash history not found, could be someone deleted it... 
		fi

	fi
	fi



crontab -l &> cron_out.txt
result=`cat cron_out.txt|grep 'no crontab'`
cron=`cat cron_out.txt|sed '/^#/ d'`
if [  -z "$result" ]
then
echo [-] Found suspicious jobs
echo ----------------------------------------------------
echo "$cron"
echo ----------------------------------------------------
fi

highcpu=`ps aux|awk '{if($3 >= 20.0) {print $0}}'`

if [ ! -z "$highcpu" ]
then
        echo -e "\n"
        echo "[-] Found suspicious process with high cpu usage"
        echo --------------------------------------------------------------------------------------
        echo "$highcpu"

fi


