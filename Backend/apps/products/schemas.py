from ninja import Schema
from products.models import Product

class ProductOut(Schema):
    id: str
    image: str
    name: str
    price: str
    