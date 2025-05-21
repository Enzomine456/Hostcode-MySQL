# Usar imagem oficial PHP 8.2 com Apache
FROM php:8.2-apache

# Ativar o módulo rewrite do Apache (muito usado em CMS)
RUN a2enmod rewrite

# Definir ServerName para suprimir aviso do Apache
RUN echo "ServerName localhost" > /etc/apache2/conf-available/servername.conf \
    && a2enconf servername

# Instalar dependências para extensões PHP e ferramentas básicas
RUN apt-get update && apt-get install -y \
    libzip-dev \
    unzip \
    git \
    zip \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libonig-dev \
    libxml2-dev \
    libcurl4-openssl-dev \
    libssl-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd mbstring pdo pdo_mysql zip curl xml opcache

# Instalar Composer globalmente
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Configurações customizadas do PHP
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

# Criar diretório para logs PHP e dar permissão para www-data
RUN mkdir -p /var/log/php && chown -R www-data:www-data /var/log/php

# Ajustar permissões do diretório padrão do Apache (caso o volume com o código esteja montado)
RUN chown -R www-data:www-data /var/www/html

# Expor porta 80
EXPOSE 80

# Comando padrão para rodar Apache no primeiro plano
CMD ["apache2-foreground"]
