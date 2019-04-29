FROM php:5.6-fpm-alpine

LABEL maintainer Alipeng <lipeng.yang@mobvista.com>

RUN set -xe \
  && apk add --no-cache --virtual .build-deps \
    $PHPIZE_DEPS \
    libtool \
    icu-dev \
    curl-dev \
    freetype-dev \
    imagemagick-dev \
    pcre-dev \
    postgresql-dev \
    libjpeg-turbo-dev \
    libpng-dev \
    libxml2-dev  \
    openldap-dev \
  && docker-php-ext-configure gd \
    --with-gd \
    --with-freetype-dir=/usr/include/  \
    --with-png-dir=/usr/include/  \
    --with-jpeg-dir=/usr/include/  \
    --with-mysqli \
  && docker-php-ext-configure bcmath \
  && docker-php-ext-configure ldap \
    --with-ldap \
  && docker-php-ext-install \
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
    mysqli \
    pgsql \
    pdo_pgsql \
    ldap \
  && pecl channel-update pecl.php.net \
  && printf "\n" | pecl install -o -f \
    imagick \
    redis \
    xdebug-2.5.5 \
    mongo \
    igbinary-2.0.8 \
  && docker-php-ext-enable \
    imagick \
    redis \
    mongo \
    igbinary \
    xdebug \
    mysqli \
  && docker-php-source delete \
  && runDeps="$( \
    scanelf --needed --nobanner --format '%n#p' --recursive /usr/local \
      | tr ',' '\n' \
      | sort -u \
      | awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' \
  )" \
  && apk add --no-cache --virtual .php-rundeps $runDeps imagemagick \
  &&  rm -rf /tmp/pear /var/cache/apk/* \
  && apk del .build-deps

WORKDIR /var/www

CMD ["php-fpm"]

EXPOSE 9000
