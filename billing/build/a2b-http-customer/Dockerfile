FROM centos:7

LABEL \
	name="a2b-http-customer" \
	image="iperfex/a2b-http-customer" \
	vendor="iperfex" \
	license="GNU GPL V3" \
	build-date="2020-08-16"

ENV TIMEZONE='America/Argentina/Buenos_Aires' 

RUN mkdir -p /usr/share/a2billing/latest
COPY v2.2.0.tar.gz /usr/share/a2billing

RUN yum -y update \
    && yum -y install -y epel-release \
    && yum-config-manager --enable epel &> /dev/null \
    && yum -y install supervisor \
    && yum -y install vim tar htop net-tools iproute git \
    && yum -y groupinstall "Web Server" \
    && yum -y install php php-gd php-mysql php-process httpd mod_ssl php-cli php-soap php-xml php-mcrypt \
    && yum -y install crontabs \
    && yum clean all

RUN usermod -u 500 apache \
    && groupmod -g 500 apache 

RUN cd /usr/share/a2billing \
    && tar -zxf v2.2.0.tar.gz \
    && rm -fr v2.2.0.tar.gz \
    && mv /usr/share/a2billing/a2billing-2.2.0/* /usr/share/a2billing/latest \
    && chmod u+xwr /usr/share/a2billing/latest/admin/templates_c \
    && chmod a+w /usr/share/a2billing/latest/admin/templates_c \
    && chmod u+xwr /usr/share/a2billing/latest/agent/templates_c \
    && chmod a+w /usr/share/a2billing/latest/agent/templates_c \
    && chmod u+xwr /usr/share/a2billing/latest/customer/templates_c \
    && chmod a+w /usr/share/a2billing/latest/customer/templates_c \
    && rm -rf /usr/share/a2billing/latest/admin/templates_c/* \
    && rm -rf /usr/share/a2billing/latest/agent/templates_c/* \
    && rm -rf /usr/share/a2billing/latest/customer/templates_c/* \
    && cp -fra /usr/share/a2billing/latest/a2billing.conf /etc \
    && chown apache:apache /etc/a2billing.conf \
    && chown apache:apache -R /usr/share/a2billing/latest \
    && chown apache:apache -R /var/lib/php/session \
    && rm -fr /etc/httpd/conf.d/welcome.conf /etc/httpd/conf.d/userdir.conf /usr/share/a2billing/a2billing-2.2.0/  

RUN cd /usr/share/a2billing/latest \
    && curl -sS https://getcomposer.org/installer | php \
    && php composer.phar install

#FIX VERSION PHP 5.4
COPY fix/XPath.class.php /usr/share/a2billing/latest/admin/phpsysinfo/includes/XPath.class.php

RUN rm -fr /var/www/html \
    && cp -fra /usr/share/a2billing/latest/customer /var/www \
    && cp -fra /usr/share/a2billing/latest/common/ /var/www \
    && cp -fra /usr/share/a2billing/latest/vendor/ /var/www \
    && mv /var/www/customer /var/www/html 

EXPOSE 80/tcp 443/tcp

COPY supervisord.conf /etc/supervisord.conf
COPY additionals/etc/httpd/conf.d/a2billing.conf /etc/httpd/conf.d
COPY additionals/etc/php.d/a2billing.ini /etc/php.d
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod 777 /usr/local/bin/docker-entrypoint.sh

CMD ["/usr/bin/supervisord"]
