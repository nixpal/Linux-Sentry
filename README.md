# Linux VeriScanner
This Script will do the following functions:

* Monitor target for suspicious login except the IP you provide in the script (we will get to this part later)
* Monitor for any new open ports other than the default ports you opened already after your Linux installation
* Monitor for any new cron jobs and notify Admin
* Monitor high usage cpu process in case your server was infected by any crypto currency malware.
* Email you with the suspicious IP with it's geolocation.
* Email you with any new open port or new high cpu usage process.


## Pre-Run instructions:

1- Create SSH keys to your linux box and try to login via SSH without any passwords.

2- Install geoip by using one of these commands :

### To install it on Arch Linux and its derivatives, run:
sudo pacman -S geoip

### On RHEL, CentOS, Fedora, Scientific Linux:
sudo yum install geoip

### On SUSE/openSUSE:
sudo zypper install geoip



3- Copy the file GeoIP.dat from the Repo to /usr/share/GeoIP/GeoIP.dat on the monitoring box. In my case I have this file on macOS in this destinaton /usr/local/var/GeoIP/GeoIP.dat
You will probably find one file there already, but it's empty one and doesn't have any data.
### usage: 
geoiplookup 8.8.8.8
You should get an output like this one:
$geoiplookup 8.8.8.8                                            
GeoIP Country Edition: US, United States

4- Let's edit your sudoers file on your server that you want to monitor to accept some commands through SSH without using sudo.
* $ sudo visudo\
Then add the following line based on your linux user.
* testUser ALL=NOPASSWD:/sbin/netstat, /bin/cat\
Note: change testUser to your linux user on the machine you want to monitor

Your netstat could be in different location, check the location with the command "which netstat"

We added two binary files to use (netstat, cat).

5- Now let's take a copy of all the open ports that already working in the background and you know they are safe.
* sudo netstat -plunt|awk ' NR>2 {print $4}' > ports-out.txt

## Configurations:
1- in file linux_scanner.py change those lines to your own configuration:
* line 15 ==> smtp_server = "smtp.gmail.com"
* line 16 ==> gmail_user = 'myusername@gmail.com'
* line 17 ==> gmail_pass = 'mypassword'
* line 19 ==> port = 465
* line 23 ==> message["To"] = "myemail@domain.com"
* line 24 ==> sender_email = "servmon@domain.com"
* line 25 ==> message["From"] = "servmon@domain.com"
* line 26 ==> message["Subject"] = "CSDev Monitor Alert"

2- create a file with ip addresses with all your linux servers you want to monitor and edit the file name in run-remote.sh.
* line 4 ==> for i in $( cat Devips.txt ); do    
Just change the Devips.txt to the name of your file.
* line 6 ==> ssh admin@"$i" 'bash -s' < who_logged.sh > out.txt 
Just change admin to the actual username on your linux servers.

3- In file who_logged.sh 
* line 66 ==> change the value of cpu usage from 20.0 to anything else ==> highcpu=`ps aux|awk '{if($3 >= 20.0) {print $0}}'`
So if you want the script to only look for processes with cpu usage more than or equal to 10, then change it to 10.0


## Final Step:

* Just run the python file now on your monitoring server.
$ python linux_scanner.py

### Thank you.


