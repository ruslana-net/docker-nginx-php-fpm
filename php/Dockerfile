FROM php:7-fpm

WORKDIR /code

# install common files
RUN apt-get update && apt-get install -y \
    git \
    ssh \
    curl \
    wget \
    vim \
    apt-transport-https \
    ca-certificates \
    supervisor \
    pkg-config

COPY ./app /code