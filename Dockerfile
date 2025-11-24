# Use PHP + Apache
FROM php:8.2-apache

# Install system dependencies & PHP extensions
RUN apt-get update && apt-get install -y \
    git unzip libzip-dev libicu-dev libonig-dev \
    && docker-php-ext-install pdo pdo_mysql intl zip opcache \
    && a2enmod rewrite

# Set working directory
WORKDIR /var/www/html

# Copy project files
COPY . .

# Copy Composer from official image
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Install dependencies WITHOUT running auto-scripts (avoid cache:clear crash)
RUN composer install --no-dev --optimize-autoloader --no-scripts

# Ensure var/ permissions
RUN mkdir -p var/cache var/log var/sessions \
    && chown -R www-data:www-data var

# Set Apache DocumentRoot to Symfony public/ folder and allow .htaccess
RUN sed -i 's#/var/www/html#/var/www/html/public#g' /etc/apache2/sites-available/000-default.conf \
 && sed -i 's#/var/www/html#/var/www/html/public#g' /etc/apache2/apache2.conf \
 && sed -i 's/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf

# Set Render dynamic port
ENV PORT=10000
RUN sed -i "s/80/${PORT}/" /etc/apache2/ports.conf \
    && sed -i "s/:80/:${PORT}/" /etc/apache2/sites-enabled/000-default.conf

EXPOSE ${PORT}

CMD ["apache2-foreground"]
