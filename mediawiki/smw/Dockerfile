# docker build --progress=plain -t test .
# docker run --rm -it test bash

FROM mediawiki:1.41

RUN <<EOF
set -e
apt update
apt upgrade --yes

apt install --yes --no-install-recommends \
    libzip-dev \
    unzip

rm -rf /var/lib/apt/lists/*

mv $PHP_INI_DIR/php.ini-production $PHP_INI_DIR/php.ini

docker-php-ext-install \
    zip

docker-php-ext-enable \
    zip
EOF

COPY mediawiki.ini $PHP_INI_DIR/conf.d/mediawiki.ini

COPY --from=composer/composer:latest-bin /composer /usr/bin/composer
COPY --chown=www-data:www-data composer.local.json .

RUN <<EOF
set -e
export COMPOSER_ALLOW_SUPERUSER=1
composer update --no-dev --no-cache
EOF

COPY --chmod=0755 entrypoint.sh /usr/local/bin/docker-smw-entrypoint
ENTRYPOINT ["docker-smw-entrypoint"]
CMD ["apache2-foreground"]