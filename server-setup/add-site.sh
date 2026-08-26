#!/bin/bash
# Usage: ./add-site.sh domain.mosinstroy.ru
# Run on the server to add a new site/subdomain

DOMAIN=$1

if [ -z "$DOMAIN" ]; then
    echo "Usage: $0 <domain>"
    exit 1
fi

SITE_DIR="/var/www/sites/$DOMAIN"
NGINX_CONF="/etc/nginx/sites-available/$DOMAIN"

mkdir -p "$SITE_DIR"

sed "s/DOMAIN_NAME/$DOMAIN/g" \
    "$(dirname "$0")/nginx-site.conf.template" > "$NGINX_CONF"

ln -sf "$NGINX_CONF" /etc/nginx/sites-enabled/

nginx -t && systemctl reload nginx

echo "Site $DOMAIN configured. Don't forget to:"
echo "  1. Add A-record for $DOMAIN -> 188.92.28.115 in DNS"
echo "  2. Add folder sites/$DOMAIN/ in the repo"
echo "  3. Run: certbot --nginx -d $DOMAIN (for HTTPS)"
