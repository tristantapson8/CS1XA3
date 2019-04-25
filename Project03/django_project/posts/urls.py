from django.conf.urls import url
from . import views

# url pattern routing for the IndexView class found in views
urlpatterns = [
    url(r'^$', IndexView.as_view()),
    ]

