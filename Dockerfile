# 1. Use PHP 8.2 CLI image
FROM php:8.2-cli

# 2. Set working directory
WORKDIR /app

# 3. Install system dependencies
RUN apt-get update && apt-get install -y \
    git unzip libpq-dev libzip-dev libonig-dev \
    && docker-php-ext-install pdo pdo_mysql zip

# 4. Install Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# 5. Copy Symfony project files
COPY . .

# 6. Install PHP dependencies without running scripts (avoid .env errors during build)
RUN composer install --no-dev --optimize-autoloader --no-scripts

# 7. Ensure var/ exists and set permissions for var/ and vendor/
RUN mkdir -p var/ && chmod -R 777 var/ vendor/

# 8. Expose Render port
ENV PORT 10000

# 9. Start Symfony built-in server with dynamic port
CMD sh -c "php -S 0.0.0.0:$PORT -t public"
