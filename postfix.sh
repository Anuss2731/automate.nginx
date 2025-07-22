#!/bin/bash

sudo apt-get update

# Exit on error
set -e

# Get current hostname
HOSTNAME=$(hostname)

echo " Installing Postfix and Mailutils..."

# Preseed Postfix installation with "Internet Site" option
echo "postfix postfix/mailname string $HOSTNAME" | sudo debconf-set-selections
echo "postfix postfix/main_mailer_type select Internet Site" | sudo debconf-set-selections

# Install Postfix and mail command (mailutils)
sudo apt-get update
sudo apt-get install -y postfix mailutils

# Confirm success
echo " ...........................Postfix installed with Internet Site mode............................"
echo " .............................Hostname set as mail name: $HOSTNAME..............................."

read -p "GIVE THE EMAIL WHICH YOU WANT TO ATTACH: " email
echo "............................................IMP:create your app passwrd form your google account manager................................... "
echo "TO GET PASSWORD"
echo "OPEN GOOGLE ACOOUNT MANAGER"
echo "search Apps password and create it"
read -p "GIVE YOUR APPS PASSWOD: " app_passwd

echo "step2:edit the postfix configration file"
POSTFIX_CONFIG="/etc/postfix/main.cf"
sudo chmod 777 "$POSTFIX_CONFIG"
sudo cp "$POSTFIX_CONFIG" "${POSTFIX_CONFIG}.bak"

sudo sed -i '/^relayhost *=/d' "$POSTFIX_CONFIG"
sudo sed -i '/^myhostname *=/d' "$POSTFIX_CONFIG"
sudo sed -i '/^smtp_sasl_password_maps *=/d' "$POSTFIX_CONFIG"
sudo sed -i '/^smtp_sasl_auth_enable *=/d' "$POSTFIX_CONFIG"
sudo sed -i '/^smtp_tls_security_level *=/d' "$POSTFIX_CONFIG"
sudo sed -i '/^smtp_sasl_security_options *=/d' "$POSTFIX_CONFIG"


sudo tee -a "$POSTFIX_CONFIG" > /dev/null <<EOL

# Added by script
relayhost = [smtp.gmail.com]:587
myhostname = your_hostname
smtp_sasl_password_maps = hash:/etc/postfix/sasl/sasl_passwd
smtp_sasl_auth_enable = yes
smtp_tls_security_level = encrypt
smtp_sasl_security_options = noanonymous
EOL

echo "Lines successfully added to $POSTFIX_CONFIG"

echo "CREATING THE SASL FILE FOR YOUR OONNECTION WITH THE EMAIL"


SASL_DIR="/etc/postfix/sasl"
SASL_FILE="$SASL_DIR/sasl_passwd"

if [ ! -d "$SASL_DIR" ]; then
    echo "Directory $SASL_DIR does not exist. Creating..."
    sudo mkdir -p "$SASL_DIR"
else
    echo "Directory $SASL_DIR already exists. Skipping creation."
fi

# Create the file inside the directory
sudo touch "$SASL_FILE"
sudo chmod 777 "$SASL_FILE"
echo "file created (or already exists): $SASL_FILE"

echo "[smtp.gmail.com]:587 $email $app_passwd" | sudo tee -a /etc/postfix/sasl/sasl_passwd > /dev/null

sudo chmod 600 "$SASL_FILE"
sudo postmap /etc/postfix/sasl/sasl_passwd
sudo systemctl start postfix.service
sudo systemctl status postfix.service


echo "FOR TEST: echo "Test Mail" | mail -s "Postfix TEST" yourgmail "
echo "YOU GET THE MAIL WITH THE NAME $(hostname)"
