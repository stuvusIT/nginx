#!/usr/bin/env bash

# Usage:
# (1) ./ip ban <ip-address>
# (2) ./ip unban <ip-address>
# (3) ./ip flush

set -euo pipefail

if [[ $# -eq 0 ]]; then
    echo "No arguments supplied"
    exit 1
fi

if [[ "$1" == "ban" ]] && ! grep -q "deny $2;" /etc/nginx/conf.d/deny.conf; then
    # Add address
    echo "deny $2;" >> /etc/nginx/conf.d/deny.conf
elif [[ "$1" == "unban" ]]; then
    # Remove address
    sed -i "/deny $2;/d" /etc/nginx/conf.d/deny.conf
elif [[ "$1" == "flush" ]]; then
    # Remove all addresses
    sed -i "/^deny/d" /etc/nginx/conf.d/deny.conf
fi

# Reload nginx
systemctl reload nginx
