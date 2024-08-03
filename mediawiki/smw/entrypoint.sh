#!/bin/sh

# do web config wizzard first, then LocalSettings.php exists and we can add the smw stuff once
if test -f LocalSettings.php; then
    if ! grep -q "wfLoadExtension('SemanticMediaWiki');" LocalSettings.php; then
        echo "wfLoadExtension('SemanticMediaWiki');" >>LocalSettings.php
        php maintenance/update.php
    fi
fi

# https://github.com/wikimedia/mediawiki-docker/blob/main/1.41/apache/Dockerfile
apache2-foreground
