#!/bin/bash

check_root


dnf install nginx -y &>>$LOGFILE 
VALIDATE $? "nginx instsall"

systemctl enable nginx &>>$LOGFILE 
VALIDATE $? "enable nginx"

systemctl start nginx &>>$LOGFILE 
VALIDATE $? "start nginx"

rm -rf /usr/share/nginx/html/* &>>$LOGFILE 
VALIDATE $? "remove code "

curl -o /tmp/frontend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-frontend-v2.zip &>>$LOGFILE 
VALIDATE $? "frontend code" 

cd /usr/share/nginx/html &>>$LOGFILE 
VALIDATE $? "copy backend code"

unzip /tmp/frontend.zip &>>$LOGFILE 
VALIDATE $? "unzip backend code"

cp -rf /home/ec2-user/expense-shell-1/expense.conf /etc/nginx/default.d/expense.conf &>>$LOGFILE 
VALIDATE $? "servie"

systemctl restart nginx &>>$LOGFILE 
VALIDATE $? "restart nginx"
