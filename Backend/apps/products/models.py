from django.db import models
from django.utils.translation import gettext_lazy as _

from django.core.validators import validate_integer, validate_image_file_extension

from authentication.models import Store

class Product(models.Model):
    store = models.ForeignKey(Store, on_delete=models.CASCADE)

    image = models.ImageField(_('image'), upload_to='products_images', validators=[validate_image_file_extension])
    name = models.CharField(_('product'), max_length=70)
    price = models.FloatField(_('price'), null=True)

    num_stock = models.IntegerField(_('quantity in stock'), validators=[validate_integer], default=0)

    def __str__(self) -> str:
        return self.name


    def get_formated_price(self):
        return f'R$ {self.price:.2f}'.replace('.', ',')
