FROM php:8.2-cli

WORKDIR /app

RUN apt-get update && apt-get install -y \
    git unzip libpq-dev libzip-dev libonig-dev \
    && docker-php-ext-install pdo pdo_mysql zip

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

COPY . .

RUN composer install --no-dev --optimize-autoloader --no-scripts

RUN mkdir -p var/cache var/log && chmod -R 777 var

ENV PORT=10000
EXPOSE 10000

CMD ["php", "-d", "variables_order=EGPCS", "-S", "0.0.0.0:10000", "-t", "public"]
