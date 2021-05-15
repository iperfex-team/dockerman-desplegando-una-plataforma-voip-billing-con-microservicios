#!/bin/bash
set -e

if [ ! -f /etc/php.d/timezone.ini ]; then
  echo "date.timezone = $TIMEZONE" > /etc/php.d/timezone.ini
fi

sed -i "s/\(hostname = *\)\(.*\)/\1${MYSQL_HOST}/" /etc/a2billing.conf
sed -i "s/\(port = *\)\(.*\)/\1 ${MYSQL_PORT}/" /etc/a2billing.conf
sed -i "s/\(user = *\)\(.*\)/\1${MYSQL_USER}/" /etc/a2billing.conf
sed -i "s/\(password = *\)\(.*\)/\1${MYSQL_PASSWORD}/" /etc/a2billing.conf
sed -i "s/\(dbname = *\)\(.*\)/\1${MYSQL_DATABASE}/" /etc/a2billing.conf

rm -rf /run/httpd/* /tmp/httpd* /var/run/a2billing/*

exec "$@"
