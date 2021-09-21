FROM php:7.4.23-apache
EXPOSE 80/tcp
WORKDIR /app
# Need for vue-cli-service
ENV PATH="/app/frontend/node_modules/.bin/:${PATH}"
ENV APACHE_DOCUMENT_ROOT /app/www

RUN apt-get update && apt-get install -y unzip nodejs npm

# Configuring Apache
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf && \
    sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf && \
    a2enmod rewrite

RUN cd /tmp && \
    curl -sS https://getcomposer.org/installer | php && \
    mv composer.phar /usr/local/bin/composer

RUN npm install -g @vue/cli eslint

# Build application
COPY ./src /app
RUN cd /app/backend && \
    composer install && \
    cd /app/frontend && \
    npm install && \
    vue-cli-service build --no-clean

