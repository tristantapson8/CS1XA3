from django import forms
from .models import Post

from django.contrib.auth import (
        authenticate,
        get_user_model,
        login,
        logout,
        )

User = get_user_model()

# UserLoginForm class, used to validate a login attemp
class UserLoginForm(forms.Form):
    username = forms.CharField()
    password = forms.CharField(widget = forms.PasswordInput)

    def cleanL(self, *args, **kwargs):
        username = self.cleaned_data.get("username")
        password = self.cleaned_data.get("password")
        user = authenticate(username = username, password = password)

        # if the username and password are found, validate user login
        if username and password:
            
            user = authenticate(username = username, password = password)

            # raise error otherwise (displayed as feedback message)
            if not user:
                raise forms.ValidationError("Invalid username or password")

        return super(UserLoginForm, self).clean(*args, **kwargs)


# UserRegisterForm class, used to validate a register attemp
class UserRegisterForm(forms.ModelForm):
    username = forms.CharField()
    password = forms.CharField(widget = forms.PasswordInput)

    class Meta:

        model = User
        fields = ['username', 'password']

        # ignore help text
        help_texts = {
            'username': None,
        }

    def cleanR(self, *args, **kwargs):
        username = self.cleaned_data.get("username")
        password = self.cleaned_data.get("password")
        user = authenticate(username = username, password = password)
 
        # if a valid user name and password is entered (no restrictions other than length from the model),
        # validate user register
        if username and password:

            user = authenticate(username = username, password = password)

            # raise error otherwise (displayed as feedback message)
            if not user:
                raise forms.ValidationError("Invalid username or password")



# UserPostForm class, to set up the fields found on the create post page
class UserPostForm(forms.ModelForm):
    class Meta:

        model = Post
        fields = ["title", "author", "content"]
         

