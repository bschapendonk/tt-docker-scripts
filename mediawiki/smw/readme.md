Sorry for butchering this folder :)

I'm using the latest docker / docker-compose ymmv!

It works :) somehow

edit `compose.yaml` and at least change `INSTALL_SERVER` to match whatever is relevant

then compose build and up
```bash
docker-compose build
docker-compose up
```

Notable things for inspiration
- `Dockerfile` installs the smw extension somehow without a lot of messy code
- The real magic happens in `entrypoint.sh`
  - If we are running `apache2-foreground`
  - And `LocalSettings.php` does not exist
    - Run `install.php` with env vars from the compose
    - Append the needed stuff to `LocalSettings.php`
    - Run `update.php`
  - The source `docker-php-entrypoint` the [original](https://github.com/docker-library/php/blob/master/8.1/bookworm/apache/docker-php-entrypoint) entrypoint code

Scary stuff
- `install.php` does things, other things than the UI wizzard to `LocalSettings.php`
- **`LocalSettings.php` is ephemeral!** gone after a container restart, but the ^ recreates it which works but is unneeded and ugly
  - The two-step approach is better!
    - Install mediawiki normally, rip `LocalSettings.php` and put it back using a volume
    - Eddit and add smw stuff
    - manually run `php maintenance/update.php`
- ownership in `/var/www/html` is a mess
  - `chown -R www-data:www-data` is slow in docker takes ~minutes
- don't try to inline bash or json scripts using `COPY <<EOF > /entrypoint.sh`
  - docker does stuff with (substituion) `$` and breaks those scripts, just copy a external file `COPY entrypoint.sh /entrypoint.sh`


