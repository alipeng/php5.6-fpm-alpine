FROM php:5.6-fpm-alpine

LABEL maintainer Alipeng <lipeng.yang@mobvista.com>

RUN apk --update --virtual build-deps add \
        autoconf \
        make \
        gcc \
        g++ \
        libtool \
        icu-dev \
        curl-dev \
        freetype-dev \
        imagemagick-dev \
        pcre-dev \
        postgresql-dev \
        libjpeg-turbo-dev \
        libpng-dev \
        libxml2-dev && \
    apk add \
        icu \
        imagemagick \
        pcre \
        freetype \
        libintl \
        libjpeg-turbo \
        libpng \
        libltdl \
        libxml2 \
        mysql-client \
        postgresql-client && \
    docker-php-ext-configure gd \
        --with-gd \
        --with-freetype-dir=/usr/include/ \
        --with-png-dir=/usr/include/ \
        --with-jpeg-dir=/usr/include/ && \
    docker-php-ext-configure bcmath && \
    docker-php-ext-install \
        soap \
        zip \
        curl \
        bcmath \
        exif \
        gd \
        iconv \
        intl \
        mbstring \
        opcache \
        pdo_mysql \
        mysql \
        pgsql \
        pdo_pgsql && \
    pecl channel-update pecl.php.net && \
    printf "\n" | pecl install -o -f \
        imagick \
        redis \
        xdebug-2.5.5 \
        mongo \
        igbinary && \
        rm -rf /tmp/pear && \
    docker-php-ext-enable \
        imagick \
        redis \
        mongo \
        igbinary \
        xdebug && \
    apk del \
        build-deps

WORKDIR /var/www

CMD ["php-fpm"]

EXPOSE 9000
