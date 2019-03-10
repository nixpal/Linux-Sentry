#!/usr/bin/python

import smtplib, ssl
from email.MIMEMultipart import MIMEMultipart
from email.MIMEText import MIMEText
from email.MIMEBase import MIMEBase
from email import encoders
import sys
import os
import subprocess
import email
from time import sleep
import imaplib

smtp_server = "smtp.cybercon.com"


port = 25
context = ssl.create_default_context()

message = MIMEMultipart("alternative")
message["To"] = "tarek@cybercon.net"
sender_email = "csdevmon@cybercon.com"
message["From"] = "csdevmon@cybercon.com"
message["Subject"] = "CSDev Monitor Alert"


while True:

    p = subprocess.Popen('./run-remote.sh', stdout=subprocess.PIPE, stderr=subprocess.PIPE, shell=True)
    (output, err) = p.communicate()

    if output == "":
        sys.stdout.write('[+]' + ' Monitoring ON'  + '\r')
        sys.stdout.flush()
        sleep(8)
        continue
    else:
        print "[-] Found something...."
        sleep(2)
        print "[-] Sending output ..."
        sleep(1)
        msg = output
        msgpart = MIMEText(msg, "plain")

        message.attach(msgpart)
        server = smtplib.SMTP(smtp_server, port)
        server.starttls()
        server.sendmail(sender_email, "tarek@cybercon.net", message.as_string())
        print "[-] Sent "
        sleep(40)
