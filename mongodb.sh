#!/bin/bash

ID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/new.log"
echo -e "$Y script started running at $TIMESTAMP $N" &>> $LOGFILE

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

VALIDATE(){
    if [ $1 -ne 0 ]
    then
    echo -e "installation of $R $2 failed $N"
    else
    echo -e "installation of $G $2 is success $N"
fi
} &>> $LOGFILE

cp mongo.repo /etc/yum.repos.d/

dnf install mongodb-org -y 

VALIDATE $? "installing mongodb"