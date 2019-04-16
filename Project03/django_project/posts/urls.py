# posts/urls.py
from django.urls import path

from .views import HomePageView

urlpatterns = [
    path('e/tapsonte/discBoard/', HomePageView.as_view(), name='home'), # disc board url
]
