## Discussion Board

This app is a very simple discussion board made with the use of database functionality;
included is a user authentication system that allows for registration, login, and logout.
The app code is found mostly in /CS1XA3/Project03/django_project/posts, as well as
/CS1XA3/Project03/django_project/django_project for settings and url routing. Html pages
for the app are also found in /CS1XA3/Project03/django_project/templates.

App page can be found at: https://mac1xa3.ca/u/tapsonte/project03.html

### How to run App 
  Below are the basic instructions to run this app:

  - Cd into the /CS1XA3/Project03 directory
  - Run the command "source bin/activate" in the terminal
  - Then cd into /CS1XA3/Project03/django_project
  - Finally, run the command "python manage.py runserver localhost:10054" in the terminal
  - Then click the button below to go to the login page!

### How to use App

  - Use the register page to sign up with a username and password
  - Once registered, use the login page to login with your credentials
  - After logging in, you can view the discussion board, or create a post
  - Logout once you are done using the app!

### App Features

  - User Authentication: Allows for the registration and login of a user provided that a valid
                       username and password is given, making use of forms rather than JSON.
                       Messages are displayed depending on valid login/register attemps, and
                       a personalized message is given to the user after a sucessfull login.
  
  - Databases: User posts can be created and stored in a database with various fields, primarily
             author, post content, and a timestamp. These posts are then displayed on the
             ain discussion board page, which can be filted by content with the search bar.
