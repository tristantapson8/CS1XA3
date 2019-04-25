from __future__ import unicode_literals 
from django.db import models

# Create your models here.

# Post class, includes post title, author, timestamps, and post content
class Post(models.Model):
    title = models.CharField(max_length = 125)
    author = models.CharField(max_length = 125, default = '')
    content = models.TextField()
    updated = models.DateTimeField(auto_now = True, auto_now_add = False)
    timestamp = models.DateTimeField(auto_now = False, auto_now_add = True)


    def __unicode__(self):
        return self.title

    def __str__(self):
        return self.title
