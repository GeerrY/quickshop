from django.http import HttpRequest, HttpResponse
from django.shortcuts import render, redirect
from django.contrib import auth

from django.contrib import messages
from django.contrib.messages import constants

from .models import Client, Store
from .decorators import only_unauth, login_required


@only_unauth(home_url='home')
def login(request: HttpRequest) -> HttpResponse:
    match request.method:
        case 'GET':
            return render(request, 'login.html')

        case 'POST':
            email = request.POST.get('email')
            password = request.POST.get('password')

            user = auth.authenticate(email=email, password=password)

            if Client.objects.filter(user=user).exists() and not Store.objects.filter(user=user).exists():
                messages.add_message(
                    request, constants.WARNING, 'Para logar no site da Quick Shop é necessário ter uma conta tipo loja.')
                return render(request, 'login.html', {'form': request.POST})

            if user:
                auth.login(request, user)
                messages.add_message(
                    request, constants.SUCCESS, 'Logado com sucesso.')
                return redirect('home')

            else:
                messages.add_message(
                    request, constants.ERROR, 'Credenciais incorretas.')
                return render(request, 'login.html', {'form': request.POST})


@login_required(login_url='login')
def logout(request: HttpRequest) -> HttpResponse:
    match request.method:
        case 'GET':
            auth.logout(request)
            messages.add_message(request, constants.SUCCESS,
                                 'Deslogado com sucesso.')
            return redirect('login')
