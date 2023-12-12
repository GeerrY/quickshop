from authentication.models import Client, User
from ninja import ModelSchema


class ClientIn(ModelSchema):
    class Config:
        model = Client
        model_fields = ['name', 'cpf', 'phone_number']

    email: str
    password: str



class UserLogin(ModelSchema):
    class Config:
        model = User
        model_fields = ['email', 'password']
        