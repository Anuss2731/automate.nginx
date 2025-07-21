#!/bin/bash

#update the system
sudo apt-get update

#install nginx
echo "..................step1: Checking if NGINX is installed...................."

if ! command -v nginx >/dev/null 2>&1; then
    echo " ...................NGINX not found. Installing...................."
    sudo apt update
    sudo apt install -y nginx
else
    echo "................ NGINX is already installed...................."
fi

echo "step2:........... Enabling and starting NGINX service...................."
# Enable NGINX to start on boot
sudo systemctl enable nginx
# Start or restart NGINX service
sudo systemctl start nginx
# Show NGINX status
sudo systemctl status nginx | grep Active
echo "............ NGINX setup complete....................."

#ufw rules
sudo ufw allow 'Nginx HTTP'
sudo ufw allow 'Nginx HTTPS'
sudo ufw status

#getting ip address
echo "..................step3: getting ip adress......................."
ip_add=$(ip r | awk '/^default/ {print $9}')
echo "this is your ip address $ip_add"

#changing permision
echo "...............step4: changing nginx.conf file permission......................."
sudo chmod 777 /etc/nginx/nginx.conf

#changing path
echo "..............step5: changing the path of configration file..........."
NGINX_CONF="/etc/nginx/nginx.conf"  # Change to your file path

# changing conf of nginx.conf file
echo "step6: changing ngin.conf file"
if grep -q '^\s*#\s*include /etc/nginx/sites-enabled/\*;' "$NGINX_CONF"; then
    echo "already commented. No changes made."
else
    sudo sed -i 's|^\s*include /etc/nginx/sites-enabled/\*;|# include /etc/nginx/sites-enabled/*;|' "$NGINX_CONF"
    echo "commented successfully."
fi

# creating configration file
echo "..................step7: creating configration file..................."
read -p "GIVE YOUR WEBSITE NAME: " name
sudo touch /etc/nginx/conf.d/$name.conf


#clone code form git
echo ".................step7: we clone your code................"
echo "YOU WANT TO CLONE YOUR CODE FORM GITHUB y/n"
read choice
case $choice in
        n)
                echo "continoue to next step";;

        y)
                echo "now provide you HTTPS of github"
                read http
	        repo_name=$(basename -s .git "$http") #get foldername in which htmlfile store
        	path="/var/www/$repo_name"
                $(sudo git clone $http $path)
                 
		if [ -d "$path" ];
	       	then
                    echo " Repo cloned successfully!"
                    echo " Repo name is: $repo_name"
                else
                    echo "Failed to clone the repo."
                    exit 1
                fi
		
		;;
	*)echo "wrong value"
		exit 1 ;;
esac



# weiting configration file

echo ".......................EDITING NGINX CONF FILE..................................."
echo "provide some basic information:"

#variable
path="/etc/nginx/conf.d/$name.conf"
sudo chmod 777 $path
read -p "WHICH PORT U WANT TO RUN WEBSITE  HTTP=80:" port
read -p "DO u have register domain name Y/N:" server
case $server in
        n)result="$ip_add";;
        y)
                read -p "give u registor domain name:" domain
                result="$domain";;
	*)echo "wrong value"
		exit 1;;
esac

echo "server {

        listen $port;
        root /var/www/$repo_name;
        server_name $result;
       
        index index.html index.htm;
        location /{
                  auth_basic off;
                try_files $uri $uri/ =404;

        }

} " > $path
sudo nginx -t
sudo systemctl reload nginx

echo "............SUCCESSFULLY YOU CREATE WEBSERVER............."
echo "......................WITH NGINX..........................."
echo " IP ADDRESS : $ip_add"

