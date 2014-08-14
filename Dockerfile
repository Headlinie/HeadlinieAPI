FROM dockerfile/ubuntu

RUN apt-get update

RUN apt-get install --yes php5 php5-dev nginx php5-fpm

RUN mkdir /worldnews/

ADD . /worldnews/

RUN rm /etc/nginx/sites-enabled/default

ADD configs/site_worldnews_backend /etc/nginx/sites-available/worldnews_backend

ADD configs/nginx.conf /etc/nginx/nginx.conf

RUN ln -s /etc/nginx/sites-available/worldnews_backend /etc/nginx/sites-enabled/worldnews_backend

EXPOSE 8000

CMD /usr/sbin/php5-fpm -y /etc/php5/fpm/php-fpm.conf -c /etc/php5/fpm/php.ini && /usr/sbin/nginx -c /etc/nginx/nginx.conf
