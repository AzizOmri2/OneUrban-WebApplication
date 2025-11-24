FROM php:8.2-apache

# Install PHP extensions
RUN apt-get update && apt-get install -y \
    git unzip libzip-dev libicu-dev \
    && docker-php-ext-install pdo pdo_mysql intl zip opcache

# Enable Apache Rewrite (required by Symfony)
RUN a2enmod rewrite

WORKDIR /var/www/html

# Copy project
COPY . .

# Install Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Install dependencies
RUN composer install --no-dev --optimize-autoloader

# Fix Symfony var/ permissions
RUN mkdir -p var/cache var/log && chown -R www-data:www-data var

# Render port
ENV PORT=10000

# Make Apache listen on Render’s dynamic port
RUN sed -i "s/80/${PORT}/" /etc/apache2/ports.conf \
 && sed -i "s/:80/:${PORT}/" /etc/apache2/sites-enabled/000-default.conf

EXPOSE ${PORT}

CMD ["apache2-foreground"]
