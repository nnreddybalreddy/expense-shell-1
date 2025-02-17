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

dnf list installed nodejs &>>$LOGFILE

if [ $? -eq 0 ]
then 
    echo "nodejs already installed"
else 
    dnf module disable nodejs -y &>>$LOGFILE 
    VALIDATE $? "mysql-server installation"
fi 
    