from typing import Callable
from django.http import HttpRequest
from django.shortcuts import redirect
from django.contrib import messages
from django.contrib.messages import constants
from .models import Store


def login_required(login_url, *d_args, **d_kwargs):
    def decorator(view_func: Callable):
        def wrapper(request: HttpRequest, *args, **kwargs):
            
            if request.user.is_authenticated:
                return view_func(request, *args, **kwargs)
            
            messages.add_message(request, constants.WARNING,'É necessario estar logado para acessar esta página.')
            return redirect(login_url)
        
        return wrapper
    return decorator


def store_login_required(login_url, *d_args, **d_kwargs):
    def decorator(view_func: Callable):
        def wrapper(request: HttpRequest, *args, **kwargs):
            
            if request.user.is_authenticated:
                if Store.objects.filter(user=request.user):
                    return view_func(request, *args, **kwargs)
                messages.add_message(request, constants.WARNING,'O usuário precisa do tipo loja para acessar esta página.')
                return redirect(login_url)
        
            messages.add_message(request, constants.WARNING,'É necessario estar logado para acessar esta página.')
            return redirect(login_url)
        
        return wrapper
    return decorator


def only_unauth(home_url, *d_args, **d_kwargs):
    def decorator(view_func: Callable):
        def wrapper(request: HttpRequest, *args, **kwargs):
            
            if request.user.is_authenticated:
                messages.add_message(request, constants.WARNING, 'É necessario estar deslogado para acessar esta página.')
                return redirect(home_url)
            
            return view_func(request, *args, **kwargs)
        
        return wrapper
    return decorator