from django.urls import path
from .views import *


urlpatterns = [
    path('home/', home, name='home'),
    path('products/', products, name='products'),
    path('info_product/<int:product_id>/', info_product, name='info_product'),
    path('edit_product/<int:product_id>/', edit_product, name='edit_product'),
    path('del_product/<int:product_id>/', del_product, name='del_product'),
    path('exportar_etiqueta/<int:product_id>/', exportar_etiqueta, name='exportar_etiqueta'),
    path('exportar_etiquetas/', exportar_etiquetas, name='exportar_etiquetas'),
    path('etiquetas/', etiquetas, name='etiquetas'),
]
