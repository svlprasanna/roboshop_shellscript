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
    echo -e "installation of $R $2 failed $N"
    exit 1
    else
    echo -e "installation of $G $2 is success $N"
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

curl -L -o /tmp/cart.zip https://roboshop-builds.s3.amazonaws.com/cart.zip
VALIDATE $? "downloading app code to app folder"

cd /app 
unzip -o /tmp/cart.zip
VALIDATE $? "unzipping the content"

npm install 
VALIDATE $? "installing the dependencies"

cp /home/centos/roboshop_shellscript/cart.service /etc/systemd/system/
VALIDATE $? "craeting a file cart.service"

systemctl daemon-reload
VALIDATE $? "daemon loading"
systemctl enable cart 
VALIDATE $? "enabling cart"
systemctl start cart
VALIDATE $? "starting cart service"
