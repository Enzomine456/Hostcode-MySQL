FROM php:8.2-apache

LABEL maintainer="seu-email@exemplo.com"
LABEL project="HostCode MySQL CMS"
LABEL description="Docker PHP + Apache para HostCode CMS com suporte MySQL e funcionalidades extras"

RUN apt-get update && apt-get install -y \
    libzip-dev zip unzip libicu-dev libpng-dev libjpeg-dev libfreetype6-dev libonig-dev libxml2-dev libcurl4-openssl-dev mariadb-client git \
    && rm -rf /var/lib/apt/lists/*

RUN docker-php-ext-configure gd --with-freetype --with-jpeg && \
    docker-php-ext-install -j$(nproc) mysqli pdo pdo_mysql mbstring zip gd xml intl curl opcache

RUN a2enmod rewrite

RUN sed -i '/<Directory \/var\/www\/>/,/<\/Directory>/ s/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

RUN { \
    echo 'display_errors=On'; \
    echo 'display_startup_errors=On'; \
    echo 'error_reporting=E_ALL'; \
    echo 'log_errors=On'; \
    echo 'error_log=/var/log/php_errors.log'; \
    echo 'upload_max_filesize=50M'; \
    echo 'post_max_size=50M'; \
    echo 'memory_limit=512M'; \
    echo 'max_execution_time=300'; \
    echo 'opcache.enable=1'; \
    echo 'opcache.memory_consumption=128'; \
    echo 'opcache.interned_strings_buffer=8'; \
    echo 'opcache.max_accelerated_files=10000'; \
    echo 'opcache.revalidate_freq=2'; \
} > /usr/local/etc/php/conf.d/custom.ini

RUN mkdir -p /var/log/php && chown -R www-data:www-data /var/log/php

# Removido o COPY ./src/ /var/www/html/ para evitar erro

# Ajustar permissões do diretório padrão do Apache, caso use volume externo
RUN chown -R www-data:www-data /var/www/html

EXPOSE 80

CMD ["apache2-foreground"]
