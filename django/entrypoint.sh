./manage.py migrate

echo "from django.contrib.auth.models import User; superusers = User.objects.filter(is_superuser=True); print(len(superusers)>0)" | python manage.py shell | grep 'False' &> /dev/null
if [ $? == 0 ]; then
   echo "Need to create superuser"
   echo "from django.contrib.auth import get_user_model; User = get_user_model(); User.objects.create_superuser('admin', 'admin@local.app', '$SITE_ADMIN_PASSWORD')" | python manage.py shell
fi

