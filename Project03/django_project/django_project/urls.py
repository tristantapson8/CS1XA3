"""django_project URL Configuration

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/2.2/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.conf.urls import include, url
from django.contrib import admin
from django.conf import settings
from django.conf.urls.static import static

from posts import views

urlpatterns = [

   # admin page url
   url ('e/tapsonte/admin/', admin.site.urls),

   # app page urls
   url (r'^e/tapsonte/$', views.home, name = 'home'),
   url (r'^e/tapsonte/register/$', views.register, name = 'register'),
   url (r'^e/tapsonte/disc/$', views.disc, name = 'disc'),
   url (r'^e/tapsonte/update/$', views.update, name = 'update'),
   url (r'^e/tapsonte/about/$', views.about, name = 'about'),
] 

if settings.DEBUG:
    urlpatterns += static(settings.STATIC_URL, document_root=settings.STATIC_ROOT)
