#!/bin/sh
set -e

if [ $1 = "apache2-foreground" ]; then
    if ! test -f LocalSettings.php; then
        php maintenance/install.php \
            --dbserver "$INSTALL_DB_SERVER" \
            --dbname "$INSTALL_DB_NAME" \
            --dbuser "$INSTALL_DB_USER" \
            --dbpass "$INSTALL_DB_PASS" \
            --pass "$INSTALL_PASS" \
            --server "$INSTALL_SERVER" \
            --scriptpath "" \
            "$INSTALL_NAME" \
            "$INSTALL_ADMIN"

        cat <<EOF >>LocalSettings.php
wfLoadExtension( 'SemanticMediaWiki' );
enableSemantics( '0.0.0.0' );
EOF

        php maintenance/update.php
    fi
fi

. docker-php-entrypoint
