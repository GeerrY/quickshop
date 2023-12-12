from django.contrib.auth.models import AbstractBaseUser, BaseUserManager, PermissionsMixin, AbstractUser
from django.db import models
from django.utils.translation import gettext_lazy as _

from .validators import no_whitespaces, cep_validator
from django.core.validators import validate_email

from .managers import UserManager


class User(AbstractBaseUser, PermissionsMixin):
    email = models.EmailField(
        _('email address'),
        unique=True, 
        blank=False, 
        validators=[validate_email])

    is_admin = models.BooleanField(default=False)
    is_staff = models.BooleanField(default=False)
    is_superuser = models.BooleanField(default=False)

    objects = UserManager()
    
    USERNAME_FIELD = 'email'


class Store(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE)

    def __str__(self) -> str:
        return self.user.email

class Client(models.Model):
    name = models.CharField(max_length=50)
    cpf = models.CharField(max_length=14, unique=True)
    phone_number = models.CharField(max_length=14)

    user = models.OneToOneField(User, on_delete=models.CASCADE)

    def __str__(self) -> str:
        return f'{self.user.email} | {self.user.email}'


