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

sudo dnf module reset redis -y
sudo dnf module enable redis:remi-7.0 -y
sudo dnf install redis -y


#sudo dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y
VALIDATE $? "installing redis repo files"

#dnf module enable redis:remi-6.2 -y
sudo systemctl enable --now redis
VALIDATE $? "enabling redis packages"

#dnf install redis -y
#VALIDATE $? "installing redis"

sed -e 's/127.0.0.1/0.0.0.0/g' /etc/redis.conf
VALIDATE $? "updating listen address"

#systemctl enable redis
#VALIDATE $? "enabling redis"

systemctl start redis
VALIDATE $? "starting redis"
