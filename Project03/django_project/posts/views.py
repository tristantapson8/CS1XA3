from django.http import HttpResponse
from django.shortcuts import render

from django.views.generic import TemplateView

class IndexView(TemplateView):
    template_name_reg = "register.html"
    template_name_home = "index.html"
    template_name_disc = "disc.html"
    template_name_up = "update.html"
    template_name_del = "delete.html"

# Create your views here.

def post_home(request):
    context = {}
    return render(request, IndexView.template_name_home, context)

def post_register(request):
    context = {}
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

