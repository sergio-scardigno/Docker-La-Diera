# Usa una imagen base de PHP con FPM
FROM php:7.3-fpm

# Instalar dependencias necesarias para Laravel
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    zip \
    unzip \
    git \
    nginx \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install gd \
    && docker-php-ext-install pdo pdo_mysql

RUN apt-get update && \
    apt-get install -y \
    libpq-dev \
    && docker-php-ext-install pdo_pgsql
    

# Instalar Composer globalmente
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Crear un directorio para el proyecto
WORKDIR /var/www/html

# Copiar el proyecto Laravel al contenedor
COPY ./la-diera/ /var/www/html/

# Instalar dependencias de Composer
# RUN composer install --no-interaction --optimize-autoloader

# Asignar permisos adecuados a las carpetas storage y bootstrap/cache
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache
RUN chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

# Copiar la configuración de Nginx al contenedor
COPY ./nginx/nginx.conf /etc/nginx/nginx.conf

# Exponer el puerto 80
EXPOSE 80

# Iniciar tanto Nginx como PHP-FPM
CMD service nginx start && php-fpm

RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache
RUN chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

