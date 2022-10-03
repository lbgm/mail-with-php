FROM ubuntu:jammy
LABEL Author="Balthazar DOSSOU" Description="Php simple dockerized app to send mail. You can use it as docker-compose service"

ARG MAIL_SERVER=mail.example.com
ARG MAIL_PORT=465
ARG MAIL_SECURE=ssl
ARG MAIL_ACCOUNT=noreply@example.com
ARG MAIL_ACCOUNT_PASSWORD=******
ARG FROM_MAIL=noreply@example.com
# 0==no verbose to 1-4==verbose
ARG SMTP_DEBUG=0

# Stop dpkg-reconfigure tzdata from prompting for input
ENV DEBIAN_FRONTEND=noninteractive

# Install apache and php7
RUN apt-get update && \
    apt-get -y install \
        apache2 \
        libapache2-mod-php \
        libapache2-mod-auth-openidc \
        php-bcmath \
        php-cli \
        php-curl \
        php-mbstring \
        php-gd \
        php-mysql \
        php-json \
        php-ldap \
        php-memcached \
        php-mime-type \
        php-pgsql \
        php-tidy \
        php-intl \
        php-xmlrpc \
        php-soap \
        php-uploadprogress \
        php-zip \
# Ensure apache can bind to 80 as non-root
        libcap2-bin && \
    setcap 'cap_net_bind_service=+ep' /usr/sbin/apache2 && \
    dpkg --purge libcap2-bin && \
    apt-get -y autoremove && \
# As apache is never run as root, change dir ownership
    a2disconf other-vhosts-access-log && \
    chown -Rh www-data. /var/run/apache2 && \
# Install ImageMagick CLI tools
    apt-get -y install --no-install-recommends imagemagick && \
# Clean up apt setup files
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
# Setup apache
    a2enmod rewrite headers expires ext_filter


COPY 000-default.conf /etc/apache2/sites-available
COPY status.conf  /etc/apache2/mods-available
COPY php-local.ini /etc/php/7.4/apache2/conf.d
COPY dir.conf /etc/apache2/mods-enabled/dir.conf

ADD /apps /var/www/html/apps
COPY /htdocs/ /var/www/html/
COPY .htaccess /var/www/html/.htaccess

RUN echo "SetEnv MAIL_SERVER "$MAIL_SERVER"" >> /var/www/html/.htaccess
RUN echo "SetEnv MAIL_PORT "$MAIL_PORT"" >> /var/www/html/.htaccess
RUN echo "SetEnv MAIL_SECURE "$MAIL_SECURE"" >> /var/www/html/.htaccess
RUN echo "SetEnv MAIL_ACCOUNT "$MAIL_ACCOUNT"" >> /var/www/html/.htaccess
RUN echo "SetEnv MAIL_ACCOUNT_PASSWORD "$MAIL_ACCOUNT_PASSWORD"" >> /var/www/html/.htaccess
RUN echo "SetEnv FROM_MAIL "$FROM_MAIL"" >> /var/www/html/.htaccess
RUN echo "SetEnv SMTP_DEBUG "$SMTP_DEBUG"" >> /var/www/html/.htaccess

RUN service apache2 restart

EXPOSE 80
ENTRYPOINT ["apache2ctl", "-D", "FOREGROUND"]
