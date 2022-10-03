ARG MAIL_SERVER=mail.example.com
ARG MAIL_PORT=465
ARG MAIL_SECURE=ssl
ARG MAIL_ACCOUNT=noreply@example.com
ARG MAIL_ACCOUNT_PASSWORD=******
ARG FROM_MAIL=noreply@example.com
# 0==no verbose to 1-4==verbose
ARG SMTP_DEBUG=0

FROM httpd:2.4
COPY httpd.conf /usr/local/apache2/conf/httpd.conf
ADD /apps /usr/local/apache2/htdocs/apps
COPY /htdocs/ /usr/local/apache2/htdocs/
COPY .htaccess /usr/local/apache2/htdocs/.htaccess

RUN echo "SetEnv MAIL_SERVER $MAIL_SERVER" > .htaccess
RUN echo "SetEnv MAIL_PORT $MAIL_PORT" > .htaccess
RUN echo "SetEnv MAIL_SECURE $MAIL_SECURE" > .htaccess
RUN echo "SetEnv MAIL_ACCOUNT $MAIL_ACCOUNT" > .htaccess
RUN echo "SetEnv MAIL_ACCOUNT_PASSWORD $MAIL_ACCOUNT_PASSWORD" > .htaccess
RUN echo "SetEnv FROM_MAIL $FROM_MAIL" > .htaccess


RUN apt install php libapache2-mod-php php-mysql

EXPOSE 80
