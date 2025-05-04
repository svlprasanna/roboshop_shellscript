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

curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip
VALIDATE $? "downloading catalogue zip file"

cd /app 
unzip -o /tmp/catalogue.zip
npm install 
VALIDATE $? "installing dependencies"

cp /home/centos/roboshop_shellscript/catalogue.service /etc/systemd/system/
VALIDATE $? "catalogue.service file created"

systemctl daemon-reload
VALIDATE $? "catalogue daemon reload"

systemctl enable catalogue
VALIDATE $? "enable the catalogue"

systemctl start catalogue
VALIDATE $? "start the catalague"

cp /home/centos/roboshop_shellscript/mongo.repo /etc/yum.repos.d/
VALIDATE $? "copying mongo repo file"

dnf install mongodb-org-shell -y
VALIDATE $? "installing mongodb"

mongo --host mongodb.lakshmimohan.shop </app/schema/catalogue.js
VALIDATE $? "loading catalogue data into mongodb"





