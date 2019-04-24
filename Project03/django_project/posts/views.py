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


class IndexView(TemplateView):
    template_name_reg = "register.html"
    template_name_home = "index.html"
    template_name_disc = "disc.html"
    template_name_up = "update.html"
    template_name_ab = "delete.html"

# Create your views here.

# LOGIN PAGE
def post_home(request):

    form = UserLoginForm(request.POST or None)
    title = "Discussion"
    context = {"form": form, "title": title}

    print("not logged on")
    
    if form.is_valid(): 
       username = form.cleaned_data.get("username")
       password = form.cleaned_data.get("password")

       user = authenticate(username = username, password = password)
       titleU = "Welcome to slackLite, " + username + "!"
       queryset = Post.objects.all()

       contextU = {"form": form, "titleU": titleU, "queryset": queryset}


       if user is not None:
           login(request, user)
           print("logged on")
           return render(request, IndexView.template_name_disc, contextU)

       else:
           print("error")

    return render(request, IndexView.template_name_home, context)

# REGISTER PAGE
def post_register(request):

    print("register attempt")

    title = "Register"
    form = UserRegisterForm(request.POST or None)

    context = {"form": form, "title": title}

    if form.is_valid():
        user = form.save(commit = False)
        password = form.cleaned_data.get('password')
        user.set_password(password)
        user.save()
        
        
        newuser = authenticate(username = user.username, password = password)
        login(request, newuser)
        print("registered user " + newuser.username)
    
    return render(request, IndexView.template_name_reg, context)


# DISCUSSIOM PAGE
def post_disc(request):

    queryset = ( Post.objects.all())

    context = {

            "titleU": "Discussion Board", "queryset": queryset

            }
    return render(request, IndexView.template_name_disc, context)

    

# UPDATE PAGE
def post_update(request):
    form = UserPostForm(request.POST or None)

    if form.is_valid():

        instance = form.save()
        instance.save()

    context ={"form": form }
    return render(request, IndexView.template_name_up, context)
 

# ABOUT PAGE
def post_about(request):


   # return HttpResponse("Counter = " + str(request.session['counter2']))


    context = { } 
    return render(request, IndexView.template_name_ab, context)

