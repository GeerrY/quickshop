from io import BytesIO
import os

from django.shortcuts import get_object_or_404, render, redirect
from django.http import HttpRequest, HttpResponse, FileResponse
from django.contrib import messages
from django.contrib.messages import constants
from setup.settings import BASE_DIR
from apps.products.utils import crop_center_to_square
from authentication.decorators import login_required, store_login_required
from authentication.models import Store

from .forms import ProductAddForm, ProductEditForm
from .pdf_etiqueta import PDF, generate_qr_code
from .models import Product


@login_required(login_url='login')
def home(request: HttpRequest) -> HttpResponse:
    match request.method:
        case 'GET':
            return render(request, 'home.html')

        case 'POST':
            pass


@login_required(login_url='login')
def products(request: HttpRequest) -> HttpResponse:
    store = Store.objects.get(user=request.user)
    products = Product.objects.filter(store=store)
    match request.method:
        case 'GET':
            product_add_form = ProductAddForm()
            return render(request, 'products.html', {'product_add_form': product_add_form, 'products': products})

        case 'POST':

            product_add_form = ProductAddForm(request.POST, request.FILES)
            if product_add_form.is_valid():
                product = product_add_form.save(commit=False)
                product.store = store
                product.save()
                image = crop_center_to_square(product.image)
                image.save(product.image.path)
                return redirect('products')
            else:
                return render(request, 'products.html', {'product_add_form': product_add_form, 'products': products})


@login_required(login_url='login')
def info_product(request: HttpRequest, product_id: int) -> HttpResponse:
    product = Product.objects.filter(id=product_id)
    if not product.exists():
        messages.add_message(request, constants.WARNING,
                             'Produto acessado não existe.')
        return redirect('products')
    if product.first().store.user != request.user:
        messages.add_message(request, constants.WARNING,
                             'Produto acessado não pertence à esta loja.')
        return redirect('products')
    product = product.first()

    match request.method:
        case 'GET':
            return render(request, 'info_product.html', {'product': product})

        case 'POST':
            pass


@login_required(login_url='login')
def edit_product(request: HttpRequest, product_id: int) -> HttpResponse:
    product = Product.objects.filter(id=product_id)
    if not product.exists():
        messages.add_message(request, constants.WARNING,
                             'Produto acessado não existe.')
        return redirect('products')
    if product.first().store.user != request.user:
        messages.add_message(request, constants.WARNING,
                             'Produto acessado não pertence à esta loja.')
        return redirect('products')

    product = product.first()
    match request.method:
        case 'GET':
            product_edit_form = ProductEditForm(instance=product)
            return render(request, 'edit_product.html', {'product_edit_form': product_edit_form})

        case 'POST':
            product_edit_form = ProductEditForm(
                request.POST, request.FILES, instance=product)
            if product_edit_form.is_valid():
                product = product_edit_form.save()
                if request.FILES.get('image'):
                    # TODO: Apagar imagem antiga
                    image = crop_center_to_square(product.image)
                    image.save(product.image.path)

                return redirect('products')
            else:
                return render(request, 'edit_product.html', {'product_edit_form': product_edit_form})


@login_required(login_url='login')
def del_product(request: HttpRequest, product_id: int) -> HttpResponse:
    product = Product.objects.filter(id=product_id)
    if not product.exists():
        messages.add_message(request, constants.WARNING,
                             'Produto acessado não existe.')
        return redirect('products')
    if product.first().store.user != request.user:
        messages.add_message(request, constants.WARNING,
                             'Produto acessado não pertence à esta loja.')
        return redirect('products')
    product = product.first()

    match request.method:
        case 'GET':
            nome = product.name
            product.delete()
            messages.add_message(request, constants.WARNING,
                                 f'Produto "{nome}" excluído.')
            return redirect('products')

        case 'POST':
            pass


@login_required(login_url='login')
def exportar_etiqueta(request: HttpRequest, product_id: int) -> HttpResponse:
    match request.method:
        case 'GET':
            product = get_object_or_404(Product, id=product_id)

            qr_code_path = os.path.join(BASE_DIR, 'qrcode.png')
            generate_qr_code(product.id, qr_code_path)

            pdf = PDF()
            pdf.add_product(qr_code_path, product.name,
                            product.get_formated_price())

            pdf_content = pdf.output(dest='S').encode('latin1')
            pdf_bytes = BytesIO(pdf_content)
            os.remove(qr_code_path)
            return FileResponse(pdf_bytes, filename=f'Etiqueta {product.name}.pdf')

        case 'POST':
            pass


@login_required(login_url='login')
def exportar_etiquetas(request: HttpRequest) -> HttpResponse | FileResponse:
    match request.method:
        case 'GET':
            products = Product.objects.filter(store__user=request.user)
            return render(request, 'exportar_etiquetas.html', {'products': products})

        case 'POST':
            pass


@login_required(login_url='login')
def etiquetas(request: HttpRequest) -> HttpResponse | FileResponse:
    match request.method:
        case 'GET':
            checked_products = request.GET.get('produtos').split(',')
            if not checked_products:
                messages.add_message(request, constants.ERROR, 'Nenhum produto selecionado.')
                return redirect('exportar_etiquetas')
            
            products = Product.objects.filter(id__in=checked_products)

            pdf = PDF()
            for product in products:
                qr_code_path = os.path.join(BASE_DIR, f'qrcode{product.id}.png')
                generate_qr_code(product.id, qr_code_path)
                pdf.add_product(qr_code_path, product.name,
                                product.get_formated_price())
                os.remove(qr_code_path)

            pdf_content = pdf.output(dest='S').encode('latin1')
            pdf_bytes = BytesIO(pdf_content)
            return FileResponse(pdf_bytes, filename=f'Etiquetas.pdf')

        case 'POST':
            pass
