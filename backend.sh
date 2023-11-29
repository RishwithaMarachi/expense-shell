log_file=/tmp/expense.log
COLOR="\e[31m"

echo -e "$COLOR Disable older version \e[0m"
dnf module disable nodejs -y &>>$log_file
if [ $? -eq 0 ]; then
  echo -e "\e[32m SUCCESS \e[0m"
else
  echo -e "\e[31m FAILURE \e[0m"
fi

echo -e "$COLOR Enable Node.js \e[0m"
dnf module enable nodejs:18 -y &>>$log_file
if [ $? -eq 0 ]; then
  echo -e "\e[32m SUCCESS \e[0m"
else
  echo -e "\e[31m FAILURE \e[0m"
fi

echo -e "$COLOR Install Node.js \e[0m"
dnf install nodejs -y &>>$log_file
if [ $? -eq 0 ]; then
  echo -e "\e[32m SUCCESS \e[0m"
else
  echo -e "\e[31m FAILURE \e[0m"
fi

echo -e "$COLOR Copying Backend Service \e[0m"
cp backend.service /etc/systemd/system/backend.service &>>$log_file
if [ $? -eq 0 ]; then
  echo -e "\e[32m SUCCESS \e[0m"
else
  echo -e "\e[31m FAILURE \e[0m"
fi

echo -e "$COLOR Add application User \e[0m"
id expense &>>$log_file
if [ $? -ne 0 ]; then
  useradd expense &>>$log_file
  if [ $? -eq 0 ]; then
   echo -e "\e[32m SUCCESS \e[0m"
  else
   echo -e "\e[31m FAILURE \e[0m"
 fi
fi

echo -e "$COLOR Making a directory with app \e[0m"
if [ -d /app ]; then
 mkdir /app &>>$log_file
 if [ $? -eq 0 ]; then
  echo -e "\e[32m SUCCESS \e[0m"
 else
  echo -e "\e[31m FAILURE \e[0m"
 fi
fi

echo -e "$COLOR Removing old version content \e[0m"
rm -rf /app/* &>>$log_file
if [ $? -eq 0 ]; then
  echo -e "\e[32m SUCCESS \e[0m"
else
  echo -e "\e[31m FAILURE \e[0m"
fi

echo -e "$COLOR Download the application code to created app directory \e[0m"
curl -o /tmp/backend.zip https://expense-artifacts.s3.amazonaws.com/backend.zip &>>$log_file
cd /app &>>$log_file
unzip /tmp/backend.zip &>>$log_file
if [ $? -eq 0 ]; then
  echo -e "\e[32m SUCCESS \e[0m"
else
  echo -e "\e[31m FAILURE \e[0m"
fi

echo -e "$COLOR download the dependencies \e[0m"
cd /app &>>$log_file
npm install &>>$log_file
if [ $? -eq 0 ]; then
  echo -e "\e[32m SUCCESS \e[0m"
else
  echo -e "\e[31m FAILURE \e[0m"
fi

echo -e "$COLOR install mysql \e[0m"
dnf install mysql -y &>>$log_file
if [ $? -eq 0 ]; then
  echo -e "\e[32m SUCCESS \e[0m"
else
  echo -e "\e[31m FAILURE \e[0m"
fi

echo -e "$COLOR Load Schema \e[0m"
mysql -h mysql-dev.devopsr1.online -uroot -pExpenseApp@1 < /app/schema/backend.sql &>>$log_file
if [ $? -eq 0 ]; then
  echo -e "\e[32m SUCCESS \e[0m"
else
  echo -e "\e[31m FAILURE \e[0m"
fi

echo -e "$COLOR Reload Enable and Restart \e[0m"
systemctl daemon-reload &>>$log_file
systemctl enable backend &>>$log_file
systemctl restart backend &>>$log_file
if [ $? -eq 0 ]; then
  echo -e "\e[32m SUCCESS \e[0m"
else
  echo -e "\e[31m FAILURE \e[0m"
fi