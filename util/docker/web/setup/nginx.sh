#!/bin/bash
set -e
set -x

# Package installation handled in 00_packages.sh

# Install nginx and configuration
cp /bd_build/web/nginx/proxy_params.conf /etc/nginx/proxy_params
cp /bd_build/web/nginx/nginx.conf.tmpl /etc/nginx/nginx.conf.tmpl
cp /bd_build/web/nginx/azuracast.conf.tmpl /etc/nginx/azuracast.conf.tmpl

# Change M3U8 MIME type to "application/x-mpegurl" for broader compatibility.
sed -i 's#application/vnd.apple.mpegurl#application/x-mpegurl#' /etc/nginx/mime.types

mkdir -p /etc/nginx/azuracast.conf.d/

# Create nginx temp dirs
# mkdir -p /tmp/app_nginx_client /tmp/app_fastcgi_temp
mkdir -p /tmp/nginx_client \
  /tmp/nginx_fastcgi \
  /tmp/nginx_cache

# touch /tmp/app_nginx_client/.tmpreaper
# touch /tmp/app_fastcgi_temp/.tmpreaper
touch /tmp/nginx_client/.tmpreaper
touch /tmp/nginx_fastcgi/.tmpreaper
touch /tmp/nginx_cache/.tmpreaper

# chmod -R 777 /tmp/app_*
chmod -R 777 /tmp/nginx_*