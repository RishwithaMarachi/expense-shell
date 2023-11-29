log_file=/tmp/expense.log
COLOR="\e[31m"

echo -e "$COLOR Disable older version and enable nodejs:18 \e[0m"
dnf module disable nodejs -y &>>$log_file
if [ $? -eq 0 ]; then
  echo SUCCESS
else
  echo FAILURE
fi

dnf module enable nodejs:18 -y &>>$log_file
if [ $? -eq 0 ]; then
  echo SUCCESS
else
  echo FAILURE
fi

echo -e "$COLOR Install Node.js \e[0m"
dnf install nodejs -y &>>$log_file
echo $?

echo -e "$COLOR Copying Backend Service \e[0m"
cp backend.service /etc/systemd/system/backend.service &>>$log_file
echo $?

echo -e "$COLOR Add application User \e[0m"
useradd expense &>>$log_file
echo $?

echo -e "$COLOR Making a directory with app \e[0m"
mkdir /app &>>$log_file
echo $?

echo -e "$COLOR Removing old version content \e[0m"
rm -rf /app/* &>>$log_file
echo $?

echo -e "$COLOR Download the application code to created app directory \e[0m"
curl -o /tmp/backend.zip https://expense-artifacts.s3.amazonaws.com/backend.zip &>>$log_file
cd /app &>>$log_file
unzip /tmp/backend.zip &>>$log_file
echo $?

echo -e "$COLOR download the dependencies \e[0m"
cd /app &>>$log_file
npm install &>>$log_file
echo $?

echo -e "$COLOR install mysql \e[0m"
dnf install mysql -y
echo $?

echo -e "$COLOR Load Schema \e[0m"
mysql -h mysql-dev.devopsr1.online -uroot -pExpenseApp@1 < /app/schema/backend.sql &>>$log_file
echo $?

echo -e "$COLOR Reload Enable and Restart \e[0m"
systemctl daemon-reload &>>$log_file
systemctl enable backend &>>$log_file
systemctl restart backend &>>$log_file
echo $?