#!/bin/sh

if [ -z "$(ls -A /etc/asterisk)" ]; then
  cp -fra /etc/asterisk.org/* /etc/asterisk
  chown iperfex:iperfex -R /etc/asterisk
fi

if [ -z "$(ls -A /var/log/asterisk)" ]; then
  cp -fra /var/log/asterisk.org/* /var/log/asterisk
  chown iperfex:iperfex -R /var/log/asterisk
fi

if [ -z "$(ls -A /var/lib/asterisk/sounds)" ]; then
  cp -fra /var/lib/asterisk/sounds.org/* /var/lib/asterisk/sounds
  chown iperfex:iperfex -R /var/lib/asterisk/sounds
fi

if [ -z "$(ls -A /etc/fail2ban)" ]; then
  cp -fra /etc/fail2ban.org/* /etc/fail2ban
fi

echo "date.timezone = $TIMEZONE" > /etc/php.d/timezone.ini

cat > /etc/odbc.ini <<ENDLINE
[a2b]
Description = MySQL A2Billing
Driver = MySQL
Database = $MYSQL_DATABASE
User = $MYSQL_USER
Password = $MYSQL_PASSWORD
Server = $MYSQL_HOST
Port = $MYSQL_PORT
Option= 3
ENDLINE

cat > /etc/asterisk/res_odbc.conf <<ENDLINE
[ENV]

[a2b]
enabled => yes
dsn => a2b
username => $MYSQL_USER
password => $MYSQL_PASSWORD
pre-connect => yes
sanitysql => select 1
idlecheck => 3600
connect_timeout => 10
ENDLINE

sed -i "s/\(hostname = *\)\(.*\)/\1${MYSQL_HOST}/" /etc/a2billing.conf
sed -i "s/\(port = *\)\(.*\)/\1 ${MYSQL_PORT}/" /etc/a2billing.conf
sed -i "s/\(user = *\)\(.*\)/\1${MYSQL_USER}/" /etc/a2billing.conf
sed -i "s/\(password = *\)\(.*\)/\1${MYSQL_PASSWORD}/" /etc/a2billing.conf
sed -i "s/\(dbname = *\)\(.*\)/\1${MYSQL_DATABASE}/" /etc/a2billing.conf

sed -i "s/_IP_DOCKER_VOIP_/`ip r |grep eth1 | cut -d' ' -f9`/g" "/etc/asterisk/manager.conf"
sed -i "s/_ASTERISK_IP_/${ASTERISK_IP}/g" "/etc/asterisk/sip.conf"
sed -i "s/_USER_/${MANAGER_USER}/g" "/etc/asterisk/manager.conf"
sed -i "s/\(secret= *\)\(.*\)/\1${MANAGER_PASSWORD}/" /etc/asterisk/manager.conf
sed -i "s/_IP_DOCKER_LAN_/`ip r |grep eth1 | cut -d'/' -f1`\/255.255.0.0/g" "/etc/asterisk/manager.conf"

FILE=/etc/a2binstall
if [ ! -f "$FILE" ]; then
    echo "$FILE does not exist."
    sleep 15 && echo "UPDATE cc_config SET config_value = '${MANAGER_HOST}' WHERE id=8;" | isql a2b &
    sleep 15 && echo "UPDATE cc_config SET config_value = '${MANAGER_USER}' WHERE id=9;" | isql a2b &
    sleep 15 && echo "UPDATE cc_config SET config_value = '${MANAGER_PASSWORD}' WHERE id=10;" | isql a2b &
    echo "yes" > /etc/a2binstall
fi

rm -fr /var/run/fail2ban/*
rm -fr /var/run/asterisk/*

if [ $FAIL2BAN = "true" ]; then
  /usr/bin/python /usr/bin/fail2ban-server -b -s /var/run/fail2ban/fail2ban.sock -p /var/run/fail2ban/fail2ban.pid -x
fi

if [ $CUSTOM_IPTABLES = "true" ]; then
    if [ -f "/etc/custom_iptables/iptables" ]; then
        echo "CUSTOM IPTABLES"
        bash /etc/custom_iptables/iptables &
    fi
fi

/usr/sbin/asterisk -f -U iperfex -G iperfex	
