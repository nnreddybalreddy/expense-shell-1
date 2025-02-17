#!/bin/bash

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
TIMESTAMP=$(date +%F-%M-%H-%S)
LOGFILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log

USERID=$(id -u)

echo "Enter db password:::"
read mysql_root_password

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




