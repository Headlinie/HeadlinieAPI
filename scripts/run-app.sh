#! /bin/sh
# -c is composer
# -n is nginx
# -f is php5-fpm
composer=''
nginx=''
fpm=''

CWD=`pwd`

while getopts 'cnf' flag; do
  case "${flag}" in
    c) composer='true' ;;
    n) nginx='true' ;;
    f) fpm='true' ;;
    *) echo "Unexpected option ${flag}" ;;
  esac
done

if [ "$nginx" ]; then
  echo ""
else
  if [ "$composer" ]; then
    echo ""
  else
    if [ "$fpm" ]; then
      echo ""
    else
      echo "[Error]  -- No services started, no need to do anything...";
      exit;
    fi
  fi
fi

if [ "$composer" ]; then
  echo "!! Installing composer dependencies"
  cd /headlinie/www
  composer install -vvv --prefer-source --dev --optimize-autoloader
fi

if [ "$fpm" ]; then
  echo "!! Running PHP-FPM"
  cd $CWD
  /usr/sbin/php5-fpm -y /etc/php5/fpm/php-fpm.conf -c /etc/php5/fpm/php.ini
fi

if [ "$nginx" ]; then
  echo "!! Running nginx"
  cd $CWD
  /usr/sbin/nginx -c /etc/nginx/nginx.conf
fi

