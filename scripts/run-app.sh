#! /bin/sh
# -c is composer
# -n is nginx
# -f is php5-fpm
composer=''
nginx=''
fpm=''

while getopts 'cnf' flag; do
  case "${flag}" in
    c) composer='true' ;;
    n) nginx='true' ;;
    f) fpm='true' ;;
    *) echo "Unexpected option ${flag}" ;;
  esac
done

if [ "$nginx" ]; then
  # Hello
  echo "asd"
else
  if [ "$composer" ]; then
    # Hello
    echo "asd"
  else
    if [ "$fpm" ]; then
      # Hello
      echo "asd";
    else
      echo "[Error]  -- No services started, no need to do anything...";
      exit;
    fi
  fi
fi

if [ "$composer" ]; then
  (cd /worldnews/www && composer install -vvv --prefer-source --dev --optimize-autoloader)
fi

if [ "$fpm" ]; then
/usr/sbin/php5-fpm -y /etc/php5/fpm/php-fpm.conf -c /etc/php5/fpm/php.ini
fi

if [ "$nginx" ]; then
/usr/sbin/nginx -c /etc/nginx/nginx.conf
fi

