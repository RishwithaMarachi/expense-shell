echo -e "\e[31m Installing nginx \e[0m"
dnf install nginx -y &>>/tmp/expense.log

echo -e "\e[32m Copying Expense Config file \e[0m"
cp expense.conf /etc/nginx/default.d/expense.conf &>>/tmp/expense.log

echo -e "\e[33m Clear Old Nginx Content \e[0m"
rm -rf /usr/share/nginx/html/* &>>/tmp/expense.log

echo -e "\e[34m Download Frontend Application Code \e[0m"
curl -o /tmp/frontend.zip https://expense-artifacts.s3.amazonaws.com/frontend.zip &>>/tmp/expense.log

echo -e "\e[35m unzip nginx \e[0m"
cd /usr/share/nginx/html &>>/tmp/expense.log
unzip /tmp/frontend.zip &>>/tmp/expense.log

echo -e "\e[36m enable and restart nginx \e[0m"
systemctl enable nginx &>>/tmp/expense.log
systemctl start nginx &>>/tmp/expense.log