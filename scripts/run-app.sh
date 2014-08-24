#! /bin/sh
# -c is composer
# -n is nginx
# -f is php5-fpm
composer=''
nginx=''
fpm=''
background=''

while getopts 'cnfb' flag; do
  case "${flag}" in
    c) composer='true' ;;
    n) nginx='true' ;;
    f) fpm='true' ;;
    b) background='true' ;;
    *) echo "Unexpected option ${flag}" ;;
  esac
done

if [ "$nginx" ]; then
  echo "Something"
else
  if [ "$composer" ]; then
    echo "Something"
  else
    if [ "$fpm" ]; then
      echo "Something"
    else
      echo "[Error]  -- No services started, no need to do anything...";
      exit;
    fi
  fi
fi

if [ "$composer" ]; then
  (cd /headlinie/www && composer install -vvv --prefer-source --dev --optimize-autoloader)
fi

if [ "$fpm" ]; then
  if [ "$background" ]; then
    /usr/sbin/php5-fpm -y /etc/php5/fpm/php-fpm.conf -c /etc/php5/fpm/php.ini&
  else
    /usr/sbin/php5-fpm -y /etc/php5/fpm/php-fpm.conf -c /etc/php5/fpm/php.ini
  fi
fi

if [ "$nginx" ]; then
  if [ "$background" ]; then
    /usr/sbin/nginx -c /etc/nginx/nginx.conf&
  else
    /usr/sbin/nginx -c /etc/nginx/nginx.conf
  fi
fi

