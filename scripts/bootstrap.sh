#! /bin/bash

#
# WorldNews Backend
#

INTERACTIVE=$1

echo "";
echo "### Building image";
echo "";

docker build -t WorldNews/Backend .

echo "";
echo "## Running container from image";
echo "";

if [ "$1" == "--interactive" ]; then
  # Interactive
  echo "##### Interactive session with bash"
  echo "## To start php5-fpm"
  echo "##   /usr/sbin/php5-fpm -y /etc/php5/fpm/php-fpm.conf -c /etc/php5/fpm/php.ini"
  echo "##"
  echo "## To start nginx:"
  echo "##   /usr/sbin/nginx -c /etc/nginx/nginx.conf"
  echo "##"
  echo "## Source located in /worldnews/"
  echo "##"
  echo "#####"
  docker run -p 8000:8000 -i -t WorldNews/Backend /bin/bash
else
  # Non-interactive
  echo "#####"
  echo "##"
  echo "## Server started on port 8000"
  echo "##"
  echo "#####"
  docker run -p 8000:8000 -i -t WorldNews/Backend
fi
