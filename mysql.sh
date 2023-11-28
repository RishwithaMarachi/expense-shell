log_file=/tmp/expense.log
COLOR="\e[31m"

echo -e "$COLOR Disable version version sql \e[0m"
dnf module disable mysql -y &>>$log_file
echo $?

echo -e "$COLOR Copying Mysql Repo file \e[0m"
cp mysql.repo /etc/yum.repos.d/mysql.repo &>>$log_file
echo $?

echo -e "$COLOR Install Mysql \e[0m"
dnf install mysql-community-server -y &>>$log_file
echo $?

echo -e "$COLOR Enable and restart \e[0m"
systemctl enable mysqld &>>$log_file
systemctl start mysqld &>>$log_file
echo $?

echo -e "$COLOR change the default root password in order to start using the database service \e[0m"
mysql_secure_installation --set-root-pass ExpenseApp@1 &>>$log_file
echo $?

echo -e "$COLOR check the new password working or not \e[0m"
mysql -uroot -pExpenseApp@1 &>>$log_file
echo $?