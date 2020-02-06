FROM nginx:latest

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

#COPY ./app /code
COPY ./nginx/conf/www.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
EXPOSE 443