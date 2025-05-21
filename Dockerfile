# Use imagem oficial do PHP com Apache
FROM php:8.2-apache

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

# Permitir uso de .htaccess para configurações Apache
RUN sed -i '/<Directory \/var\/www\/>/,/<\/Directory>/ s/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf

# Instalar Composer para gerenciar dependências PHP
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Configurações PHP para desenvolvimento e produção
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

# Criar diretórios para logs do PHP e dar permissão para o usuário www-data
RUN mkdir -p /var/log/php && chown -R www-data:www-data /var/log/php

# ----------------------------------------------
# ATENÇÃO:
# Para que o comando COPY funcione, você deve executar
# o build DO LADO ONDE ESTÁ A PASTA 'src', assim:
#
# Estrutura de pastas esperada:
# .
# ├── Dockerfile
# └── src/
#     ├── index.php
#     └── ...
#
# Comando para build:
# docker build -t hostcode-cms .
#
# Se não fizer isso, vai dar erro "src: not found"
# ----------------------------------------------

# Copiar código fonte do HostCode CMS para o Apache
COPY ./src/ /var/www/html/

# Ajustar permissões do diretório web para www-data
RUN chown -R www-data:www-data /var/www/html

# Expor a porta 80 para acesso HTTP
EXPOSE 80

# Executar Apache em foreground para manter container rodando
CMD ["apache2-foreground"]
