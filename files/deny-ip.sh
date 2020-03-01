#!/bin/bash

# Usage:
# (1) ./ip ban <ip-address>
# (2) ./ip unban <ip-address>
# (3) ./ip flush

if [ $# -eq 0 ]; then
    echo "No arguments supplied"
    exit
fi

if [ $1 == "ban" ]; then
    # Add address
    sed -i "/deny $2;/d" /etc/nginx/conf.d/deny.conf
    echo "deny $2;" >> /etc/nginx/conf.d/deny.conf
elif [ $1 == "unban" ]; then
    # Remove address
    sed -i "/deny $2;/d" /etc/nginx/conf.d/deny.conf
elif [ $1 == "flush" ]; then
    # Remove all addresses
    sed -i "/^deny/d" /etc/nginx/conf.d/deny.conf
fi

# Reload nginx
systemctl reload nginx
