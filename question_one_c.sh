#!/bin/bash
# question_one_c_i.sh ------> Simple Shell Script For automation
# Linux server / desktop.
# Author: Eleman hillary Banabas
# Date: 12/12/2017

#self-explanatory
cd /home/
mkdir admins
chown .admin admins
chmod 770 admins
chmod g+s admins

#creating a crontab
crontab -e 
#already created
30 17 * * * /bin/echo hello
#listing crontabs
crontab -l

#finding all files ending with a dot pl  owned by root and then copying them to /opt/dir
find / -user root -name "*.pl" -exec cp -r {} /opt/dir\;
