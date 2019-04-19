from django.http import HttpResponse
from django.shortcuts import render, redirect

from django.views.generic import TemplateView
import json

from django.contrib.auth import (
        authenticate, get_user_model,
        login,
        logout,
        )

from .forms import UserLoginForm, UserRegisterForm



class IndexView(TemplateView):
    template_name_reg = "register.html"
    template_name_home = "index.html"
    template_name_disc = "disc.html"
    template_name_up = "update.html"
    template_name_del = "delete.html"

# Create your views here.

# LOGIN PAGE
def post_home(request):
    
    form = UserLoginForm(request.POST or None)
    title = "Login"
    context = {"form":form, "title": title}

    #print(request.user.is_authenticated())
    print("not logged on")
    
    if form.is_valid(): 
       username = form.cleaned_data.get("username")
       password = form.cleaned_data.get("password")

       user = authenticate(username = username, password = password)
    

       if user is not None:
           login(request, user)
           print("logged on")
           return render(request, IndexView.template_name_disc, context)

       else:
           print("Stuck in Limbo")
    
   
    #context = {}
    return render(request, IndexView.template_name_home, context)

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

def post_disc(request):
    context = {
            
            "title": "User Posts"
            
            }
    return render(request, IndexView.template_name_disc, context)

def post_update(request):
    context = {}
    return render(request, IndexView.template_name_up, context)
 
def post_delete(request):
    context = {}
    return render(request, IndexView.template_name_del, context)

