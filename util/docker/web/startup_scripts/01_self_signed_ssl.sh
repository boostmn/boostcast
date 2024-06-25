#!/bin/bash

# mkdir -p /var/azuracast/acme/challenges || true

# if [ -f /var/azuracast/acme/default.crt ]; then
#     rm -rf /var/azuracast/acme/default.key || true
#     rm -rf /var/azuracast/acme/default.crt || true
# fi

# # Generate a self-signed certificate if one doesn't exist in the certs path.
# if [ ! -f /var/azuracast/acme/default.crt ]; then
#     echo "Generating self-signed certificate..."

#     openssl req -new -nodes -x509 -subj "/C=US/ST=Texas/L=Austin/O=IT/CN=localhost" \
#         -days 365 -extensions v3_ca \
#         -keyout /var/azuracast/acme/default.key \
#         -out /var/azuracast/acme/default.crt
# fi

# if [ ! -f /var/azuracast/acme/ssl.crt ]; then
#     ln -s /var/azuracast/acme/default.key /var/azuracast/acme/ssl.key
#     ln -s /var/azuracast/acme/default.crt /var/azuracast/acme/ssl.crt
# fi

# chown -R azuracast:azuracast /var/azuracast/acme || true
# chmod -R u=rwX,go=rX /var/azuracast/acme || true

if [ -z "$ACME_DIR" ]; then
  if [ -d "/var/azuracast/acme" ]; then
    export ACME_DIR="/var/azuracast/acme"
  else
    export ACME_DIR="/var/azuracast/storage/acme"
  fi
fi

mkdir -p "$ACME_DIR/challenges" || true

if [ -f "$ACME_DIR/default.crt" ]; then
    rm -rf "$ACME_DIR/default.key" || true
    rm -rf "$ACME_DIR/default.crt" || true
fi

# Generate a self-signed certificate if one doesn't exist in the certs path.
if [ ! -f "$ACME_DIR/default.crt" ]; then
    echo "Generating self-signed certificate..."

    openssl req -new -nodes -x509 -subj "/C=US/ST=Texas/L=Austin/O=IT/CN=localhost" \
        -days 365 -extensions v3_ca \
        -keyout "$ACME_DIR/default.key" \
        -out "$ACME_DIR/default.crt"
fi

# Check for broken symlinks (may be caused by storage location changes)
if [ ! -e "$ACME_DIR/ssl.crt" ]; then
    rm -rf "$ACME_DIR/ssl.key" || true
    rm -rf "$ACME_DIR/ssl.crt" || true
fi

if [ ! -f "$ACME_DIR/ssl.crt" ]; then
    if [ -f "$ACME_DIR/acme.crt" ]; then
        ln -s "$ACME_DIR/acme.key" "$ACME_DIR/ssl.key"
        ln -s "$ACME_DIR/acme.crt" "$ACME_DIR/ssl.crt"
    else
        ln -s "$ACME_DIR/default.key" "$ACME_DIR/ssl.key"
        ln -s "$ACME_DIR/default.crt" "$ACME_DIR/ssl.crt"
    fi
fi

chown -R azuracast:azuracast "$ACME_DIR" || true
chmod -R u=rwX,go=rX "$ACME_DIR" || true