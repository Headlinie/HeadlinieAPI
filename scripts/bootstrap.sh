#! /bin/bash

#
# WorldNews Backend
#

DEV=$1
WORKING_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && cd .. && pwd )"

echo "";
echo "### Building image";
echo "";

docker build -t WorldNews/Backend .

echo "";
echo "## Running container from image";
echo "";

if [ "$DEV" == "--dev" ]; then
  # Interactive
  echo "##### Interactive session with bash and synced folders"
  echo "## Source located in /worldnews/"
  echo "##"
  echo "## To start php5-fpm"
  echo "##   /usr/sbin/php5-fpm -y /etc/php5/fpm/php-fpm.conf -c /etc/php5/fpm/php.ini"
  echo "##"
  echo "## To start nginx:"
  echo "##   /usr/sbin/nginx -c /etc/nginx/nginx.conf"
  echo "##"
  echo "#####"
  echo "##"
  echo "## OR start using script provided in /worldnews/scripts"
  echo "##   sh /worldnews/scripts/run-app.sh"
  echo "##"
  echo "## OR start same script with installing composer first"
  echo "##   sh /worldnews/scripts/run-app.sh --composer "
  echo "##"
  echo "#####"
  #docker run -p 8000:8000 -i -t WorldNews/Backend /bin/bash
  docker run -p 8000:8000 -v /home/victor/Projects/worldnewsBackend:/worldnews/:rw -i -t WorldNews/Backend /bin/bash
else
  # Non-interactive
  echo "#####"
  echo "##"
  echo "## Server started on port 8000"
  echo "##"
  echo "#####"
  docker run -p 8000:8000 -i -t WorldNews/Backend
fi
