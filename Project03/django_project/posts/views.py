from django.http import HttpResponse, JsonResponse
from django.shortcuts import render, redirect
from django.core import serializers
from django.contrib.auth.models import User

from django.views.generic import TemplateView
import json 


from django.contrib.auth import (
        authenticate, get_user_model,
        login,
        logout,
        )

from .forms import UserLoginForm, UserRegisterForm, UserPostForm
from .models import Post

# NOTE: some imports are basically useless, as left during testing or scrapped features

# IndexView class, used to assign html pages as variables
class IndexView(TemplateView):
    template_name_reg = "register.html"
    template_name_home = "index.html"
    template_name_disc = "disc.html"
    template_name_up = "update.html"
    template_name_ab = "about.html"

# Create your views here.

# LOGIN PAGE
def home(request):

    form = UserLoginForm(request.POST or None)
    title = "Discussion"
    context = { "form": form, "title": title } 

    # terminal testing
    print("not logged on")
    
    # form validation, user greeted with a hello message after sucessfully logging on
    if form.is_valid(): 
       username = form.cleaned_data.get("username")
       password = form.cleaned_data.get("password")

       user = authenticate(username = username, password = password)
       titleU = "Welcome to slackLite, " + username + "!"
       query_db = Post.objects.all()

       contextU = { "form": form, "titleU": titleU, "query_db": query_db }

       # user is logged on if credentials are found in the database 
       if user is not None:
           login(request, user)
           print("logged on")
           return render(request, IndexView.template_name_disc, contextU)

       else:
           print("error")

    return render(request, IndexView.template_name_home, context)


# REGISTER PAGE
def register(request):

    # terminal testing
    print("register attempt")

    title = "Register"
    form = UserRegisterForm(request.POST or None)

    context = { "form": form, "title": title }

    # form validation, username and password is saved to database
    if form.is_valid():
        user = form.save(commit = False)
        password = form.cleaned_data.get('password')
        user.set_password(password)
        user.save()
        
        user_valid = authenticate(username = user.username, password = password)
        login(request, user_valid)

        # terminal testing
        print("registered user " + user_valid.username + " sucessfully")
    
    return render(request, IndexView.template_name_reg, context)


# DISCUSSIOM PAGE
def disc(request):
 
    query_db = ( Post.objects.all())

    context = { "titleU": "Discussion Board", "query_db": query_db }
    return render(request, IndexView.template_name_disc, context)

    
# UPDATE PAGE
def update(request):

    # terminal testing
    print("create post attempt")
    form = UserPostForm(request.POST or None)

    # form validation, discussion post is saved to the databse
    if form.is_valid():

        instance = form.save()
        instance.save()

        # terminal testing
        print("user post created sucessfully")

    context = { "form": form }

    return render(request, IndexView.template_name_up, context)
 

# ABOUT PAGE
def about(request):

    # terminal testing
    print("about page")

    context = { } 
    return render(request, IndexView.template_name_ab, context)

