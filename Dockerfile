# Use imagem oficial do PHP com Apache
FROM php:8.2-apache

# Metadados do container
LABEL maintainer="seu-email@exemplo.com"
LABEL project="HostCode MySQL CMS"
LABEL description="Docker PHP + Apache para HostCode CMS com suporte MySQL e funcionalidades extras"

# Atualiza e instala dependências necessárias para extensões e utilitários
RUN apt-get update && apt-get install -y \
    libzip-dev \
    zip unzip \
    libicu-dev \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libonig-dev \
    libxml2-dev \
    libcurl4-openssl-dev \
    mariadb-client \
    git \
    && rm -rf /var/lib/apt/lists/*

# Instalar extensões PHP necessárias para CMS comum
RUN docker-php-ext-configure gd --with-freetype --with-jpeg && \
    docker-php-ext-install -j$(nproc) mysqli pdo pdo_mysql mbstring zip gd xml intl curl opcache

# Habilitar mod_rewrite do Apache para urls amigáveis
RUN a2enmod rewrite

# Copiar configuração customizada do Apache para permitir .htaccess (se quiser usar)
RUN sed -i '/<Directory \/var\/www\/>/,/<\/Directory>/ s/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf

# Instalar Composer (gerenciador de dependências PHP)
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Configuração do PHP para desenvolvimento (exemplo, pode ser alterada)
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

# Criar diretórios para logs do PHP e Apache, com permissões
RUN mkdir -p /var/log/php && \
    chown -R www-data:www-data /var/log/php

# Copiar o código fonte do HostCode CMS para o diretório padrão do Apache
COPY ./src/ /var/www/html/

# Ajustar permissões do diretório web
RUN chown -R www-data:www-data /var/www/html

# Expor porta 80 para web
EXPOSE 80

# Definir ponto de entrada padrão (Apache em foreground)
CMD ["apache2-foreground"]
