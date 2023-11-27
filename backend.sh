echo -e "\e[31m Disable older version and enable nodejs:18 \e[0m"
dnf module disable nodejs -y
dnf module enable nodejs:18 -y

echo -e "\e[32m Install Node.js \e[0m"
dnf install nodejs -y

echo -e "\e[33m Copying Backend Service \e[0m"
cp backend.service /etc/systemd/system/backend.service

echo -e "\e[34m Add application User \e[0m"
useradd expense

echo -e "\e[35m Making a directory with app \e[0m"
mkdir /app

echo -e "\e[36m Download the application code to created app directory \e[0m"
curl -o /tmp/backend.zip https://expense-artifacts.s3.amazonaws.com/backend.zip
cd /app
unzip /tmp/backend.zip

echo -e "\e[31m download the dependencies \e[0m"
cd /app
npm install

echo -e "\e[32m install mysql \e[0m"
dnf install mysql -y

echo -e "\e[33m Load Schema \e[0m"
mysql -h mysql-dev.devopsr1.online -uroot -pExpenseApp@1 < /app/schema/backend.sql

echo -e "\e[34m Reload Enable and Restart \e[0m"
systemctl daemon-reload
systemctl enable backend
systemctl restart backend