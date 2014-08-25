#! /bin/bash

#
# Headlinie API
#

DEV=$1
CACHE=$2

if [ "$DEV" == "--dev" ]; then
  # Nada
  echo
else
  CACHE=$1
  echo "Building from scratch without any cache!"
fi

# Get new random port for new container
random_port=`shuf -i 8000-9000 -n 1`

# Get the id of the old container
old_container=`docker ps | grep "headlinie/api:latest" | cut -d " " -f1`
# Get the port of the old container
old_container_port=`docker inspect $old_container | grep -i "hostport" | tail -n 1 | cut -d '"' -f4`

WORKING_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && cd .. && pwd )"

echo "!! Got all configuration data"

echo "";
echo "### Building image";
echo "";

echo "!! Building the container"
if [ "$CACHE" == "--no-cache" ]; then
  docker build --no-cache -t headlinie/api .
else
  docker build -t headlinie/api .
fi

echo "";
echo -e "\033[33;32m## Running container from image";
echo "";

if [ "$DEV" == "--dev" ]; then
  # Interactive
  echo -e "\033[33;35m##### Interactive session with bash and synced folders"
  echo -e "##\033[33;34m Source located in /headlinie/"
  echo -e "\033[33;35m##"
  echo "## To start php5-fpm"
  echo -e "## \033[33;34m  /usr/sbin/php5-fpm -y /etc/php5/fpm/php-fpm.conf -c /etc/php5/fpm/php.ini"
  echo -e "\033[33;35m##"
  echo "## To start php5-fpm"
  echo -e "##  \033[33;34m /usr/sbin/php5-fpm -y /etc/php5/fpm/php-fpm.conf"
  echo "## To start nginx:"
  echo -e "##  \033[33;34m /usr/sbin/nginx -c /etc/nginx/nginx.conf"
  echo -e "\033[33;35m##"
  echo "#####"
  echo "##"
  echo "## OR start using script provided in /headlinie/scripts"
  echo -e "##  \033[33;34m sh /headlinie/scripts/run-app.sh"
  echo -e "\033[33;35m##"
  echo "## The following arguments are available for starting different services"
  echo "##"
  echo -e "\033[33;35m##  \033[33;34m -c Install composer dependencies"
  echo -e "\033[33;35m##  \033[33;34m -f Start PHP-FPM"
  echo -e "\033[33;35m##  \033[33;34m -n Start Nginx"
  echo -e "\033[33;35m##"
  echo "#####"
  docker run -p 8000:8000 -v $WORKING_DIR:/headlinie/:rw -i -t headlinie/api /bin/bash
else
  # Non-interactive
  echo "#####"
  echo "##"
  echo "## Server started on port 8000"
  echo "##"
  echo "#####"

  # Start new container
  echo "!! Starting new container on port $random_port"
  docker run -p $random_port:8000 -i -t headlinie/api

  # Get the id of the new container
  new_container=`docker ps | grep "headlinie/api:latest" | cut -d " " -f1`
  # Get the port of the new container
  new_container_port=`docker inspect $new_container | grep -i "hostport" | tail -n 1 | cut -d '"' -f4`

  # Tell NGINX to change port to new container
  echo "!! Replaceing $old_container_port with $new_container_port in nginx configuration"
  sed -i.bak s/$old_container_port/$new_container_port/ /etc/nginx/sites-enabled/headlinie

  echo "!! Restarting nginx"
  sudo service nginx restart

  # Stop old container
  echo "!! Stopping old container"
  docker stop $old_container

  # Remove old container
  echo "!! Removing old container"
  docker rm $old_container
fi
