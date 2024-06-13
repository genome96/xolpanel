#!/bin/bash

# Define your variables here
bottoken="7210432180:AAEIvgyONqpqzDSdU7rlalbpDq8kklBN9dU"
admin="1187810967"

# Function to extract domain name
extract_domain() {
    # Check if domain files exist and extract domain from the first found file
    if [ -f "/etc/xray/domain" ]; then
        domain=$(cat /etc/xray/domain)
    elif [ -f "/etc/v2ray/domain" ]; then
        domain=$(cat /etc/v2ray/domain)
    elif [ -f "/root/domain" ]; then
        domain=$(cat /root/domain)
    elif [ -f "/root/scdomain" ]; then
        domain=$(cat /root/scdomain)
    else
        echo "Domain file not found!"
        exit 1
    fi
}

# Function to install necessary packages and configure xolpanel
install_xolpanel() {
    # Create a non-interactive environment
    export DEBIAN_FRONTEND=noninteractive

    # Install necessary packages
    apt-get update
    apt-get install -y python3 python3-pip git unzip >/dev/null 2>&1

    # Clone xolpanel repository
    git clone https://github.com/genome96/xolpanel.git >/dev/null 2>&1
    unzip xolpanel/xolpanel.zip >/dev/null 2>&1
    pip3 install -r xolpanel/requirements.txt >/dev/null 2>&1
    pip3 install pillow >/dev/null 2>&1

    # Set up data
    echo -e BOT_TOKEN='"'$bottoken'"' > /root/xolpanel/var.txt
    echo -e ADMIN='"'$admin'"' >> /root/xolpanel/var.txt
    echo -e DOMAIN='"'$domain'"' >> /root/xolpanel/var.txt

    # Create systemd service file for xolpanel
    cat > /etc/systemd/system/xolpanel.service << END
[Unit]
Description=Simple XolPanel - @XolPanel
After=network.target

[Service]
WorkingDirectory=/root
ExecStart=/usr/bin/python3 -m xolpanel
Restart=always

[Install]
WantedBy=multi-user.target
END

    # Start and enable xolpanel service
    systemctl daemon-reload
    systemctl start xolpanel
    systemctl enable xolpanel >/dev/null 2>&1
}

# Main execution flow
extract_domain
install_xolpanel

# Clean up unnecessary files
rm -rf /root/xolpanel.zip
rm -rf /root/xolpanel