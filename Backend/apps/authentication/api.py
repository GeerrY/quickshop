from ninja import Router
from typing import Dict
from .schemas import ClientIn, UserLogin
from authentication.models import Client, User
from django.contrib import auth
from base64 import b64encode

authentication_router = Router()

@authentication_router.post('/register', response={201: Dict, 200: Dict})
def register(request, payload: ClientIn):
    if User.objects.filter(email=payload.email).exists():
        return 200, {'success': False, 'message': 'Email já cadastrado.'}
    if Client.objects.filter(cpf=payload.cpf).exists():
        return 200, {'success': False, 'message': 'CPF já cadastrado.'}

    user = User(email=payload.email)
    user.set_password(payload.password)
    user.save()

    Client.objects.create(
        user=user,
        name=payload.name,
        cpf=payload.cpf,
        phone_number=payload.phone_number,
    )
    return 201, {'success': True, 'token': b64encode(f'{user.email}:{payload.password}'.encode('utf-8')).decode('utf-8')}


@authentication_router.post('/login', response={200: Dict, 401: Dict})
def register(request, payload: UserLogin):
    user = auth.authenticate(**payload.dict())
    if user:
        return 200 , {'success': True, 'token': b64encode(f'{user.email}:{payload.password}'.encode('utf-8')).decode('utf-8')}
    return 401, {'success': False, 'message': 'Credenciais inválidas.'}
