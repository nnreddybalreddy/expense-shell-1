#!/bin/bash

source ./common.sh

echo "Enter db password:::"
read mysql_root_password

check_root

dnf module disable nodejs -y &>>$LOGFILE 
VALIDATE $? "nodejs disable"

dnf module enable nodejs:20 -y &>>$LOGFILE 
VALIDATE $? "nodejs enable"

dnf install nodejs -y &>>$LOGFILE 
VALIDATE $? "install nodejs "

id expense &>>$LOGFILE

if [ $? -ne 0 ]
then 
    useradd expense &>>$LOGFILE 
    VALIDATE $? "user add expense"
else 
    echo "expense user already"
fi 

mkdir -p /app &>>$LOGFILE 
VALIDATE $? "app"

curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip &>>$LOGFILE 
VALIDATE $? "app"

cd /app &>>$LOGFILE 
VALIDATE $? "app"

rm -rf /app/* &>>$LOGFILE 
VALIDATE $? "remove app files " 

unzip /tmp/backend.zip &>>$LOGFILE 
VALIDATE $? "copy backend code"

npm install &>>$LOGFILE 
VALIDATE $? "npm install"

cp -rf /home/ec2-user/expense-shell-1/backend.service /etc/systemd/system/backend.service &>>$LOGFILE 
VALIDATE $? "copied service"

systemctl daemon-reload &>>$LOGFILE 
VALIDATE $? "daemon reload" 

systemctl start backend &>>$LOGFILE 
VALIDATE $? "start backend"

systemctl enable backend  &>>$LOGFILE 
VALIDATE $? "enable backend"

dnf install mysql -y >>$LOGFILE 
VALIDATE $? "mysql install"

mysql -h db.narendra.shop -uroot -p${mysql_root_password} < /app/schema/backend.sql &>>$LOGFILE 
VALIDATE $? "scheam load"

systemctl restart backend >>$LOGFILE 
VALIDATE $? "backend restart"





