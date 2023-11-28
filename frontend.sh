log_file=/tmp/expense.log
echo -e "\e[31m Installing nginx \e[0m"
dnf install nginx -y &>>$log_file

echo -e "\e[32m Copying Expense Config file \e[0m"
cp expense.conf /etc/nginx/default.d/expense.conf &>>$log_file

echo -e "\e[33m Clear Old Nginx Content \e[0m"
rm -rf /usr/share/nginx/html/* &>>$log_file

echo -e "\e[34m Download Frontend Application Code \e[0m"
curl -o /tmp/frontend.zip https://expense-artifacts.s3.amazonaws.com/frontend.zip &>>$log_file

echo -e "\e[35m unzip nginx \e[0m"
cd /usr/share/nginx/html &>>$log_file
unzip /tmp/frontend.zip &>>$log_file

echo -e "\e[36m enable and restart nginx \e[0m"
systemctl enable nginx &>>$log_file
systemctl start nginx &>>$log_file