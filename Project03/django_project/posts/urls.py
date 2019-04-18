from django.conf.urls import url
from . import views

urlpatterns = [
    url(r'^e/tapsonte/register/$', IndexView.as_view()),
    ]

