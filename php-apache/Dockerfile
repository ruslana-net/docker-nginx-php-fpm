FROM php:7.2.11-apache

ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data

ARG TIMEZONE
ARG ENVIRONMENT
ARG SERVER_NAME
ARG SERVER_ALIASES

RUN apt-get update && apt-get install -y \
    openssl \
    git \
    unzip \
    vim \
    sudo \
    cron \
    libssl-dev libxml2-dev libpng-dev libzip-dev libxml2-dev libmcrypt-dev libcurl4-openssl-dev libsodium-dev pkg-config \
    libwebp-dev libjpeg62-turbo-dev libxpm-dev libfreetype6-dev libxslt-dev libbz2-dev
#    xvfb libfontconfig xfonts-75dpi fontconfig libjpeg62-turbo libxrender1

#
#RUN echo "FromLineOverride=YES" >> /etc/ssmtp/ssmtp.conf && \
#    echo 'sendmail_path = "/usr/sbin/ssmtp -t"' > /usr/local/etc/php/conf.d/mail.ini

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Set timezone
RUN ln -snf /usr/share/zoneinfo/${TIMEZONE} /etc/localtime && echo ${TIMEZONE} > /etc/timezone \
&& printf '[PHP]\ndate.timezone = "%s"\n', ${TIMEZONE} > /usr/local/etc/php/conf.d/tzone.ini \
&& "date"

# Type docker-php-ext-install to see available extensions
ENV CFLAGS="-I/usr/src/php"

RUN curl -O https://download.libsodium.org/libsodium/releases/libsodium-1.0.18.tar.gz \
&& tar xfvz libsodium-1.0.18.tar.gz \
&& cd libsodium-1.0.18 && \
    ./configure && \
    make && make check && \
    make install

RUN docker-php-ext-configure gd --with-gd --with-webp-dir --with-jpeg-dir=DIR \
    --with-png-dir=DIR --with-zlib-dir --with-freetype-dir

RUN docker-php-ext-install pdo pdo_mysql mysqli opcache gd xml xmlrpc mbstring curl zip intl iconv xsl ctype bz2 calendar exif fileinfo json posix tokenizer xmlwriter phar soap bcmath xmlreader sodium

RUN pecl install mcrypt \
    && docker-php-ext-enable mcrypt

# Install phpunit, the tool that we will use for testing
RUN curl --location --output /usr/local/bin/phpunit https://phar.phpunit.de/phpunit.phar \
    && chmod +x /usr/local/bin/phpunit

#COPY cert/server.crt /etc/apache2/ssl/server.crt
#COPY cert/server.key /etc/apache2/ssl/server.key

RUN printf '<VirtualHost *:80> \n DocumentRoot /var/www/html \n ServerName %s \n ServerAlias %s \n</VirtualHost>', ${SERVER_NAME} ${SERVER_ALIAS} > /etc/apache2/sites-available/webapp.conf

RUN rm /etc/apache2/sites-available/000-default.conf \
    && rm /etc/apache2/sites-available/default-ssl.conf \
    && ln -s /etc/apache2/sites-available/*.conf /etc/apache2/sites-enabled/ \
    && rm /etc/apache2/sites-enabled/000-default.conf

RUN a2enmod rewrite
RUN a2enmod ssl

RUN usermod -u 1000 www-data

WORKDIR /var/www/html

EXPOSE 80
EXPOSE 443
