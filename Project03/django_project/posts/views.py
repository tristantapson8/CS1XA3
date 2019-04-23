from django.http import HttpResponse, JsonResponse
from django.shortcuts import render, redirect
from django.core import serializers

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
    template_name_del = "delete.html"

# Create your views here.

# LOGIN PAGE
def post_home(request):
    
    form = UserLoginForm(request.POST or None)
    title = "Discussion"
    #titleU = ""
    context = {"form": form, "title": title}

    #print(request.user.is_authenticated())
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
           #titleU = titleU + "Welcome " + username + "!"
           return render(request, IndexView.template_name_disc, contextU)

       else:
           print("Stuck in Limbo")

    #context = {"form":form, "title": title, "titleU": titleU}
       

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

    queryset = ( Post.objects.all())

    '''
    query = request.GET.get("search")
    if not query or None:

        print("query database with " + str(query))

        queryset_list = query.filter(title="test")

        contextQ = {

             "titleU": "Discussion Board", "queryset_list": queryset_list

             }

        return render(request, IndexView.template_name_disc, contextQ)

    #qs_json = serializers.serialize('json', queryset)

    #i = request.session.get('counter', queryset)
    #request.session['counter'] = i

    '''

    context = {
            
            "titleU": "Discussion Board", "queryset": queryset
            
            }
    return render(request, IndexView.template_name_disc, context)
    #return render(request, IndexView.template_name_disc, qs_json)
    #return HttpResponse("Counter = " + str(request.session['counter']))

def post_update(request):
    form = UserPostForm(request.POST or None)

    if form.is_valid():
        instance = form.save()
        instance.save()

    context =  {"form": form}
    return render(request, IndexView.template_name_up, context)
 
def post_delete(request):

    qs = Post.objects.all()
    ys = '-'.join([str(i) for i in qs])

    di = request.session.get('counter2', "HELLO")
    request.session['counter2'] = di+ " " + ys
    this = str(request.session['counter2'])

   # return HttpResponse("Counter = " + str(request.session['counter2']))


    context = {"this": this} 
    return render(request, IndexView.template_name_del, context)

