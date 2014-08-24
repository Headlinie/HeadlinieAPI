FROM dockerfile/ubuntu

# Container stuff

RUN apt-get update
RUN apt-get install --yes php5 php5-dev nginx php5-fpm

# Installing composer

RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer

# Application stuff

RUN mkdir -p /headlinie/api
ADD www/composer.json /headlinie/api/composer.json
RUN (cd /headlinie/api; composer install -o)
ADD . /headlinie/
RUN (cd /headlinie/api; composer install -o)

# Configuration stuff

RUN rm /etc/nginx/sites-enabled/default
ADD configs/site_headlinie_api /etc/nginx/sites-available/headlinie_api
ADD configs/nginx.conf /etc/nginx/nginx.conf
RUN ln -s /etc/nginx/sites-available/headlinie_api /etc/nginx/sites-enabled/headlinie_api

# Running stuff

EXPOSE 8000
#CMD /usr/sbin/php5-fpm -y /etc/php5/fpm/php-fpm.conf -c /etc/php5/fpm/php.ini && /usr/sbin/nginx -c /etc/nginx/nginx.conf
CMD sh /headlinie/scripts/run-app.sh -c -n -f -b
