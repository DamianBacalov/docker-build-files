#!/bin/bash

python3 manage.py migrate

echo "from django.contrib.auth.models import User; superusers = User.objects.filter(is_superuser=True); print(len(superusers)>0)" | python3 manage.py shell | grep 'False' &> /dev/null
if [ $? == 0 ]; then
   echo "Need to create superuser"
   echo "from django.contrib.auth import get_user_model; User = get_user_model(); User.objects.create_superuser('admin', 'admin@local.app', '$SITE_ADMIN_PASSWORD')" | python3 manage.py shell
fi

python3 manage.py collectstatic
set -m
uwsgi --uid nginx --socket /tmp/uwsgi.sock --plugins python3 --protocol uwsgi -w django_rest_api.wsgi:application --master & 
nginx -g "pid /tmp/nginx.pid;" -c /etc/nginx/nginx.conf
fg %1
