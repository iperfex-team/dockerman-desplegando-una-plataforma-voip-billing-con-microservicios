FROM centos:7

LABEL \
        name="a2b-http" \
        image="iperfex/a2b-http" \
        vendor="iperfex" \
        license="GNU GPL V3" \
        build-date="2020-08-14"

ENV TIMEZONE='America/Argentina/Buenos_Aires' \
    FAIL2BAN=false \
    CUSTOM_IPTABLE=false

RUN mkdir -p /usr/share/a2billing/latest
COPY v2.2.0.tar.gz /usr/share/a2billing
COPY irontec.repo /etc/yum.repos.d/irontec.repo

RUN yum -y update \
    && yum -y install epel-release \
    && yum clean all \
    && yum -y install vim tar htop net-tools iproute git \
    && yum -y install gcc gcc-c++ make wget libxml2-devel ncurses-devel openssl-devel sqlite-devel libuuid-devel vim-enhanced jansson-devel unixODBC unixODBC-devel libtool-ltdl libtool-ltdl-devel subversion speex-devel mysql-devel subversion sngrep fail2ban \
    && yum -y install unixODBC unixODBC-devel libtool-ltdl libtool-ltdl-devel \
    && yum -y install mysql-connector-odbc \
    && yum -y install php php-gd php-mysql php-process httpd mod_ssl php-cli php-soap php-xml php-mcrypt \
    && odbcinst -q -d

WORKDIR /usr/src
RUN svn co http://svn.pjsip.org/repos/pjproject/trunk/ pjproject-trunk
WORKDIR /usr/src/pjproject-trunk
RUN ./configure --libdir=/usr/lib64 --prefix=/usr --enable-shared --disable-sound --disable-resample --disable-video --disable-opencore-amr CFLAGS='-O2 -DNDEBUG' \ 
    && make dep \
    && make \
    && make install \
    && ldconfig \
    && rm -fr /usr/src/pjproject-trunk

WORKDIR /usr/src
RUN wget https://downloads.asterisk.org/pub/telephony/asterisk/asterisk-13-current.tar.gz \
    && tar -zxf asterisk-13-current.tar.gz \
    && cd asterisk-13.* \
    && sh contrib/scripts/get_mp3_source.sh \
    && sh contrib/scripts/install_prereq install \
    && ./bootstrap.sh \
    && ./configure CFLAGS='-g -O2 -mtune=native' --libdir=/usr/lib64 \
    && make menuselect/menuselect menuselect-tree menuselect.makeopts \
    && menuselect/menuselect --disable BUILD_NATIVE --enable app_confbridge --disable app_fax --enable app_macro --enable codec_silk --enable format_mp3 --enable BETTER_BACKTRACES \
    && make \
    && make \
    && make install \
    && make samples \
    && rm -fr /usr/src/asterisk-*

COPY codec_g729-ast130-gcc4-glibc2.2-x86_64-core2.so /usr/lib64/asterisk/modules/codec_g729.so

WORKDIR /etc/fail2ban
COPY fail2ban .

WORKDIR /etc/asterisk
COPY asterisk . 

RUN sed -i -e 's/# MAXFILES=/MAXFILES=/' /usr/sbin/safe_asterisk \
    && sed -i 's/TTY=9/TTY=/g' /usr/sbin/safe_asterisk \
    && useradd -m iperfex -s /sbin/nologin \
    && usermod -u 500 iperfex \
    && groupmod -g 500 iperfex \
    && touch /etc/asterisk/additional_a2billing_iax.conf \
    && touch /etc/asterisk/additional_a2billing_sip.conf \
    && echo \#include additional_a2billing_sip.conf >> /etc/asterisk/sip.conf \
    && echo \#include additional_a2billing_iax.conf >> /etc/asterisk/iax.conf \
    && chown -Rf iperfex:iperfex /etc/asterisk/additional_a2billing_iax.conf \
    && chown -Rf iperfex:iperfex /etc/asterisk/additional_a2billing_sip.conf \
    && mkdir -p  /var/run/asterisk \
    && chown iperfex:iperfex /var/run/asterisk \
    && chown -R iperfex:iperfex /etc/asterisk \
    && chown -R iperfex:iperfex /var/lib/asterisk \
    && chown -R iperfex:iperfex /var/log/asterisk \
    && chown -R iperfex:iperfex /var/spool/asterisk \
    && chown -R iperfex:iperfex /usr/lib64/asterisk \
    && echo "asterisk -rvvvvvvvvvv" > /usr/local/sbin/a \
    && chmod 777 /usr/local/sbin/a \
    && mkdir -p /var/lib/asterisk/agi-bin/ \
    && chown iperfex:iperfex -R /var/lib/asterisk/agi-bin/ \
    && cp -fra /etc/asterisk /etc/asterisk.org

RUN cd /usr/share/a2billing \
    && tar -zxf v2.2.0.tar.gz \
    && rm -fr v2.2.0.tar.gz \
    && mv /usr/share/a2billing/a2billing-2.2.0/* /usr/share/a2billing/latest \
    && cp -fra /usr/share/a2billing/latest/a2billing.conf /etc \
    && chown iperfex:iperfex /etc/a2billing.conf \
    && chown iperfex:iperfex -R /usr/share/a2billing/latest \
    && chmod 777 /usr/share/a2billing/latest/AGI/a2billing.php /usr/share/a2billing/latest/AGI/a2billing_monitoring.php \
    && cd /usr/share/a2billing/latest/addons/sounds \
    && ./install_a2b_sounds.sh \
    && chown iperfex:iperfex -R /var/lib/asterisk/sounds \
    && cp -fra /var/lib/asterisk/sounds /var/lib/asterisk/sounds.org \
    && rm -fr /usr/share/a2billing/a2billing-2.2.0

RUN cd /usr/share/a2billing/latest \
    && curl -sS https://getcomposer.org/installer | php \
    && php composer.phar install

#fail2ban
RUN cp -fra /etc/fail2ban /etc/fail2ban.org \
    && mkdir -p /var/log/fail2ban /var/log/asterisk \
    && touch /var/log/asterisk/full \
    && touch /var/log/asterisk/messages \
    && touch /var/log/asterisk/security \
    && chown iperfex:iperfex -R /var/log/asterisk \
    && cp -fra /var/log/asterisk /var/log/asterisk.org

EXPOSE 5038/tcp 5060/udp 10000-20000/udp 4569/udp 

COPY docker-entrypoint.sh /docker-entrypoint.sh 
RUN chmod 777 /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
