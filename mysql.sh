log_file=/tmp/expense.log
COLOR="\e[31m"

MySQL_ROOT_PASSWORD=$1
status_check(){
  if [ $? -eq 0 ]; then
  echo -e "\e[32m SUCCESS \e[0m"
else
  echo -e "\e[31m FAILURE \e[0m"
fi
}

echo -e "$COLOR Disable version version sql \e[0m"
dnf module disable mysql -y &>>$log_file
status_check

echo -e "$COLOR Copying Mysql Repo file \e[0m"
cp mysql.repo /etc/yum.repos.d/mysql.repo &>>$log_file
status_check

echo -e "$COLOR Install Mysql \e[0m"
dnf install mysql-community-server -y &>>$log_file
status_check

echo -e "$COLOR Enable and restart \e[0m"
systemctl enable mysqld &>>$log_file
systemctl start mysqld &>>$log_file
status_check

echo -e "$COLOR change the default root password in order to start using the database service \e[0m"
mysql_secure_installation --set-root-pass ${MySQL_ROOT_PASSWORD} &>>$log_file
status_check

echo -e "$COLOR check the new password working or not \e[0m"
mysql -uroot -p${MySQL_ROOT_PASSWORD} &>>$log_file
status_check