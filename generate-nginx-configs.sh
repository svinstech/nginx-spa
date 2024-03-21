#!/usr/bin/env bash

set -e

generate_conf () {
cat << EOF > $1
server {
  listen 80 default_server;

  gzip on;
  gzip_min_length 1000;
  gzip_types text/plain text/xml application/javascript text/css;

  root /app;

  # normal routes
  # serve given url and default to index.html if not found
  # e.g. /, /user and /foo/bar will return index.html
  location / {
    add_header Cache-Control "no-store";
    add_header Content-Security-Policy $2;
    add_header X-Content-Type-Options "nosniff";
    add_header X-XSS-Protection "1; mode=block";
    try_files \$uri \$uri/index.html /index.html;
  }

  # files
  # for all routes matching a dot, check for files and return 404 if not found
  # e.g. /file.js returns a 404 if not found
  location ~ \.(?!html) {
    add_header Cache-Control "public, max-age=2678400";
    try_files \$uri =404;
  }
}
EOF
}

generate_conf "nginx.conf" "\"frame-ancestors 'self'\""
generate_conf "nginx-embedded-non-prod.conf" "\"frame-ancestors 'self' https://mock-embedded-partner.vouch-stg.us https://uat-mock-embedded-partner.vouch-stg.us https://mock-embedded-partner.vouch-dev.us\""
generate_conf "nginx-embedded-prod.conf" "\"frame-ancestors 'self'\""
