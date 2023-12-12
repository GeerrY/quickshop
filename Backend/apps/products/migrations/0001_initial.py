# Generated by Django 4.2.5 on 2023-09-29 01:32

import django.core.validators
from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    initial = True

    dependencies = [
        ('authentication', '0002_adress_alter_user_email_store'),
    ]

    operations = [
        migrations.CreateModel(
            name='Product',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('image', models.ImageField(upload_to='products_images', validators=[django.core.validators.validate_image_file_extension], verbose_name='image')),
                ('name', models.CharField(max_length=50, verbose_name='product')),
                ('price', models.FloatField(null=True, verbose_name='price')),
                ('num_stock', models.IntegerField(validators=[django.core.validators.validate_integer], verbose_name='quantity in stock')),
                ('store', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='authentication.store')),
            ],
        ),
    ]
