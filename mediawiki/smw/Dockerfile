FROM mediawiki:1.41

# WORKDIR is apperently /var/www/html
# composer:latest-bin throws errors about does not comply with psr-4 autoloading standard
COPY --from=composer/composer:2.6-bin /composer /usr/bin/composer
COPY composer.local.json .
COPY entrypoint.sh .

RUN <<EOF
    apt update
    apt upgrade --yes
    apt install --yes --no-install-recommends \
        unzip
    rm -rf /var/lib/apt/lists/*
EOF

RUN <<EOF
    export COMPOSER_ALLOW_SUPERUSER=1
    composer update --no-dev --no-cache
EOF

CMD ["./entrypoint.sh"]
