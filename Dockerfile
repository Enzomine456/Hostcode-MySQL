# Base PHP 8.2 com Apache
FROM php:8.2-apache

LABEL maintainer="seu-email@exemplo.com"
LABEL project="HostCode MySQL CMS"
LABEL description="Docker PHP + Apache para HostCode CMS com suporte MySQL e funcionalidades extras"

# Atualizar e instalar dependências para extensões PHP comuns em CMS
RUN apt-get update && apt-get install -y \
    libzip-dev zip unzip libicu-dev libpng-dev libjpeg-dev libfreetype6-dev libonig-dev libxml2-dev libcurl4-openssl-dev mariadb-client git \
    && rm -rf /var/lib/apt/lists/*

# Configurar e instalar extensões PHP necessárias
RUN docker-php-ext-configure gd --with-freetype --with-jpeg && \
    docker-php-ext-install -j$(nproc) mysqli pdo pdo_mysql mbstring zip gd xml intl curl opcache

# Ativar mod_rewrite para URLs amigáveis
RUN a2enmod rewrite

# Permitir uso de .htaccess para configs do Apache
RUN sed -i '/<Directory \/var\/www\/>/,/<\/Directory>/ s/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf

# Copiar o Composer para dentro do container (para gerenciar dependências PHP)
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Configurações PHP customizadas (ativar erros, aumentar limites, opcache etc)
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

# Criar diretório para logs PHP e garantir permissões
RUN mkdir -p /var/log/php && chown -R www-data:www-data /var/log/php

# --------------------------------------------------
# ATENÇÃO IMPORTANTE SOBRE O COPY ./src/ /var/www/html/
#
# 1) A pasta `src` deve estar na MESMA pasta onde este Dockerfile está.
#    Exemplo:
#
#    /HostCodeProject
#       |-- Dockerfile
#       |-- src/
#           |-- index.php
#           |-- outros arquivos
#
# 2) Você deve rodar o build DO LADO ONDE ESTÁ O DOCKERFILE E A PASTA src
#    Exemplo de comando:
#
#    docker build -t hostcode-cms .
#
#    (o ponto indica que o contexto do build é a pasta atual, incluindo a pasta src)
#
# 3) Se a pasta src estiver fora, ou Dockerfile em outra pasta, o COPY vai falhar.
#    Ajuste o caminho do COPY ou o contexto do build.
#
# --------------------------------------------------

# Copiar código fonte do HostCode CMS para dentro do container, diretório do Apache
COPY ./src/ /var/www/html/

# Ajustar permissões para o usuário www-data (apache)
RUN chown -R www-data:www-data /var/www/html

# Expor porta 80 para acessar pelo navegador
EXPOSE 80

# Comando padrão para rodar o Apache em foreground
CMD ["apache2-foreground"]
