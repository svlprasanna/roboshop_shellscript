#!/bin/bash

ID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/mongo.log"
echo -e "$Y script started running at $TIMESTAMP $N"

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
}

dnf module disable nodejs -y
dnf module enable nodejs:18 -y
VALIDATE $? "enabling nodejs 18"

dnf install nodejs -y
VALIDATE $? "installing nodejs"
