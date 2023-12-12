from ninja import Router
from django.http import HttpRequest

from products.models import Product
from authentication.models import Client

from efipay import EfiPay
from setup.settings import EFI_CREDENTIALS, PIX_KEY

from typing import Dict, List


shopping_router = Router()


@shopping_router.post('/buy', response=Dict)
def buy_products(request: HttpRequest, products: List[Dict]):
    value = 0
    for product in products:
        value += Product.objects.get(id=product['id']).price * product['quant']

    client = Client.objects.get(user=request.auth)
    efi = EfiPay(EFI_CREDENTIALS)

    body = {
        'calendario': {
            'expiracao': 300,
        },
        'devedor': {
            'cpf': client.cpf.replace('.', '').replace('-', ''),
            'nome': client.name,
        },
        'valor': {
            'original': f'{value:.2f}',
        },
        'chave': PIX_KEY,
    }

    response = efi.pix_create_immediate_charge(body=body)
    response = efi.pix_generate_qrcode(params={'id': response['loc']['id']})
    return {'success': True, 'pix_code': response['qrcode'], 'b64_qrcode_image': response['imagemQrcode'], 'pix_code': response['qrcode']}
