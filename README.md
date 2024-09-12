#  Bug It
- `Bug It` is an application used to report bugs to Google Sheets by sending an image, a description, and other relevant fields.


## Project Structre
- The project follows the MVVM pattern along with **Clean Code Principles**.

1. Presentation Layer
    1. View
    2. ViewModel
2. Domain Layer
    1. UseCase
    2. Repository Protocol
    3. Entities
3. Data Layer
    1. Repository Implemntation
    
    
## Scenes

- Login Screen 
    - Login With Google Account to get access token, so you can update google sheet
    
- Upload Screen 
    - upload images in this screen and return the link, then open `BugIt` screen
    
- BugIt
    - this screen is responsible for update googleSheet with images link and some fields 
