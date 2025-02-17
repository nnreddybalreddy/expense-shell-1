#!/bin/bash

source ./common.sh

echo "Enter db password:::"
read mysql_root_password

check_root


dnf install mysql-server -y &>>$LOGFILE 
VALIDATE $? "mysql server"

systemctl enable mysqld &>>$LOGFILE 
VALIDATE $? "enable mysqld"

systemctl start mysqld &>>$LOGFILE 
VALIDATE $? "start mysql server"

mysql -h db.narendra.shop -uroot -p${mysql_root_password} -e 'show databases;' &>>$LOGFILE

if [ $? -ne 0 ]
then 
    mysql_secure_installation --set-root-pass ${mysql_root_password} &>>$LOGFILE
else 
    echo -e "MySQL Root password is already setup...$Y SKIPPING $N"
fi 



