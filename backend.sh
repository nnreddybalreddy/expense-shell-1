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
    useradd expense
else 
    echo "expense user already"
fi 


