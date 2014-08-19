FROM dockerfile/ubuntu

# Container stuff

RUN apt-get update
RUN apt-get install --yes php5 php5-dev nginx php5-fpm

# Installing composer

RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer

# Application stuff

RUN mkdir -p /worldnews/www
ADD www/composer.json /worldnews/www/composer.json
RUN (cd /worldnews/www; composer install -o)
ADD . /worldnews/
RUN (cd /worldnews/www; composer install -o)

# Configuration stuff

RUN rm /etc/nginx/sites-enabled/default
ADD configs/site_worldnews_backend /etc/nginx/sites-available/worldnews_backend
ADD configs/nginx.conf /etc/nginx/nginx.conf
RUN ln -s /etc/nginx/sites-available/worldnews_backend /etc/nginx/sites-enabled/worldnews_backend

# Running stuff

EXPOSE 8000
#CMD /usr/sbin/php5-fpm -y /etc/php5/fpm/php-fpm.conf -c /etc/php5/fpm/php.ini && /usr/sbin/nginx -c /etc/nginx/nginx.conf
CMD sh /worldnews/scripts/run-app.sh -c -n -f
