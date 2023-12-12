from ninja import NinjaAPI
from ninja.security import HttpBasicAuth

from typing import Any, Optional
from django.http import HttpRequest

from apps.authentication.api import authentication_router
from apps.products.api import products_router
from apps.shopping.api import shopping_router
from django.contrib import auth

class BasicAuth(HttpBasicAuth):
    def authenticate(self, request: HttpRequest, email: str, password: str) -> Any | None:
        return auth.authenticate(email=email, password=password)

api = NinjaAPI()

api.add_router('auth', authentication_router)
api.add_router('products', products_router, auth=BasicAuth())
api.add_router('shopping', shopping_router, auth=BasicAuth())
