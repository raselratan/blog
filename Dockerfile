FROM php:8.3.0-apache
WORKDIR /var/www/html

# Enable Apache mod_rewrite
RUN a2enmod rewrite

# Install required Linux libraries
RUN apt-get update -y && apt-get install -y \
    libicu-dev \
    libmariadb-dev \
    unzip zip \
    zlib1g-dev \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev

# Install PHP Extensions
RUN docker-php-ext-install gettext intl pdo_mysql gd

RUN docker-php-ext-configure gd --enable-gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd

# Enable and install the PCNTL extension
RUN docker-php-ext-install pcntl

# Install Redis PHP Extension
RUN pecl install redis && docker-php-ext-enable redis

# Copy Composer from the official Composer image
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
