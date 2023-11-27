echo -e "\e[31m Installing nginx \e[0m"
dnf install nginx -y

echo -e "\e[32m Copying Expense Config file \e[0m"
cp expense.conf /etc/nginx/default.d/expense.conf

echo -e "\e[33m Clear Old Nginx Content \e[0m"
rm -rf /usr/share/nginx/html/*

echo -e "\e[34m Download Frontend Application Code \e[0m"
curl -o /tmp/frontend.zip https://expense-artifacts.s3.amazonaws.com/frontend.zip &>>/tmp/expense.log

echo -e "\e[35m unzip nginx \e[0m"
cd /usr/share/nginx/html
unzip /tmp/frontend.zip

echo -e "\e[36m enable and restart nginx \e[0m"
systemctl enable nginx
systemctl start nginx