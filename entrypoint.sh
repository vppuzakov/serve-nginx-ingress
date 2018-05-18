#!/bin/bash -ex

find /etc/nginx/ -name "*.conf" -type f -exec sed -i -- 's/NGINX_LISTEN_PORT/'${NGINX_LISTEN_PORT}'/g' {} \;
find /etc/nginx/ -name "*.conf" -type f -exec sed -i -- 's/NGINX_SSL_PORT/'${NGINX_SSL_PORT}'/g' {} \;

cp /usr/share/zoneinfo/${TIMEZONE} /etc/localtime
echo ${TIMEZONE} > /etc/timezone

mkdir -p /etc/nginx/ssl

# generate dhparams.pem
if [ ! -f /etc/nginx/ssl/dhparams.pem ]; then
  echo "make dhparams"
  pushd /etc/nginx/ssl
  openssl dhparam -out dhparams.pem 2048
  chmod 600 dhparams.pem
  popd
fi

exec "$@"
