#!/bin/bash

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
TIMESTAMP=$(date +%F-%M-%H-%S)
LOGFILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log

USERID=$(id -u)

# echo "Enter db password:::"
# read mysql_root_password

if [ $USERID -ne 0 ]
then 
    echo "Be a root user"
    exit 1
else 
    echo "You are super"    
fi 

VALIDATE(){
    if [ $? -eq 0 ]
    then 
        echo -e "$2 $G success $N"
    else 
        echo -e "$2 $R failure $N"    
    fi 
}


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
