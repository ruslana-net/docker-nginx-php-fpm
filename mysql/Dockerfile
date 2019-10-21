# See https://github.com/docker-library/php/blob/master/7.1/fpm/Dockerfile
FROM mysql:5.7.25

ADD ./conf.d/* /etc/mysql/conf.d/

RUN apt-get update && apt-get install -y \
    openssl \
    git \
    unzip \
    vim \
    sudo \
    procps


RUN usermod -u 1000 www-data

WORKDIR /var/lib/mysql

EXPOSE 3306
