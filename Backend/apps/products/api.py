from ninja import Router

from django.http import HttpRequest
from django.shortcuts import get_object_or_404

from .schemas import ProductOut
from products.models import Product


products_router = Router()


@products_router.get('/{product_id}', response=ProductOut)
def get_product(request: HttpRequest, product_id: int):
    product = get_object_or_404(Product, id=product_id)
    return {'id': product.id, 'image': product.image.url, 'name': product.name, 'price': product.get_formated_price()}
