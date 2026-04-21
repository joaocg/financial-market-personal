FROM php:8.3-cli

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        git \
        unzip \
        libzip-dev \
        default-mysql-client \
        tesseract-ocr \
        tesseract-ocr-eng \
        tesseract-ocr-por \
    && docker-php-ext-install pdo_mysql pcntl zip \
    && pecl install redis \
    && docker-php-ext-enable redis \
    && rm -rf /var/lib/apt/lists/*

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html

COPY docker/php/start-app.sh /usr/local/bin/start-app
COPY docker/php/start-worker.sh /usr/local/bin/start-worker

RUN chmod +x /usr/local/bin/start-app /usr/local/bin/start-worker
