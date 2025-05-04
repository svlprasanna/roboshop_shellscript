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

dnf install nginx -y
VALIDATE $? "installing nginx"

systemctl enable nginx
VALIDATE $? "enabling nginx"

systemctl start nginx
VALIDATE $? "starting nginx"

rm -rf /usr/share/nginx/html/*
VALIDATE $? "removing the default content pointing to"

curl -o /tmp/web.zip https://roboshop-builds.s3.amazonaws.com/web.zip
VALIDATE $? "download the front end content"

cd /usr/share/nginx/html
unzip -o /tmp/web.zip
VALIDATE $? "unzip the content"

cp /home/centos/roboshop_shellscript/roboshop.conf /etc/nginx/default.d/
systemctl restart nginx
VALIDATE $? "restart the nginx"
