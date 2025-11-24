# Use PHP-FPM
FROM php:8.2-fpm

WORKDIR /app

# Install dependencies
RUN apt-get update && apt-get install -y \
    git unzip libpq-dev libzip-dev libonig-dev \
    && docker-php-ext-install pdo pdo_mysql zip

# Install Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Copy project
COPY . .

# Install PHP dependencies
RUN composer install --no-dev --optimize-autoloader --no-scripts

# Ensure var folders exist
RUN mkdir -p var/cache var/log && chmod -R 777 var

# Expose Render port
ENV PORT 10000

# Start PHP-FPM (Render uses port from env)
CMD ["php-fpm"]
