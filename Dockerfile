FROM php:8.2-cli

WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git unzip curl libpq-dev libzip-dev libonig-dev \
    && docker-php-ext-install pdo pdo_mysql zip

# Install Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Install Symfony CLI
RUN curl -sS https://get.symfony.com/cli/installer | bash \
    && mv /root/.symfony*/bin/symfony /usr/local/bin/symfony

# Copy project
COPY . .

# Install PHP dependencies
RUN composer install --no-dev --optimize-autoloader --no-scripts

# Fix folder permissions
RUN mkdir -p var/cache var/log && chmod -R 777 var

# Render uses PORT env variable
ENV PORT 10000

EXPOSE 10000

# Start Symfony server
CMD ["symfony", "server:start", "--no-tls", "--port=10000", "--allow-http", "--no-interaction"]
