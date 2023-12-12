from django import forms
from .models import Product
from django.utils.safestring import mark_safe

class ProductAddForm(forms.ModelForm):
    class Meta:
        model = Product 
        fields = ('image', 'name', 'price')


    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)

        self.fields['image'].label = 'Imagem'
        self.fields['name'].label = 'Nome'
        self.fields['name'].strip = True
        self.fields['price'].label = 'Preço'
        
        for fild in self.fields:
            self.fields[fild].widget.attrs.update({'class': 'form-control', 'autocomplete': 'off', 'placeholder': ''})


class CustomImageWidget(forms.ClearableFileInput):
    def render(self, name, value, attrs=None, renderer=None):
        html = super().render(name, value, attrs, renderer)
        
        if value and hasattr(value, 'url'):
            image_html = f'<br><img src="{value.url}" width="100px" style="border-radius: 5px" class="rounded"/>'
            html = mark_safe(f'''
                             {image_html}
                             <br>
                             Modificar:
                             <input type="file" name="image" accept="image/*" class="form-control d_logo">
                             ''')
        
        return html
    

class ProductEditForm(forms.ModelForm):
    image = forms.ImageField(widget=CustomImageWidget)
    class Meta:
        model = Product 
        fields = ('image', 'name', 'price', 'num_stock')


    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)

        self.fields['image'].label = 'Imagem Atual:'
        self.fields['name'].label = 'Nome'
        self.fields['name'].strip = True
        self.fields['price'].label = 'Preço'
        self.fields['num_stock'].label = 'Quantidade em estoque'
        
        for fild in self.fields:
            self.fields[fild].widget.attrs.update({'class': 'form-control', 'autocomplete': 'off', 'placeholder': ''})