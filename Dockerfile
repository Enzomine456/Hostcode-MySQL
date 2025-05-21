FROM php:8.2-apache

# Atualiza e instala extensões necessárias (exemplo: mysqli, pdo_mysql, zip)
RUN apt-get update && apt-get install -y \
    libzip-dev \
    unzip \
    && docker-php-ext-install mysqli pdo pdo_mysql zip \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Define ServerName para Apache (remove aviso no log)
RUN echo "ServerName localhost" > /etc/apache2/conf-available/servername.conf \
    && a2enconf servername

# Ajusta nível do log do Apache para warn (menos verboso)
RUN echo "LogLevel warn" > /etc/apache2/conf-available/loglevel.conf \
    && a2enconf loglevel

# Configura PHP com parâmetros customizados para desenvolvimento
RUN { \
    echo 'display_errors=On'; \
    echo 'display_startup_errors=On'; \
    echo 'error_reporting=E_ALL & ~E_NOTICE'; \
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

# Cria pasta de logs do PHP e define permissões
RUN mkdir -p /var/log/php && chown -R www-data:www-data /var/log/php

# Copia seu código fonte para o diretório padrão do Apache
# IMPORTANTE: ajuste o caminho conforme sua estrutura real
COPY ./src/ /var/www/html/

# Ajusta permissões para www-data (usuário do Apache)
RUN chown -R www-data:www-data /var/www/html

# Expõe a porta 80 para acesso HTTP
EXPOSE 80

# Comando padrão para rodar o Apache no foreground
CMD ["apache2-foreground"]
