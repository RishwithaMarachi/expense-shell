echo -e" \e[31m Disable version version sql \e[0m"
dnf module disable mysql -y

echo -e" \e[32m Copying Mysql Repo file \e[0m"
cp mysql.repo /etc/yum.repos.d/mysql.repo

echo -e" \e[33m Install Mysql \e[0m"
dnf install mysql-community-server -y

echo -e" \e[34m Enable and restart \e[0m"
systemctl enable mysqld
systemctl start mysqld

echo -e" \e[35m change the default root password in order to start using the database service \e[0m"
mysql_secure_installation --set-root-pass ExpenseApp@1

echo -e" \e[36m check the new password working or not \e[0m"
mysql -uroot -pExpenseApp@1
