from django.shortcuts import render
from django.http import HttpResponse

def hello(request):
    return HttpResponse("Hello")

def gettest(request):
    keys = request.GET
    name = keys.get("name","")
    age = keys.get("age","")

    return HttpResponse("Hello " + name + " youre " + age + " old")

# Views here, get and post are interchangable
