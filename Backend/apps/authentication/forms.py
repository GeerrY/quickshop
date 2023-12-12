from django.contrib.auth import forms
from .models import User


class UserCreationForm(forms.BaseUserCreationForm):

    class Meta(forms.BaseUserCreationForm.Meta):

        model = User 
        fields = ("email", 'password')

        
class UserChangeForm(forms.UserChangeForm):

    class Meta(forms.UserChangeForm.Meta):
        
        model = User
