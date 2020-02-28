#!/bin/bash

# Usage:
# (1) ./ip ban <ip-address>
# (2) ./ip unban <ip-address>

if [ $# -eq 0 ]; then
    echo "No arguments supplied"
    exit
fi

# Remove IP address
sed -i "/deny $2;/d" /etc/nginx/conf.d/deny.conf

# Add IP address if needed
if [ $1 == "ban" ]; then
    echo "deny $2;" >> /etc/nginx/conf.d/deny.conf
fi

# Reload nginx
systemctl reload nginx
