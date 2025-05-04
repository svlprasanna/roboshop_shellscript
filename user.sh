#!/bin/bash

ID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/mongo.log"
echo -e "$Y script started running at $TIMESTAMP $N"

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

if [ $ID -ne 0 ]
then
echo "error:please run with root access"
exit 1
else
echo "you are root user"
fi

VALIDATE(){
    if [ $1 -ne 0 ]
    then
    echo -e "$R $2 failed $N"
    exit 1
    else
    echo -e "$G $2 is success $N"
fi
}

dnf module disable nodejs -y
dnf module enable nodejs:18 -y
VALIDATE $? "enabling nodejs 18"

dnf install nodejs -y
VALIDATE $? "installing nodejs"

id roboshop
if [ id -ne 0 ] 
then
useradd roboshop
VALIDATE $? "adding roboshop user"
else
echo " user roboshop already exists so skipping.."
fi

mkdir -p /app
VALIDATE $? "creating app directory"

curl -L -o /tmp/user.zip https://roboshop-builds.s3.amazonaws.com/user.zip
VALIDATE $? "downloading application code to app directory"

cd /app
unzip -o /tmp/user.zip
VALIDATE $? "unzipping files"

npm install 
VALIDATE $? "downloading dependencies"

cp /home/centos/roboshop_shellscript/user.service /etc/systemd/system/
VALIDATE "creating user.service file"

systemctl daemon-reload
VALIDATE $? "daemon loading"
systemctl enable user 
VALIDATE $? "enable the user service"
systemctl start user
VALIDATE $? "starting the user service"

cp /home/centos/roboshop_shellscript/mongo.repo /etc/yum.repos.d/
VALIDATE $? "creating mongo repository"

dnf install mongodb-org-shell -y
VALIDATE $? "installing mongodb client"

mongo --host mongodb.lakshmimohan.shop </app/schema/user.js
VALIDATE $? "loading schema into mongodb"
